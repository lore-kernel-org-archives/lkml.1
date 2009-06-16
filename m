Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbZFPWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbZFPWrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZFPWrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:47:07 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:47060 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZFPWrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:47:05 -0400
X-Greylist: delayed 1162 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 18:47:05 EDT
Date: Wed, 17 Jun 2009 00:27:23 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
Message-ID: <20090616222723.GA18394@iram.es>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com> <alpine.LFD.2.01.0906131312470.3237@localhost.localdomain> <alpine.LFD.2.01.0906131323270.3237@localhost.localdomain> <4A34E4A5.3040306@redhat.com> <18996.60235.178618.531664@cargo.ozlabs.ibm.com> <4A34F564.2010500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A34F564.2010500@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 04:04:36PM +0300, Avi Kivity wrote:
> Paul Mackerras wrote:
>> Avi Kivity writes:
>>
>>   
>>> An alternative implementation using 64-bit cmpxchg will recover most 
>>> of the costs of hashed spinlocks.  I assume most serious 32-bit  
>>> architectures have them?
>>>     
>>
>> Have a 64-bit cmpxchg, you mean?  x86 is the only one I know of, and
>> it already has an atomic64_t implementation using cmpxchg8b (or
>> whatever it's called).
>>   
>
> Yes (and it is cmpxchg8b).  I'm surprised powerpc doesn't have DCAS support.

Well, s390 and m68k have the equivalent (although I don't think Linux
suppiorts SMP m68k, although some dual 68040/68060 boards have existed).

But 32 bit PPC will never have it. It just does not fit in the architecture
since integer loads and stores are limited to 32 bit (or split into 32 bit
chunks). Besides that there is no instruction that performs a read-modify-write
of memory. This would make the LSU much more complex for a corner case.

Hey, Intel also botched the first implementation of cmpxchg8b on the Pentium:
the (in)famous f00f bug is actually "lock cmpxchg8b" with a register operand.

Now for these counters, other solutions could be considered, like using
the most significant bit as a lock and having "only" 63 usable bits (when 
counting ns, this overflows at 292 years). 

>
>> My thinking is that the 32-bit non-x86 architectures will be mostly
>> UP, so the overhead is just an interrupt enable/restore.  Those that
>> are SMP I would expect to be small SMP -- mostly just 2 cpus and maybe
>> a few 4-way systems.
>>   
>
> The new Nehalems provide 8 logical threads in a single socket.  All  
> those threads share a cache, and they have cmpxchg8b anyway, so this  
> won't matter.
>

The problem is not Nehalem (who wants to run 32 bit kernels on a Nehalem
anyway) or x86.

The problem is that the assumption that the largest PPC32 SMP are 4 way
may be outdated:

http://www.freescale.com/webapp/sps/site/prod_summary.jsp?fastpreview=1&code=P4080

and some products including that processor have been announced (I don't know
whether they are shipping or not) and (apparently) run Linux.

	Gabriel
