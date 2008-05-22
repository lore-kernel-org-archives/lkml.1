Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbYEVWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbYEVWaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbYEVWaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:30:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38826 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760588AbYEVWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:30:15 -0400
Date: Thu, 22 May 2008 23:17:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH] apm_emu: push BKL down into ioctl handlers
Message-ID: <20080522231727.4b0c4da4@core>
In-Reply-To: <20080522204059.GB24212@uranus.ravnborg.org>
References: <20080522212341.6527256c@core>
	<20080522204059.GB24212@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 22:40:59 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, May 22, 2008 at 09:23:41PM +0100, Alan Cox wrote:
> > Part of the elimination of the old lock based ioctl. This one can
> > probably lose the remaining BKL pretty trivially
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> -ENOPATCH

Must be  race between the sending gnomes and the pasting gnome ;)

diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index cdd876d..4ea7188 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -29,6 +29,7 @@
 #include <linux/completion.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 
 #include <asm/system.h>
 
@@ -292,8 +293,7 @@ static unsigned int apm_poll(struct file *fp, poll_table * wait)
  *   Only when everyone who has opened /dev/apm_bios with write permission
  *   has acknowledge does the actual suspend happen.
  */
-static int
-apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
+static long apm_ioctl(struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as = filp->private_data;
 	int err = -EINVAL;
@@ -301,6 +301,8 @@ apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 	if (!as->suser || !as->writer)
 		return -EPERM;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case APM_IOC_SUSPEND:
 		mutex_lock(&state_lock);
@@ -378,7 +380,7 @@ apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 		mutex_unlock(&state_lock);
 		break;
 	}
-
+	unlock_kernel();
 	return err;
 }
 
@@ -443,7 +445,7 @@ static struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
-	.ioctl		= apm_ioctl,
+	.unlocked_ioctl	= apm_ioctl,
 	.open		= apm_open,
 	.release	= apm_release,
 };
