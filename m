Return-Path: <linux-kernel-owner+w=401wt.eu-S933411AbZLLDT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbZLLDT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 22:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762860AbZLLDT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 22:19:26 -0500
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.65]:45362 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762750AbZLLDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 22:19:26 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 12 Dec 2009 12:19:02 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 4/4] memcg: implement memory thresholds
Message-Id: <20091212121902.e95f9561.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <9e6e8d687224c6cbc54281f7c3d07983f701f93d.1260571675.git.kirill@shutemov.name>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	<747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	<9e6e8d687224c6cbc54281f7c3d07983f701f93d.1260571675.git.kirill@shutemov.name>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 00:59:19 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> It allows to register multiple memory and memsw thresholds and gets
> notifications when it crosses.
> 
> To register a threshold application need:
> - create an eventfd;
> - open memory.usage_in_bytes or memory.memsw.usage_in_bytes;
> - write string like "<event_fd> <memory.usage_in_bytes> <threshold>" to
>   cgroup.event_control.
> 
> Application will be notified through eventfd when memory usage crosses
> threshold in any direction.
> 
> It's applicable for root and non-root cgroup.
> 
> It uses stats to track memory usage, simmilar to soft limits. It checks
> if we need to send event to userspace on every 100 page in/out. I guess
> it's good compromise between performance and accuracy of thresholds.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |  263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 263 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c6081cc..5ba2140 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6,6 +6,10 @@
>   * Copyright 2007 OpenVZ SWsoft Inc
>   * Author: Pavel Emelianov <xemul@openvz.org>
>   *
> + * Memory thresholds
> + * Copyright (C) 2009 Nokia Corporation
> + * Author: Kirill A. Shutemov
> + *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
>   * the Free Software Foundation; either version 2 of the License, or
> @@ -38,6 +42,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/mm_inline.h>
>  #include <linux/page_cgroup.h>
> +#include <linux/eventfd.h>
>  #include "internal.h"
>  
>  #include <asm/uaccess.h>
> @@ -56,6 +61,7 @@ static int really_do_swap_account __initdata = 1; /* for remember boot option*/
>  
>  static DEFINE_MUTEX(memcg_tasklist);	/* can be hold under cgroup_mutex */
This mutex has already removed in current mmotm.
Please write a patch for memcg based on mmot.

>  #define SOFTLIMIT_EVENTS_THRESH (1000)
> +#define THRESHOLDS_EVENTS_THRESH (100)
>  
>  /*
>   * Statistics for memory cgroup.

(snip)

> @@ -1363,6 +1395,11 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	if (mem_cgroup_soft_limit_check(mem))
>  		mem_cgroup_update_tree(mem, page);
>  done:
> +	if (mem_cgroup_threshold_check(mem)) {
> +		mem_cgroup_threshold(mem, false);
> +		if (do_swap_account)
> +			mem_cgroup_threshold(mem, true);
> +	}
>  	return 0;
>  nomem:
>  	css_put(&mem->css);
> @@ -1906,6 +1943,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>  
>  	if (mem_cgroup_soft_limit_check(mem))
>  		mem_cgroup_update_tree(mem, page);
> +	if (mem_cgroup_threshold_check(mem)) {
> +		mem_cgroup_threshold(mem, false);
> +		if (do_swap_account)
> +			mem_cgroup_threshold(mem, true);
> +	}
>  	/* at swapout, this memcg will be accessed to record to swap */
>  	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
>  		css_put(&mem->css);
Can "if (do_swap_account)" check be moved into mem_cgroup_threshold ?


Thanks,
Daisuke Nishimura.
