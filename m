Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbYDCVkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbYDCVkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYDCVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:40:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:25445 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYDCVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gUH4VLmE5OZXdlV8GouMUnEWUlhn60g/TI6NoyHkiN5Zw7EXnCgfyvBLDdRfyCGZR04HxH5Vl0k4xV7tJ6kOZZKKTYirCqH6CBOqRDafroV+x+huTpc+7kj0wTm7ytnSPYV1HFnzpLR5VP++fky0v6juiYKP5t9eAoKa6mFN16w=
Message-ID: <19f34abd0804031440x582674f6sa0dcddb62b0db226@mail.gmail.com>
Date: Thu, 3 Apr 2008 23:40:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: mmiotrace bug: recursive probe hit
Cc: avi@qumranet.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Pavel Roskin" <proski@gnu.org>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi
In-Reply-To: <20080404000701.70bbc1a4@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	 <20080328222500.21863a44@daedalus.pq.iki.fi>
	 <20080330202608.054702a4@daedalus.pq.iki.fi>
	 <20080404000701.70bbc1a4@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 11:07 PM, Pekka Paalanen <pq@iki.fi> wrote:
> Pekka Paalanen <pq@iki.fi> wrote:
> > C) Vegard mentioned something about per-cpu page tables for kmemcheck.
>  > This would be the ultimate solution, because it would solve two problems:
>  > - recursive probe hits
>  > - missed events due to another cpu disarming the page for single stepping
>  > Would it be possible to have a single temporary per-cpu pte?
>  >
>  > I understood kmemcheck has similar issues. Of course, one could force the
>  > system down to a single running CPU, but that feels nasty.

Yes, Ingo Molnar has suggested per-cpu page tables, but that's so far
away from what I am capable of, so unless Ingo wants to do it himself,
I fear it will never be done ;-) [I also believe the resulting code
would be too ugly and too un-useful for the rest of the kernel that it
would probably not ever be merged. But that's a different story.] But
I do think this is the best solution in terms of reliability.

We do indeed limit maxcpus to 1 at run-time if the kernel is compiled
with CONFIG_SMP. kmemcheck is a debugging facility, and as such,
actual multiprocessor support is not critical for the purpose of
kmemcheck, in my opinion. Doesn't the same hold for mmiotrace?

>  One more idea:
>
>  D) Emulate the faulting instruction.
>  In __ioremap(), do the mapping, but steal it for mmiotrace's personal use,
>  and return a bogus mapping that is identifiable in #pf handler. When
>  something accesses the bogus mapping, emulate and step over the faulting
>  instruction using the stolen IO memory mapping. This would get rid of
>  the debug trap and single stepping, and also remove the need to disarm
>  the mmio page, which means tracing would work reliably on SMP without
>  any page table kludges. This would also remove the yet another instruction
>  decoding code that mmiotrace has.
>
>  The catch is the instruction emulation. I see KVM has some emulation code,
>  but I cannot understand it without a deep study that would take me weeks.
>  Is that general enough to be used, or could it be generalized?
>  Mmiotrace, apart from executing the instruction with a modified address,
>  would need to extract the type of IO memory access, width and the data
>  read/written. And since it is dealing with IO memory, the emulation
>  should be very careful to access the hardware exactly like the original
>  instruction would have.

I think that would be extremely difficult to do. I am personally
trying to stay as far away from opcode decoding (and recoding!
*shudder*) as possible. I do the minimal decoding for operand sizes,
etc, which I think you do as well in mmiotrace.

>  Maybe also kmemcheck could use this approach, since the current approach
>  is very much like in mmiotrace: #pf, show page, single step, #db trap,
>  hide page.

They are indeed very much the same. I wish somebody had told me about
mmiotrace when I first started working on kmemcheck! :-)


I don't think I can be of much more help than that. Just my opinion on things.


Kind regards,
Vegard Nossum
