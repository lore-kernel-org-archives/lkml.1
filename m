Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0BSRIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:08:39 -0500
Received: from kroah.org ([198.145.64.141]:57673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab0BSRAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:52 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:46 2010
Message-Id: <20100219163246.659489066@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [57/93] dell-wmi, hp-wmi, msi-wmi: check wmi_get_event_data() return value
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Len Brown <len.brown@intel.com>

commit fda11e61ff8a4e3a8ebbd434e46560b67cc0ca9d upstream

[ backport to 2.6.32 ]

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
the caller must kfree the returned buffer if AE_OK is returned.

The callers of wmi_get_event_data() pass ACPI_ALLOCATE_BUFFER,
and thus must check its return value before accessing
or kfree() on the buffer.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/dell-wmi.c |    7 ++++++-
 drivers/platform/x86/hp-wmi.c   |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -158,8 +158,13 @@ static void dell_wmi_notify(u32 value, v
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	static struct key_entry *key;
 	union acpi_object *obj;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO "dell-wmi: bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -334,8 +334,13 @@ static void hp_wmi_notify(u32 value, voi
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	static struct key_entry *key;
 	union acpi_object *obj;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO "hp-wmi: bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 


