Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZFCDyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZFCDyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZFCDyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:54:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46351 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZFCDyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:54:01 -0400
Date: Wed, 3 Jun 2009 12:52:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: Re: [PATCH mmotm 2/2] memcg: allow mem.limit bigger than
 memsw.limit iff unlimited
Message-Id: <20090603125228.368ecaf7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090603115027.80f9169b.nishimura@mxp.nes.nec.co.jp>
References: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp>
	<20090603115027.80f9169b.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009 11:50:27 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Now users cannot set mem.limit bigger than memsw.limit.
> This patch allows mem.limit bigger than memsw.limit iff mem.limit==unlimited.
> 
> By this, users can set memsw.limit without setting mem.limit.
> I think it's usefull if users want to limit memsw only.
> They must set mem.limit first and memsw.limit to the same value now for this purpose.
> They can save the first step by this patch.
> 

I don't like this. No benefits to users.
The user should know when they set memsw.limit they have to set memory.limit.
This just complicates things.

If you want to do this, add an interface as
  memory.all.limit_in_bytes (or some better name)
and allow to set memory.limit and memory.memsw.limit _at once_.

But I'm not sure it's worth to try. Saving user's few steps by the kenerl patch ?

Thanks,
-Kame


> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  mm/memcontrol.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6629ed2..2b63cb1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1742,11 +1742,12 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		/*
>  		 * Rather than hide all in some function, I do this in
>  		 * open coded manner. You see what this really does.
> -		 * We have to guarantee mem->res.limit < mem->memsw.limit.
> +		 * We have to guarantee mem->res.limit < mem->memsw.limit,
> +		 * except for mem->res.limit == RESOURCE_MAX(unlimited) case.
>  		 */
>  		mutex_lock(&set_limit_mutex);
>  		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> -		if (memswlimit < val) {
> +		if (val != RESOURCE_MAX && memswlimit < val) {
>  			ret = -EINVAL;
>  			mutex_unlock(&set_limit_mutex);
>  			break;
> @@ -1789,11 +1790,12 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		/*
>  		 * Rather than hide all in some function, I do this in
>  		 * open coded manner. You see what this really does.
> -		 * We have to guarantee mem->res.limit < mem->memsw.limit.
> +		 * We have to guarantee mem->res.limit < mem->memsw.limit,
> +		 * except for mem->res.limit == RESOURCE_MAX(unlimited) case.
>  		 */
>  		mutex_lock(&set_limit_mutex);
>  		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> -		if (memlimit > val) {
> +		if (memlimit != RESOURCE_MAX && memlimit > val) {
>  			ret = -EINVAL;
>  			mutex_unlock(&set_limit_mutex);
>  			break;
> 

