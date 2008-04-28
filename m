Return-Path: <linux-kernel-owner+w=401wt.eu-S936795AbYD1Qtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936795AbYD1Qtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936703AbYD1Qt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:49:29 -0400
Received: from saeurebad.de ([85.214.36.134]:58486 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936626AbYD1Qt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:49:28 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [patch] mm: node-setup agnostic free_bootmem()
References: <20080426185516.GA32364@elte.hu>
	<alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	<20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de>
	<20080427234630.GC14338@elte.hu> <877iein859.fsf@saeurebad.de>
	<20080428004046.GA16155@elte.hu>
Date: Mon, 28 Apr 2008 18:49:24 +0200
In-Reply-To: <20080428004046.GA16155@elte.hu> (Ingo Molnar's message of "Mon,
	28 Apr 2008 02:40:46 +0200")
Message-ID: <87skx56i23.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> > so i very much agree that your changes are cleaner, i just wanted to 
>> > have one that has all the fixes included.
>> 
>> I had planned this to be another patch because there are more then one 
>> boundary check I wanted to tighten.  I can merge them though if you 
>> like.
>
> no, better to have them in separate patches.

Okay.

>> > Would you like to post a patch against current -git or should i 
>> > extract the cleaner reserve_bootmem() from your previous patch?
>> 
>> I just moved and have only sporadic internet access and free time 
>> slots available.  Would be nice if you could do it!
>
> sure, find the merged patch below, against latest -git, boot-tested on 
> x86. Is this what you had in mind?
>
> 	Ingo
>
> ---------------->
> Subject: mm: node-setup agnostic free_bootmem()
> From: Johannes Weiner <hannes@saeurebad.de>
> Date: Wed, 16 Apr 2008 13:36:31 +0200
>
> Make free_bootmem() look up the node holding the specified address
> range which lets it work transparently on single-node and multi-node
> configurations.
>
> If the address range exceeds the node range, it well be marked free
> across node boundaries, too.
>
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> CC: Yasunori Goto <y-goto@jp.fujitsu.com>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Christoph Lameter <clameter@sgi.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/bootmem.c |   27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
>
> Index: linux-x86.q/mm/bootmem.c
> ===================================================================
> --- linux-x86.q.orig/mm/bootmem.c
> +++ linux-x86.q/mm/bootmem.c
> @@ -493,8 +493,31 @@ int __init reserve_bootmem(unsigned long
>  void __init free_bootmem(unsigned long addr, unsigned long size)
>  {
>  	bootmem_data_t *bdata;
> -	list_for_each_entry(bdata, &bdata_list, list)
> -		free_bootmem_core(bdata, addr, size);
> +	unsigned long pos = addr;
> +	unsigned long partsize = size;
> +
> +	list_for_each_entry(bdata, &bdata_list, list) {
> +		unsigned long remainder = 0;
> +
> +		if (pos < bdata->node_boot_start)
> +			continue;
> +
> +		if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
> +			remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
> +			partsize -= remainder;
> +		}
> +
> +		free_bootmem_core(bdata, pos, partsize);
> +
> +		if (!remainder)
> +			return;
> +
> +		pos = PFN_PHYS(bdata->node_low_pfn + 1);
> +	}
> +	printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
> +			"state: pos=%lx, partsize=%lx\n", addr, size,
> +			pos, partsize);
> +	BUG();
>  }
>  
>  unsigned long __init free_all_bootmem(void)

Yes, looks good.  But needs explicit testing, I guess.

	Hannes
