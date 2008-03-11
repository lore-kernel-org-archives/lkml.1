Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYCKVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYCKVPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbYCKVPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:15:31 -0400
Received: from wapgw.hccnet.nl ([62.251.0.19]:39187 "EHLO wapgw.hccnet.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbYCKVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:15:30 -0400
X-Greylist: delayed 3341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 17:15:29 EDT
Message-ID: <47D6F76E.2090706@van-ginkel.eu>
Date: Tue, 11 Mar 2008 22:19:42 +0100
From: sander van ginkel <sander@van-ginkel.eu>
Reply-To: sander@van-ginkel.eu
User-Agent: Thunderbird 1.5.0.9 (X11/20070507)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ptmx: adding handshake support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For serial over ethernet communication, /dev/ptmx will be used to create 
a virtual device.
Due to the lack of a modem status register and a modem control register 
in the ptmx driver,
it won't be possible to transfer handshake signaling.

I wrote this patch to add these registers to the ptmx driver.
The modem status register, which controls CD,CTS,DSR,RI is normally 
read-only. To be able to
pass these signals from the remote port to the local ptmx device, I've 
added an IOCTL routine.
The result of a remote TIOCMGET IOCTL call , can be passed directly 
through this IOCTL routine.
The IOCTL value I used for this is, 0x5426 which was formerly known as 
TIOCTTYGSTRUCT.

I've tested this patch at an 2.6.16.27 kernel.

Suggestions and/or other test results are welcome.

Sander


Signed-off-by: Sander van Ginkel <sander@van-ginkel.eu>

===================================================================
--- drivers/char/pty.c    2008-03-03 20:02:09.000000000 +0100
+++ drivers/char/pty-new.c    2008-03-02 21:55:53.000000000 +0100
@@ -7,6 +7,8 @@
  *    -- C. Scott Ananian <cananian@alumni.princeton.edu>, 14-Jan-1998
  *  Added TTY_DO_WRITE_WAKEUP to enable n_tty to send POLL_OUT to
  *      waiting writers -- Sapan Bhatia <sapan@corewars.org>
+ *  Added support for MCR/MSR, used for serial over ethernet
+ *    -- Sander van Ginkel <sander@van-ginkel.eu>
  *
  *
  */
@@ -32,6 +34,16 @@
 #include <linux/bitops.h>
 #include <linux/devpts_fs.h>
 
+struct pty_mcrmsr {
+
+    struct semaphore        sem;            /* locks this structure */
+
+    /* for tiocmget and tiocmset functions */
+
+    int                     msr;            /* MSR shadow */
+    int                     mcr;            /* MCR shadow */
+};
+
 /* These are global because they are accessed in tty_io.c */
 #ifdef CONFIG_UNIX98_PTYS
 struct tty_driver *ptm_driver;
@@ -199,6 +211,7 @@
 
 static int pty_open(struct tty_struct *tty, struct file * filp)
 {
+        struct pty_mcrmsr *mcrmsr;
     int    retval = -ENODEV;
 
     if (!tty || !tty->link)
@@ -216,10 +229,90 @@
     set_bit(TTY_THROTTLED, &tty->flags);
     set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
     retval = 0;
+
+    /* initialize the pointer in case something fails */
+    
+    tty->driver_data = NULL;                          
+    tty->link->driver_data = NULL;
+
+    /* first time accessing this device, let's create it */
+
+    mcrmsr = kmalloc(sizeof(*mcrmsr), GFP_KERNEL);
+
+    init_MUTEX(&mcrmsr->sem);
+
+    if (mcrmsr != NULL) {
+        down(&mcrmsr->sem);
+
+        /* save our structure within the tty structure */
+
+        mcrmsr->mcr=0;
+        mcrmsr->msr=0;
+
+        tty->driver_data = mcrmsr;
+        tty->link->driver_data = mcrmsr;
+
+        up(&mcrmsr->sem);
+
+    }
+
 out:
     return retval;
 }
 
+static int pty_tiocmget(struct tty_struct *tty, struct file *file)
+{
+    struct pty_mcrmsr *mcrmsr = tty->driver_data;
+    unsigned int result = 0;
+    unsigned int msr=0;
+    unsigned int mcr=0;
+
+    if (tty->driver_data != NULL) {
+        msr = mcrmsr->msr;
+        mcr = mcrmsr->mcr;
+    }
+
+    result = ((mcr & 0x01)  ? TIOCM_DTR  : 0) |  /* DTR is set */
+        ((mcr & 0x02)  ? TIOCM_RTS  : 0) |  /* RTS is set */
+        ((mcr & 0x04)  ? TIOCM_LOOP : 0) |  /* LOOP is set */
+        ((msr & 0x08)  ? TIOCM_CTS  : 0) |  /* CTS is set */
+        ((msr & 0x10)  ? TIOCM_CAR  : 0) |  /* Carrier detect is set*/
+        ((msr & 0x20)  ? TIOCM_RI   : 0) |  /* Ring Indicator is set */
+        ((msr & 0x40)  ? TIOCM_DSR  : 0);   /* DSR is set */
+
+    return result;
+}
+
+static int pty_tiocmset(struct tty_struct *tty, struct file 
*file,unsigned int set, unsigned int clear)
+{
+    struct pty_mcrmsr *mcrmsr = tty->driver_data;
+    unsigned int mcr=0;
+
+    if (tty->driver_data != NULL)
+        mcr = mcrmsr->mcr;
+
+    if (set & TIOCM_DTR)
+        mcr |= 0x01;
+    if (set & TIOCM_RTS)
+        mcr |= 0x02;
+    if (set & TIOCM_LOOP)
+        mcr |= 0x04;
+
+    if (clear & TIOCM_DTR)
+        mcr &= ~0x01;
+    if (clear & TIOCM_RTS)
+        mcr &= ~0x02;
+    if (clear & TIOCM_LOOP)
+        mcr &= ~0x04;
+
+    /* set the new MCR value in the device */
+
+    if (tty->driver_data != NULL)
+        mcrmsr->mcr=mcr;
+
+    return 0;
+}
+
 static void pty_set_termios(struct tty_struct *tty, struct termios 
*old_termios)
 {
         tty->termios->c_cflag &= ~(CSIZE | PARENB);
@@ -235,6 +328,8 @@
     .chars_in_buffer = pty_chars_in_buffer,
     .unthrottle = pty_unthrottle,
     .set_termios = pty_set_termios,
+    .tiocmget = pty_tiocmget,
+    .tiocmset = pty_tiocmset,
 };
 
 /* Traditional BSD devices */
@@ -339,11 +434,44 @@
 static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
                 unsigned int cmd, unsigned long arg)
 {
+    unsigned int value;
+    struct pty_mcrmsr *mcrmsr = tty->driver_data;
+    unsigned int msr=0;
+    unsigned int mcr=0;
+
     switch (cmd) {
     case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
         return pty_set_lock(tty, (int __user *)arg);
     case TIOCGPTN: /* Get PT Number */
         return put_user(tty->index, (unsigned int __user *)arg);
+
+    case 0x5426: /* Set all of the handshake line, even the normally 
read only */
+        {
+        if (copy_from_user(&value,(unsigned int *)arg,sizeof(unsigned 
int)))
+            return -EFAULT;
+
+        if (value & 0x0002) /* DTR set */
+            mcr|=0x01;
+        if (value & 0x0004) /* RTS set */
+            mcr|=0x02;
+        if (value & 0x8000) /* LOOP set */
+            mcr|=0x04;
+        if (value & 0x0020) /* CTS set */
+            msr|=0x08;
+        if (value & 0x0040) /* DCD set */
+            msr|=0x10;
+        if (value & 0x0080) /* RI set */
+            msr|=0x20;
+        if (value & 0x0100) /* DSR set */
+            msr|=0x40;
+
+        if (tty->driver_data != NULL)
+            {
+            mcrmsr->msr=msr;
+            mcrmsr->mcr=mcr;
+            }
+        return 0;
+        }          
     }
 
     return -ENOIOCTLCMD;

