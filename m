Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbXKBBk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbXKBBk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbXKBBkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:40:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58210 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbXKBBkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:40:12 -0400
Date: Thu, 1 Nov 2007 18:40:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <472A5A7A.6020508@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711011818530.24692@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711010601430.27666@schroedinger.engr.sgi.com>
 <20071101.142936.114015234.davem@davemloft.net>
 <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
 <20071101.153824.91808126.davem@davemloft.net>
 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
 <472A5A7A.6020508@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... On x86_64 we could take 8 terabyte virtual space (bit order 43)

With the worst case scenario of 16k of cpus (bit order 16) we are looking 
at 43-16 = 27 ~ 128MB per cpu. Each percpu can at max be mapped by 64 pmd 
entries. 4k support is actually max for projected hw. So we'd get 
to 512M. 

On IA64 we could take half of the vmemmap area which is 45 bits. So 
we could get up to 512MB (with 16k pages, 64k pages can get us even 
further) assuming we can at some point run 16 processors per node (4k is 
the current max which would put the limit on the per cpu area >1GB).

Lets say you have a system with 64 cpus and an area of 128M of per cpu 
storage. Then we are using 8GB of total memory for per cpu storage. The 
128M allows us to store f.e.  16 M of word size counters.

With SLAB and the current allocpercpu you would need the following for 
16M counters:

16M*32*64 (minimum alloc size of SLAB is 32 byte and we alloc via 
		kmalloc) for the data.

16M*64*8 for the pointer arrays. 16M allocpercpu areas for 64 processors 
		and a pointer size of 8 bytes.

So you would need to use 40G in current systems. The new scheme 
would only need 8GB for the same amount of counters.

So I think its unreasonable to assume that currently systems exist that 
can use more than 128m of allocpercpu space (assuming 64 cpus).

---
 include/asm-x86/pgtable_64.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_64.h	2007-11-01 18:15:52.282577904 -0700
+++ linux-2.6/include/asm-x86/pgtable_64.h	2007-11-01 18:18:02.886979040 -0700
@@ -138,10 +138,14 @@ static inline pte_t ptep_get_and_clear_f
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
+#define PERCPU_START	 _AC(0xfffff20000000000, UL)
+#define PERCPU_END	 _AC(0xfffffa0000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
+#define PERCPU_MIN_SHIFT	PMD_SHIFT
+#define PERCPU_BITS		43
+
 #define _PAGE_BIT_PRESENT	0
 #define _PAGE_BIT_RW		1
 #define _PAGE_BIT_USER		2

