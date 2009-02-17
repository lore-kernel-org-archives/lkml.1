Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZBQV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZBQV6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZBQV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:58:04 -0500
Received: from gw.goop.org ([64.81.55.164]:42477 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZBQV6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:58:02 -0500
Message-ID: <499B32E4.4080501@goop.org>
Date: Tue, 17 Feb 2009 13:57:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200707241140.12945.nickpiggin@yahoo.com.au> <49470433.4050504@goop.org> <200812301442.37654.nickpiggin@yahoo.com.au>
In-Reply-To: <200812301442.37654.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> I have patches to move the tlb flushing to an asynchronous process context...
> but all tweaks to that (including flushing at vmap) are just variations on the
> existing flushing scheme and don't solve your problem, so I don't think we
> really need to change that for the moment (my patches are mainly for latency
> improvement and to allow vunmap to be usable from interrupt context).
>   

Hi Nick,

I'm very interested in being able to call vm_unmap_aliases() from 
interrupt context.  Does the work you mention here encompass that?

For Xen dom0, when someone does something like dma_alloc_coherent, we 
allocate the memory as normal, and then swizzle the underlying physical 
pages to be machine physically contiguous (vs contiguous pseudo-physical 
guest memory), and within the addressable range for the device.  In 
order to do that, we need to make sure the pages are only mapped by the 
linear mapping, and there are no other aliases.

And since drivers are free to allocate dma memory at interrupt time, 
this needs to happen at interrupt time too.

(The tlb flush issue that started this read should be a non-issue for 
Xen, at least, because all cross-cpu tlb flushes should happen via  a 
hypercall rather than kernel-initiated IPIs, so there's no possibility 
of deadlock.  Though I'll happily admit that taking advantage of the 
implementation properties of a particular implementation is not very 
pretty...)

Thanks,
    J


