Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXFNHyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXFNHyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXFNHxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:53:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbXFNHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:53:54 -0400
Date: Thu, 14 Jun 2007 00:53:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ioctl disappeared (tty_ioctl)
Message-Id: <20070614005314.85168c03.akpm@linux-foundation.org>
In-Reply-To: <20070614104223.GA3678@darkstar.te-china.tietoenator.com>
References: <20070614104223.GA3678@darkstar.te-china.tietoenator.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 10:42:23 +0000 Dave Young <hidave.darkstar@gmail.com> wrote:

> The kernel reported the messages:
> 
> do_ioctl: ioctl c02bff70 disappeared
> symbol: tty_ioctl+0x0/0x4e0
>  [<c01813b4>] do_ioctl+0x74/0xd0
>  [<c02bff70>] tty_ioctl+0x0/0x4e0
>  [<c018159e>] vfs_ioctl+0x5e/0x1d0
>  [<c0181787>] sys_ioctl+0x77/0x90
>  [<c0104258>] syscall_call+0x7/0xb
>  [<c0430000>] __sched_text_start+0x570/0x6c0
>  =======================

Right, thanks.  This should repair it:



From: Paul Fulghum <paulkf@microgate.com>

Restore tty locked ioctl handler which was replaced with
an unlocked ioctl handler in hung_up_tty_fops by the patch:

commit e10cc1df1d2014f68a4bdcf73f6dd122c4561f94
Author: Paul Fulghum <paulkf@microgate.com>
Date:   Thu May 10 22:22:50 2007 -0700

    tty: add compat_ioctl

This was reported in:
[Bug 8473] New: Oops: 0010 [1] SMP

The bug is caused by switching to hung_up_tty_fops in do_tty_hangup.  An
ioctl call can be waiting on BLK after testing for existence of the locked
ioctl handler in the normal tty fops, but before calling the locked ioctl
handler.  If a hangup occurs at that point, the locked ioctl fop is NULL
and an oops occurs.

(akpm: we can remove my debugging code from do_ioctl() now, but it'll be OK to
do that for 2.6.23)

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/char/tty_io.c~tty-restore-locked-ioctl-file-op drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-restore-locked-ioctl-file-op
+++ a/drivers/char/tty_io.c
@@ -1173,8 +1173,14 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct file * file,
-			      unsigned int cmd, unsigned long arg)
+static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
+			     unsigned int cmd, unsigned long arg)
+{
+	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
+}
+
+static long hung_up_tty_compat_ioctl(struct file * file,
+				     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1222,8 +1228,8 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.unlocked_ioctl = hung_up_tty_ioctl,
-	.compat_ioctl	= hung_up_tty_ioctl,
+	.ioctl		= hung_up_tty_ioctl,
+	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
 
_

