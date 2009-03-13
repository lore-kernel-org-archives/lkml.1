Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZCMP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZCMP2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZCMP2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:28:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37491 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbZCMP2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:28:24 -0400
Message-Id: <49BA815E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 13 Mar 2009 14:53:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <hannes@cmpxchg.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: alloc_bootmem_low() mis-uses
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you are being listed as the authors of mm/bootmem.c, I'd like to raise
the following issues in the hope that you can shed some additional light on
the original intentions of that code.

>From looking at all the callers of this and similar functions I'm getting the
impression that the majority of them are actually mis-uses: These functions
should really only be used when there is a need for getting an address
below ARCH_LOW_ADDRESS_LIMIT, but they should in particular not be
used just because the caller wants to make sure he doesn't get any
highmem range back (which is because highmem never enters the bootmem
allocator in the first place). Or am I missing something here?

A second aspect is that there is no attempt to preserve memory below
ARCH_LOW_ADDRESS_LIMIT for those few callers that really need to
get such memory (swiotlb, ACPI sleep) - 'normal' bootmem allocations
honor MAX_DMA_ADDRESS, but not ARCH_LOW_ADDRESS_LIMIT. This
apparently can, on systems with very much memory, lead to earlier
huge allocations (e.g. alloc_large_system_hash() and
alloc_node_mem_map()) exhausting almost all of the memory below that
boundary. Not avoiding that area may also result in unnecessary
pressure on later GFP_DMA32 allocations.

Wouldn't it therefore be reasonable to
- eliminate all the bogus callers of alloc_bootmem_low() & Co,
- change ___alloc_bootmem_nopanic() to use a three (or even multi) stage
  search, based on the fact that the goal argument isn't something that
  must be strictly adhered to anyway, and
- change alloc_bootmem_core() to start allocating from the top rather
  than the bottom?

Thanks, Jan

