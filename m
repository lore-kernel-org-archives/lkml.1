Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYHRWdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYHRWdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYHRWcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:32:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60099 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753811AbYHRWcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:32:54 -0400
Date: Mon, 18 Aug 2008 23:15:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not
 allocated
Message-ID: <20080818231546.73020e41@lxorguk.ukuu.org.uk>
In-Reply-To: <19f34abd0808151426i69256b59m25a9a0676b50a6ba@mail.gmail.com>
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
	<19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
	<20080815162848.08ff793c@lxorguk.ukuu.org.uk>
	<19f34abd0808151426i69256b59m25a9a0676b50a6ba@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 23:26:28 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On Fri, Aug 15, 2008 at 5:28 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> ida_remove called for id=112 which is not allocated.
> >> ida_remove called for id=67 which is not allocated.
> >> ida_remove called for id=191 which is not allocated.
> >> ida_remove called for id=23 which is not allocated.
> >>
> >> ..and with no backtrace, so I guess it means "not harmful". Sorry for the noise.
> >
> > Thats definitely not good and wants digging into further.
> 
> Hi,
> 
> I've now been digging. This reproduces it accurately:
> 
> # mknod fubar c 128 42
> # cat fubar
> <ctrl-c>
> 
> idr_remove called for id=42 which is not allocated.

pty: If the administrator creates a device not for a ptmx slave don't error

From: Alan Cox <alan@redhat.com>


The open path for ptmx slaves is via the ptmx device. Opening them any
other way is not allowed. Vegard Nossum found that previously this was not
the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
---

 drivers/char/tty_io.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 53b62c4..430c266 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1217,7 +1217,8 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  *	init_dev		-	initialise a tty device
  *	@driver: tty driver we are opening a device on
  *	@idx: device index
- *	@tty: returned tty structure
+ *	@ret_tty: returned tty structure
+ *	@first_ok: ok to open a new device (used by ptmx)
  *
  *	Prepare a tty device. This may not be a "new" clean device but
  *	could also be an active device. The pty drivers require special
@@ -1238,7 +1239,7 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  */
 
 static int init_dev(struct tty_driver *driver, int idx,
-	struct tty_struct **ret_tty)
+	struct tty_struct **ret_tty, int first_ok)
 {
 	struct tty_struct *tty, *o_tty;
 	struct ktermios *tp, **tp_loc, *o_tp, **o_tp_loc;
@@ -1269,6 +1270,12 @@ static int init_dev(struct tty_driver *driver, int idx,
 	}
 	if (tty) goto fast_track;
 
+	if (driver->subtype == PTY_TYPE_MASTER &&
+		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
+		printk("SLAP\n");
+		retval = -EIO;
+		goto end_init;
+	}
 	/*
 	 * First time open is complex, especially for PTY devices.
 	 * This code guarantees that either everything succeeds and the
@@ -1403,7 +1410,7 @@ static int init_dev(struct tty_driver *driver, int idx,
 
 	if (retval)
 		goto release_mem_out;
-	 goto success;
+	goto success;
 
 	/*
 	 * This fast open can be used if the tty is already open.
@@ -1785,7 +1792,7 @@ static void release_dev(struct file *filp)
 }
 
 /**
- *	tty_open		-	open a tty device
+ *	__tty_open		-	open a tty device
  *	@inode: inode of device file
  *	@filp: file pointer to tty
  *
@@ -1864,7 +1871,7 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	retval = init_dev(driver, index, &tty);
+	retval = init_dev(driver, index, &tty, 0);
 	mutex_unlock(&tty_mutex);
 	if (retval)
 		return retval;
@@ -1961,7 +1968,7 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 		return index;
 
 	mutex_lock(&tty_mutex);
-	retval = init_dev(ptm_driver, index, &tty);
+	retval = init_dev(ptm_driver, index, &tty, 1);
 	mutex_unlock(&tty_mutex);
 
 	if (retval)
