Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbXJCTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbXJCTX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXJCTXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:23:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbXJCTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:23:20 -0400
Date: Wed, 3 Oct 2007 12:22:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Neil Romig <neil@romig.demon.co.uk>, linux-kernel@vger.kernel.org,
       hyoshiok@miraclelinux.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: File corruption when using kernels 2.6.18+
In-Reply-To: <84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>
References: <46FFC371.9040805@romig.demon.co.uk> 
 <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com> 
 <4702B28F.5050404@romig.demon.co.uk>  <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
  <4703E287.3070705@romig.demon.co.uk>
 <84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Pekka Enberg wrote:

> Hi Neil,
> 
> On 10/3/07, Neil Romig <neil@romig.demon.co.uk> wrote:
> > > > Thanks for your help on this. I have narrowed it down to commit
> > > > "c22ce143d15eb288543fe9873e1c5ac1c01b69a1 x86: cache pollution aware
> > > > __copy_from_user_ll()". This fits with the errors I'm getting, so now I need
> > > > to find out if I can safely ignore this patch, or does it have to be modified?
> > > > This is my first Linux bug in many years of simply using it, so I'm a little
> > > > nervous!
> 
> A some point in time, I wrote:
> > > Just to make sure, if you disable CONFIG_X86_INTEL_USERCOPY, the
> > > corruption goes away?
> 
> On 10/3/07, Neil Romig <neil@romig.demon.co.uk> wrote:
> > It took some fiddling to disable (edit arch/i386/Kconfig.cpu) but that has fixed it.
> > Many thanks!
> >
> > Does this need to be reported as a bug? Or should the kernel config scripts be
> > changed to enable this option to be easily turned off?
> 
> Looks like a bug to me. Can we have your /proc/cpuinfo too?

I doubt it's a CPU bug. It's more likely a chipset or motherboard bug 
around the CPU. The patterns for the original "cp" corruption that Neil 
posted seem to be:

	   File offset		correct		corrupt
	 decimal      hex
	======== ========
	  642470 0009cda6	'm' 0x6D	'o' 0x6f
	  972198 000ed5a6	'i' 0x69	'a' 0x61
	 1243686 0012fa26	's' 0x73	'c' 0x63
	 1676846 0019962e	't' 0x74	'`' 0x64
	 1907974 001d1d06	' ' 0x20	'(' 0x28
	...

and since it's apparently about using the uncached accesses, it's 
interesting that the low three bits are identical in all those corruptions 
(they also seem to be single-bit errors in the actual byte-value, although 
the bit is not the same). If the external bus is 64 bits (?), that would 
say that it's one particular byte lane that is dodgy.

I would bet that the reason the intel-optimized memcpy triggers this is 
that the non-temporal stores just means that you go out directly on the 
bus, and it probably just shows a weakness in the chipset or bus that 
doesn't show with the normal cacheline accesses.

			Linus
