Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZAIEAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZAIEAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 23:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZAIEAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 23:00:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZAIEAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 23:00:06 -0500
Message-ID: <4966CB89.1020403@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 11:59:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 1/4] cgroup: support per cgroup subsys state ID (CSS
 ID)
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com> <20090108182817.2c393351.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090108182817.2c393351.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
>  {
>  	struct inode *inode = new_inode(sb);
> @@ -2335,6 +2339,7 @@ static void init_cgroup_css(struct cgrou
>  	css->cgroup = cgrp;
>  	atomic_set(&css->refcnt, 1);
>  	css->flags = 0;
> +	css->id = NULL;
>  	if (cgrp == dummytop)
>  		set_bit(CSS_ROOT, &css->flags);
>  	BUG_ON(cgrp->subsys[ss->subsys_id]);
> @@ -2410,6 +2415,10 @@ static long cgroup_create(struct cgroup 
>  			goto err_destroy;
>  		}
>  		init_cgroup_css(css, ss, cgrp);
> +		if (ss->use_id)
> +			if (alloc_css_id(ss, parent, cgrp))
> +				goto err_destroy;
> +		/* At error, ->destroy() callback has to free assigned ID. */

A bug here:

if alloc_css_id(ss, parent, cgrp) failed, then ss->destroy() called free_css_id(),
then panic.

maybe check if (css->id == NULL) in free_css_id() ?

>  	}
>  
>  	cgroup_lock_hierarchy(root);
> @@ -2699,6 +2708,8 @@ int __init cgroup_init(void)
>  		struct cgroup_subsys *ss = subsys[i];
>  		if (!ss->early_init)
>  			cgroup_init_subsys(ss);
> +		if (ss->use_id)
> +			cgroup_subsys_init_idr(ss);
>  	}
>  
>  	/* Add init_css_set to the hash table */
> @@ -3231,3 +3242,260 @@ static int __init cgroup_disable(char *s
>  	return 1;
>  }
>  __setup("cgroup_disable=", cgroup_disable);
