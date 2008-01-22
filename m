Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYAVXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYAVXOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYAVXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:14:06 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34458 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbYAVXOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:14:04 -0500
Subject: Re: 2.6.24-rc8-mm1: sparc64 warning at fs/file_table.c:49
	__fput+0x1a8/0x1e0()
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, sparclinux@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20080122130228.e7596163.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <200801222130.24136.m.kozlowski@tuxland.pl>
	 <20080122130228.e7596163.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 15:13:58 -0800
Message-Id: <1201043638.7585.47.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-22 at 13:02 -0800, Andrew Morton wrote:
> > On Tue, 22 Jan 2008 21:30:23 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> > Hello,
> > 
> > Issuing "sysrq-s sysrq-u" sequence causes these warnings on sparc64:
> > 
> > ------------[ cut here ]------------
> > WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> > Modules linked in: sg sr_mod cdrom
> > Call Trace:
> >  [00000000004c9ac8] __fput+0x1b0/0x1e0
> >  [00000000004c6978] filp_close+0x60/0x80
> >  [00000000004c6a18] sys_close+0x80/0xe0
> >  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
> >  [0000000000012f1c] 0x12f24
> > ---[ end trace 6dbe14ff8ec57744 ]---
> > ------------[ cut here ]------------
...
> That's
> 
>         WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);


The emergency remount code forcibly removes FMODE_WRITE from
filps.  The r/o bind mount code notices that this was done
without a proper mnt_drop_write() and properly gives a
warning.

This patch does a mnt_drop_write() and also notes in the
filp that this was done to suppress any warning that would
have otherwise been triggered.

I also wonder if inode->i_writecount is made inconsistent
by the emergency remount code.  I guess it is, but the
damage is limited to a single inode instead of being
visible more globally like the mnt write count.  Probably
not really worth fixing.

BTW, this wasn't just a sparc thing.  I triggered it in about
3 seconds on a plain old x86 machine.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/super.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN fs/super.c~robind-sysrq-fix fs/super.c
--- linux-2.6.git/fs/super.c~robind-sysrq-fix	2008-01-22 14:33:38.000000000 -0800
+++ linux-2.6.git-dave/fs/super.c	2008-01-22 14:51:13.000000000 -0800
@@ -37,6 +37,7 @@
 #include <linux/idr.h>
 #include <linux/kobject.h>
 #include <linux/mutex.h>
+#include <linux/file.h>
 #include <asm/uaccess.h>
 
 
@@ -566,10 +567,26 @@ static void mark_files_ro(struct super_b
 {
 	struct file *f;
 
+retry:
 	file_list_lock();
 	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
-			f->f_mode &= ~FMODE_WRITE;
+		struct vfsmount mnt;
+		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+		       continue;
+		if (!file_count(f))
+			continue;
+		if (!(f->f_mode & FMODE_WRITE))
+			continue;
+		f->f_mode &= ~FMODE_WRITE;
+		f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+		mnt = f->f_path.mnt;
+		file_list_unlock();
+		/*
+		 * This can sleep, so we can't hold
+		 * the file_list_lock() spinlock.
+		 */
+		mnt_drop_write(mnt);
+		goto retry;
 	}
 	file_list_unlock();
 }
_


-- Dave

