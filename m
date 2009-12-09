Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZLIWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZLIWx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbZLIWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:53:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbZLIWxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:53:52 -0500
Date: Wed, 9 Dec 2009 23:53:30 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvram: Fix missing smp_lock.h in nvram
In-Reply-To: <520f0cf10912091433v1881989dr1c5dcb589e6f06f7@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912092335230.5146@localhost.localdomain>
References: <c62985530912090944p24dfe910mf9fff4c021ac7691@mail.gmail.com> <520f0cf10912091433v1881989dr1c5dcb589e6f06f7@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-785366160-1260399214=:5146"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-785366160-1260399214=:5146
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT


On Wed, Dec 9, 2009 at 6:44 PM, Frederic Weisbecker <fweisbec@gmail.com> 
wrote:
> 2009/12/6, Thomas Gleixner <tglx@linutronix.de>:
> > Linus,
> >
> > Please pull the latest bkl-drivers-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > bkl-drivers-for-linus
> >
> > Thanks,
> >
> >       tglx
> >
> > ------------------>
> > Frederic Weisbecker (3):
> >       mem_class: Drop the bkl from memory_open()
> >       nvram: Drop the bkl from nvram_llseek()
> 
> 
> This breaks the upstream tree. It looks like a patch from Ingo
> that removed the bkl in nvram_open() is missing.
> 
> Please consider the following patch:
> 
> From 4ce046f911b1cb62b4e952fd599e0d8c3dcd8703 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Wed, 9 Dec 2009 18:31:53 +0100
> Subject: [PATCH] nvram: Fix missing smp_lock.h in nvram
> 
> The bkl has been removed from nvram_llseek() and smp_lock.h was
> removed because another patch in the same tree zapped the remaining
> usage of bkl in the same file. But this patch must have been excluded
> later, then we still need the smp_lock.h headers for the bkl use
> in nvram_open().
> 
> This fixes the following build error:
> 
> drivers/char/nvram.c: In function ‘nvram_open’:
> drivers/char/nvram.c:332: erreur: implicit declaration of function ‘lock_kernel’
> drivers/char/nvram.c:339: erreur: implicit declaration of function
> ‘unlock_kernel’
> make[2]: *** [drivers/char/nvram.o] Erreur 1
> make[1]: *** [drivers/char] Erreur 2
> make: *** [drivers] Erreur 2
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  drivers/char/nvram.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 2100a8f..4008e2c 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -110,6 +110,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
> +#include <linux/smp_lock.h>
> 
>  #include <asm/system.h>
> 
> --
> 1.6.2.3
> --

Ingo's patch was just probably just misplaced, I'd rather that we
resubmit it than put back smp_lock.h

Plus I have a follow-up one that converts nvram_ioctl to unlocked_ioctl.

>From 19a26663db8c627a29e4aabb39a1c84ef85e9fb3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Oct 2009 17:48:38 +0200
Subject: [PATCH 1/2] nvram: Drop the BKL from nvram_open()

It's safe to remove the BKL from nvram_open(): there's no open()
versus read() races: nvram_init() is very simple and race-free,
it registers the device then puts it into /proc - there's no
state init to race with.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/nvram.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 88cee40..740e356 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -331,14 +331,12 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 
 static int nvram_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock(&nvram_state_lock);
 
 	if ((nvram_open_cnt && (file->f_flags & O_EXCL)) ||
 	    (nvram_open_mode & NVRAM_EXCL) ||
 	    ((file->f_mode & FMODE_WRITE) && (nvram_open_mode & NVRAM_WRITE))) {
 		spin_unlock(&nvram_state_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -349,7 +347,6 @@ static int nvram_open(struct inode *inode, struct file *file)
 	nvram_open_cnt++;
 
 	spin_unlock(&nvram_state_lock);
-	unlock_kernel();
 
 	return 0;
 }
-- 
1.6.5.2

>From fa2448aa56537113dcca77eb7b39a0fc72041122 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 21:57:19 +0200
Subject: [PATCH 2/2] nvram: Convert nvram_ioctl to unlocked_ioctl

After removing the BKL from open, we can also convert nvram_ioctl to
an unlocked_ioctl. It has it's own spin_lock, and doesn't rely on the BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/nvram.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 740e356..724b9fe 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -292,8 +292,7 @@ checksum_err:
 	return -EIO;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long nvram_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int i;
 
@@ -414,13 +413,13 @@ static int nvram_add_proc_fs(void)
 #endif /* CONFIG_PROC_FS */
 
 static const struct file_operations nvram_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= nvram_llseek,
-	.read		= nvram_read,
-	.write		= nvram_write,
-	.ioctl		= nvram_ioctl,
-	.open		= nvram_open,
-	.release	= nvram_release,
+	.owner			= THIS_MODULE,
+	.llseek			= nvram_llseek,
+	.read			= nvram_read,
+	.write			= nvram_write,
+	.unlocked_ioctl		= nvram_ioctl,
+	.open			= nvram_open,
+	.release		= nvram_release,
 };
 
 static struct miscdevice nvram_dev = {
-- 
1.6.5.2

 
--8323328-785366160-1260399214=:5146--
