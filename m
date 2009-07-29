Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZG2LHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZG2LHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZG2LHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:07:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38504 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753459AbZG2LHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:07:13 -0400
Date: Wed, 29 Jul 2009 12:07:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gene Heskett <gene.heskett@verizon.net>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729120704.3299ff2e@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
	<200907282250.46018.gene.heskett@verizon.net>
	<alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 21:49:05 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 28 Jul 2009, Gene Heskett wrote:
> > 
> > It doesn't seem to do anything for bz 13841 here.  Sorry, I wish it did.
> 
> No, bz 13841 isn't about pty's, it's about usb serial. The patches in this 
> thread would mainly be pty-related, and would affect other tty drivers 
> (like your usb one) only purely by chance.
> 
> could you bisect the 13841 behavior?

See the thread in 13821 on linux-usb list which extends from the "why do
we leak ttyUSB numbers" into this as well. Its been pinned down and the in
tree fix is confirmed to do the job for that case. Not perfectly because
it needs a further small fix as

a) it should call drv->close() within the mutex on the error path if the
tty_block_til_ready() fails without which you get a leak on a few drivers
but nothing too harmful. (Noted by Alan Stern inspecting the patch)

b) it fails the 'variable frequency generator on carrier pin' test - but
that isn't a regression as such as all 2.6 kernels I've tried crash
during that test with USB.  (Running my 'extreme violence' test setup)

I suspect that doing

        retval = tty_port_block_til_ready(&port->port, tty, filp);
        if (retval == 0) {
                if (!first)
                        usb_serial_put(serial);
                return 0;
        }
        mutex_lock(&port->mutex);


	if (tty_hung_up_p(filp)) {
		mutex_unlock(&port->mutex);
		return retval;
	}
	dev->close(port);

	...

fixes both. The race basically is

		open
		drop mutex so we can wait for the port
		wait for the port
						[hangup]
						[serial_do_down]
		block_til_ready reports an error
		take mutex
			duplicate serial_do_down


Most serial drivers don't try and do open clean up in open() instead they
do it in close() which is called by the tty layer on an open failure
(always has been) and which turns out to be a useful design
decision as it means the driver doesn't have to tie itself in knots and
tty_port_close_start() handles all the mechanics. Plus they use
ASYNC_INITIALIZED as flag to avoid double shutdowns on a device.

Simply deleting most of the clean up from serial_open and letting close()
do its job would I think clean that up no end but not in an -rc perhaps.


