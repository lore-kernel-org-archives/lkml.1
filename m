Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbZJOInN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbZJOInN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbZJOInN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:43:13 -0400
Received: from www.tglx.de ([62.245.132.106]:55003 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760320AbZJOInL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:43:11 -0400
Message-Id: <20091015083933.775584232@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tony Luck <tony.luck@intel.com>
Subject: [patch 1/7] ia64: Remove the BKL from perfmon
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline; filename=ia64-remove-bkl-from-perfmon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pfm_ioctl() is empty and can be safely converted to unlocked_ioctl. We
could also remove it, but that would change the return value.

sn_hwperf_ioctl() drops the BKL on entry and reacquires is on
exit. Convert to unlocked_ioctl.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/perfmon.c          |   21 ++++++++++-----------
 arch/ia64/sn/kernel/sn2/sn_hwperf.c |    8 ++------
 2 files changed, 12 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/perfmon.c
+++ linux-2.6-tip/arch/ia64/kernel/perfmon.c
@@ -1701,8 +1701,7 @@ pfm_poll(struct file *filp, poll_table *
 	return mask;
 }
 
-static int
-pfm_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pfm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	DPRINT(("pfm_ioctl called\n"));
 	return -EINVAL;
@@ -2179,15 +2178,15 @@ pfm_no_open(struct inode *irrelevant, st
 
 
 static const struct file_operations pfm_file_ops = {
-	.llseek   = no_llseek,
-	.read     = pfm_read,
-	.write    = pfm_write,
-	.poll     = pfm_poll,
-	.ioctl    = pfm_ioctl,
-	.open     = pfm_no_open,	/* special open code to disallow open via /proc */
-	.fasync   = pfm_fasync,
-	.release  = pfm_close,
-	.flush	  = pfm_flush
+	.llseek		= no_llseek,
+	.read		= pfm_read,
+	.write		= pfm_write,
+	.poll		= pfm_poll,
+	.unlocked_ioctl	= pfm_ioctl,
+	.open		= pfm_no_open,	/* special open code to disallow open via /proc */
+	.fasync		= pfm_fasync,
+	.release	= pfm_close,
+	.flush		= pfm_flush
 };
 
 static int
Index: linux-2.6-tip/arch/ia64/sn/kernel/sn2/sn_hwperf.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ linux-2.6-tip/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -682,8 +682,7 @@ static int sn_hwperf_map_err(int hwperf_
 /*
  * ioctl for "sn_hwperf" misc device
  */
-static int
-sn_hwperf_ioctl(struct inode *in, struct file *fp, u32 op, unsigned long arg)
+static long sn_hwperf_ioctl(struct file *fp, u32 op, unsigned long arg)
 {
 	struct sn_hwperf_ioctl_args a;
 	struct cpuinfo_ia64 *cdata;
@@ -699,8 +698,6 @@ sn_hwperf_ioctl(struct inode *in, struct
 	int i;
 	int j;
 
-	unlock_kernel();
-
 	/* only user requests are allowed here */
 	if ((op & SN_HWPERF_OP_MASK) < 10) {
 		r = -EINVAL;
@@ -858,12 +855,11 @@ sn_hwperf_ioctl(struct inode *in, struct
 error:
 	vfree(p);
 
-	lock_kernel();
 	return r;
 }
 
 static const struct file_operations sn_hwperf_fops = {
-	.ioctl = sn_hwperf_ioctl,
+	.unlocked_ioctl = sn_hwperf_ioctl,
 };
 
 static struct miscdevice sn_hwperf_dev = {


