Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbZFQHiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbZFQHiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZFQHh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:37:57 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:48490 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZFQHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:37:55 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf record/report: Add call graph /
 call chain profiling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, efault@gmx.de, arjan@infradead.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
In-Reply-To: <20090616080924.GB16229@elte.hu>
References: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org>
	 <20090616025750.GB6057@nowhere>  <20090616080924.GB16229@elte.hu>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 09:37:59 +0200
Message-Id: <1245224279.13761.21585.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 10:09 +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > @@ -43,11 +44,19 @@ static int		full_paths;
> > >  static unsigned long	page_size;
> > >  static unsigned long	mmap_window = 32;
> > >  
> > > +struct ip_chain_event {
> > > +	__u16 nr;
> > 
> > Is it needed to have the nr encoded in the ip_chain? We can 
> > already find it by doing kernel + user.
> 
> That's a good observation. Since we havent exposed the call-chain 
> bits in upstream version of the tools, we could still improve on 
> this a little bit.
> 
> I think the best would be context separators which occupy a special 
> address in some quiet corner of the 64-bit address space.
> 
> That way we'd have streams of u64 entries:
> 
>    ip-1
>    ip-2
>    CONTEXT_IRQ
>    ip-3
>    ip-4
>    CONTEXT_SYSCALL
>    ip-5
>    ip-6
> 
> The following contexts IDs would be useful:
> 
>   CONTEXT_NMI
>   CONTEXT_HARDIRQ
>   CONTEXT_SOFTIRQ
>   CONTEXT_KERNEL
>   CONTEXT_USER
>   CONTEXT_GUEST_NMI
>   CONTEXT_GUEST_HARDIRQ
>   CONTEXT_GUEST_SOFTIRQ
>   CONTEXT_GUEST_KERNEL
>   CONTEXT_GUEST_USER
> 
> The context IDs would occupy some rare and 
> unlikely-to-be-allocated-soon corner of the address space - say 
> startig at 0x8765432112345000. (and real RIPs would be filtered and 
> nudged just outside that space of a handful IDs.)

Right, that works too, but should we use (u64)-1..-4095 for that? We
already use that range for things like ERR_PTR() so its very unlikely we
have something sensible mapped there.

