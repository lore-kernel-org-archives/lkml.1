Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYIEQkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYIEQkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYIEQki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:40:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbYIEQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:40:37 -0400
Date: Fri, 5 Sep 2008 09:39:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Beulich <jbeulich@novell.com>
cc: linux@sandersweb.net, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi-suse@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C17754.76E4.0078.0@novell.com>
Message-ID: <alpine.LFD.1.10.0809050931340.3117@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net> <48C17754.76E4.0078.0@novell.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Sep 2008, Jan Beulich wrote:
> 
> I disagree here: If I configure a 686+ kernel, I expect these NOPs to be
> that way (and to work). If you want to run on something that's not
> compliant, you just shouldn't configure your kernel that way.

Well, if you actually do a

	git grep 'ASM_NOP[0-9]'

you'll find that just the _definitions_ of those things are the bulk of it 
BY FAR, and that there doesn't seem to be a single user that cares even 
remotely about performance.

So I actually think that the whole thing is a waste of time. We should 
probably 

 - pick a single set of NOP's per 32-bit/64-bit (since the good nops in 
   32-bit aren't 64-bit instructions at all, so we do want different nops 
   depending on _that_)

   The whole static choice by microarchitecture is pure garbage.

 - Probably also just declare that those default nops are single 
   instructions, just so that we never even have to think about it from a 
   dynamic replacement angle.

   Look at the uses again, and realize that it really is just pure garbage 
   to have this kind of complex and subtle stuff going on.

 - Move the optimized nop definitions (K7_NOPx etc) to the only place that 
   cares - asm/x86/kernel/alternative.c. When we do things _dynamically_, 
   it can actually make sense to pick a nop more precisely, but for this 
   whole static thing it's just a pain.

IOW, if it actually _worked_ reasonably, I wouldn't care. But clearly it 
doesn't. And once it's not working reasonably, it should be fixed.

		Linus
