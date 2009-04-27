Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbZD0Kxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbZD0Kxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZD0Kxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:53:46 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:64671 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZD0Kxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:53:45 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Metzger <markus.t.metzger@intel.com>, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <20090424083128.GI24912@elte.hu>
References: <20090424100055.A30408@sedona.ch.intel.com>
	 <20090424011328.b5e949ce.akpm@linux-foundation.org>
	 <20090424083128.GI24912@elte.hu>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 12:53:36 +0200
Message-Id: <1240829616.7620.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 10:31 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 

> > The patch looks like a regression to me.  vmalloc memory is slower 
> > to allocate, slower to free, slower to access and can exhaust or 
> > fragment the vmalloc arena.  Confused.
> 
> Performance does not matter here (this is really a slowpath), but 
> fragmentation does matter, especially on 32-bit systems.
> 
> I'd not uglify the code via vmap() - and vmap has the same 
> fundamental address space limitations on 32-bit as vmalloc().
> 
> The existing kmalloc() is fine. We do larger than PAGE_SIZE 
> allocations elsewhere too (the kernel stack for example), and this 
> is a debug facility, so failing the allocation is not a big problem 
> even if it happens.

Nobody has yet told what the typical size of these allocations are. If
they're large enough to account in pages, one should arguable use the
page allocator not kmalloc. Also, any >3 order allocation (>32kb) are
very likely to fail. Having this ptrace interface work in the (unloaded)
development environment but not in a (loaded) production environment
will render it basically useless IMHO.

Having a regular high order allocation with vmalloc/vmap fallback is
quite normal, esp. if one wants to promote the use of this facility as
usable.

So, no, I very strongly disagree that the existing kmalloc is fine.


PS. I get shitloads of order-4 alloc failures from GEM after a few days
of uptime on my laptop.

