Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYDGWKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYDGWKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDGWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:10:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbYDGWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:10:31 -0400
Date: Mon, 7 Apr 2008 15:09:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: menage@google.com, xemul@openvz.org, hugh@veritas.com,
       skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       rientjes@google.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Message-Id: <20080407150956.9a29573a.akpm@linux-foundation.org>
In-Reply-To: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2008 13:35:44 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 1. Add mm->owner change callbacks using cgroups
> 
> ...
>
> +config MM_OWNER
> +	bool "Enable ownership of mm structure"
> +	help
> +	  This option enables mm_struct's to have an owner. The advantage
> +	  of this approach is that it allows for several independent memory
> +	  based cgroup controllers to co-exist independently without too
> +	  much space overhead
> +
> +	  This feature adds fork/exit overhead. So enable this only if
> +	  you need resource controllers

Do we really want to offer this option to people?  It's rather a low-level
thing and it's likely to cause more confusion than it's worth.  Remember
that most kernels get to our users via kernel vendors - to what will they
be setting this config option?

>  config CGROUP_MEM_RES_CTLR
>  	bool "Memory Resource Controller for Control Groups"
>  	depends on CGROUPS && RESOURCE_COUNTERS
> +	select MM_OWNER

Presumably they'll always be setting it to "y" if they are enabling cgroups
at all.

> --- linux-2.6.25-rc8/kernel/cgroup.c~memory-controller-add-mm-owner	2008-04-03 22:43:27.000000000 +0530
> +++ linux-2.6.25-rc8-balbir/kernel/cgroup.c	2008-04-03 22:43:27.000000000 +0530
> @@ -118,6 +118,7 @@ static int root_count;
>   * be called.
>   */
>  static int need_forkexit_callback;
> +static int need_mm_owner_callback;

I suppose these should be __read_mostly.

