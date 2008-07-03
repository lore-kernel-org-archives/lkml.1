Return-Path: <linux-kernel-owner+w=401wt.eu-S935220AbYGCHMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220AbYGCHMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYGCG6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821AbYGCFhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:37:33 -0400
Date: Wed, 2 Jul 2008 22:36:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>,
       Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: [-mm][PATCH 1/10] fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR
 build
Message-Id: <20080702223652.3b57dc4b.akpm@linux-foundation.org>
In-Reply-To: <20080625185950.D84F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080625185950.D84F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 19:01:40 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> =
> From: Rik van Riel <riel@redhat.com>
> 
> Both CONFIG_PROC_PAGE_MONITOR and CONFIG_UNEVICTABLE_LRU depend on
> mm/pagewalk.c being built.  Create a CONFIG_PAGE_WALKER Kconfig
> variable that is automatically selected if needed.
> 
> Debugged-by: Benjamin Kidwell <benjkidwell@yahoo.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki@jp.fujitsu.com>
> 
> ---
>  init/Kconfig |    1 +
>  mm/Kconfig   |    5 +++++
>  mm/Makefile  |    2 +-
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> Index: b/init/Kconfig
> ===================================================================
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -803,6 +803,7 @@ source "arch/Kconfig"
>  config PROC_PAGE_MONITOR
>   	default y
>  	depends on PROC_FS && MMU
> +	select PAGE_WALKER
>  	bool "Enable /proc page monitoring" if EMBEDDED
>   	help
>  	  Various /proc files exist to monitor process memory utilization:

You used select!  With the usual consequences.

mm/pagewalk.c: In function `walk_pud_range':
mm/pagewalk.c:64: error: implicit declaration of function `pud_none_or_clear_bad'
mm/pagewalk.c: In function `walk_page_range':
mm/pagewalk.c:119: error: implicit declaration of function `pgd_addr_end'
mm/pagewalk.c:120: error: implicit declaration of function `pgd_none_or_clear_ba

That's SuperH allmodconfig.  I expect all nommu builds are busted.

> Index: b/mm/Kconfig
> ===================================================================
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -209,9 +209,14 @@ config VIRT_TO_BUS
>  	def_bool y
>  	depends on !ARCH_NO_VIRT_TO_BUS
>  
> +# automatically selected by UNEVICTABLE_LRU or PROC_PAGE_MONITOR
> +config PAGE_WALKER
> +	def_bool n
> +
>  config UNEVICTABLE_LRU
>  	bool "Add LRU list to track non-evictable pages"
>  	default y
> +	select PAGE_WALKER

So what do we do?  Make UNEVICTABLE_LRU depend on CONFIG_MMU?  That
would be even worse than what we have now.

