Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbYDOMvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbYDOMvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYDOMvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:51:40 -0400
Received: from saeurebad.de ([85.214.36.134]:55681 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYDOMvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:51:39 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, ak@suse.de,
       clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
	<20080415071120.GB15499@elte.hu>
Date: Tue, 15 Apr 2008 14:51:25 +0200
In-Reply-To: <20080415071120.GB15499@elte.hu> (Ingo Molnar's message of "Tue,
	15 Apr 2008 09:11:20 +0200")
Message-ID: <87hce3i8mq.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
>> Subject: bootmem: node-setup agnostic free_bootmem()
>> From: Johannes Weiner <hannes@saeurebad.de>
>> 
>> Make free_bootmem() look up the node holding the specified address 
>> range which lets it work transparently on single-node and multi-node 
>> configurations.
>
> this patch does not fix the bug Yinghai's (now dropped) patches solved: 
> reserve_early() allocations. So NAK until the full problem has been 
> sorted out ...

Okay, NAK on -mm and -x86 for sure.  The patch was meant for mainline
where there is no need for free_bootmem() going across nodes, right?

But I still object to the way Yinghai implemented it.
free_bootmem_core() should not be twisted like this.

How about the following (untested, even uncompiled, but you should get
the idea) proposal which would replace the patch discussed in this
thread:

--- tree-linus.orig/mm/bootmem.c
+++ tree-linus/mm/bootmem.c
@@ -421,7 +421,25 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+
+	list_for_each_entry(bdata, &bdata_list, list) {
+		unsigned long remainder = 0;
+
+		if (addr < bdata->node_boot_start)
+			continue;
+
+		if (PFN_DOWN(addr + size) > bdata->node_low_pfn)
+			remainder = PFN_DOWN(addr + size) - bdata->node_low_pfn;
+
+		size -= PFN_PHYS(remainder);
+		free_bootmem_core(bdata, addr, size)
+
+		if (!remainder)
+			break;
+
+		addr = PFN_PHYS(bdata->node_low_pfn + 1);
+	}
 }
 
 unsigned long __init free_all_bootmem(void)
---
	Hannes
