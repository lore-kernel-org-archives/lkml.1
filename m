Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbZFQLmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbZFQLmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZFQLly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:41:54 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56995 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbZFQLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ImG/8w7fZUOS6lbj9dVo92YDr+aD3I7H7QthIf8zy74GiU946g51jyfgNv3Ku8nQ4u
         ejf0WL+o/8xD8Qv/jnuqW2lkVbbkMM9K3T0thXaeqxXPc5ogyw3PI/qbVqCeIkWGGBd1
         vqVbk8s5W9S8uAxHwkwcfULBgOEG7x0hWjpSs=
Date: Wed, 17 Jun 2009 13:41:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, efault@gmx.de, arjan@infradead.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: [tip:perfcounters/core] perf record/report: Add call graph /
	call chain profiling
Message-ID: <20090617114149.GA6064@nowhere>
References: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org> <20090616025750.GB6057@nowhere> <20090616080924.GB16229@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616080924.GB16229@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:09:24AM +0200, Ingo Molnar wrote:
> 
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
> 
> The advantage would be that this is infinitely flexible and 
> extensible - any level of nesting can be expressed without having 
> separate fields for nr_hv_guest_irq, etc. It's also pretty fast to 
> parse.



Indeed, nice idea!


 
> Hm?
> 
> 	Ingo

