Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYIETI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYIETI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYIETIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:08:44 -0400
Received: from gw.goop.org ([64.81.55.164]:57255 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYIETIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:08:44 -0400
Message-ID: <48C183B6.6030909@goop.org>
Date: Fri, 05 Sep 2008 12:08:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Beulich <jbeulich@novell.com>, linux@sandersweb.net,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi-suse@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net> <48C17754.76E4.0078.0@novell.com> <alpine.LFD.1.10.0809050931340.3117@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809050931340.3117@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 5 Sep 2008, Jan Beulich wrote:
>   
>> I disagree here: If I configure a 686+ kernel, I expect these NOPs to be
>> that way (and to work). If you want to run on something that's not
>> compliant, you just shouldn't configure your kernel that way.
>>     
>
> Well, if you actually do a
>
> 	git grep 'ASM_NOP[0-9]'
>
> you'll find that just the _definitions_ of those things are the bulk of it 
> BY FAR, and that there doesn't seem to be a single user that cares even 
> remotely about performance.
>   

Well, the paravirt_ops patching uses multibyte nops to pad out the
unused space in a patch site, and they're generally on hot paths
(otherwise we wouldn't bother with patching).  But even then I don't
think the particular nop chosen matters all that much, and even if it
did using the dumb redundant prefix long nops seems to be as good as or
better than the p6 nops.  The "call mcount" patching ftrace wants to do
would also be pretty common.

> So I actually think that the whole thing is a waste of time. We should 
> probably 
>
>  - pick a single set of NOP's per 32-bit/64-bit (since the good nops in 
>    32-bit aren't 64-bit instructions at all, so we do want different nops 
>    depending on _that_)
>
>    The whole static choice by microarchitecture is pure garbage.
>
>  - Probably also just declare that those default nops are single 
>    instructions, just so that we never even have to think about it from a 
>    dynamic replacement angle.
>   

Yes, that would be a good idea.

>  - Move the optimized nop definitions (K7_NOPx etc) to the only place that 
>    cares - asm/x86/kernel/alternative.c. When we do things _dynamically_, 
>    it can actually make sense to pick a nop more precisely, but for this 
>    whole static thing it's just a pain.
>   

Yep.  We could run the p6 nops with an exception handler to see if the
cpu actually supports them or not.  And if not, just fall back to
something simple and good enough.

    J
