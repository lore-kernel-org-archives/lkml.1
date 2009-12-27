Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZL0UNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZL0UNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZL0UNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:13:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60450 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZL0ULs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:11:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 6/12] ACPI: Add support for new refcounted GPE API to drivers
Date: Sun, 27 Dec 2009 21:03:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl>
In-Reply-To: <200912272057.10443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272103.54675.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Add GPE refcounting support to ACPI drivers that need it. This will
currently do little until the core is changed over to use the new
behaviour.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by; Rafael J. Wysocki <rjw@sisk.pl>
---
drivers/acpi/button.c |   12 ++++++++++++
 drivers/acpi/button.c |   12 ++++++++++++
 drivers/acpi/ec.c     |    4 +++-
 drivers/acpi/wakeup.c |    6 ++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -427,6 +427,10 @@ static int acpi_button_add(struct acpi_d
 				  ACPI_GPE_TYPE_WAKE_RUN);
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
+		acpi_ref_runtime_gpe(device->wakeup.gpe_device,
+				     device->wakeup.gpe_number);
+		acpi_ref_wakeup_gpe(device->wakeup.gpe_device,
+				    device->wakeup.gpe_number);
 		device->wakeup.state.enabled = 1;
 	}
 
@@ -446,6 +450,14 @@ static int acpi_button_remove(struct acp
 {
 	struct acpi_button *button = acpi_driver_data(device);
 
+	if (device->wakeup.flags.valid) {
+		acpi_unref_runtime_gpe(device->wakeup.gpe_device,
+			     device->wakeup.gpe_number);
+		acpi_unref_wakeup_gpe(device->wakeup.gpe_device,
+				      device->wakeup.gpe_number);
+		device->wakeup.state.enabled = 0;
+	}
+
 	acpi_button_remove_fs(device);
 	input_unregister_device(button->input);
 	kfree(button);
Index: linux-2.6/drivers/acpi/ec.c
===================================================================
--- linux-2.6.orig/drivers/acpi/ec.c
+++ linux-2.6/drivers/acpi/ec.c
@@ -755,7 +755,7 @@ static int ec_install_handlers(struct ac
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 	acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
-	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_ref_runtime_gpe(NULL, ec->gpe);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
@@ -772,6 +772,7 @@ static int ec_install_handlers(struct ac
 		} else {
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
+                        acpi_unref_runtime_gpe(NULL, ec->gpe);
 			return -ENODEV;
 		}
 	}
@@ -782,6 +783,7 @@ static int ec_install_handlers(struct ac
 
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
+	acpi_unref_runtime_gpe(NULL, ec->gpe);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 		pr_err(PREFIX "failed to remove space handler\n");
Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -81,6 +81,8 @@ void acpi_enable_wakeup_device(u8 sleep_
 		if (!dev->wakeup.flags.run_wake)
 			acpi_enable_gpe(dev->wakeup.gpe_device,
 					dev->wakeup.gpe_number);
+		acpi_ref_wakeup_gpe(dev->wakeup.gpe_device,
+				    dev->wakeup.gpe_number);
 	}
 }
 
@@ -121,6 +123,8 @@ void acpi_disable_wakeup_device(u8 sleep
 			acpi_clear_gpe(dev->wakeup.gpe_device,
 				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
 		}
+		acpi_unref_wakeup_gpe(dev->wakeup.gpe_device,
+				    dev->wakeup.gpe_number);
 	}
 }
 
@@ -141,6 +145,8 @@ int __init acpi_wakeup_device_init(void)
 				  ACPI_GPE_TYPE_WAKE_RUN);
 		acpi_enable_gpe(dev->wakeup.gpe_device,
 				dev->wakeup.gpe_number);
+		acpi_ref_wakeup_gpe(dev->wakeup.gpe_device,
+				    dev->wakeup.gpe_number);
 		dev->wakeup.state.enabled = 1;
 	}
 	mutex_unlock(&acpi_device_lock);

