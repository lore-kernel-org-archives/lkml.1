Return-Path: <linux-kernel-owner+w=401wt.eu-S1423054AbXBBBOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423054AbXBBBOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 20:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423057AbXBBBOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 20:14:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423054AbXBBBOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 20:14:08 -0500
Date: Thu, 1 Feb 2007 17:13:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de, linux-serial@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drivers/isdn/gigaset: new M101 driver
Message-Id: <20070201171345.bd98ce30.akpm@osdl.org>
In-Reply-To: <200702012112.l11LCOO4016557@lx1.pxnet.com>
References: <200702012112.l11LCOO4016557@lx1.pxnet.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 22:12:24 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> +/* Kbuild sometimes doesn't set this */
> +#ifndef KBUILD_MODNAME
> +#define KBUILD_MODNAME "asy_gigaset"
> +#endif

That's a subtle way of reporting a kbuild bug ;)

What's the story here?

> --- linux-2.6.20-rc6-mm3-orig/drivers/isdn/gigaset/ser-gigaset.c	1970-01-01 01:00:00.000000000 +0100
> +++ local/drivers/isdn/gigaset/ser-gigaset.c	2007-01-29 23:41:39.000000000 +0100
> @@ -0,0 +1,853 @@
> +/* This is the serial hardware link layer (HLL) for the Gigaset 307x isdn
> + * DECT base (aka Sinus 45 isdn) using the RS232 DECT data module M101,
> + * written as a line discipline.
> + *
> + * =====================================================================
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + * =====================================================================
> + */
> +
> +#include "gigaset.h"
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/platform_device.h>
> +#include <linux/tty.h>
> +#include <linux/poll.h>
> +
> +/* Version Information */
> +#define DRIVER_AUTHOR "Tilman Schmidt"
> +#define DRIVER_DESC "Serial Driver for Gigaset 307x using Siemens M101"
> +
> +#define GIGASET_MINORS     1
> +#define GIGASET_MINOR      0
> +#define GIGASET_MODULENAME "ser_gigaset"
> +#define GIGASET_DEVNAME    "ttyGS"
> +
> +/* length limit according to Siemens 3070usb-protokoll.doc ch. 2.1 */
> +#define IF_WRITEBUF 264
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_LDISC(N_GIGASET_M101);
> +
> +static int startmode = SM_ISDN;
> +module_param(startmode, int, S_IRUGO);
> +MODULE_PARM_DESC(startmode, "initial operation mode");
> +static int cidmode = 1;
> +module_param(cidmode, int, S_IRUGO);
> +MODULE_PARM_DESC(cidmode, "stay in CID mode when idle");
> +
> +static struct gigaset_driver *driver = NULL;

Unneeded initialisation.

> +struct ser_cardstate {
> +	struct platform_device	dev;
> +	struct tty_struct	*tty;
> +	atomic_t		refcnt;
> +	struct semaphore	dead_sem;
> +};
> +
> +static struct platform_driver device_driver = {
> +	.driver = {
> +		.name = GIGASET_MODULENAME,
> +	},
> +};
> +
> +struct ser_bc_state {};

Does this need kernel-wide scope?

> +static void flush_send_queue(struct cardstate *);
> +
> +/* transmit data from current open skb
> + * result: number of bytes sent or error code < 0
> + */
> +static int write_modem(struct cardstate *cs)
> +{
> +	struct tty_struct *tty = cs->hw.ser->tty;
> +	struct bc_state *bcs = &cs->bcs[0];	/* only one channel */
> +	struct sk_buff *skb = bcs->tx_skb;
> +	int sent;
> +
> +	if (!tty || !tty->driver || !skb)
> +		return -EFAULT;

Is EFAULT appropriate?

Can all these things happen?

> +	if (!skb->len) {
> +		dev_kfree_skb_any(skb);
> +		bcs->tx_skb = NULL;
> +		return -EINVAL;
> +	}
> +
> +	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);

Is a client of the tty interface supposed to be diddling tty flags like this?

> +	sent = tty->driver->write(tty, skb->data, skb->len);
> +	gig_dbg(DEBUG_OUTPUT, "write_modem: sent %d", sent);
> +	if (sent < 0) {
> +		/* error */
> +		flush_send_queue(cs);
> +		return sent;
> +	}
> +	skb_pull(skb, sent);
> +	if (!skb->len) {
> +		/* skb sent completely */
> +		gigaset_skb_sent(bcs, skb);
> +
> +		gig_dbg(DEBUG_INTR, "kfree skb (Adr: %lx)!",
> +			(unsigned long) skb);
> +		dev_kfree_skb_any(skb);
> +		bcs->tx_skb = NULL;
> +	}
> +	return sent;
> +}
> +
> +/*
> + * transmit first queued command buffer
> + * result: number of bytes sent or error code < 0
> + */
> +static int send_cb(struct cardstate *cs)
> +{
> +	struct tty_struct *tty = cs->hw.ser->tty;
> +	struct cmdbuf_t *cb, *tcb;
> +	unsigned long flags;
> +	int sent = 0;
> +
> +	if (!tty || !tty->driver)
> +		return -EFAULT;
> +
> +	spin_lock_irqsave(&cs->cmdlock, flags);
> +	cb = cs->cmdbuf;
> +	spin_unlock_irqrestore(&cs->cmdlock, flags);

It is doubtful if the locking here does anything useful.

> +	if (!cb)
> +		return 0;	/* nothing to do */
> +
> +	if (cb->len) {
> +		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> +		sent = tty->driver->write(tty, cb->buf + cb->offset, cb->len);
> +		if (sent < 0) {
> +			/* error */
> +			gig_dbg(DEBUG_OUTPUT, "send_cb: write error %d", sent);
> +			flush_send_queue(cs);
> +			return sent;
> +		}
> +		cb->offset += sent;
> +		cb->len -= sent;
> +		gig_dbg(DEBUG_OUTPUT, "send_cb: sent %d, left %u, queued %u",
> +			sent, cb->len, cs->cmdbytes);
> +	}
> +
> +	while (cb && !cb->len) {
> +		spin_lock_irqsave(&cs->cmdlock, flags);
> +		cs->cmdbytes -= cs->curlen;
> +		tcb = cb;
> +		cs->cmdbuf = cb = cb->next;
> +		if (cb) {
> +			cb->prev = NULL;
> +			cs->curlen = cb->len;
> +		} else {
> +			cs->lastcmdbuf = NULL;
> +			cs->curlen = 0;
> +		}
> +		spin_unlock_irqrestore(&cs->cmdlock, flags);
> +
> +		if (tcb->wake_tasklet)
> +			tasklet_schedule(tcb->wake_tasklet);
> +		kfree(tcb);
> +	}
> +	return sent;
> +}
> +
>
> ...
>
> +/*
> + * queue an AT command string for transmission to the Gigaset device
> + * parameters:
> + *	cs		controller state structure
> + *	buf		buffer containing the string to send
> + *	len		number of characters to send
> + *	wake_tasklet	tasklet to run when transmission is complete, or NULL
> + * return value:
> + *	number of bytes queued, or error code < 0
> + */
> +static int gigaset_write_cmd(struct cardstate *cs, const unsigned char *buf,
> +                             int len, struct tasklet_struct *wake_tasklet)
> +{
> +	struct cmdbuf_t *cb;
> +	unsigned long flags;
> +
> +	gigaset_dbg_buffer(atomic_read(&cs->mstate) != MS_LOCKED ?
> +	                     DEBUG_TRANSCMD : DEBUG_LOCKCMD,
> +	                   "CMD Transmit", len, buf);
> +
> +	if (len <= 0)
> +		return 0;
> +
> +	if (!(cb = kmalloc(sizeof(struct cmdbuf_t) + len, GFP_ATOMIC))) {
> +		dev_err(cs->dev, "%s: out of memory!\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(cb->buf, buf, len);
> +	cb->len = len;
> +	cb->offset = 0;
> +	cb->next = NULL;
> +	cb->wake_tasklet = wake_tasklet;
> +
> +	spin_lock_irqsave(&cs->cmdlock, flags);
> +	cb->prev = cs->lastcmdbuf;
> +	if (cs->lastcmdbuf)
> +		cs->lastcmdbuf->next = cb;
> +	else {
> +		cs->cmdbuf = cb;
> +		cs->curlen = len;
> +	}
> +	cs->cmdbytes += len;
> +	cs->lastcmdbuf = cb;
> +	spin_unlock_irqrestore(&cs->cmdlock, flags);

Would the use of list_heads simplify things here?  Or are we dealing with a
hardware-imposed layout?

> +	spin_lock_irqsave(&cs->lock, flags);
> +	if (cs->connected)
> +		tasklet_schedule(&cs->write_tasklet);
> +	spin_unlock_irqrestore(&cs->lock, flags);
> +	return len;
> +}
> +
> ...
> +
> +/*
> + * implementation of ioctl(GIGASET_BRKCHARS)
> + * parameter:
> + *	controller state structure
> + * return value:
> + *	-EINVAL (unimplemented function)
> + */
> +static int gigaset_brkchars(struct cardstate *cs, const unsigned char buf[6])
> +{
> +	/* not implemented */
> +	return -EINVAL;
> +}

ENOTTY might be more appropriate here.

> +/*
> + * Free hardware specific device data
> + * This will be called by "gigaset_freecs" in common.c
> + */
> +static void gigaset_freecshw(struct cardstate *cs)
> +{
> +	tasklet_kill(&cs->write_tasklet);

Does tasklet kill() wait for the tasklet to stop running on a different
CPU?  I thing so, but it was written in the days before we commented code.

> +	if (!cs->hw.ser)
> +		return;
> +	dev_set_drvdata(&cs->hw.ser->dev.dev, NULL);
> +	platform_device_unregister(&cs->hw.ser->dev);
> +	kfree(cs->hw.ser);
> +	cs->hw.ser = NULL;
> +}
> +
> +/* dummy to shut up framework warning */
> +static void gigaset_device_release(struct device *dev)
> +{
> +	//FIXME anything to do? cf. platform_device_release()
> +}

Ask Greg ;)

> +			down(&cs->hw.ser->dead_sem);

Does this actually use the semaphore's counting feature?  If not, can we
switch it to a mutex?

> +/*
> + * Ioctl on the tty.
> + * Called in process context only.
> + * May be re-entered by multiple ioctl calling threads.
> + */
> +static int
> +gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
> +		  unsigned int cmd, unsigned long arg)
> +{
> +	struct cardstate *cs = cs_get(tty);
> +	int rc, val;
> +	int __user *p = (int __user *)arg;
> +
> +	if (!cs)
> +		return -ENXIO;
> +
> +	switch (cmd) {
> +	case TCGETS:
> +	case TCGETA:
> +		/* pass through to underlying serial device */
> +		rc = n_tty_ioctl(tty, file, cmd, arg);
> +		break;
> +
> +	case TCFLSH:
> +		/* flush our buffers and the serial port's buffer */
> +		switch (arg) {
> +		case TCIFLUSH:
> +			/* no own input buffer to flush */
> +			break;
> +		case TCIOFLUSH:
> +		case TCOFLUSH:
> +			flush_send_queue(cs);
> +			break;
> +		}
> +		/* flush the serial port's buffer */
> +		rc = n_tty_ioctl(tty, file, cmd, arg);
> +		break;
> +
> +	case FIONREAD:
> +		/* unused, always return zero */
> +		val = 0;
> +		rc = put_user(val, p) ? -EFAULT : 0;

I think
		rc = put_user(val, p);
will do the same thing here.

> + * Will not be re-entered while running but other ldisc functions
> + * may be called in parallel.
> + * Can be called from hard interrupt level as well as soft interrupt
> + * level or mainline.
> + * Parameters:
> + *	tty	tty structure
> + *	buf	buffer containing received characters
> + *	cflags	buffer containing error flags for received characters (ignored)
> + *	count	number of received characters
> + */
> +static void
> +gigaset_tty_receive(struct tty_struct *tty, const unsigned char *buf,
> +		    char *cflags, int count)
> +{
> +	struct cardstate *cs = cs_get(tty);
> +	unsigned tail, head, n;
> +	struct inbuf_t *inbuf;
> +
> +	if (!cs)
> +		return;
> +	if (!(inbuf = cs->inbuf)) {
> +		dev_err(cs->dev, "%s: no inbuf\n", __func__);
> +		cs_put(cs);
> +		return;
> +	}
> +
> +	tail = atomic_read(&inbuf->tail);
> +	head = atomic_read(&inbuf->head);
> +	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u, receive %u bytes",
> +		head, tail, count);
> +
> +	if (head <= tail) {
> +		n = RBUFSIZE - tail;
> +		if (count >= n) {
> +			/* buffer wraparound */
> +			memcpy(inbuf->data + tail, buf, n);
> +			tail = 0;
> +			buf += n;
> +			count -= n;
> +		} else {
> +			memcpy(inbuf->data + tail, buf, count);
> +			tail += count;
> +			buf += count;
> +			count = 0;
> +		}
> +	}

Perhaps the (fairly revolting) circ_buf.h can be used for this stuff.

> +	if (count > 0) {
> +		/* tail < head and some data left */
> +		n = head - tail - 1;
> +		if (count > n) {
> +			dev_err(cs->dev,
> +				"inbuf overflow, discarding %d bytes\n",
> +				count - n);
> +			count = n;
> +		}
> +		memcpy(inbuf->data + tail, buf, count);
> +		tail += count;
> +	}
> +
> +	gig_dbg(DEBUG_INTR, "setting tail to %u", tail);
> +	atomic_set(&inbuf->tail, tail);
> +
> +	/* Everything was received .. Push data into handler */
> +	gig_dbg(DEBUG_INTR, "%s-->BH", __func__);
> +	gigaset_schedule_event(cs);
> +	cs_put(cs);
> +}
> +

