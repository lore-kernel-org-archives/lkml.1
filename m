Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYDDNTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYDDNTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYDDNT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:19:28 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:45887 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755551AbYDDNT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:19:27 -0400
Date: Fri, 4 Apr 2008 16:18:53 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: avi@qumranet.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Pavel Roskin" <proski@gnu.org>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi
Subject: Re: mmiotrace bug: recursive probe hit
Message-ID: <20080404161853.7a10a6e9@daedalus.pq.iki.fi>
In-Reply-To: <19f34abd0804031440x582674f6sa0dcddb62b0db226@mail.gmail.com>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	<20080328222500.21863a44@daedalus.pq.iki.fi>
	<20080330202608.054702a4@daedalus.pq.iki.fi>
	<20080404000701.70bbc1a4@daedalus.pq.iki.fi>
	<19f34abd0804031440x582674f6sa0dcddb62b0db226@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 23:40:28 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On Thu, Apr 3, 2008 at 11:07 PM, Pekka Paalanen <pq@iki.fi> wrote:
> > ...

> We do indeed limit maxcpus to 1 at run-time if the kernel is compiled
> with CONFIG_SMP. kmemcheck is a debugging facility, and as such,
> actual multiprocessor support is not critical for the purpose of
> kmemcheck, in my opinion. Doesn't the same hold for mmiotrace?

Actually, I think kmemcheck should support SMP even more than mmiotrace.
Mmiotrace is just a reverse engineering tool for hardware drivers, but
kmemcheck as a debugging tool could be valuable specifically on SMP,
think about racing CPUs using and initializing memory. Dropping to UP
might hide those problems.

> >  One more idea:
> >
> >  D) Emulate the faulting instruction.
> >  In __ioremap(), do the mapping, but steal it for mmiotrace's personal use,
> >  and return a bogus mapping that is identifiable in #pf handler. When
> >  something accesses the bogus mapping, emulate and step over the faulting
> >  instruction using the stolen IO memory mapping. This would get rid of
> >  the debug trap and single stepping, and also remove the need to disarm
> >  the mmio page, which means tracing would work reliably on SMP without
> >  any page table kludges. This would also remove the yet another instruction
> >  decoding code that mmiotrace has.
> >
> >  The catch is the instruction emulation. I see KVM has some emulation code,
> >  but I cannot understand it without a deep study that would take me weeks.
> >  Is that general enough to be used, or could it be generalized?
> >  Mmiotrace, apart from executing the instruction with a modified address,
> >  would need to extract the type of IO memory access, width and the data
> >  read/written. And since it is dealing with IO memory, the emulation
> >  should be very careful to access the hardware exactly like the original
> >  instruction would have.
> 
> I think that would be extremely difficult to do. I am personally
> trying to stay as far away from opcode decoding (and recoding!
> *shudder*) as possible. I do the minimal decoding for operand sizes,
> etc, which I think you do as well in mmiotrace.

To be honest, I don't know how easy or difficult it is. If there was a
general decoding facility, it shouldn't be that hard to use, if someone
else makes the facility for us ;-)
Could all relevant instructions be represented as three-address-code or
in some other simple form?
This seems to require some experimenting with code.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
