Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYFBHGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYFBHGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYFBHGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:06:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60985 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781AbYFBHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:06:14 -0400
Date: Mon, 2 Jun 2008 07:51:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602075113.60d0fdf8@core>
In-Reply-To: <20080601161510.GA26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com>
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

> First I added a new dcd_change() ldisc method which can be used as
> follow:

This looks good.
> 
> static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
> {
>        int id = (int) tty->disc_data;
>        struct timespec __ts;
>        struct pps_ktime ts;
> 
>        /* First of all we get the time stamp... */
>        getnstimeofday(&__ts);
> 
>        /* ... and translate it to PPS time data struct */
>        ts.sec = __ts.tv_sec;
>        ts.nsec = __ts.tv_nsec;
> 
>        /* Now do the PPS event report */
>        pps_event(id, &ts,
>                        status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR, tty);
> 
>        pr_debug("[STDev] PPS %s at %lu on source #%d\n",
>                        status ? "assert" : "clear", jiffies, id);
> }
> 
> However this solution gives very low precision timestamps so that's

Where are you calling it from, and how ?

> 2) The new dcd_change() method is well implemented? Can I add the
> "irq" parameter or I can find it somewhere?

Not all tty devices have an IRQ (I suspect those which do not are useless
for PPS reporting however). 

Do you get decent reports if you change the tty driver to do

	getnstimeofday(&ts);
	[blah blah lots of serial port I/O code]
	if (dcd ^ old_dcd)
		ld->dcd_change(tty, dcd, &ts);

??

Alan
