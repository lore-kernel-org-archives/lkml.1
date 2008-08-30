Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYH3GTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYH3GTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYH3GTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:19:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYH3GTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:19:22 -0400
Date: Fri, 29 Aug 2008 23:18:05 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.1.10.0808292216310.3290@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808292312120.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>  <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>  <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>  <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
  <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>  <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org> <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
 <alpine.LFD.1.10.0808292216310.3290@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Linus Torvalds wrote:
> 
> IORESOURCE_BUSY is really more of a "legacy bit". It has almost no bearing 
> on the actual allocations.

And just to clarify - I think that while you get that error for the 
qla2xxx driver, I suspect that your actual resource tree is all good, and 
that the PCI allocations were fine.

And then the problem you his is now that the driver literally thinks that 
some other driver already took that resource.

The patch I just sent is not actually the patch I think you should do: the 
proper patch is to just remove IORESOURCE_BUSY from the e820 resources, 
simply because they are _not_ indicative of a driver already holding on to 
the resource.

Of course, the sad part is that potentially IORESOURCE_BUSY might actually 
be a really good bit for exactly that - we've had tons of issues with 
hardware sensors literally having a kernel driver _and_ a system level 
driver (ie ACPI), and things get confused exactly because there are now 
two drivers trying to drive the same piece of hardware.

But basically, if you have BAR's and the e820 resource areas co-existing, 
then the e820 resources shouldn't be marked BUSY.

Anyway - to just re-cap - you might as well just ignore the patch I just 
sent out, and instead just avoid doing that BUSY bit to begin with in the 
"late e820" case. Simpler and more correct.

		Linus
