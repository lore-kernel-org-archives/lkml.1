Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYFBO50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYFBO50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYFBO5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:57:18 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49770 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYFBO5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:57:17 -0400
Date: Mon, 2 Jun 2008 16:56:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20080602145603.GG26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com> <20080602075113.60d0fdf8@core> <20080602092551.GC26854@enneenne.com> <20080602150257.54692f35@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602150257.54692f35@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 03:02:57PM +0100, Alan Cox wrote:
> > It could be a bit better... I did as above since I supposed that you
> > wished all PPS code should be removed from serial port code.
> 
> Ideally. But if it is genuinely the case that the serial port IRQ handler
> in some cases needs to do
> 
> my_interrupt() {
> 	get_timestamp()
> 	frob_with_hardware()
> 	ld->dcd_change(blah, timestamp)
> }
> 
> then that is still fairly clean and more importantly actually appears to
> work. I'd avoid all the ifdefs with this in the serial drivers that need
> more accuracy:
> 
> {
> 	struct timespec ts;
> 	if (ld->dcd_change)
> 		getnstimeofday(&ts);
> 	existing tty stuff
> 	if (ld->dcd_change)
> 		ld->dcd_change(tty, status, &ts);
> }

I prefere avoid the if clause for getnstimeofday() since each
instruction delay may decrease time precision, so:

{
      struct timespec ts;
      getnstimeofday(&ts);
      existing tty stuff
      if (ld->dcd_change)
              ld->dcd_change(tty, status, &ts);
}

In the wrost case the timestamp is not used.

> And in ld->dcd_change do
> 
> 	struct timespec myts;
> 	/* Caller passed NULL meaning 'do your own timestamp' */
> 	if (ts == NULL) {
> 		ts = &myts;
> 		getnstimeofday(&myts);
> 	}

Ok.

> so for uart that would
> 
> 	uart_dcd_change(struct uart_port *port, unsigned int status,
> 					struct timespec *ts) {
> 	{
> 		...
> 	}
> 
> passing the timestamp from the ttys own IRQ handler

Great!

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
