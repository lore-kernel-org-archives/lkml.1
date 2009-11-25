Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbZKYADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbZKYADo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934452AbZKYADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:03:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53283 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbZKYADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:03:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Nov 2009 09:00:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: stable <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH -stable] memcg: avoid oom-killing innocent task
 in case of use_hierarchy
Message-Id: <20091125090050.e366dca5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091124162854.fb31e81e.nishimura@mxp.nes.nec.co.jp>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<20091124162854.fb31e81e.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 16:28:54 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> task_in_mem_cgroup(), which is called by select_bad_process() to check whether
> a task can be a candidate for being oom-killed from memcg's limit, checks
> "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs to).
> 
> But this check return true(it's false positive) when:
> 
> 	<some path>/00		use_hierarchy == 0	<- hitting limit
> 	  <some path>/00/aa	use_hierarchy == 1	<- "curr"
> 
> This leads to killing an innocent task in 00/aa. This patch is a fix for this
> bug. And this patch also fixes the arg for mem_cgroup_print_oom_info(). We
> should print information of mem_cgroup which the task being killed, not current,
> belongs to.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  mm/memcontrol.c |    2 +-
>  mm/oom_kill.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fd4529d..3acc226 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -496,7 +496,7 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
>  	task_unlock(task);
>  	if (!curr)
>  		return 0;
> -	if (curr->use_hierarchy)
> +	if (mem->use_hierarchy)
>  		ret = css_is_ancestor(&curr->css, &mem->css);
>  	else
>  		ret = (curr == mem);

Hmm. Maybe not-expected behavior...could you add comment ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
(*) I'm sorry I can't work enough in these days.

Thanks,
-Kame

