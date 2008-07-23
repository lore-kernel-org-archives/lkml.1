Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYGWWSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYGWWSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYGWWSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:18:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:40746 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYGWWSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:18:41 -0400
Subject: Re: [PATCH 0/2][RT] powerpc - fix bug in irq reverse mapping radix
	tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>, paulus@samba.org,
       michael@ellerman.id.au
In-Reply-To: <20080723165932.57e3ada2@bull.net>
References: <20080723165932.57e3ada2@bull.net>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 08:17:38 +1000
Message-Id: <1216851458.11027.346.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   The root cause of this bug lies in the fact that the XICS interrupt controller
> uses a radix tree for its reverse irq mapping and that we cannot allocate the tree
> nodes (even GFP_ATOMIC) with preemption disabled.

Is that yet another caes of -rt changing some basic kernel semantics ?

>   In fact, we have 2 nested preemption disabling when we want to allocate
> a new node:
> 
>   - setup_irq() does a spin_lock_irqsave() before calling xics_startup() which
>     then calls irq_radix_revmap() to insert a new node in the tree
> 
>   - irq_radix_revmap() also does a spin_lock_irqsave() (in irq_radix_wrlock())
>     before the radix_tree_insert()
> 
>   The first patch moves the call to irq_radix_revmap() from xics_startup() out to
> xics_host_map_direct() and xics_host_map_lpar() which are called with preemption
> enabled.

I suppose that would work.

>   The second patch is a little more involved in that it takes advantage of
> the concurrent radix tree to simplify the locking requirements and allows
> to allocate a new node outside a preemption disabled section.
> 
>   I just hope I've correctly understood the concurrent radix trees semantic
> and got the (absence of) locking right.

Hrm, that will need some scrutinity.

Thanks for looking at this.

Cheers,
Ben.


