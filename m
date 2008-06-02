Return-Path: <linux-kernel-owner+w=401wt.eu-S1762428AbYFBOSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762428AbYFBOSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYFBOSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:18:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57860 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755340AbYFBOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:18:08 -0400
Date: Mon, 2 Jun 2008 15:02:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602150257.54692f35@core>
In-Reply-To: <20080602092551.GC26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com>
	<20080602075113.60d0fdf8@core>
	<20080602092551.GC26854@enneenne.com>
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

> It could be a bit better... I did as above since I supposed that you
> wished all PPS code should be removed from serial port code.

Ideally. But if it is genuinely the case that the serial port IRQ handler
in some cases needs to do

my_interrupt() {
	get_timestamp()
	frob_with_hardware()
	ld->dcd_change(blah, timestamp)
}

then that is still fairly clean and more importantly actually appears to
work. I'd avoid all the ifdefs with this in the serial drivers that need
more accuracy:

{
	struct timespec ts;
	if (ld->dcd_change)
		getnstimeofday(&ts);
	existing tty stuff
	if (ld->dcd_change)
		ld->dcd_change(tty, status, &ts);
}

And in ld->dcd_change do

	struct timespec myts;
	/* Caller passed NULL meaning 'do your own timestamp' */
	if (ts == NULL) {
		ts = &myts;
		getnstimeofday(&myts);
	}

so for uart that would

	uart_dcd_change(struct uart_port *port, unsigned int status,
					struct timespec *ts) {
	{
		...
	}

passing the timestamp from the ttys own IRQ handler

