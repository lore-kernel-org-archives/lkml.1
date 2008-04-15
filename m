Return-Path: <linux-kernel-owner+w=401wt.eu-S1765222AbYDOUE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765222AbYDOUE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761634AbYDOUD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:03:56 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:57359 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760940AbYDOUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iYc01NMhM++d2npCSbjyBTZ863W+xa2fDdfgGoXc/3/HIheAanytpBDQY/xdjjUf3iEEnoJtpsrNcDeV+6QmciEdJK7jRd7njpvfzoJF/GG1NCB5N7FKqn//mY6H19ZVrI+YOjCUFnpiJkFlks5O6w6vKzFPwdIgB9/hPRP7sAs=
Message-ID: <86802c440804151303k29295e9bp70c1046b8c9dca76@mail.gmail.com>
Date: Tue, 15 Apr 2008 13:03:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ak@suse.de, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <87mynuhp0o.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
	 <20080415071120.GB15499@elte.hu> <87hce3i8mq.fsf@saeurebad.de>
	 <86802c440804151157m5baab2efla7f35a8f98ac76b7@mail.gmail.com>
	 <87mynuhp0o.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:55 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
>
>
>  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>  > On Tue, Apr 15, 2008 at 5:51 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>  >> Hi Ingo,
>  >>
>  >>
>  >>
>  >>  Ingo Molnar <mingo@elte.hu> writes:
>  >>
>  >>  > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>  >>  >
>  >>  >> Subject: bootmem: node-setup agnostic free_bootmem()
>  >>  >> From: Johannes Weiner <hannes@saeurebad.de>
>  >>  >>
>  >>  >> Make free_bootmem() look up the node holding the specified address
>  >>  >> range which lets it work transparently on single-node and multi-node
>  >>  >> configurations.
>  >>  >
>  >>  > this patch does not fix the bug Yinghai's (now dropped) patches solved:
>  >>  > reserve_early() allocations. So NAK until the full problem has been
>  >>  > sorted out ...
>  >>
>  >>  Okay, NAK on -mm and -x86 for sure.  The patch was meant for mainline
>  >>  where there is no need for free_bootmem() going across nodes, right?
>  >>
>  >>  But I still object to the way Yinghai implemented it.
>  >>  free_bootmem_core() should not be twisted like this.
>  >>
>  >>  How about the following (untested, even uncompiled, but you should get
>  >>  the idea) proposal which would replace the patch discussed in this
>  >>  thread:
>  >>
>  >>  --- tree-linus.orig/mm/bootmem.c
>  >>  +++ tree-linus/mm/bootmem.c
>  >>  @@ -421,7 +421,25 @@ int __init reserve_bootmem(unsigned long
>  >>
>  >>
>  >>   void __init free_bootmem(unsigned long addr, unsigned long size)
>  >>   {
>  >>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  >>  +       bootmem_data_t *bdata;
>  >>  +
>  >>  +       list_for_each_entry(bdata, &bdata_list, list) {
>  >>  +               unsigned long remainder = 0;
>  >>
>  >> +
>  >>  +               if (addr < bdata->node_boot_start)
>  >>  +                       continue;
>  >>  +
>  >>  +               if (PFN_DOWN(addr + size) > bdata->node_low_pfn)
>  >>  +                       remainder = PFN_DOWN(addr + size) - bdata->node_low_pfn;
>  >>  +
>  >>  +               size -= PFN_PHYS(remainder);
>  >>
>  >> +               free_bootmem_core(bdata, addr, size)
>  >>  +
>  >>  +               if (!remainder)
>  >>  +                       break;
>  >>  +
>  >>  +               addr = PFN_PHYS(bdata->node_low_pfn + 1);
>  >>  +       }
>  >>
>  >>  }
>  >>
>  >>   unsigned long __init free_all_bootmem(void)
>  >
>  > how about
>  > 1. bdata is not sorted?
>
>  They are kept in a sorted list.  How could they be unsorted?
>
>
>  > 2. intel cross node box: node0: 0g-2g, 4g-6g, node1: 2g-4g, 6g-8g. i
>  > don't think they have two bdata struct for every node.
>
>  How do the bdata structures represent this setup right now?  Are you
>  sure that there is not a node descriptor for every contiguous region?

http://lkml.org/lkml/2008/3/25/233

Subject	[patch] srat, x86_64: Add support for nodes spanning other nodes

For example, If the physical address layout on a two node system with 8 GB
memory is something like:
node 0: 0-2GB, 4-6GB
node 1: 2-4GB, 6-8GB

Current kernels fail to boot/detect this NUMA topology.

ACPI SRAT tables can expose such a topology which needs to be supported.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

YH
