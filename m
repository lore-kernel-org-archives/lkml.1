Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbZE0RKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbZE0RKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZE0RKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:10:34 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:43301 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZE0RKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:10:33 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: LOCK prefix on uni processor has its use (was Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic)
Date: Wed, 27 May 2009 12:10:29 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090527170118.GC4024@prithivi.gnumonks.org>
In-Reply-To: <20090527170118.GC4024@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271210.32698.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Harald Welte wrote:
> Hi hpa and others,
> 
> On Sat, May 23, 2009 at 04:44:08PM -0700, H. Peter Anvin wrote:
>  
> > It looks like there might be a problem with the C7-M ... Michael reports
> > that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
> > necessary for a uniprocessor.
> 
> It seems, they are neccessary.
> 
> Here are some statements from the CPU logic guys at VIA/Centaur:
> 
> * A read-modify-write sequence cannot be interupted.
> * All X86 instructions except rep-strings are atomic wrt interrupts.
> * The lock prefix has uses on a UP processor: It keeps DMA devices from
>   interfering with a read-modify-write sequence
> 
> Furthermore, they have done some experimentation in the past, making the
> CPU simply ignore the LOCK prefix on uni-processor (running a certain popular
> proprietary operating system): It doesn't work, presumably of the abovementioned
> DMA related conflict.
> 
> Also, the engineers believe that it is only a matter of time until different
> CPU/chipset combination would expose the same bug.  Since the in-order
> single-retire C7-M is more vulnerable than out-of-order, multiple-retire CPU's,
> they are not surprised that the issue shows first on the C7-M.
> 
> The recommendation from the CPU engineers, unsurprisingly, thus is to put the
> LOCK prefixes back where they were.
> 
> Hope this helps you.
> 
> Now if I understand the issues correctly, it would mean that there is some
> driver code that modifies a certain chunk of memory, while DMA of some
> peripheral is also accessing that memory.  I suppose it would not have to be
> the same actual address, but probably being within the same cache line is
> already sufficient.
>

I am also testing with the pci cache line size hard-coded to be the same size
as the processor cache line size (a WAFG for now) - -

It is too soon (only an 1 1/2 hours) to be a significant finding - -
but if this was set to twice the physical line length, it would be only
flushing every other line - which I think would show up *real* fast.  ;)

I am noticing some "dropped buffers and/or dropped packets" in my streaming
music - - but that is not conclusive of anything other than hd-audio may
be using the wrong cache stride also.  ;)

Mike 
> Now the question is: Is this a valid operation of a driver?  Should the driver
> do such things, or is such a driver broken?  When would that occur?  I'm trying
> to come up with a case, but typically you e.g. allocate some DMA buffer and
> then don't touch it until the hardware has processed it.
> 
> Regards,


