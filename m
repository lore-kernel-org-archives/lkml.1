Return-Path: <linux-kernel-owner+w=401wt.eu-S1764899AbYFHLxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764899AbYFHLxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760787AbYFHLxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:53:34 -0400
Received: from mail1.aster.pl ([212.76.33.23]:9983 "EHLO mail1.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbYFHLxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:53:33 -0400
Content-Disposition: inline
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: linux-kernel@vger.kernel.org
Subject: Fwd: 2.6.25.4-rt4 problems
Date: Sun, 8 Jun 2008 13:11:27 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200806081311.27729.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
To have 2.6.24-rt4 and rt6 working without BUGs in dmesg I did some patching.
Probably this was wrong and I only masked some other problem.
I'm not a kernel specialist, so could you look at it?

Regards,
Jakub

----------  Przekazana wiadomość  ----------

Temat: 2.6.25.4-rt4 problems
Data: poniedziałek, 2 czerwca 2008
Od: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Do: tglx@timesys.com

Hello,
On my laptop I've been seeing constant flood of printk BUG from migh_sleep 
coming from cpu_idle():

[  121.955048] BUG: sleeping function called from invalid context swapper(0) 
at kernel/rtmutex.c:739
[  121.955048] in_atomic():1 [00000001], irqs_disabled():0
[  121.955048] Pid: 0, comm: swapper Not tainted 2.6.25.4-rt6 #2
[  121.955048]  [<c0120f61>] __might_sleep+0xf1/0xf8
[  121.955048]  [<c0466a4c>] __rt_spin_lock+0x24/0x61
[  121.955048]  [<c0466a91>] rt_spin_lock+0x8/0xa
[  121.955048]  [<c013f00d>] pm_qos_requirement+0x10/0x29
[  121.955048]  [<c03a09a6>] menu_select+0x5d/0x7f
[  121.955048]  [<c039ff48>] cpuidle_idle_call+0x47/0x9b
[  121.955048]  [<c039ff01>] ? cpuidle_idle_call+0x0/0x9b
[  121.955048]  [<c01060ff>] cpu_idle+0xaf/0x106
[  121.955048]  [<c0453e5f>] rest_init+0x67/0x69
[  121.955048]  =======================

 I have fixed it with:

--- linux-2.6.25.4/kernel/pm_qos_params.c	2008-05-15 17:00:12.000000000 +0200
+++ linux-2.6.25-k01/kernel/pm_qos_params.c	2008-06-01 19:51:37.180887278 
+0200
@@ -192,12 +192,15 @@
  */
 int pm_qos_requirement(int pm_qos_class)
 {
-	int ret_val;
+	int ret_val, locked;
 	unsigned long flags;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
+	locked = preempt_count() > 0;
+	if (!locked)
+	    spin_lock_irqsave(&pm_qos_lock, flags);
 	ret_val = pm_qos_array[pm_qos_class]->target_value;
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	if (!locked)
+	    spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return ret_val;
 }


Oh, and some functions were missing. To compile kernel I had to add:

--- linux-2.6.25.4/kernel/sched.c	2008-06-02 07:53:07.515908233 +0200
+++ linux-2.6.25-k01/kernel/sched.c	2008-06-01 14:27:39.147029258 +0200
@@ -671,6 +671,19 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
+static inline u64 global_rt_period()
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+} 
+
+static inline u64 global_rt_runtime()
+{
+	if (sysctl_sched_rt_period < 0)
+	    return RUNTIME_INF;
+	    
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
+
 /*
  * We really dont want to do anything complex within switch_to()
  * on PREEMPT_RT - this check enforces this.

To shut up another BUG:

--- linux-2.6.25.4/drivers/ata/libata-core.c	2008-05-15 17:00:12.000000000 
+0200
+++ linux-2.6.25-k01/drivers/ata/libata-core.c	2008-06-01 23:34:09.392635934 
+0200
@@ -5145,14 +5145,14 @@
 		unsigned long flags;
 
 		/* FIXME: use a bounce buffer */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
 		ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
 
 		kunmap_atomic(buf, KM_IRQ0);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 	} else {
 		buf = page_address(page);
 		ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
@@ -5282,14 +5282,14 @@
 		unsigned long flags;
 
 		/* FIXME: use bounce buffer */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
 		consumed = ap->ops->data_xfer(dev,  buf + offset, count, rw);
 
 		kunmap_atomic(buf, KM_IRQ0);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 	} else {
 		buf = page_address(page);
 		consumed = ap->ops->data_xfer(dev,  buf + offset, count, rw);
@@ -5462,7 +5462,7 @@
 {
 	unsigned long flags = 0;
 	int poll_next;
-
+	
 	WARN_ON((qc->flags & ATA_QCFLAG_ACTIVE) == 0);
 
 	/* Make sure ata_qc_issue_prot() does not throw things

and:

diff -U 3 -H -d -r -N -- linux-2.6.25.4/drivers/ata/libata-scsi.c 
linux-2.6.25-k01/drivers/ata/libata-scsi.c
--- linux-2.6.25.4/drivers/ata/libata-scsi.c	2008-05-15 17:00:12.000000000 
+0200
+++ linux-2.6.25-k01/drivers/ata/libata-scsi.c	2008-06-02 00:03:27.528945648 
+0200
@@ -1705,14 +1705,14 @@
 	struct scsi_cmnd *cmd = args->cmd;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 
 	buflen = ata_scsi_rbuf_get(cmd, &rbuf);
 	memset(rbuf, 0, buflen);
 	rc = actor(args, rbuf, buflen);
 	ata_scsi_rbuf_put(cmd, rbuf);
 
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
@@ -2489,7 +2489,7 @@
 			unsigned int buflen;
 			unsigned long flags;
 
-			local_irq_save(flags);
+			local_irq_save_nort(flags);
 
 			buflen = ata_scsi_rbuf_get(cmd, &buf);
 
@@ -2508,7 +2508,7 @@
 
 			ata_scsi_rbuf_put(cmd, buf);
 
-			local_irq_restore(flags);
+			local_irq_restore_nort(flags);
 		}
 
 		cmd->result = SAM_STAT_GOOD;


-------------------------------------------------------
