Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbYBOBWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbYBOBWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbYBOBVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:21:55 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:48254 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755227AbYBOBVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:21:54 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 12/14] fs/binfmt_aout.c: Use time_* macros
Date: Fri, 15 Feb 2008 03:19:21 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1203003412-11594-13-git-send-email-caglar@pardus.org.tr> <Pine.LNX.4.64.0802142044470.12316@anakin>
In-Reply-To: <Pine.LNX.4.64.0802142044470.12316@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802150319.23446.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14 Şub 2008 Per tarihinde, Geert Uytterhoeven şunları yazmıştı: 
> To me these constructs look like good candidates for replacement by
> printk_ratelimit()?
> 
> Gr{oetje,eeting}s,

What about something like following?


Use printk_ratelimit() instead of jiffies based arithmetic, suggested by Geert Uytterhoeven

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

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

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
