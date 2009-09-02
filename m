Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZIBSNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZIBSNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZIBSNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:13:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40578 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZIBSNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:13:18 -0400
From: Matthew Garrett <mjg@redhat.com>
To: robert.moore@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] ACPI: Add support for new refcounted GPE API to drivers
Date: Wed,  2 Sep 2009 14:12:52 -0400
Message-Id: <1251915173-10144-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1251915173-10144-1-git-send-email-mjg@redhat.com>
References: <20090902181014.GA10917@srcf.ucam.org>
 <1251915173-10144-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 146.115.120.20
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPE refcounting support to ACPI drivers that need it. This will
currently do little until the core is changed over to use the new
behaviour.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/button.c |   13 +++++++++++++
 drivers/acpi/ec.c     |    3 +++
 drivers/acpi/wakeup.c |    6 ++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 9195deb..4dd67b1 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -367,6 +367,9 @@ static int acpi_button_add(struct acpi_device *device)
 	if (button->type == ACPI_BUTTON_TYPE_LID)
 		acpi_lid_send_state(device);
 
+	acpi_get_runtime_gpe(device->wakeup.gpe_device,
+			     device->wakeup.gpe_number);
+
 	if (device->wakeup.flags.valid) {
 		/* Button's GPE is run-wake GPE */
 		acpi_set_gpe_type(device->wakeup.gpe_device,
@@ -374,6 +377,8 @@ static int acpi_button_add(struct acpi_device *device)
 				  ACPI_GPE_TYPE_WAKE_RUN);
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
+		acpi_get_wakeup_gpe(device->wakeup.gpe_device,
+				    device->wakeup.gpe_number);
 		device->wakeup.state.enabled = 1;
 	}
 
@@ -393,6 +398,14 @@ static int acpi_button_remove(struct acpi_device *device, int type)
 {
 	struct acpi_button *button = acpi_driver_data(device);
 
+	acpi_put_runtime_gpe(device->wakeup.gpe_device,
+			     device->wakeup.gpe_number);
+	if (device->wakeup.flags.valid) {
+		acpi_put_wakeup_gpe(device->wakeup.gpe_device,
+				    device->wakeup.gpe_number);
+		device->wakeup.state.enabled = 0;
+	}
+
 	acpi_button_remove_fs(device);
 	input_unregister_device(button->input);
 	kfree(button);
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 391f331..56f6ba9 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -790,6 +790,7 @@ ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
+	acpi_put_runtime_gpe(NULL, ec->gpe);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 		pr_err(PREFIX "failed to remove space handler\n");
@@ -900,6 +901,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 		return -ENODEV;
 	acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
 	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_get_runtime_gpe(NULL, ec->gpe);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
@@ -916,6 +918,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 		} else {
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
+			acpi_put_runtime_gpe(NULL, ec->gpe);
 			return -ENODEV;
 		}
 	}
diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index 88725dc..98023ef 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -81,6 +81,8 @@ void acpi_enable_wakeup_device(u8 sleep_state)
 		if (!dev->wakeup.flags.run_wake)
 			acpi_enable_gpe(dev->wakeup.gpe_device,
 					dev->wakeup.gpe_number);
+		acpi_get_wakeup_gpe(dev->wakeup.gpe_device,
+				    dev->wakeup.gpe_number);
 	}
 }
 
@@ -121,6 +123,8 @@ void acpi_disable_wakeup_device(u8 sleep_state)
 			acpi_clear_gpe(dev->wakeup.gpe_device,
 				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
 		}
+		acpi_put_wakeup_gpe(dev->wakeup.gpe_device,
+				    dev->wakeup.gpe_number);
 	}
 }
 
@@ -141,6 +145,8 @@ int __init acpi_wakeup_device_init(void)
 				  ACPI_GPE_TYPE_WAKE_RUN);
 		acpi_enable_gpe(dev->wakeup.gpe_device,
 				dev->wakeup.gpe_number);
+		acpi_get_wakeup_gpe(dev->wakeup.gpe_device,
+				    dev->wakeup.gpe_number);
 		dev->wakeup.state.enabled = 1;
 	}
 	mutex_unlock(&acpi_device_lock);
-- 
1.6.2.5

