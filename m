Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYCQJkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYCQJkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYCQJhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:50 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42604 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755175AbYCQJhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:33 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] fs/binfmt_aout.c: Use printk_ratelimit()
Date: Mon, 17 Mar 2008 11:36:32 +0200
Message-Id: <1205746593-24820-10-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205746593-24820-9-git-send-email-caglar@pardus.org.tr>
References: <>
 <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-5-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-6-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-8-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-9-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use printk_ratelimit() instead of jiffies based arithmetic, suggested by Geert Uytterhoeven

Cc: linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 fs/binfmt_aout.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index a1bb224..ba4cddb 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -372,21 +372,17 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 			 
 		flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
 	} else {
-		static unsigned long error_time, error_time2;
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ)
+		    (N_MAGIC(ex) != NMAGIC) && printk_ratelimit())
 		{
 			printk(KERN_NOTICE "executable not page aligned\n");
-			error_time2 = jiffies;
 		}
 
-		if ((fd_offset & ~PAGE_MASK) != 0 &&
-		    (jiffies-error_time) > 5*HZ)
+		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
 		{
 			printk(KERN_WARNING 
 			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
-			error_time = jiffies;
 		}
 
 		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
@@ -495,15 +491,13 @@ static int load_aout_library(struct file *file)
 	start_addr =  ex.a_entry & 0xfffff000;
 
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
-		static unsigned long error_time;
 		loff_t pos = N_TXTOFF(ex);
 
-		if ((jiffies-error_time) > 5*HZ)
+		if (printk_ratelimit())
 		{
 			printk(KERN_WARNING 
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
-			error_time = jiffies;
 		}
 		down_write(&current->mm->mmap_sem);
 		do_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
-- 
1.5.4.3

