Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZANGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZANGue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZANGu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:50:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54312 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZANGuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:50:25 -0500
Date: Wed, 14 Jan 2009 15:49:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Fix section mismatch in memcontrol.c
Message-Id: <20090114154912.2e01f9f5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <496D74CE.2070308@cn.fujitsu.com>
References: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
	<496C2B4F.3090406@cn.fujitsu.com>
	<20090113151307.e9ddc085.kamezawa.hiroyu@jp.fujitsu.com>
	<b9df5fa10901132043j5a577b2fxeaaa4cc1fdd551f2@mail.gmail.com>
	<20090114140010.3649cd2e.kamezawa.hiroyu@jp.fujitsu.com>
	<496D74CE.2070308@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 13:14:54 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 14 Jan 2009 10:43:24 +0600
> > "Rakib Mullick" <rakib.mullick@gmail.com> wrote:
> > 
> >> Sure. You can carryout your other jobs. Here is the patch.
> >> Thanks for your help guys.
> >>
> > Thank you. I confirmed this fixes mismatch.
> > 
> > Could you send this with your Signed-off-by, again ?
> > 
> > you got my Ack.
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> 
> No... This patch is still not correct..
> 
> It's mem_cgroup_create() but not enable_swap_cgroup() that needs
> to be marked as __init_refok.
> 
> Here is the correct one:
> 
Ah..maybe you're right.

BTW, reading inclinde/linux/init.h again

==
/* modpost check for section mismatches during the kernel build.
 * A section mismatch happens when there are references from a
 * code or data section to an init section (both code or data).
 * The init sections are (for most archs) discarded by the kernel
 * when early init has completed so all such references are potential bugs.
 * For exit sections the same issue exists.
 * The following markers are used for the cases where the reference to
 * the *init / *exit section (code or data) is valid and will teach
 * modpost not to issue a warning.
 * The markers follow same syntax rules as __init / __initdata. */
#define __ref            __section(.ref.text) noinline
#define __refdata        __section(.ref.data)
#define __refconst       __section(.ref.rodata)

==

It seems init_refok is old style.

Could you convert to __ref ?

-Kame



> ===============
> 
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Wed, 14 Jan 2009 13:07:31 +0800
> Subject: [PATCH] memcg: fix section mismatch
> 
> At system boot when creating the top cgroup, mem_cgroup_create() calls
> enable_swap_cgroup() which is marked as __init, so mark mem_cgroup_create()
> as __init_refok to avoid false section mismatch warning.
> 
> Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2996b8..a2c929f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2181,7 +2181,7 @@ static void __init enable_swap_cgroup(void)
>  }
>  #endif
>  
> -static struct cgroup_subsys_state *
> +static struct cgroup_subsys_state * __init_refok
>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  {
>  	struct mem_cgroup *mem, *parent;
> -- 
> 1.5.4.rc3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

