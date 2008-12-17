Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759993AbYLQJRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYLQJRR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbYLQJRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:17:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34641 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbYLQJQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:16:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>
Date: Wed, 17 Dec 2008 01:06:30 -0800
Message-ID: <m1wsdz892h.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [RFC][PATCH] fix xconsole.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Long ago xconsole broke (a regression) and it has been a mystery to
me.  One of my coworkers mentioned it again and I happened to been
looking at code in the vicinity and I finally figured out what
happened.

>From the tty_ioctl manpage  TIOCCONS is documented as:
  Redirecting console output
       TIOCCONS  void
              Redirect output that would have gone to /dev/console or
              /dev/tty0 to the given tty.  If that was a pty master,
              send it to the slave.  Anybody can do this as long as
              the output was not redirected yet.  If it was redirected
              already EBUSY is returned, but root may stop redirection
              by using this ioctl with fd pointing at /dev/console or
              /dev/tty0.


And it used to match the implementation. But then we had what appears
to be an overzealous security fix.

The console messages may only be redirected once, and root may perform
that initial redirection.  So I don't see why it is a security issue.

Do we have a better way to see console messages when we are in X?
I haven't seen it. 

Perhaps if we had a working xconsole we would have less random spew to
the console.

> commit adc281202e9c8824c3d1688a109bc5f19b6184d1
> Author: od <od>
> Date:   Tue Oct 19 14:59:16 2004 +0000
> 
>     [PATCH] TIOCCONS security
>     
>     The ioctl TIOCCONS allows any user to redirect console output to another
>     tty.  This allows anyone to suppress messages to the console at will.
>     
>     AFAIK nowadays not many programs write to /dev/console, except for start
>     scripts and the kernel (printk() above console log level).
>     
>     Still, I believe that administrators and operators would not like any user
>     to be able to hijack messages that were written to the console.
>     
>     The only user of TIOCCONS that I am aware of is bootlogd/blogd, which runs
>     as root.  Please comment if there are other users.
>     
>     Is there any reason why normal users should be able to use TIOCCONS?
>     
>     Otherwise I would suggest to restrict access to root (CAP_SYS_ADMIN), e.g.
>     with this patch.
>     
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
>     
>     BKrev: 41752bc4MrRxTUxDRjvfWObhWFXPyA

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 1412a8d..44794a9 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2128,10 +2128,10 @@ static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
 
 static int tioccons(struct file *file)
 {
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (file->f_op->write == redirected_tty_write) {
 		struct file *f;
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		spin_lock(&redirect_lock);
 		f = redirect;
 		redirect = NULL;
