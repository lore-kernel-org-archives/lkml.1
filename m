Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYDOS5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYDOS5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYDOS5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:57:43 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:23751 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbYDOS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kXNBndaLcIUwTtv1403nt3Ekc1caKE+5Ij+q376fEuawmdReOJzvuKogP7oTvfYGCdP46c6me4HbGJ33BqyapFveA4JnFNsDZSivI7yMNAIdnxa0T3UYHTKTboFVtIX8ASjnIWNzDeI3hNvyiMKQ6eHE9j2G06Uv72FFttE6w+c=
Message-ID: <86802c440804151157m5baab2efla7f35a8f98ac76b7@mail.gmail.com>
Date: Tue, 15 Apr 2008 11:57:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ak@suse.de, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <87hce3i8mq.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
	 <20080415071120.GB15499@elte.hu> <87hce3i8mq.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 5:51 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi Ingo,
>
>
>
>  Ingo Molnar <mingo@elte.hu> writes:
>
>  > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>  >
>  >> Subject: bootmem: node-setup agnostic free_bootmem()
>  >> From: Johannes Weiner <hannes@saeurebad.de>
>  >>
>  >> Make free_bootmem() look up the node holding the specified address
>  >> range which lets it work transparently on single-node and multi-node
>  >> configurations.
>  >
>  > this patch does not fix the bug Yinghai's (now dropped) patches solved:
>  > reserve_early() allocations. So NAK until the full problem has been
>  > sorted out ...
>
>  Okay, NAK on -mm and -x86 for sure.  The patch was meant for mainline
>  where there is no need for free_bootmem() going across nodes, right?
>
>  But I still object to the way Yinghai implemented it.
>  free_bootmem_core() should not be twisted like this.
>
>  How about the following (untested, even uncompiled, but you should get
>  the idea) proposal which would replace the patch discussed in this
>  thread:
>
>  --- tree-linus.orig/mm/bootmem.c
>  +++ tree-linus/mm/bootmem.c
>  @@ -421,7 +421,25 @@ int __init reserve_bootmem(unsigned long
>
>
>   void __init free_bootmem(unsigned long addr, unsigned long size)
>   {
>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  +       bootmem_data_t *bdata;
>  +
>  +       list_for_each_entry(bdata, &bdata_list, list) {
>  +               unsigned long remainder = 0;
>
> +
>  +               if (addr < bdata->node_boot_start)
>  +                       continue;
>  +
>  +               if (PFN_DOWN(addr + size) > bdata->node_low_pfn)
>  +                       remainder = PFN_DOWN(addr + size) - bdata->node_low_pfn;
>  +
>  +               size -= PFN_PHYS(remainder);
>
> +               free_bootmem_core(bdata, addr, size)
>  +
>  +               if (!remainder)
>  +                       break;
>  +
>  +               addr = PFN_PHYS(bdata->node_low_pfn + 1);
>  +       }
>
>  }
>
>   unsigned long __init free_all_bootmem(void)

how about
1. bdata is not sorted?
2. intel cross node box: node0: 0g-2g, 4g-6g, node1: 2g-4g, 6g-8g. i
don't think they have two bdata struct for every node.

YH
