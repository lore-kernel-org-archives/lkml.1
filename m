Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZFLPXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZFLPXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZFLPX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:23:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbZFLPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:23:25 -0400
Date: Fri, 12 Jun 2009 08:22:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
 suspending
Message-Id: <20090612082252.519061c3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0906121244020.30911@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	<Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	<20090612091002.GA32052@elte.hu>
	<1244798515.7172.99.camel@pasglop>
	<84144f020906120224v5ef44637pb849fd247eab84ea@mail.gmail.com>
	<1244799389.7172.110.camel@pasglop>
	<Pine.LNX.4.64.0906121244020.30911@melkki.cs.Helsinki.FI>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 12:45:21 +0300 (EEST) Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Fri, 12 Jun 2009 12:39:58 +0300
> Subject: [PATCH] Sanitize "gfp" flags during boot
> 
> With the recent shuffle of initialization order to move memory related
> inits earlier, various subtle breakage was introduced in archs like
> powerpc due to code somewhat assuming that GFP_KERNEL can be used as
> soon as the allocators are up. This is not true because any __GFP_WAIT
> allocation will cause interrupts to be enabled, which can be fatal if
> it happens too early.
> 
> This isn't trivial to fix on every call site. For example, powerpc's
> ioremap implementation needs to be called early. For that, it uses two
> different mechanisms to carve out virtual space. Before memory init,
> by moving down VMALLOC_END, and then, by calling get_vm_area().
> Unfortunately, the later does GFK_KERNEL allocations. But we can't do
> anything else because once vmalloc's been initialized, we can no longer
> safely move VMALLOC_END to carve out space.
> 
> There are other examples, wehere can can be called either very early
> or later on when devices are hot-plugged. It would be a major pain for
> such code to have to "know" whether it's in a context where it should
> use GFP_KERNEL or GFP_NOWAIT.
> 
> Finally, by having the ability to silently removed __GFP_WAIT from
> allocations, we pave the way for suspend-to-RAM to use that feature
> to also remove __GFP_IO from allocations done after suspending devices
> has started. This is important because such allocations may hang if
> devices on the swap-out path have been suspended, but not-yet suspended
> drivers don't know about it, and may deadlock themselves by being hung
> into a kmalloc somewhere while holding a mutex for example.
> 
> ...
>
> +/*
> + * We set up the page allocator and the slab allocator early on with interrupts
> + * disabled. Therefore, make sure that we sanitize GFP flags accordingly before
> + * everything is up and running.
> + */
> +gfp_t gfp_allowed_bits = ~(__GFP_WAIT|__GFP_FS | __GFP_IO);

__read_mostly

> +void mm_late_init(void)
> +{
> +	/*
> +	 * Interrupts are enabled now so all GFP allocations are safe.
> +	 */
> +	gfp_allowed_bits = __GFP_BITS_MASK;
> +}

Using plain old -1 here would be a more obviously-correct change.


