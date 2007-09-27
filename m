Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXI0GGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXI0GGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXI0GGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:06:06 -0400
Received: from tag.witbe.net ([81.88.96.48]:52158 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbXI0GGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:06:04 -0400
Date: Thu, 27 Sep 2007 08:05:51 +0200
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <htejun@gmail.com>
Cc: David Newall <david@davidnewall.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>, rol@witbe.net
Subject: Re: 2.6.23-rc7 - _random_ IRQ23 : nobody cared
Message-ID: <20070927080551.424e90b9@tux.DEF.witbe.net>
In-Reply-To: <46FAFF7A.5070208@gmail.com>
References: <20070924083336.7a08fd61@tux.DEF.witbe.net>
	<46F7C933.4080003@davidnewall.com>
	<20070925090057.5778aa2a@tux.DEF.witbe.net>
	<46FAFF7A.5070208@gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, 27 Sep 2007 09:55:22 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Paul Rolland wrote:
> > Hi David,
> > 
> > On Mon, 24 Sep 2007 23:56:59 +0930
> > David Newall <david@davidnewall.com> wrote:
> > 
> >> Paul Rolland "(???????) wrote:
> >>> Hell, IRQ 23 is shared between libata and my modem !!!
> >>>   
> >> Tried using the modem?
> > 
> Can you change driver load order such that the driver for the modem is
> loaded first?

As I said, it's not possible, because :
 - the modem driver is an out-kernel one, so I have to wait the end of the
   boot process so that it can be loaded,
 - libata on IRQ23 is the one taking care of my disks, and I suspect it 
   quite hard to install a modem driver before having the disk driver
   installed.

I was thinking of delaying the disabling of the IRQ, which is basically the
other part of the problem (the first part being that spurious IRQ from the
modem). If it is possible to do that long enough for the modem driver to be
loaded, then the "IRQ xx : nobody cared" becomes an informational message
during the boot process, and then it vanishes, leaving a perfectly working
machine.
I suspect something in note_interrupt that would do (totally
untested, just thinking loudly) :

	/* Allow some delay to complete boot process before
	 * killing an IRQ. This allow some modules to be
	 * loaded before we decide the IRQ will not be handled.
	 */
	if (jiffies > 120*HZ) {
		/*
		 * Now kill the IRQ
		 */
		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
		desc->status |= IRQ_DISABLED;
		desc->depth = 1;
		desc->chip->disable(irq);
	}

I'll try that this week-end, but if someone has an opinion about it, I'll
be glad to know :)

Regards,
Paul

