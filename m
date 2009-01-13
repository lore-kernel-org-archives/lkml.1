Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZAMFuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZAMFuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZAMFt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:49:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53198 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZAMFt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:49:59 -0500
Message-ID: <496C2B4F.3090406@cn.fujitsu.com>
Date: Tue, 13 Jan 2009 13:49:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Fix section mismatch in memcontrol.c
References: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
In-Reply-To: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>

Rakib Mullick wrote:
> Impact: Fix section mismatch warning.
> 
> The annotation for __init in enable_swap_cgroup() and __initdata for
> really_do_swap_account produces the following warning. Which is not
> right, since this function is called from non-init section. This patch
> fixes it. If anything else please notice.
> 

I saw this warning on IA64. But this fix is wrong IMO.

enable_swap_cgroup() will be called at system boot only:

start_kernel()
  cgroup_init()
    mem_cgroup_create()
      enable_swap_cgroup()

I think the proper fix is annotate mem_cgroup_create() with __init_refok.

>   LD      mm/built-in.o
> WARNING: mm/built-in.o(.text+0x277d9): Section mismatch in reference
> from the function mem_cgroup_create() to the function
> .init.text:enable_swap_cgroup()
> The function mem_cgroup_create() references
> the function __init enable_swap_cgroup().
> This is often because mem_cgroup_create lacks a __init
> annotation or the annotation of enable_swap_cgroup is wrong.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/mm/memcontrol.c	2009-01-12 09:53:10.000000000 +0600
> +++ linux-2.6/mm/memcontrol.c	2009-01-12 19:40:06.134648480 +0600
> @@ -46,7 +46,7 @@ struct cgroup_subsys mem_cgroup_subsys _
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  /* Turned on only when memory cgroup is enabled &&
> really_do_swap_account = 0 */
>  int do_swap_account __read_mostly;
> -static int really_do_swap_account __initdata = 1; /* for remember boot option*/
> +static int really_do_swap_account = 1; /* for remember boot option*/
>  #else
>  #define do_swap_account		(0)
>  #endif
> @@ -2170,13 +2170,13 @@ static void mem_cgroup_put(struct mem_cg
> 
> 
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> -static void __init enable_swap_cgroup(void)
> +static void enable_swap_cgroup(void)
>  {
>  	if (!mem_cgroup_disabled() && really_do_swap_account)
>  		do_swap_account = 1;
>  }
>  #else
> -static void __init enable_swap_cgroup(void)
> +static void enable_swap_cgroup(void)
>  {
>  }
>  #endif
> --
