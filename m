Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYKQQ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYKQQ6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYKQQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:58:27 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60180 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbYKQQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:58:26 -0500
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
From: Zachary Amsden <zach@vmware.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4921428A.76E4.0078.0@novell.com>
References: <4921428A.76E4.0078.0@novell.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 09:53:07 -0800
Message-Id: <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 01:08 -0800, Jan Beulich wrote:
> Commit 49f19710512c825aaea73b9207b3a848027cda1d hints at the
> current solution not being the final one, yet the advertised (for 2.6.22)
> change apparently never happened. However, it seems to me that
> flushing a potentially huge (it terms of time to completion) batch
> asynchronously is no really good idea. Instead, I'd think that adding to

The batch size is limited by many factors; the number of possible PTEs
updated is only 64 in the COW path, up to 1024 at most for zero / remap
paths / mprotect paths.  While 1024 is large, I don't think it qualifies
as huge, and it should really be very uncommon.  In practice, the
batching under VMI is limited by the size of the hypercall queue, which
is only 256 entries.

> the batch should be prevented in asynchronous contexts altogether, or
> things should properly nest. As a positive side effect, disabling interrupts
> in the batch handling - in particular around the submission of the batch -
> could also be avoided, reducing interrupt latency (perhaps significantly
> in some case).

Jeremy already fixed that; we don't disable interrupts, the change he
made was to flush and then immediately restart the batching.

Re: nesting properly, there is no low-level interface provided to issue
"forced" updates, that is updates which bypass any batching and take
effect immediately.  We considered it, but wanted a simple design of a
strictly in-order update queue to reduce complexity.  This means you
either have no batching, eliminate the scenarios which require nesting,
disable interrupts, or flush previously batched updates when nested
operations are required.  The latter seems the lesser of the evils.

> 
> Likewise I would think that the flush out of vmalloc_sync_one() isn't
> appropriate, and it should rather be avoided for the set_pmd() there to
> get into the batching code altogether.

That's impossible.  The flush is needed and there is no way to avoid it.
The kernel has no general restrictions about contexts in which it is
safe vs. unsafe to touch the kernel's own vmalloc'ed memory, so you can
get a page fault due to lazy syncing of vmalloc area PDEs in non-PAE
mode.  You really have to service that fault.

> (Background to this: After adding lazy mmu mode support in our forward
> ported tree, we've actually been hit by these calls out of kmap_...(), as
> originally I didn't pay much attention to these and didn't care to synchronize
> batch addition and flushing with asynchronous operations.)

What tree is that?  Unclear from your message.

Thanks,

Zach

