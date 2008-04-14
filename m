Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbYDNTjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbYDNTjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYDNTj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:39:29 -0400
Received: from smtp40.hccnet.nl ([62.251.0.29]:39276 "EHLO smtp40.hccnet.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYDNTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:39:28 -0400
Message-ID: <4803C0F9.9010004@van-ginkel.eu>
Date: Mon, 14 Apr 2008 22:39:21 +0200
From: sander van ginkel <sander@van-ginkel.eu>
Reply-To: sander@van-ginkel.eu
User-Agent: Thunderbird 1.5.0.9 (X11/20070507)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: sander@van-ginkel.eu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptmx: adding handshake support
References: <20080311212830.5f4apfr4uqs884cc@62.129.139.44>	<20080330140948.0cqmtqb9us880cw8@62.129.139.44>	<20080330131652.7073589c@core>	<480229CB.2080108@van-ginkel.eu> <20080413233503.22576c47@core>
In-Reply-To: <20080413233503.22576c47@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected the last issues

Signed-off-by: Sander van Ginkel <sander@van-ginkel.eu>

===================================================================

diff -pru linux-2.6.25-rc8.orig/drivers/char/pty.c 
linux-2.6.25-rc8/drivers/char/pty.c
--- linux-2.6.25-rc8.orig/drivers/char/pty.c    2008-04-01 
21:44:26.000000000 +0200
+++ linux-2.6.25-rc8/drivers/char/pty.c    2008-04-14 23:01:56.000000000 
+0200
@@ -196,6 +196,7 @@ static void pty_flush_buffer(struct tty_
 
 static int pty_open(struct tty_struct *tty, struct file * filp)
 {
+    unsigned int    *mcrmsr;
     int    retval = -ENODEV;
 
     if (!tty || !tty->link)
@@ -212,11 +213,50 @@ static int pty_open(struct tty_struct *t
     clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
     set_bit(TTY_THROTTLED, &tty->flags);
     set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+
+    /* first time accessing this device, let's create it */
+
+    mcrmsr = kzalloc(sizeof(*mcrmsr), GFP_KERNEL);
+
+    if (mcrmsr != NULL) {
+
+        /* save our data within the tty structure */
+
+        *mcrmsr=0;
+
+        tty->driver_data = mcrmsr;
+        tty->link->driver_data = mcrmsr;
+    }
+    else
+    {
+        goto out;
+    }      
+
     retval = 0;
+
 out:
     return retval;
 }
 
+static int pty_tiocmget(struct tty_struct *tty, struct file *file)
+{
+    unsigned int *mcrmsr;
+
+    mcrmsr = tty->driver_data;
+
+    return *mcrmsr;
+}
+
+static int pty_tiocmset(struct tty_struct *tty, struct file 
*file,unsigned int set, unsigned int clear)
+{
+    unsigned int *mcrmsr;
+
+    mcrmsr = tty->driver_data;
+    *mcrmsr=set;
+
+    return 0;
+}
+
 static void pty_set_termios(struct tty_struct *tty, struct ktermios 
*old_termios)
 {
         tty->termios->c_cflag &= ~(CSIZE | PARENB);
@@ -232,6 +272,8 @@ static const struct tty_operations pty_o
     .chars_in_buffer = pty_chars_in_buffer,
     .unthrottle = pty_unthrottle,
     .set_termios = pty_set_termios,
+    .tiocmget = pty_tiocmget,
+    .tiocmset = pty_tiocmset,
 };
 
 /* Traditional BSD devices */
@@ -364,11 +406,26 @@ static struct ctl_table pty_root_table[]
 static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
                 unsigned int cmd, unsigned long arg)
 {
+    unsigned int value;
+    unsigned int *mcrmsr;
+
+        mcrmsr=tty->driver_data;
+
     switch (cmd) {
     case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
         return pty_set_lock(tty, (int __user *)arg);
     case TIOCGPTN: /* Get PT Number */
         return put_user(tty->index, (unsigned int __user *)arg);
+
+    case VMCRMSR: /* Set all of the handshake line, even the normally 
read only */
+        {
+        if (copy_from_user(&value,(unsigned int *)arg,sizeof(unsigned 
int)))
+            return -EFAULT;
+
+        *mcrmsr=value;
+
+        return 0;
+        }        
     }
 
     return -ENOIOCTLCMD;


