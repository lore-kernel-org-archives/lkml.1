Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYDPRzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYDPRzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYDPRzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:55:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:30639 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYDPRzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cWR/ZyLEK53YKvQHyC8VzN3eVl/lzosQ7Syylc6CF5QzodwOyitDnxxYSIU7xoTSmhHsU/LOKs5A8BaRq16dlUwxr0HouxOttQBZFDvLZBqW9JU4LQ4yyoTPN6hM6+Zxtur7xWYce9kmrmvVlcfMaqGXJZbDyldNvHiSA6nnONo=
Message-ID: <86802c440804161054h6f0cfc3dmde49006afb7889b2@mail.gmail.com>
Date: Wed, 16 Apr 2008 10:54:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [RFC][patch 2/5] mm: Node-setup agnostic free_bootmem()
Cc: LKML <linux-kernel@vger.kernel.org>, "Linux MM" <linux-mm@kvack.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080416113719.092060936@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
	 <20080416113719.092060936@skyscraper.fehenstaub.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 4:36 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Make free_bootmem() look up the node holding the specified address
>  range which lets it work transparently on single-node and multi-node
>  configurations.
>
>  If the address range exceeds the node range, it well be marked free
>  across node boundaries, too.
>
>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  CC: Ingo Molnar <mingo@elte.hu>
>  CC: Andi Kleen <andi@firstfloor.org>
>  CC: Yinghai Lu <yhlu.kernel@gmail.com>
>  CC: Yasunori Goto <y-goto@jp.fujitsu.com>
>  CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  CC: Christoph Lameter <clameter@sgi.com>
>  CC: Andrew Morton <akpm@linux-foundation.org>
>  ---
>   mm/bootmem.c |   10 +++++++++-
>   1 files changed, 9 insertions(+), 1 deletions(-)
>
>  Index: tree-linus/mm/bootmem.c
>  ===================================================================
>  --- tree-linus.orig/mm/bootmem.c
>  +++ tree-linus/mm/bootmem.c
>  @@ -421,7 +421,32 @@ int __init reserve_bootmem(unsigned long
>
>   void __init free_bootmem(unsigned long addr, unsigned long size)
>   {
>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  +       bootmem_data_t *bdata;
>  +       unsigned long pos = addr;
>  +       unsigned long partsize = size;
>  +
>  +       list_for_each_entry(bdata, &bdata_list, list) {
>  +               unsigned long remainder = 0;
>  +
>  +               if (pos < bdata->node_boot_start)
>  +                       continue;
>  +
>  +               if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
>  +                       remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
>  +                       partsize -= remainder;
>  +               }
>  +
>  +               free_bootmem_core(bdata, pos, partsize);
>  +
>  +               if (!remainder)
>  +                       return;
>  +
>  +               pos = PFN_PHYS(bdata->node_low_pfn + 1);
>  +       }
>  +       printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
>  +                       "state: pos=%lx, partsize=%lx\n", addr, size,
>  +                       pos, partsize);
>  +       BUG();
>   }
>
>   unsigned long __init free_all_bootmem(void)
>
>  --

Yes, it should work well with cross nodes case.

but please add boundary check on free_bootmem_node too.

YH
