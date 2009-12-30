Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZL3GVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZL3GVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZL3GVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:21:51 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:55393 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZL3GVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:21:48 -0500
Date: Wed, 30 Dec 2009 01:21:42 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Paul Rolland <rol@as2917.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net,
       linux-acpi@vger.kernel.org, werner <w.landgraf@ru.ru>
Subject: [PATCH] dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously
 returned 21, it should follow 0/-E convention
In-reply-to: <20091228175301.4e89aa65@tux.DEF.witbe.net>
Message-id: <alpine.LFD.2.00.0912300119190.15839@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
 <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
 <20091228094444.GG24690@elte.hu> <20091228120125.GA10911@elte.hu>
 <20091228160212.1f70d825@tux.DEF.witbe.net>
 <20091228175301.4e89aa65@tux.DEF.witbe.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

wmi_install_notify_handler() returns an acpi_error,
but dell_wmi_init() needs return a -errno style error.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/dell-wmi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 916ccb2..4c7e702 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -323,6 +323,7 @@ static int __init dell_wmi_input_setup(void)
 static int __init dell_wmi_init(void)
 {
 	int err;
+	acpi_status status;
 
 	if (wmi_has_guid(DELL_EVENT_GUID)) {
 		printk(KERN_WARNING "dell-wmi: No known WMI GUID found\n");
@@ -336,14 +337,14 @@ static int __init dell_wmi_init(void)
 	if (err)
 		return err;
 
-	err = wmi_install_notify_handler(DELL_EVENT_GUID,
+	status = wmi_install_notify_handler(DELL_EVENT_GUID,
 					 dell_wmi_notify, NULL);
-	if (err) {
+	if (ACPI_FAILURE(status)) {
 		input_unregister_device(dell_wmi_input_dev);
 		printk(KERN_ERR
 			"dell-wmi: Unable to register notify handler - %d\n",
-			err);
-		return err;
+			status);
+		return -ENODEV;
 	}
 
 	return 0;
-- 
1.6.6.rc4.11.g129a5


