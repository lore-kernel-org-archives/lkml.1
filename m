Return-Path: <linux-kernel-owner+w=401wt.eu-S936071AbZAPCNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936071AbZAPCNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 21:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762151AbZAPCNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 21:13:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761558AbZAPCM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 21:12:59 -0500
Date: Thu, 15 Jan 2009 18:12:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>
Subject: Re: [BUGFIX][PATCH] memcg: get/put parents at create/free
Message-Id: <20090115181243.8dad9052.akpm@linux-foundation.org>
In-Reply-To: <20090116105009.7cabac46.nishimura@mxp.nes.nec.co.jp>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<7602a77a9fc6b1e8757468048fde749a.squirrel@webmail-b.css.fujitsu.com>
	<20090115100330.37d89d3d.nishimura@mxp.nes.nec.co.jp>
	<20090115110044.3a863af8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115111420.8559bdb3.nishimura@mxp.nes.nec.co.jp>
	<20090115133814.a52460fa.nishimura@mxp.nes.nec.co.jp>
	<20090115164537.d402e95f.nishimura@mxp.nes.nec.co.jp>
	<20090115165453.271848d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115171315.965da4e3.nishimura@mxp.nes.nec.co.jp>
	<20090115172336.0ed780bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115175131.9542ae59.nishimura@mxp.nes.nec.co.jp>
	<20090115181056.74a938d5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090116105009.7cabac46.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 10:50:09 +0900 Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> This version works well in my test.
> 
> Andrew, please pick up this one.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> The lifetime of struct cgroup and struct mem_cgroup is different and
> mem_cgroup has its own reference count for handling references from swap_cgroup.
> 
> This causes strange problem that the parent mem_cgroup dies while
> child mem_cgroup alive, and this problem causes a bug in case of use_hierarchy==1
> because res_counter_uncharge climbs up the tree.
> 
> This patch is for avoiding it by getting the parent at create, and
> putting it at freeing.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Reviewed-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fb62b43..45e1b51 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -202,6 +202,8 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
>  
>  static void mem_cgroup_get(struct mem_cgroup *mem);
>  static void mem_cgroup_put(struct mem_cgroup *mem);
> +static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
> +static void mem_cgroup_get_parent(struct mem_cgroup *mem);
>  
>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>  					 struct page_cgroup *pc,
> @@ -2185,10 +2187,28 @@ static void mem_cgroup_get(struct mem_cgroup *mem)
>  
>  static void mem_cgroup_put(struct mem_cgroup *mem)
>  {
> -	if (atomic_dec_and_test(&mem->refcnt))
> +	if (atomic_dec_and_test(&mem->refcnt)) {
> +		struct mem_cgroup *parent = parent_mem_cgroup(mem);
>  		__mem_cgroup_free(mem);
> +		if (parent)
> +			mem_cgroup_put(parent);
> +	}
> +}
> +
> +static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem)
> +{
> +	if (!mem->res.parent)
> +		return NULL;
> +	return mem_cgroup_from_res_counter(mem->res.parent, res);
>  }
>  
> +static void mem_cgroup_get_parent(struct mem_cgroup *mem)
> +{
> +	struct mem_cgroup *parent = parent_mem_cgroup(mem);
> +
> +	if (parent)
> +		mem_cgroup_get(parent);
> +}
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  static void __init enable_swap_cgroup(void)
> @@ -2237,6 +2257,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  	if (parent)
>  		mem->swappiness = get_swappiness(parent);
>  	atomic_set(&mem->refcnt, 1);
> +	mem_cgroup_get_parent(mem);
>  	return &mem->css;
>  free_out:
>  	__mem_cgroup_free(mem);

It seems strange that we add a little helper function for the get(),
but open-code the put()?

