Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYBSNDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYBSNDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760179AbYBSNC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:02:57 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:50095 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149AbYBSNC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:02:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFNiukdMQWRV/2dsb2JhbACBWaxi
Date: Tue, 19 Feb 2008 08:02:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219130253.GA29804@Krystal>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219102700.GC14092@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080219102700.GC14092@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:00:27 up 8 days,  9:00,  2 users,  load average: 0.87, 0.63,
	0.70
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Mathieu, Christoph is on vacation and I'm not at all that familiar 
> > with this cmpxchg_local() optimization, so if you could take a peek at 
> > this bug report to see if you can spot something obviously wrong with 
> > it, I would much appreciate that.
> 
> hm, it's bad for at least one other reason as well (which is probably 
> unrelated to this crash):
> 
>  /*
>   * Currently fastpath is not supported if preemption is enabled.
>   */
>  #if defined(CONFIG_FAST_CMPXCHG_LOCAL) && !defined(CONFIG_PREEMPT)
>  #define SLUB_FASTPATH
>  #endif
> 
> such !PREEMPT exceptions tend to show "i didnt want to think too hard 
> about the preemptible case so just turn it off" thinking.
> 

Ingo, a comment in slub.c explains it :

/*
 * The SLUB_FASTPATH path is provisional and is currently disabled if the
 * kernel is compiled with preemption or if the arch does not support
 * fast cmpxchg operations. There are a couple of coming changes that will
 * simplify matters and allow preemption. Ultimately we may end up making
 * SLUB_FASTPATH the default.
 *
 * 1. The introduction of the per cpu allocator will avoid array lookups
 *    through get_cpu_slab(). A special register can be used instead.
 *
 * 2. The introduction of per cpu atomic operations (cpu_ops) means that
 *    we can realize the logic here entirely with per cpu atomics. The
 *    per cpu atomic ops will take care of the preemption issues.
 */

So there is more coming in the preemption area.


> Also, why isnt this "SLUB_FASTPATH" flag done in the Kconfig space?
> 

Eventually, I think only CONFIG_FAST_CMPXCHG_LOCAL will be needed (when
the code will support preemption). Therefore, this SLUB_FASTPATH define
seems to be only here temporarily.

I'm looking at the code right now.. more to come.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
