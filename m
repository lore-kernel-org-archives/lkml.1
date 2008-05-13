Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYEMARU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYEMARU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbYEMARJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:17:09 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:57194 "EHLO
	outbound4-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756215AbYEMARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:17:08 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4828DDFE.6050805@am.sony.com>
Date: Mon, 12 May 2008 17:17:02 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] [PPC] provide walk_memory_resource() for ppc
References: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com> <1206664795.19368.13.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1206664795.19368.13.camel@dyn9047017100.beaverton.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2008 00:17:03.0038 (UTC) FILETIME=[AB2EB5E0:01C8B48E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've had some trouble with this change.

Badari Pulavarty wrote:
> Provide walk_memory_resource() for ppc64. PPC maintains 
> logic memory region mapping in lmb.memory structures. Walk
> through these structures and do the callbacks for the
> contiguous chunks.

...

> --- linux-2.6.25-rc3.orig/arch/powerpc/mm/mem.c	2008-03-05 10:14:28.000000000 -0800
> +++ linux-2.6.25-rc3/arch/powerpc/mm/mem.c	2008-03-05 10:32:16.000000000 -0800
> @@ -148,19 +148,35 @@ out:
>  
>  /*
>   * walk_memory_resource() needs to make sure there is no holes in a given
> - * memory range. On PPC64, since this range comes from /sysfs, the range
> - * is guaranteed to be valid, non-overlapping and can not contain any
> - * holes. By the time we get here (memory add or remove), /proc/device-tree
> - * is updated and correct. Only reason we need to check against device-tree
> - * would be if we allow user-land to specify a memory range through a
> - * system call/ioctl etc. instead of doing offline/online through /sysfs.
> + * memory range. PPC64 does not maintain the memory layout in /proc/iomem.
> + * Instead it maintains it in lmb.memory structures. Walk through the
> + * memory regions, find holes and callback for contiguous regions.
>   */
>  int
>  walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
>  			int (*func)(unsigned long, unsigned long, void *))
>  {
> -	return  (*func)(start_pfn, nr_pages, arg);
> +	struct lmb_property res;
> +	unsigned long pfn, len;
> +	u64 end;
> +	int ret = -1;
> +
> +	res.base = (u64) start_pfn << PAGE_SHIFT;
> +	res.size = (u64) nr_pages << PAGE_SHIFT;
> +
> +	end = res.base + res.size - 1;
> +	while ((res.base < end) && (lmb_find(&res) >= 0)) {
                                    ^^^^^^^^^^^^^^

In the PS3 platform code (arch/pwerpc/platfroms/ps3/mm.c) the hotplug
memory is added like this:

	...
	result = add_memory(0, start_addr, map.r1.size);
	...
	result = online_pages(start_pfn, nr_pages);
	...

In its work, online_pages() eventually calls walk_memory_resource(),
which has been changed as above to do a test on lmb_find(). I found
that this lmb_find() test always fails for PS3 since add_memory()
does not call lmb_add().

Is it the responsibility of the platform code to call lmb_add(), or
should that be done by add_memory()?

-Geoff



