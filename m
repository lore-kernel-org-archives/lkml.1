Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbXBXTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbXBXTwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbXBXTwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:52:45 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:10508 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbXBXTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:52:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tH0DvVbjQ8B8SvSnncC/vCY0ti1kMUlBuy4blLcXa4dZmb6t2bbByoGdR5mS5yvSBwYQ2BhUmSJc+rZBhnbhjUQsCsz3kHf8ucDkEg1viWBEqFIJks8ykLV8r4f95DIwuk7ot2VaNhVkrR5exOUe5uyVhbu7KcgvYhJA+xlpreU=
Message-ID: <f2b55d220702241152o640abaf3jc10afefaae8476cb@mail.gmail.com>
Date: Sat, 24 Feb 2007 11:52:41 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070223121751.GA6626@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
	 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223121751.GA6626@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Ingo Molnar <mingo@elte.hu> wrote:
> > This is a fundamental misconception. [...]
>
> > The scheduler, on the other hand, has to blow and reload all of the
> > hidden state associated with force-loading the PC and wherever your
> > architecture keeps its TLS (maybe not the whole TLB, but not nothing,
> > either). [...]
>
> please read up a bit more about how the Linux scheduler works. Maybe
> even read the code if in doubt? In any case, please direct kernel newbie
> questions to http://kernelnewbies.org/, not linux-kernel@vger.kernel.org.

This is not the first kernel I've swum around in, and I've been
mucking with the Linux kernel since early 2.2 and coding assembly for
heavily pipelined processors on and off since 1990.  So I may be a
newbie to your lingo, and I may even be a loud-mouthed idiot, but I'm
not a wet-behind-the-ears undergrad, OK?

Now, I've addressed the non-free-ness of a TLS swap elsewhere; what
about function pointers in state machines (with or without flipping
"supervisor mode" bits)?  Just because loading the PC from a data
register is one opcode in the instruction stream does not mean that it
is not quite expensive in terms of blown pipeline state and I-cache
stalls.  Really fast state machines exploit PC-relative branches that
really smart CPUs can speculatively execute past (after a few
traversals) because there are a small number of branch targets
actually hit.  The instruction prefetch / scheduler unit actually
keeps a table of PC-relative jump instructions found in I-cache, with
a little histogram of destinations eventually branched to, and
speculatively executes down the top branch or two.  (Intel Pentiums
have a fairly primitive but effective variant of this; see
http://www.x86.org/articles/branch/branchprediction.htm.)

More general mechanisms are called "branch target buffers" and US
Patent 6609194 is a good hook into the literature.  A sufficiently
smart CPU designer may have figured out how to do something similar
with computed jumps (add pc, pc, foo), but odds are high that it cuts
out when you throw function pointers around.  Syscall dispatch is a
special and heavily optimized case, though -- so it's quite
conceivable that a well designed userland switch/case state machine
that makes syscalls will outperform an in-kernel state machine data
structure traversal.  If this doesn't happen to be true on today's
desktop, it may be on tomorrow's desktop or today's NUMA monstrosity
or embedded mega-multi-MIPS.

There can also be other reasons why tabulated PC-relative jumps and
immediate PC loads are faster than PC loads from data registers.
Take, for instance, the Transmeta Crusoe, which (AIUI) used a trick
similar to the FX!32 x86 emulation on Alpha/NT.  If you're going to
"translate" CISC to RISC on the fly, you're going to recognize
switch/case idioms (including tabulated PC-relative branches), and fix
up the translated branch table to contain offsets to the
RISC-translated branch targets.  So the state transitions are just as
cheap as if they had been compiled to RISC in the first place.  Do it
with function pointers, and the the execution machine is going to have
to stall while it looks up the text location to see if it has it
translated in I-cache somewhere.  Guess what:  the PIV works the same
way (http://www.karbosguide.com/books/pcarchitecture/chapter12.htm).

Are you starting to get the picture that syslets -- clever as they
might have been on a VAX -- defeat many of the mechanisms that CPU and
compiler architects have negotiated over decades for accelerating real
code?  Especially now that we have hyper-threaded CPUs (parallel
instruction decode/issue units sharing almost all of their cache
hierarchy), you can almost treat the kernel as if it were microcode
for a syscall coprocessor.  If you try to migrate application code
across the syscall boundary, you may perform well on micro-benchmarks
but you're storing up trouble for the future.

If you don't think this kind of fallout is real, talk to whoever had
the bright idea of hijacking FPU registers to implement memcpy in
1996.  The PIII designers rolled over and added XMM so
micro-optimizers would get their dirty mitts off the FPU, which it
appears that Doug Ledford and Jim Blandy duly acted on in 1999.  Yes,
you still need to use FXSAVE/FXRSTOR when you want to mess with the
XMM stuff, but the CPU is smart enough to keep a shadow copy of all
the microstate that the flag states represent.  So if all you do
between FXSAVE and FXRSTOR is shlep bytes around with MOVAPS, the
FXRSTOR costs you little or nothing.  What hurts is an FXRSTOR from a
location that isn't the last location you FXSAVEd to, or an FXRSTOR
after actual FP arithmetic instructions have altered status flags.

The preceding may contain errors in detail -- I am neither a CPU
architect nor an x86 compiler writer nor even a serious kernel hacker.
 But hopefully it's at least food for thought.  If not, you know where
the "ignore this prolix nitwit" key is to be found on your keyboard.

Cheers,
- Michael
