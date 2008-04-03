Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbYDCGhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbYDCGhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 02:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbYDCGhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 02:37:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42649 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbYDCGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 02:37:09 -0400
Date: Thu, 3 Apr 2008 15:41:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v5)
Message-Id: <20080403154106.39f26460.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403055901.31796.41411.sendpatchset@localhost.localdomain>
References: <20080403055901.31796.41411.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just nitpicks ;)

On Thu, 03 Apr 2008 11:29:01 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

>  #define mm_match_cgroup(mm, cgroup)	\
> -	((cgroup) == rcu_dereference((mm)->mem_cgroup))
> +	((cgroup) == mem_cgroup_from_task((mm)->owner))
>  

After this patch, above should be 
==
#define mm_match_cgroup_css(mm, css, subsys_id)
	((css) == task_subsys_state((mm)->owner, subsys_id) 
==
This generic macro may be good for your purpose.


>  #endif
> diff -puN init/Kconfig~memory-controller-add-mm-owner init/Kconfig
> --- linux-2.6.25-rc8/init/Kconfig~memory-controller-add-mm-owner	2008-04-03 10:08:23.000000000 +0530
> +++ linux-2.6.25-rc8-balbir/init/Kconfig	2008-04-03 10:08:23.000000000 +0530
> @@ -371,9 +371,21 @@ config RESOURCE_COUNTERS
>            infrastructure that works with cgroups
>  	depends on CGROUPS
>  
> +config MM_OWNER
> +	bool "Enable ownership of mm structure"
> +	help
> +	  This option enables mm_struct's to have an owner. The advantage
> +	  of this approach is that it allows for several independent memory
> +	  based cgorup controllers to co-exist independently without too
> +	  much space overhead
	 Above is an explanation for this patch.
	  More simple text is better... How about
	 ==
	  This is necessary for some cgroup subsystem related to memory management.
	 ==
> +
> +	  This feature adds fork/exit overhead. So enable this only if
> +	  you need resource controllers
> +


>  config CGROUP_MEM_RES_CTLR
>  	bool "Memory Resource Controller for Control Groups"
>  	depends on CGROUPS && RESOURCE_COUNTERS
> +	select MM_OWNER

I don't like "select"....this should be
	depends on CGROUPS && RESOURCE_COUNTERS && MM_OWNER

Thanks,
-Kame

