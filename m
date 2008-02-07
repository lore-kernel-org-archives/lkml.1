Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYBGIga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYBGIga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYBGIgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:36:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:35422 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYBGIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HMd29x4lVrt9Yi0+M5Ge54LnL3VKv6SPPRbpCLsNjbEPXdvF4zzl9ipnOnsF0G5PNJ9pYfyQiuzttT1ChkmNsQAxTSncNT8kO0+W6Xxm33M2HeR4ycCK09k1/kuSCMkhIGdaYRg7FIXfnslAOQikV7ey/AOdEK5zq3UHTYQhfnk=
Message-ID: <86802c440802070036w1aced44ft8ab880e8ddeedc85@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:36:18 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: fix page table size
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080207080930.GB28631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802061246.43413.yinghai.lu@sun.com>
	 <200802061501.26533.yinghai.lu@sun.com>
	 <20080206231226.GA6417@elte.hu>
	 <200802062022.44069.yinghai.lu@sun.com>
	 <20080207080930.GB28631@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 12:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > [PATCH] x86_64: fix page table size
>
> > Entering add_active_range(0, 1048576, 67239936) 2 entries of 3200 used
> > end_pfn_map = 67239936
> > Kernel panic - not syncing: Overlapping early reservations 8000-109fff
> > PGTABLE to 9bc00-9dbff EBDA
> >
> > change back the logic. we DO need extra space for pmds when
> > direct_gbpages is not there.
>
> > @@ -370,7 +370,7 @@ static void __init find_early_table_space(unsigned long end)
> >
> >       puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
> >       tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
> > -     if (direct_gbpages) {
> > +     if (!direct_gbpages) {
>
> thanks Yinghai, applied!
>
> I'm wondering why this bug didnt trigger more widely. It seems to me it
> needs some serious amount of RAM to trigger this bug - correct?

yes.  need 256g.
128g without patch it still work. because round_up(.., PAGE_SIZE) get
some extra.

>
> btw., it would be nice to have some "lots of RAM simulation" debugging
> code which would just _fake_ a really large e820 map and would in the
> end throw away the 'fake' pages later during bootup. Perhaps tell the
> early allocator to never allocate into these fake areas [via an struct
> e820 entry flag], but all our sizing code and the boot bitmaps, etc.
> would be sized accordingly, as if we had this much RAM - and we'd
> trigger these nuances. We could put this into a new "fakemem=128GB" boot
> option and hence we could boot with fakemem=128GB on a 2GB box and could
> at least hope to be able to boot [with some serious amount of RAM wasted
> on over-sized pagetables, allocator bitmaps and mem_map[]]. Hm?

sound interesting. but need some variable to prevent using non exist page.

YH
