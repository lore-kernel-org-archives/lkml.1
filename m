Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYHVKta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYHVKta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYHVKtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:49:22 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44154 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYHVKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:49:21 -0400
Date: Fri, 22 Aug 2008 19:29:43 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>, ryov@valinux.co.jp
Subject: Re: [PATCH -mm][preview] memcg: a patch series for next [8/9]
Message-Id: <20080822192943.4009a7b5.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080819174404.80dd5102.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819174404.80dd5102.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I think you are making updated ones, I send comments so far.

On Tue, 19 Aug 2008 17:44:04 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Very experimental...
> 
> mem+swap controller prototype.
> 
> This patch adds CONFIG_CGROUP_MEM_RES_CTLR_SWAP as memory resource
> controller's swap extension.
> 
> When enabling this, memory resource controller will have 2 limits.
> 
>  - memory.limit_in_bytes .... limit for pages
>  - memory.memsw_limit_in_bytes .... limit for pages + swaps.
> 
> Following is (easy) accounting state transion after this patch.
> 
>    pages   swaps    pages_total   memsw_total
>     +1       -           +1           +1        new page allocation.
>     -1      +1           -1           -         swap out.
>     +1      -1            0           -         swap in (*).
>     -       -1           -            -1        swap_free.
> 
What do you mean by "pages_total"?

> At swap-out, swp_entry will be charged against the cgroup of the page.
> At swap-in, the page will be charged when it's mapped.
> (Maybe accounting at read_swap() will be beautiful but we can avoid some of
>  error handling to delay accounting until mem_cgroup_charge().)
> 
> The charge against swap_entry will be uncharged when swap_entry is freed.
> 
> The parameter res.swaps just includes swaps not-on swap cache.
> So, this doesn't show real usage of swp_entry just shows swp_entry on disk.
> 
IMHO, it would be better to "show" real usage of swp_entry.
Otherwise, "sum of swap usage of all groups" != "swap usage of
system shown by meminfo"(but it means adding another counter, hmm...).

Instead of showing the usage of disk_swap, how about showing
the memsw total usage, which is to be limited by user.

> This patch doesn't include codes for control files.
> 
> TODO:
>   - clean up. and add comments.
>   - support vm_swap_full() under cgroup.
Is it needed?

In my swap controller, swap entries are limited per cgroup.
So, to make swap_cgroup_charge() fail less frequently,
vm_swap_full() should be calculated per cgroup so that
vm can free swap entries in advance.

But I think in mem+swap controller the situation is different.

>   - find easier-to-understand protocol....
>   - check force_empty....(maybe buggy)
>   - support page migration.
>   - test!!
> 
And,
- move charge along with task move
- hierarchy support

Of course, more basic features and stabilization should be done first.


I agree with this patch as a whole, but I'm worrying about race
between swapout and swapin about the same entry(I should consider more...).


Thanks,
Daisuke Nishimura.
