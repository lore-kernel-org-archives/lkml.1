Return-Path: <linux-kernel-owner+w=401wt.eu-S933581AbZFOT1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbZFOT1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZFOT1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:27:30 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:42546 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbZFOT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:27:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAKE6NkpMQWQl/2dsb2JhbACBT9UbhA0F
Date: Mon, 15 Jun 2009 15:27:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615192720.GA9056@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A369CD8.3090505@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:24:07 up 107 days, 15:50,  3 users,  load average: 0.65, 0.48,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Peter Zijlstra wrote:
> > On Mon, 2009-06-15 at 14:59 -0400, Mathieu Desnoyers wrote:
> >> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> >>> On Mon, 2009-06-15 at 14:48 -0400, Mathieu Desnoyers wrote:
> >>>> we should not care that much about the performance hit of
> >>>> saving/restoring the cr2 register at each nmi entry/exit.
> >>> But we do, perf counters very much cares about nmi performance.
> >>>
> >> To a point where it cannot afford a simple register save/restore ?
> >>
> >> There is "caring" and "_caring_". I am tempted to ask what NMI handler
> >> execution frequency you have in mind here to figure out if we are not
> >> trying to optimize sub-nanoseconds per minutes. ;)
> > 
> > Ah, well, I have no idea who expensive cr2 is, if its like a regular
> > register then it should be fine. If however its tons more expensive then
> > we should really avoid it.
> > 
> > As to the freq, 100kHz would be nice ;-)
> > 
> 
> Writing control registers is serializing, so it's a lot more expensive
> than writing a normal register; my *guess* is that it will be on the
> order of 100-200 cycles.
> 
> That is not based on any actual information.
> 

Then how about just writing to the cr2 register *if* it has changed
while the NMI handler was running ?

if (unlikely(read_cr2() != saved_cr2)))
	write_cr2(saved_cr2)

Mathieu

> 	-hpa
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
