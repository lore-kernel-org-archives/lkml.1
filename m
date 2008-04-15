Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbYDOOjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbYDOOjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbYDOOja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:39:30 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:57512 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257AbYDOOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:39:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAONaBEhMQWoK/2dsb2JhbACBXqtC
Date: Tue, 15 Apr 2008 10:39:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415143928.GA24556@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415140430.GA6576@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080415140430.GA6576@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:10:23 up 46 days, 10:21,  4 users,  load average: 0.22, 0.39,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > See, these tracer tools are my nightmare as member of an 
> > > > enterprise linux team. They'll make an already hard job even 
> > > > harder, no thanks!
> > > 
> > > i'm clearly NAK-ing all futex trace hooks until the true impact of 
> > > the whole marker facility is better understood. I've tried them for 
> > > the scheduler and they were a clear failure: too bloated and too 
> > > persistent.
> > 
> > I have not seen any counter argument for the in-depth analysis of the 
> > instruction cache impact of the optimized markers I've done. Arguing 
> > that the markers are "bloated" based only on "size kernel/sched.o" 
> > output is a bit misleading.
> 
> uhm, i'm not sure what you mean - how else would you quantify bloat than 
> to look at the size of the affected subsystem?
> 
> 	Ingo

Data cache bloat inspection :
If you use the "size" output, it will take into account all the data
placed in special sections. At link time, these sections are put
together far from the actual cache hot kernel data.

Instruction cache bloat inspection :
If a code region is placed with cache cold instructions (unlikely
branches), it should not increase the cache impact, since although we
might use one more cache line, it won't be often loaded in cache because
all the code that shares this cache line is unlikely.

TLB entries bloat :
If code is added in unlikely branches, the instruction size increase
could increase the number of TLB entries required to keep cache hot
code. However, in our case, adding 10 (hot) + 50 (cold) bytes to the
scheduler code per optimized marker would require 68 markers to occupy a
whole 4kB TLB entry. Statistically, we could suppose that adding less
than 34 markers to the scheduler should not use any supplementary TLB
entry.  Adding 3 markers is therefore very unlikely to increase the TLB
impact. Given we have about 1024 TLB entries, adding 1/25th of a TLB
entry to the cache hot kernel instructions should not matter much,
especially since it might be absorbed by alignment.

And since the kernel core code is placed in "Huge TLB pages" on many
architectures nowadays, I really don't think the impact of a few bytes
out of 4MB is significant.

I therefore think that looking only at code size is misleading when
considering the cache impact of markers, since they have been designed
to put the bytes as far away as possible from cache-hot memory.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
