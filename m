Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbYCUXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbYCUXIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbYCUWwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:03 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41274 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbYCUWwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:00 -0400
Message-Id: <20080321224439.410973428@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 60/76] SCSI: gdth: bugfix for the at-exit problems
Content-Disposition: inline; filename=scsi-gdth-bugfix-for-the-at-exit-problems.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Boaz Harrosh <bharrosh@panasas.com>

gdth_exit would first remove all cards then stop the timer
and would not sync with the timer function. This caused a crash
in gdth_timer() when module was unloaded.
So del_timer_sync the timer before we delete the cards.

also the reboot notifier function would crash. So clean
that up and fix the crashes.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/gdth.c |   82 +++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 54 deletions(-)

--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -183,7 +183,6 @@ static int gdth_ioctl(struct inode *inod
                       unsigned int cmd, unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
@@ -418,12 +417,6 @@ static inline void gdth_set_sglist(struc
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
-/* notifier block to get a notify on system shutdown/halt/reboot */
-static struct notifier_block gdth_notifier = {
-    gdth_halt, NULL, 0
-};
-static int notifier_disabled = 0;
-
 static gdth_ha_str *gdth_find_ha(int hanum)
 {
 	gdth_ha_str *ha;
@@ -3793,6 +3786,8 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    BUG_ON(list_empty(&gdth_instances));
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -4668,45 +4663,6 @@ static void gdth_flush(gdth_ha_str *ha)
     }
 }
 
-/* shutdown routine */
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
-{
-    gdth_ha_str *ha;
-#ifndef __alpha__
-    gdth_cmd_str    gdtcmd;
-    char            cmnd[MAX_COMMAND_SIZE];   
-#endif
-
-    if (notifier_disabled)
-        return NOTIFY_OK;
-
-    TRACE2(("gdth_halt() event %d\n",(int)event));
-    if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
-        return NOTIFY_DONE;
-
-    notifier_disabled = 1;
-    printk("GDT-HA: Flushing all host drives .. ");
-    list_for_each_entry(ha, &gdth_instances, list) {
-        gdth_flush(ha);
-
-#ifndef __alpha__
-        /* controller reset */
-        memset(cmnd, 0xff, MAX_COMMAND_SIZE);
-        gdtcmd.BoardNode = LOCALBOARD;
-        gdtcmd.Service = CACHESERVICE;
-        gdtcmd.OpCode = GDT_RESET;
-        TRACE2(("gdth_halt(): reset controller %d\n", ha->hanum));
-        gdth_execute(ha->shost, &gdtcmd, cmnd, 10, NULL);
-#endif
-    }
-    printk("Done.\n");
-
-#ifdef GDTH_STATISTICS
-    del_timer(&gdth_timer);
-#endif
-    return NOTIFY_OK;
-}
-
 /* configure lun */
 static int gdth_slave_configure(struct scsi_device *sdev)
 {
@@ -5141,13 +5097,13 @@ static void gdth_remove_one(gdth_ha_str 
 
 	scsi_remove_host(shp);
 
+	gdth_flush(ha);
+
 	if (ha->sdev) {
 		scsi_free_host_dev(ha->sdev);
 		ha->sdev = NULL;
 	}
 
-	gdth_flush(ha);
-
 	if (shp->irq)
 		free_irq(shp->irq,ha);
 
@@ -5173,6 +5129,24 @@ static void gdth_remove_one(gdth_ha_str 
 	scsi_host_put(shp);
 }
 
+static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
+{
+	gdth_ha_str *ha;
+
+	TRACE2(("gdth_halt() event %d\n", (int)event));
+	if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
+		return NOTIFY_DONE;
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_flush(ha);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gdth_notifier = {
+    gdth_halt, NULL, 0
+};
+
 static int __init gdth_init(void)
 {
 	if (disable) {
@@ -5235,7 +5209,6 @@ static int __init gdth_init(void)
 	add_timer(&gdth_timer);
 #endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
-	notifier_disabled = 0;
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
 	return 0;
@@ -5245,14 +5218,15 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
+	unregister_chrdev(major, "gdth");
+	unregister_reboot_notifier(&gdth_notifier);
 
 #ifdef GDTH_STATISTICS
-	del_timer(&gdth_timer);
+	del_timer_sync(&gdth_timer);
 #endif
-	unregister_chrdev(major,"gdth");
-	unregister_reboot_notifier(&gdth_notifier);
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_remove_one(ha);
 }
 
 module_init(gdth_init);

-- 
