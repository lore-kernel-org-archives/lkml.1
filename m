Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab0BDRfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:35:55 -0500
Received: from kroah.org ([198.145.64.141]:34619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489Ab0BDRVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:37 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:55 2010
Message-Id: <20100204171454.432792817@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [13/74] ACPI: Add platform-wide _OSC support.
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 3563ff964fdc36358cef0330936fdac28e65142a upstream.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c   |   26 ++++++++++++++++++++++++++
 include/linux/acpi.h |    7 +++++++
 2 files changed, 33 insertions(+)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -466,6 +466,30 @@ out_kfree:
 }
 EXPORT_SYMBOL(acpi_run_osc);
 
+static u8 sb_uuid_str[] = "0811B06E-4A27-44F9-8D60-3CBBC22E7B48";
+static void acpi_bus_osc_support(void)
+{
+	u32 capbuf[2];
+	struct acpi_osc_context context = {
+		.uuid_str = sb_uuid_str,
+		.rev = 1,
+		.cap.length = 8,
+		.cap.pointer = capbuf,
+	};
+	acpi_handle handle;
+
+	capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
+	capbuf[OSC_SUPPORT_TYPE] = OSC_SB_PR3_SUPPORT; /* _PR3 is in use */
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PAD_SUPPORT;
+#endif
+	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
+		return;
+	if (ACPI_SUCCESS(acpi_run_osc(handle, &context)))
+		kfree(context.ret.pointer);
+	/* do we need to check the returned cap? Sounds no */
+}
+
 /* --------------------------------------------------------------------------
                                 Event Management
    -------------------------------------------------------------------------- */
@@ -856,6 +880,8 @@ static int __init acpi_bus_init(void)
 	status = acpi_ec_ecdt_probe();
 	/* Ignore result. Not having an ECDT is not fatal. */
 
+	acpi_bus_osc_support();
+
 	status = acpi_initialize_objects(ACPI_FULL_INITIALIZATION);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX "Unable to initialize ACPI objects\n");
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -274,6 +274,13 @@ struct acpi_osc_context {
 
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 
+/* platform-wide _OSC bits */
+#define OSC_SB_PAD_SUPPORT		1
+#define OSC_SB_PPC_OST_SUPPORT		2
+#define OSC_SB_PR3_SUPPORT		4
+#define OSC_SB_CPUHP_OST_SUPPORT	8
+#define OSC_SB_APEI_SUPPORT		16
+
 /* _OSC DW1 Definition (OS Support Fields) */
 #define OSC_EXT_PCI_CONFIG_SUPPORT		1
 #define OSC_ACTIVE_STATE_PWR_SUPPORT 		2


