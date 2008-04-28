Return-Path: <linux-kernel-owner+w=401wt.eu-S935896AbYD1PjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935896AbYD1PjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934435AbYD1PjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49060 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934088AbYD1Pi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:38:59 -0400
Date: Mon, 28 Apr 2008 18:38:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: [2.6 patch] mm/filemap.c:generic_write_checks() mustn't be inline
Message-ID: <20080428153826.GA2813@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 07:22:22PM +0200, Ingo Molnar wrote:
>...
> then it fails with:
> 
>  mm/filemap.c: In function '__generic_file_aio_write_nolock':
>  mm/filemap.c:1831: sorry, unimplemented: inlining failed in call to 'generic_write_checks': function body not available
> 
> i used:
> 
>    make ARCH=um SUBARCH=x86_64 -j64 linux
> 
> on x86-64, gcc-4.3.0-0.13. Config is:
> 
>    http://redhat.com/~mingo/misc/.config.um
>...

Patch below.

> 	Ingo
>...

cu
Adrian


<--  snip  -->


This patch fixes the following build error with UML and gcc 4.3:

<--  snip  -->

...
  CC      mm/filemap.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/filemap.c: In function ‘__generic_file_aio_write_nolock’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/filemap.c:1831: sorry, unimplemented: inlining failed in call to ‘generic_write_checks’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/filemap.c:2383: sorry, unimplemented: called from here
make[2]: *** [mm/filemap.o] Error 1

<--  snip  -->

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e4a4374513a2b23060bb385d83f1e67427b1b665 diff --git a/mm/filemap.c b/mm/filemap.c
index 07e9d92..576b553 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1827,7 +1827,8 @@ EXPORT_SYMBOL(iov_iter_single_seg_count);
  * Returns appropriate error code that caller should return or
  * zero in case that write should be allowed.
  */
-inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk)
+int generic_write_checks(struct file *file, loff_t *pos, size_t *count,
+			 int isblk)
 {
 	struct inode *inode = file->f_mapping->host;
 	unsigned long limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
