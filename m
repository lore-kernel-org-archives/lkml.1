Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYCUGTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYCUGTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYCUGSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:18:54 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53274 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753385AbYCUGSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:53 -0400
Message-Id: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:03 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [00/14] Virtual Compound Page Support V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocations of larger pages are not reliable in Linux. If larger
pages have to be allocated then one faces various choices of allowing
graceful fallback or using vmalloc with a performance penalty due
to the use of a page table. Virtual Compound pages are
a simple solution out of this dilemma.

A virtual compound allocation means that there will be first of all
an attempt to satisfy the request with physically contiguous memory.
If that is not possible then a virtually contiguous memory will be
created.

This has two advantages:

1. Current uses of vmalloc can be converted to allocate virtual
   compounds instead. In most cases physically contiguous
   memory can be used which avoids the vmalloc performance
   penalty. See f.e. the e1000 driver patch.

2. Uses of higher order allocations (stacks, buffers etc) can be
   converted to use virtual compounds instead. Physically contiguous
   memory will still be used for those higher order allocs in general
   but the system can degrade to the use of vmalloc should memory
   become heavily fragmented.

There is a compile time option to switch on fallback for
testing purposes. Virtually mapped mmemory may behave differently
and the CONFIG_FALLBACK_ALWAYS option will ensure that the code is
tested to deal with virtual memory.

V2->V3:
- Put the code into mm/vmalloc.c and leave the page allocator alone.
- Add a series of examples where virtual compound pages can be used.
- Diffed on top of the page flags and the vmalloc info patches
  already in mm.
- Simplify things by omitting some of the more complex code
  that used to be in there.

V1->V2
- Remove some cleanup patches and the SLUB patches from this set.
- Transparent vcompound support through page_address() and
  virt_to_head_page().
- Additional use cases.
- Factor the code better for an easier read
- Add configurable stack size.
- Follow up on various suggestions made for V1

RFC->V1
- Complete support for all compound functions for virtual compound pages
  (including the compound_nth_page() necessary for LBS mmap support)
- Fix various bugs
- Fix i386 build

-- 
