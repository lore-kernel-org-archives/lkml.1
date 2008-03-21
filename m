Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbYCUVfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbYCUVfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYCUVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:34:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44843 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800AbYCUVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:34:56 -0400
Date: Fri, 21 Mar 2008 14:33:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [13/14] vcompound: Use vcompound for swap_map
In-Reply-To: <8763vfixb8.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0803211429270.21071@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061727.269764652@sgi.com>
 <8763vfixb8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:

> > is larger then there is no way around the use of vmalloc.
> 
> Have you considered the potential memory wastage from rounding up
> to the next page order now? (similar in all the other patches
> to change vmalloc). e.g. if the old size was 64k + 1 byte it will
> suddenly get 128k now. That is actually not a uncommon situation
> in my experience; there are often power of two buffers with 
> some small headers.

Yes the larger the order the more significant the problem becomes.

> A long time ago (in 2.4-aa) I did something similar for module loading
> as an experiment to avoid too many TLB misses. The module loader
> would first try to get a continuous range in the direct mapping and 
> only then fall back to vmalloc.
> 
> But I used a simple trick to avoid the waste problem: it allocated a
> continuous range rounded up to the next page-size order and then freed
> the excess pages back into the page allocator. That was called
> alloc_exact(). If you replace vmalloc with alloc_pages you should
> use something like that too I think.

That trick is still in use for alloc_large_system_hash....

But cutting off the tail of compound pages would make treating them as 
order N pages difficult. The vmalloc fallback situation is easy to deal 
with.

Maybe we can think about making compound pages being N consecutive pages 
of PAGE_SIZE rather than an order O page? The api would be a bit 
different then and it would require changes to the page allocator. More 
fragmentation if pages like that are freed.

