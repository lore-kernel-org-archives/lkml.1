Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab0BEQJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:09:16 -0500
Received: from jgarrett.org ([64.5.53.252]:55259 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0BEQJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:09:14 -0500
Date: Fri, 5 Feb 2010 10:09:00 -0600
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100205160900.GA2736@jgarrett.org>
References: <20100126084740.GA5265@jgarrett.org> <87y6jkee1b.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6jkee1b.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jeff Garrett <jeff@jgarrett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 10:45:20PM +0100, Andi Kleen wrote:
> jeff@jgarrett.org (Jeff Garrett) writes:
> 
> > Hi,
> >
> > I was trying to chase down a theory that my desktop machine (a core i7)
> > is running warm (the fan sounds like it's at full speed all the time,
> > and I think it's not always acted this way -- hence the theory).
> >
> > powertop is never showing it spending any time in C3...
> >
> > I compiled a kernel without USB/sound/radeon, and ran without X.  I was
> > able to get the wakeups/sec down below 20, but no time is spent in C3.
> 
> [...]
> > This may be a complete red herring, but I added some printk logic to
> > acpi_idle_bm_check(), and it is getting called often, but bm_status is
> > always 1.  [I infer from this that the idle logic is trying to go into
> > C3, but this check is stopping it...  Unless I misread something.]
> 
> Normally a Core i7 (or any modern Intel systems) should not use
> bm_check at all. That's only for older systems that didn't support
> MWAIT with c-state hint, but relied on the old port based interface. 

bm_check = 1, bm_control = 0

I don't know what any of this means.  :)

I tried changing processor_idle.c.  It reads (for C3):
1106                         state->enter = pr->flags.bm_check ?
1107                                         acpi_idle_enter_bm :
1108                                         acpi_idle_enter_simple;

So it always calls acpi_idle_enter_bm in my case.  I tried modifying it
to call acpi_idle_enter_simple for entering C3 instead.  When I did
this, it did make it into C3 according to powertop, but the wakeups per
second grew by at least 10x.  I couldn't get that below ~400-800/s, and
the residency in C3 was limited to about ~50%, as reported by powertop.

> So something is already confused there.

Might just be me.  :)

> I think it should still work though.
> Of course if you really have a lot of bus mastering in the background
> then yes there will be no C3.
> 
> -Andi

I have no idea what counts as bus mastering (is it just DMA transfers to
PCI devices?)...  But with a fairly idle system, with things like USB
configured out, what could be doing it if it exists?  Would there be
some nice function I could instrument with a few printk's to, to see?  I
compiled with PCI_DEBUG=y, and "bus master" doesn't show up in the
dmesg.

-Jeff
