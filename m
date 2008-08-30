Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYH3DLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYH3DLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYH3DLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:11:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbYH3DLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:11:09 -0400
Date: Fri, 29 Aug 2008 20:10:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808292000v767ce75fn80f665f2cf79ce3d@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808292006001.5010@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>  <200808300031.16708.rjw@sisk.pl>  <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com> 
 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>  <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
  <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>  <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org> <86802c440808292000v767ce75fn80f665f2cf79ce3d@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
>
> > Yeah, no, that's horrid. I'm happy it's reverted.
> 
> if update res->end according mmconfig end, before insert it forcibly,
> then could fix the chipset BAR problem too.

Except it's still a horrible patch that special-cases all the wrong things 
(ie random resources that we just happen to know that ACPI etc cares 
about).

There's no way to know in general if ACPI might care deeply where some 
random resource is (say, graphics memory) and it might be done with a BAR.

So that's why I think the approach stinks.

> BTW, insert_resource_expand_to_fit need to be replaced with
> insert_resource_split_to_fit....
> test stub reveal expand will make __request_region not working for
> some devices...because reserved_entries from e820 take
> IORESOUCE_BUSY...

Well, we should probably just remove the IORESOURCE_BUSY part.

Again, that comes from the fact that the e820 resources used to _override_ 
everything - they were inserted first, and nothing else was _ever_ allowed 
to allocate in that region. 

But if we're changing that, then the whole IORESOURCE_BUSY part doesn't 
make sense.

In fact, in general, IORESOURCE_BUSY doesn't much make sense any more in 
general, because it was actually more of an ISA-timeframe locking model 
saying "you can't touch this region". But if the whole point is that we 
now try to allow PCI device BAR's and the e820 maps to co-exist, then the 
whole - and only - reason for IORESOURCE_BUSY for them goes away..

			Linus
