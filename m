Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbZBMSK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbZBMSK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZBMSKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:10:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZBMSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:10:16 -0500
Date: Fri, 13 Feb 2009 10:09:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
 (repost)
In-Reply-To: <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com>
 <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain> <20090213173352.GB4684@Krystal> <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Btw, for user space, if you want to do this all right for something like 
BF. I think the only _correct_ thing to do (in the sense that the end 
result will actually be debuggable) is to essentially give full SMP 
coherency in user space.

It's doable, but rather complicated, and I'm not 100% sure it really ends 
up making sense. The way to do it is to just simply say:

 - never map the same page writably on two different cores, and always 
   flush the cache (on the receiving side) when you switch a page from one 
   core to another.

Now, the kernel can't really do that reasonably, but user space possibly could.

Now, I realize that blackfin doesn't actually even have a MMU or a TLB, so 
by "mapping the same page" in that case we end up really meaning "having a 
shared mapping or thread". I think that _should_ be doable. The most 
trivial approach might be to simply limit all processes with shared 
mappings or CLONE_VM to core 0, and letting core 1 run everything else 
(but you could do it differently: mapping something with MAP_SHARED would 
force you to core 0, but threads would just force the thread group to 
stay on _one_ core, rather than necessarily a fixed one).

Yeah, because of the lack of real memory protection, the kernel can't 
_know_ that processes don't behave badly and access things that they 
didn't explicitly map, but I'm hoping that that is rare.

And yes, if you really want to use threads as a way to do something 
across cores, you'd be screwed - the kenrel would only schedule the 
threads on one CPU. But considering the undefined nature of threading on 
such a cpu, wouldn't that still be preferable? Wouldn't it be nice to have 
the knowledge that user space _looks_ cache-coherent by virtue of the 
kernel just limiting cores appropriately?

And then user space would simply not need to worry as much. Code written 
for another architecture will "just work" on BF SMP too. With the normal 
uclinux limitations, of course.

			Linus
