Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZD2UBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZD2UBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbZD2UAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:00:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55460 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760288AbZD2UAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:00:41 -0400
Message-ID: <49F8B1A1.4010208@garzik.org>
Date: Wed, 29 Apr 2009 15:59:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, h.mitake@gmail.com, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	<20090421.173123.191021055.davem@davemloft.net>	<adak55438gp.fsf_-_@cisco.com>	<20090428.221228.217954247.davem@davemloft.net>	<20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org> <adahc071ie4.fsf@cisco.com>
In-Reply-To: <adahc071ie4.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > This removal patch is completely pointless, because it moves us
>  > backwards to the point where we had a bunch of drivers defining it.
> 
> No, the current kernel still requires drivers to define it anyway,
> because there are tons of 32-bit architectures that are not x86.

Then let's fix that issue...  by propagating the common definition to 
other platforms that properly implement {read,write}[bwl] in terms of 
the PCI bus.


> And more than that, centralizing the definition makes the API much more
> dangerous for driver authors.

I think that's really cranking the hyperbole level to 11.

The common definition is... the one found most commonly in the wild. 
For weird drivers, they will do their own thing.

That's pretty much how other drivers handle things.

Apply your logic here to _any_ API in the kernel, for the same result.


>  > At least the networking drivers I messed with (until 11/2008) were
>  > always fine with a non-atomic readq.
> 
> The commit to niu I keep citing (e23a59e1, "niu: Fix readq
> implementation when architecture does not provide one.") shows that
> drivers need to take care.  Now, the x86 implementation would happen to

That commit also shows that, had the driver been using a common 
definition, problems would not have arisen.


> work for that hardware, but eg drivers/infiniband/hw/amso1100 defines
> readq with the opposite order -- whether that's required or just an

'required' seems unlikely, given that

a) their readq only exists when #ifndef readq, thus implying the 
driver-local readq is far less tested, on their most-tested, 
highest-volume platform.

b) their readq still operates in LE order -- as it should: 
read,write[bwl] were defined in terms of PCI originally, and thus 
defined to be LE.

c) their __raw_writeq writes in lower-32-bits-first, as one would expect


> arbitrary choice, I don't know.  And drivers/infiniband/hw/mthca has
> some uses of __raw_writeq() that only work if no other CPU accesses to
> the same page can happen between the two halves, so it adds a per-page
> spinlock for 32-bit architectures.  etc.

Any use of __raw_xxx implies that You Know What You're Doing And Accept 
The Consequences.  __raw_xxx means _you_ handle endian conversions, 
barriers, and other arch-specific details.  I don't think that a driver 
intentionally using the "raw" APIs is a good source of ideas and 
generalizations.

So, for your three examples,

	1) niu - common definition is OK

	2) amso1100 - common definition is OK; driver-local definition
	   never used on common PCI platforms

	3) mthca - intentionally uses raw API, an API which ditches
	   arch-specific barriers, endian conversions, and other
	   guarantees.

Given that, I see zero justification for API removal.  I see 
justification for propagating this code to other PCI-capable platforms.

Finally, I think given all this time we've had driver-define writeq and 
readq, and "driver authors were forced to think about this API" -- the 
result was the obvious definition now in place!

	Jeff




