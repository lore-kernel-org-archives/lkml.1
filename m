Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZJUUJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZJUUJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZJUUJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:09:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbZJUUJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:09:44 -0400
Date: Wed, 21 Oct 2009 22:09:21 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, wim@iguana.be,
       Thomas Gleixner <tglx@linutronix.de>, viro@zeniv.linux.org.uk,
       Ingo Molnar <mingo@elte.hu>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [tip:bkl/drivers] nvram: Drop the BKL from nvram_open()
In-Reply-To: <tip-83cb16727085b18191f45eb0ede6bf1f97d67a7a@git.kernel.org>
Message-ID: <alpine.LFD.2.00.0910212207240.3526@localhost.localdomain>
References: <1255116426-7270-1-git-send-email-fweisbec@gmail.com> <tip-83cb16727085b18191f45eb0ede6bf1f97d67a7a@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, tip-bot for Ingo Molnar wrote:

> Commit-ID:  83cb16727085b18191f45eb0ede6bf1f97d67a7a
> Gitweb:     http://git.kernel.org/tip/83cb16727085b18191f45eb0ede6bf1f97d67a7a
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 14 Oct 2009 17:48:38 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 14 Oct 2009 17:54:03 +0200
> 
> nvram: Drop the BKL from nvram_open()
> 
> It's safe to remove the BKL from nvram_open(): there's no open()
> versus read() races: nvram_init() is very simple and race-free,
> it registers the device then puts it into /proc - there's no
> state init to race with.
> 
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> LKML-Reference: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/char/nvram.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 2100a8f..7cf4518 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -329,14 +329,12 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
>  
>  static int nvram_open(struct inode *inode, struct file *file)
>  {
> -	lock_kernel();
>  	spin_lock(&nvram_state_lock);
>  
>  	if ((nvram_open_cnt && (file->f_flags & O_EXCL)) ||
>  	    (nvram_open_mode & NVRAM_EXCL) ||
>  	    ((file->f_mode & FMODE_WRITE) && (nvram_open_mode & NVRAM_WRITE))) {
>  		spin_unlock(&nvram_state_lock);
> -		unlock_kernel();
>  		return -EBUSY;
>  	}
>  
> @@ -347,7 +345,6 @@ static int nvram_open(struct inode *inode, struct file *file)
>  	nvram_open_cnt++;
>  
>  	spin_unlock(&nvram_state_lock);
> -	unlock_kernel();
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

This patch and a previous one remove the bkl from the open and llseek 
functions. We can also convert to an unlocked_ioctl

>From 8eab1862b12cc851dc2c811261dda7a22d13e83a Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 21:57:19 +0200
Subject: [PATCH] nvram: Convert nvram_ioctl to unlocked_ioctl

After removing the BKL from open, we can also convert nvram_ioctl to
an unlocked_ioctl. It has it's only spin_lock, and doesn't rely on the BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/nvram.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 7cf4518..6c34279 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -290,8 +290,7 @@ checksum_err:
 	return -EIO;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long nvram_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int i;
 
@@ -412,13 +411,13 @@ static int nvram_add_proc_fs(void)
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
1.6.0.6

