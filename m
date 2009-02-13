Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZBMS7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZBMS7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbZBMS7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:59:19 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:47919 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312AbZBMS7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:59:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUEAG9LlUlMQWt2/2dsb2JhbACBbtBdhBwG
Date: Fri, 13 Feb 2009 13:54:11 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090213185411.GB7124@Krystal>
References: <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com> <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain> <20090213173352.GB4684@Krystal> <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain> <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:41:41 up 43 days, 18:39,  3 users,  load average: 0.87, 0.64,
	0.61
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> Btw, for user space, if you want to do this all right for something like 
> BF. I think the only _correct_ thing to do (in the sense that the end 
> result will actually be debuggable) is to essentially give full SMP 
> coherency in user space.
> 
> It's doable, but rather complicated, and I'm not 100% sure it really ends 
> up making sense. The way to do it is to just simply say:
> 
>  - never map the same page writably on two different cores, and always 
>    flush the cache (on the receiving side) when you switch a page from one 
>    core to another.
> 
> Now, the kernel can't really do that reasonably, but user space possibly could.
> 
> Now, I realize that blackfin doesn't actually even have a MMU or a TLB, so 
> by "mapping the same page" in that case we end up really meaning "having a 
> shared mapping or thread". I think that _should_ be doable. The most 
> trivial approach might be to simply limit all processes with shared 
> mappings or CLONE_VM to core 0, and letting core 1 run everything else 
> (but you could do it differently: mapping something with MAP_SHARED would 
> force you to core 0, but threads would just force the thread group to 
> stay on _one_ core, rather than necessarily a fixed one).
> 
> Yeah, because of the lack of real memory protection, the kernel can't 
> _know_ that processes don't behave badly and access things that they 
> didn't explicitly map, but I'm hoping that that is rare.
> 
> And yes, if you really want to use threads as a way to do something 
> across cores, you'd be screwed - the kenrel would only schedule the 
> threads on one CPU. But considering the undefined nature of threading on 
> such a cpu, wouldn't that still be preferable? Wouldn't it be nice to have 
> the knowledge that user space _looks_ cache-coherent by virtue of the 
> kernel just limiting cores appropriately?
> 
> And then user space would simply not need to worry as much. Code written 
> for another architecture will "just work" on BF SMP too. With the normal 
> uclinux limitations, of course.
> 
> 			Linus
> 

I don't know enough about BF to tell for sure, but the other way around
I see that would still permit running threads with shared memory space
on different CPUs is to call a cache flush each time a userspace lock is
taken/released (at the synchronization points where the "magic
test-and-set instruction" is used) _from_ userspace.

If some more elaborate userspace MT code uses something else than those
basic locks provided by core libraries to synchronize data exchange,
then it would be on its own and have to ensure cache flushing itself.

And yes, that would be incredibly costly/slow. This is why RCU-style
reader-sides are good : they have much more relaxed synchronization
constraints.

I am just thinking that the single-process to a single core solution you
propose above will be somewhat limiting if we end up with a 64-cores
non-cache-coherent architecture. They tend to be especially used for
stuff like video decoding, which is very easy to parallelize when shared
memory is available. But I guess we are not there yet.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
