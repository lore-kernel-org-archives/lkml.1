Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbXDILdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbXDILdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXDILdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:33:52 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3924 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbXDILdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:33:50 -0400
Date: Mon, 9 Apr 2007 12:33:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070409113341.GA26874@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>
References: <20070330110022.GA21653@flint.arm.linux.org.uk> <20070330110800.GB21653@flint.arm.linux.org.uk> <20070408101826.GA5431@flint.arm.linux.org.uk> <20070408210917.6e306851@the-village.bc.nu> <20070409081824.GA28366@flint.arm.linux.org.uk> <20070409112506.65f7c8e0@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409112506.65f7c8e0@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 11:25:06AM +0100, Alan Cox wrote:
> > When you quantise those figures using a clock period of 62.5ns (16MHz)
> > you end up with: 2 clocks active (2*62.5 > 70), 1 clock recovery
> > (1*62.5 > 25) and 2 clocks cycle (2*62.5 > 120).
> > 
> > Last time I checked, active + recovery must always be equal to the cycle
> > time, and unless my math is failing me, 2 + 1 does not equal 2.
> 
> The libata code does the following:
> 
>         if (t->active + t->recover < t->cycle) {
>                 t->active += (t->cycle - (t->active + t->recover)) / 2;
>                 t->recover = t->cycle - t->active;
>         }
> 
> which probably means for 16MHz you don't have enough resolution to be sure
> you'll error in this direction in all cases. If so you just need to try
> adding
> 
> 	if (t->active + t->recover > t->cycle)
> 		t->cycle = t->active + t->recover
> 
> to stretch the cycle time to fit the resolution as well.
> 
> And we should get this tested/fixed by someone seeing the problem, before
> and instead of putting hacks/notes in drivers that may then get lost

I agree; this is why I sent the patch out as an RFC before wanting it
merged.  My feeling at the time when I wrote this is it's something that
the libata timing calculation code should already be catering for.

I should've explicitly mentioned that in the comments, but forgot.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
