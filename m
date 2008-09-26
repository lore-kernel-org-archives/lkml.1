Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYIZJsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYIZJsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYIZJr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:47:56 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42327 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753291AbYIZJrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:47:55 -0400
Message-ID: <48DCAFC4.40009@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2008 15:17:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 4/12] memcg make page->mapping NULL before calling uncharge
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925151639.5e2ddea4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080925151639.5e2ddea4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This patch tries to make page->mapping to be NULL before
> mem_cgroup_uncharge_cache_page() is called.
> 
> "page->mapping == NULL" is a good check for "whether the page is still
> radix-tree or not".
> This patch also adds BUG_ON() to mem_cgroup_uncharge_cache_page();
> 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good, small nit-pick below

>  #endif
>  	ClearPagePrivate(page);
>  	set_page_private(page, 0);
> -	page->mapping = NULL;
> +	/* page->mapping contains a flag for PageAnon() */
> +	if (PageAnon(page)) {
> +		/* This page is uncharged at try_to_unmap(). */
> +		page->mapping = NULL;
> +	} else {
> +		/* Obsolete file cache should be uncharged */
> +		page->mapping = NULL;
> +		mem_cgroup_uncharge_cache_page(page);
> +	}
> 

Isn't it better and correct coding style to do

	/*
	 * Uncharge obsolete file cache
	 */
	if (!PageAnon(page))
		mem_cgroup_uncharge_cache_page(page);
	/* else - uncharged at try_to_unmap() */
	page->mapping = NULL;


-- 
	Balbir
