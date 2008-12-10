Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYLJCV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYLJCV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYLJCVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:21:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60562 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYLJCVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:21:17 -0500
Message-ID: <493F2737.9060901@cn.fujitsu.com>
Date: Wed, 10 Dec 2008 10:19:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com> <20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static bool memcg_is_obsolete(struct mem_cgroup *mem)
> +{

Will this function be called with mem->css.refcnt == 0? If yes, then
this function is racy.

cg = mem->css.cgroup
				cgroup_diput()
				  mem_cgroup_destroy()
				    mem->css.cgroup = NULL;
				  kfree(cg);
if (!cg || cgroup_is_removed(cg)...)

(accessing invalid cg)

> +	struct cgroup *cg = mem->css.cgroup;
> +	/*
> +	 * "Being Removed" means pre_destroy() handler is called.
> +	 * After  "pre_destroy" handler is called, memcg should not
> +	 * have any additional charges.
> +	 * This means there are small races for mis-accounting. But this
> +	 * mis-accounting should happen only under swap-in opration.
> +	 * (Attachin new task will fail if cgroup is under rmdir()).
> +	 */
> +
> +	if (!cg || cgroup_is_removed(cg) || cgroup_is_being_removed(cg))
> +		return true;
> +	return false;
> +}
> +

...

>  static void mem_cgroup_destroy(struct cgroup_subsys *ss,
>  				struct cgroup *cont)
>  {
> -	mem_cgroup_free(mem_cgroup_from_cont(cont));
> +	struct mem_cgroup *mem = mem_cgroup_from_cont(cont):
> +	mem_cgroup_free(mem);
> +	/* forget */
> +	mem->css.cgroup = NULL;

mem might already be destroyed by mem_cgroup_free(mem).

>  }
