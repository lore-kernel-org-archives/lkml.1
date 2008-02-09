Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYBIN43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYBIN43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYBIN4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:56:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34960 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbYBIN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:56:19 -0500
Date: Sat, 9 Feb 2008 15:31:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080209143131.GD22569@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <200802090008.05430.prakash@punnoor.de> <20080209115920.GB21172@one.firstfloor.org> <200802091253.11478.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802091253.11478.prakash@punnoor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 12:53:11PM +0100, Prakash Punnoor wrote:
> On the day of Saturday 09 February 2008 Andi Kleen hast written:
> > > Grr, I don't know why I am discussing with stubborn and/or arrogant devs
> > > like you seem to be. But I actually did what you wanted and as *expected*
> > > - as I
> >
> > Thanks.
> >
> > > said I understand that trivial piece of code you posted - your patch
> > > fails here for my nforce2:
> >
> > That is 2.6.24 + my patch?  And system didn't boot?
> >
> > > cat /proc/interrupts
> > >            CPU0
> > >   0:        832    XT-PIC-XT        timer <---------------- seeing this?
> >
> > Well it looks like it is ticking. What are the symptoms?
> 
> You are seeing it. If you read my other mails you would comprehend it as well.

I would like to see a boot log with v3 of my patch at least so that I can 
see what is going on. Can you please supply one?

If you booted the patch as you claimed earlier that should be quite 
easy for you.

> > > And no, I won't test it on my MCP51 as I *know* what happens: As soon as
> > > I disable hpet, the quirk gets triggered and will lock up my system.
> >
> > I readded the HPET check in v2 especially for you so if HPET is enabled
> > no quirk is triggered.
> 
> Still you didn't give *any* proof that mcp51 needs quirk at all. I therefore 
> want that line *removed*:

We discussed this back then with Nvidia engineers and they stated
that only NF5 would need timer overrides. 

I suppose they didn't know about the case of your NF4 though. The only
reason for that I can think of is that your particular board differs
in non trivial ways from the reference design. Ok I suppose that's 
possible.

> 
> +       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 ? 
> */
> 
> Furthermore my original bios didn't have option to enable hpet. What then? 
> Kernel hangs unless I specify acpi_use_timer_override. Great.

Yes that's true, but that was the case anyways even without my
patch. Without my patch timer overrides are ignored on all Nvidia
boards without HPET. 

So no regression. And with HPET you should be fine for v2+ 


> 
> Hint: The correct way of quirking would be *only having this one* line:

No, we have NF3 and NF4 systems which have bogus timer overrides
unfortunately. If it was only for the NF2 everything would be easy.

> +       QBRIDGE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2, 
> nvidia_timer),
> 
> According to Len Brown's comment this would work for every nforce2. For every 
> other nforceX use DMI Scan and only quirk known broken bioses instead of 
> messing up working boxes.

DMI generally doesn't scale for any issues that are in reference
BIOS, because there are so many different OEMs. 

It might work for your specific board though. But again that does not
change with or withouyt my patch. On the other hand since your board
seems to have a BIOS update available with hpet enabled it seems
to work now, so your box is covered anyways.

Admittedly the cases my patch fixes are not very wide -- it is basically
only NF5 boards that do have an old BIOS without HPET. For everything
else it should be ideally a noop (if not I did something wrong).
Maybe those NF5 boards with old pre Vista certified BIOS are dying
out, but at least when I wrote the patch originally there were several
users were which had NF5 boards without HPET and no BIOS update available.

-Andi
