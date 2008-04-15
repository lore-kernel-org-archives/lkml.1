Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYDOCDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYDOCDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbYDOCDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:03:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40426 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbYDOCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:03:01 -0400
Date: Tue, 15 Apr 2008 11:07:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, menage@google.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation.
Message-Id: <20080415110705.794aa543.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48040B7D.4040708@cn.fujitsu.com>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
	<48040B7D.4040708@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 09:57:17 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >  #include <asm/uaccess.h>
> >  
> > @@ -993,7 +994,7 @@ mem_cgroup_create(struct cgroup_subsys *
> >  		mem = &init_mem_cgroup;
> >  		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
> >  	} else
> > -		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
> > +		mem = vmalloc(sizeof(struct mem_cgroup));
> >  
> 
> memset(mem, 0, sizeof(*mem));
> 
ok, will rewrite.

> should we initialize it with 0?
> 
yes. (at least, per-cpu stat. mem->css, per-node pointer, ... should be zero.)

Thanks,
-Kame


> >  	if (mem == NULL)
> >  		return ERR_PTR(-ENOMEM);
> > @@ -1011,7 +1012,7 @@ free_out:
> >  	for_each_node_state(node, N_POSSIBLE)
> >  		free_mem_cgroup_per_zone_info(mem, node);
> >  	if (cont->parent != NULL)
> > -		kfree(mem);
> > +		vfree(mem);
> >  	return ERR_PTR(-ENOMEM);
> >  }
> >  
> > @@ -1031,7 +1032,7 @@ static void mem_cgroup_destroy(struct cg
> >  	for_each_node_state(node, N_POSSIBLE)
> >  		free_mem_cgroup_per_zone_info(mem, node);
> >  
> > -	kfree(mem_cgroup_from_cont(cont));
> > +	vfree(mem_cgroup_from_cont(cont));
> >  }
> >  
> >  static int mem_cgroup_populate(struct cgroup_subsys *ss,
> > 
> >
> 

