Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbXBZVVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbXBZVVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030522AbXBZVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:21:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803AbXBZVVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:21:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
Date: Mon, 26 Feb 2007 22:23:14 +0100
User-Agent: KMail/1.9.5
Cc: "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>,
       "Karasyov, Konstantin A" <konstantin.a.karasyov@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@osdl.org>
References: <8E389A5F2FEABA4CB1DEC35A25CB39CE82FE9F@mssmsx411> <200702251958.37315.rjw@sisk.pl> <200702262335.47874.arvidjaar@mail.ru>
In-Reply-To: <200702262335.47874.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702262223.14974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 February 2007 21:35, Andrey Borzenkov wrote:
> On Воскресенье 25 февраля 2007, Rafael J. Wysocki wrote:
> >
> > The patch looks good, but the changelog does not.  First, AFAICT, the
> > x86_64 code doesn't touch anything outside the e820 map.  Why do you think
> > it does?
> >
> 
> the following code:
> 
>        paddr = round_down(e820.map[0].addr + e820.map[0].size, PAGE_SIZE);
>         for (i = 1; i < e820.nr_map; i++) {
>                 struct e820entry *ei = &e820.map[i];
> 
>                 if (paddr < ei->addr)
>                         e820_mark_nosave_range(paddr,
>                                         round_up(ei->addr, PAGE_SIZE));
> 
> obviously will mark region *between* two e820 regions if they are not
> adjacent. I do not say that it is wrong (I have no idea); but exactly because
> I have no idea I tried to avoid it.

Yes, you are right, sorry.  We have to do this for x86_64, because there are
such holes in there on machines with more than 2 GB of RAM and swsusp chokes
on them if they are not marked.

On i386 we shouldn't really mark reserved areas in the highmem zone(s) as
nosave, because they are handled in a different way.

> > Second, it is not true that the region in question is at 0xee00 on x86_64.
> > At least on my box it's above the end of RAM.
> >
> 
> On my box the problem region starts at ee800 :) But you are right, it does not
> belong here.
> 
> > I think the x86_64 version is correct too.
> >
> 
> I do not say it is not. I just say that it does something I cannot verify so I
> better avoid it (i.e. I better change existing behaviour as little as
> possible).

OK

Can you please test your patch with the loop in e820_mark_nosave_regions()
restricted to the zones below highmem?

Rafael
