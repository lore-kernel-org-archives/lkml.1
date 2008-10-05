Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYJEQQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYJEQQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYJEQJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:09:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48478 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756922AbYJEQJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:09:50 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 33/76] tty: Add termiox
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:09:50 +0100
Message-ID: <20081005160938.1997.98381.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a way to describe the various additional modes and flow control
features that random weird hardware shows up and software such as wine
wants to emulate as Windows supports them.

TCGETX/TCSETX and the termiox ioctl are a SYS5 extension that we might as
well adopt. This patches adds the structures and the basic ioctl interfaces
when the TCGETX etc defines are added for an architecture. Drivers wishing
to use this stuff need to add new methods.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_ioctl.c   |   58 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/ioctls.h   |    4 +++
 include/linux/termios.h    |   15 +++++++++++
 include/linux/tty.h        |    1 +
 include/linux/tty_driver.h |    9 +++++++
 5 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index bf34e45..93bfa1d 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -579,6 +579,50 @@ static int get_termio(struct tty_struct *tty, struct termio __user *termio)
 	return 0;
 }
 
+
+#ifdef TCGETX
+
+/**
+ *	set_termiox	-	set termiox fields if possible
+ *	@tty: terminal
+ *	@arg: termiox structure from user
+ *	@opt: option flags for ioctl type
+ *
+ *	Implement the device calling points for the SYS5 termiox ioctl
+ *	interface in Linux
+ */
+
+static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
+{
+	struct termiox tnew;
+	struct tty_ldisc *ld;
+
+	if (tty->termiox == NULL)
+		return -EINVAL;
+	if (copy_from_user(&tnew, arg, sizeof(struct termiox)))
+		return -EFAULT;
+
+	ld = tty_ldisc_ref(tty);
+	if (ld != NULL) {
+		if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
+			ld->ops->flush_buffer(tty);
+		tty_ldisc_deref(ld);
+	}
+	if (opt & TERMIOS_WAIT) {
+		tty_wait_until_sent(tty, 0);
+		if (signal_pending(current))
+			return -EINTR;
+	}
+
+	mutex_lock(&tty->termios_mutex);
+	if (tty->ops->set_termiox)
+		tty->ops->set_termiox(tty, &tnew);
+	mutex_unlock(&tty->termios_mutex);
+	return 0;
+}
+
+#endif
+
 static unsigned long inq_canon(struct tty_struct *tty)
 {
 	int nr, head, tail;
@@ -936,6 +980,20 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			return -EFAULT;
 			return 0;
 #endif
+#ifdef TCGETX
+	case TCGETX:
+		if (real_tty->termiox == NULL)
+			return -EINVAL;
+		if (copy_to_user(p, real_tty->termiox, sizeof(struct termiox)))
+			return -EFAULT;
+		return 0;
+	case TCSETX:
+		return set_termiox(real_tty, p, 0);
+	case TCSETXW:
+		return set_termiox(real_tty, p, TERMIOS_WAIT);
+	case TCSETXF:
+		return set_termiox(real_tty, p, TERMIOS_FLUSH);
+#endif		
 	case TIOCGSOFTCAR:
 		/* FIXME: for correctness we may need to take the termios
 		   lock here - review */
diff --git a/include/asm-x86/ioctls.h b/include/asm-x86/ioctls.h
index 2cd4775..d2798f9 100644
--- a/include/asm-x86/ioctls.h
+++ b/include/asm-x86/ioctls.h
@@ -56,6 +56,10 @@
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int)
 				/* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
+#define TCSETX		0x5433
+#define TCSETXF		0x5434
+#define TCSETXW		0x5435
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
diff --git a/include/linux/termios.h b/include/linux/termios.h
index 4786628..2acd0c1 100644
--- a/include/linux/termios.h
+++ b/include/linux/termios.h
@@ -4,4 +4,19 @@
 #include <linux/types.h>
 #include <asm/termios.h>
 
+#define NFF	5
+
+struct termiox
+{
+	__u16	x_hflag;
+	__u16	x_cflag;
+	__u16	x_rflag[NFF];
+	__u16	x_sflag;
+};
+
+#define	RTSXOFF		0x0001		/* RTS flow control on input */
+#define	CTSXON		0x0002		/* CTS flow control on output */
+#define	DTRXOFF		0x0004		/* DTR flow control on input */
+#define DSRXON		0x0008		/* DCD flow control on output */
+
 #endif
diff --git a/include/linux/tty.h b/include/linux/tty.h
index b6e6c26..b64d10b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -219,6 +219,7 @@ struct tty_struct {
 	spinlock_t ctrl_lock;
 	/* Termios values are protected by the termios mutex */
 	struct ktermios *termios, *termios_locked;
+	struct termiox *termiox;	/* May be NULL for unsupported */
 	char name[64];
 	struct pid *pgrp;		/* Protected by ctrl lock */
 	struct pid *session;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 16d2794..ac6e58e 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -180,6 +180,14 @@
  *	not force errors here if they are not resizable objects (eg a serial
  *	line). See tty_do_resize() if you need to wrap the standard method
  *	in your own logic - the usual case.
+ *
+ * void (*set_termiox)(struct tty_struct *tty, struct termiox *new);
+ *
+ *	Called when the device receives a termiox based ioctl. Passes down
+ *	the requested data from user space. This method will not be invoked
+ *	unless the tty also has a valid tty->termiox pointer.
+ *
+ *	Optional: Called under the termios lock
  */
 
 #include <linux/fs.h>
@@ -220,6 +228,7 @@ struct tty_operations {
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct tty_struct *real_tty,
 				struct winsize *ws);
+	int (*set_termiox)(struct tty_struct *tty, struct termiox *tnew);
 #ifdef CONFIG_CONSOLE_POLL
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);

