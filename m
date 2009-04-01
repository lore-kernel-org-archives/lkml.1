Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbZDAT7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbZDAT7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZDAT7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:59:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbZDAT7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:59:34 -0400
Date: Wed, 1 Apr 2009 12:39:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <20090401190113.GA734@elte.hu>
Message-ID: <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain>
References: <20090325150035.541e707a@skybase> <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org>
 <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Apr 2009, Ingo Molnar wrote:
>  
> The rest (unannotated variables) is to be assumed "access-rarely" or 
> "we-dont-care", by default. This is actually 95% of the global 
> variables.

I'm not at all convinced that this is a good option.

The thing is, things like "read_mostly" or "access_rarely" may talk about 
how we access those individual variables, but you're missing a _huge_ 
chunk of the puzzle if you ignore the _correlations_ of those accesses 
with accesses to other variables.

The thign is, if you have variables 'a' and 'b', and they are always 
accessed together, then it's probably worth it to put them in the same 
cacheline.

And that is true EVEN IF 'b' is basically read-only, but 'a' is always 
written to. Marking 'a' as read-only or read-mostly is actually a bad 
idea, since the only thing it can ever result in is a bigger cache 
footprint.

The fact that the read-only cacheline has "nicer" behavior is totally 
irrelevant - it's still an extra cacheline that we're accessing. And they 
aren't free, even if read-only cachelines that can be shared across CPU's 
are certainly a lot cheaper than ones that bounce.

			Linus
