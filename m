Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbYKFTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbYKFTyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYKFTxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:53:45 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:60863 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYKFTxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:53:40 -0500
Date: Thu, 06 Nov 2008 14:18:55 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 2.6.25,26.stable] ACPI: dock: avoid check _STA method
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
Message-id: <alpine.LFD.2.00.0811061417380.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:02:03 2008 +0800

    ACPI: dock: avoid check _STA method
    
    In some BIOSes, every _STA method call will send a notification again,
    this cause freeze. And in some BIOSes, it appears _STA should be called
    after _DCK. This tries to avoid calls _STA, and still keep the device
    present check.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10431
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

Index: linux-2.6.25.y/drivers/acpi/dock.c
===================================================================
--- linux-2.6.25.y.orig/drivers/acpi/dock.c
+++ linux-2.6.25.y/drivers/acpi/dock.c
@@ -599,14 +599,17 @@ static int handle_eject_request(struct d
 static void dock_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct dock_station *ds = data;
+	struct acpi_device *tmp;
 
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
-		if (!dock_in_progress(ds) && dock_present(ds)) {
+		if (!dock_in_progress(ds) && acpi_bus_get_device(ds->handle,
+		   &tmp)) {
 			begin_dock(ds);
 			dock(ds);
 			if (!dock_present(ds)) {
 				printk(KERN_ERR PREFIX "Unable to dock!\n");
+				complete_dock(ds);
 				break;
 			}
 			atomic_notifier_call_chain(&dock_notifier_list,
