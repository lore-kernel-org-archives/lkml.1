Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZANIWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZANIWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZANIWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:22:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34035 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZANIWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:22:44 -0500
Date: Wed, 14 Jan 2009 17:21:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix return value of mem_cgroup_hierarchy_write()
Message-Id: <20090114172138.d73a8be8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <496D9E0C.4060806@cn.fujitsu.com>
References: <496D9E0C.4060806@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 16:10:52 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> When there are sub-dirs, writing to memory.use_hierarchy returns -EBUSY,
> this doesn't seem to fit the meaning of EBUSY, and is inconsistent with
> memory.swappiness, which returns -EINVAL in this case.
> 

Hmm...I'm not sure what error code is the best.

In usual, -EINVAL means parameter to write() is bad. In this case, it isn't.

Considering that, -EBUSY seems ok at returning error because of children.
How about change swappiness to return -EBUSY ?

Thanks,
-Kame






> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  mm/memcontrol.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bc8f101..2497f7d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1760,6 +1760,9 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
>  	struct cgroup *parent = cont->parent;
>  	struct mem_cgroup *parent_mem = NULL;
>  
> +	if (val != 0 && val != 1)
> +		return -EINVAL;
> +
>  	if (parent)
>  		parent_mem = mem_cgroup_from_cont(parent);
>  
> @@ -1773,12 +1776,9 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
>  	 * set if there are no children.
>  	 */
>  	if ((!parent_mem || !parent_mem->use_hierarchy) &&
> -				(val == 1 || val == 0)) {
> -		if (list_empty(&cont->children))
> +	    list_empty(&cont->children))
>  			mem->use_hierarchy = val;
> -		else
> -			retval = -EBUSY;
> -	} else
> +	else
>  		retval = -EINVAL;
>  	cgroup_unlock();
>  
> -- 
> 1.5.4.rc3
> 

