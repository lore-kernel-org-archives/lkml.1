Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXGESqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXGESqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXGESq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:46:27 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:43415 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389AbXGESq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:46:26 -0400
Message-ID: <468D3C6C.8060900@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2007 00:16:04 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Pavel Emelianov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [-mm PATCH 4/7] Memory controller memory accounting
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop> <20070704222203.17702.37327.sendpatchset@balbir-laptop>
In-Reply-To: <20070704222203.17702.37327.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Balbir Singh wrote:
> Add the accounting hooks. The accounting is carried out for RSS and Page
> Cache (unmapped) pages. There is now a common limit and accounting for both.
> The RSS accounting is accounted at page_add_*_rmap() and page_remove_rmap()
> time. Page cache is accounted at add_to_page_cache(),
> __delete_from_page_cache(). Swap cache is also accounted for.
> 
> Each page's meta_page is protected with a bit in page flags, this makes
> handling of race conditions involving simultaneous mappings of a page easier.
> A reference count is kept in the meta_page to deal with cases where a page
> might be unmapped from the RSS of all tasks, but still lives in the page
> cache.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  fs/exec.c                  |    1 
>  include/linux/memcontrol.h |   11 +++
>  include/linux/page-flags.h |    3 +
>  mm/filemap.c               |    8 ++
>  mm/memcontrol.c            |  132 ++++++++++++++++++++++++++++++++++++++++++++-
>  mm/memory.c                |   22 +++++++
>  mm/migrate.c               |    6 ++
>  mm/page_alloc.c            |    3 +
>  mm/rmap.c                  |    2 
>  mm/swap_state.c            |    8 ++
>  mm/swapfile.c              |   40 +++++++------
>  11 files changed, 218 insertions(+), 18 deletions(-)
> 

[snip]

> diff -puN mm/migrate.c~mem-control-accounting mm/migrate.c
> --- linux-2.6.22-rc6/mm/migrate.c~mem-control-accounting	2007-07-04 15:05:27.000000000 -0700
> +++ linux-2.6.22-rc6-balbir/mm/migrate.c	2007-07-04 15:05:27.000000000 -0700
> @@ -28,6 +28,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/vmalloc.h>
>  #include <linux/security.h>
> +#include <linux/memcontrol.h>
> 
>  #include "internal.h"
> 
> @@ -157,6 +158,11 @@ static void remove_migration_pte(struct 
>   		return;
>   	}
> 
> +	if (mem_container_charge(page, mm)) {

Minor correction.  The above line should be

if (mem_container_charge(new, mm)) {

to avoid compilation error.

--Vaidy

[snip]
