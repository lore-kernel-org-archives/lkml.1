Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXDIKWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXDIKWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 06:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbXDIKWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 06:22:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40557 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932128AbXDIKWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 06:22:09 -0400
Date: Mon, 9 Apr 2007 11:25:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070409112506.65f7c8e0@the-village.bc.nu>
In-Reply-To: <20070409081824.GA28366@flint.arm.linux.org.uk>
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
	<20070330110800.GB21653@flint.arm.linux.org.uk>
	<20070408101826.GA5431@flint.arm.linux.org.uk>
	<20070408210917.6e306851@the-village.bc.nu>
	<20070409081824.GA28366@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The timings the drive sees clearly are not based upon a 16MHz clock
> period.  Therefore, I'd prefer to get the nanoseconds from the
> calculation and work from that.

Makes sense.

> Obviously I can demonstrate a bug. 8)
> 
> Lets say that we want to do MW DMA mode 2.  This has the minimum timing
> of 70ns active, 25ns recovery, 120ns cycle time.

Well it depends on the drive id data but assuming the defaults yes

> When you quantise those figures using a clock period of 62.5ns (16MHz)
> you end up with: 2 clocks active (2*62.5 > 70), 1 clock recovery
> (1*62.5 > 25) and 2 clocks cycle (2*62.5 > 120).
> 
> Last time I checked, active + recovery must always be equal to the cycle
> time, and unless my math is failing me, 2 + 1 does not equal 2.

The libata code does the following:

        if (t->active + t->recover < t->cycle) {
                t->active += (t->cycle - (t->active + t->recover)) / 2;
                t->recover = t->cycle - t->active;
        }

which probably means for 16MHz you don't have enough resolution to be sure
you'll error in this direction in all cases. If so you just need to try
adding

	if (t->active + t->recover > t->cycle)
		t->cycle = t->active + t->recover

to stretch the cycle time to fit the resolution as well.

And we should get this tested/fixed by someone seeing the problem, before
and instead of putting hacks/notes in drivers that may then get lost

Alan
