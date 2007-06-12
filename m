Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbXFLJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbXFLJmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXFLJmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:42:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:34809 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXFLJmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lg8seuKvjU50kBw1Zn6ebY917b+47br8WWSmXH2h9pUJKNcoQR5SLHGgaJOg5N8dOEBpYxgpXjKWeletT/pEA3VixsmqeDC94ieWKas82ba7iCTW3TWSEL7hGmN0P690A7a1O5ioEDwcn8Gjf559QSzd6jn2eg4+Kg3F6mTWX5U=
Message-ID: <a781481a0706120242o5bcabee1ke67c96d5a7dd6cb0@mail.gmail.com>
Date: Tue, 12 Jun 2007 15:12:21 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] fix improper .init-type section references
Cc: linux-kernel@vger.kernel.org, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <466E66AE.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E66AE.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> .. which modpost started warning about.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
>  kernel/kthread.c |    2 +-
>  mm/page_alloc.c  |   18 +++++++++---------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> --- linux-2.6.22-rc4/kernel/kthread.c   2007-06-11 18:09:47.000000000 +0200
> +++ 2.6.22-rc4-init-attribs/kernel/kthread.c    2007-06-11 09:10:42.000000000 +0200
> @@ -215,7 +215,7 @@ int kthread_stop(struct task_struct *k)
>  EXPORT_SYMBOL(kthread_stop);
>
>
> -static __init void kthreadd_setup(void)
> +static noinline __init_refok void kthreadd_setup(void)
>  {
>         struct task_struct *tsk = current;

This isn't ok. There isn't any __init function that is (safely) referenced
by kthreadd_setup(), so we shouldn't really be marking it as such.
Also, kthreadd_setup() is really only ever called at init time, so we'd
want it to remain __init.

I believe the correct fix to silence modpost here would be to mark its
caller kthreadd() also as __init, because it too is used only at init time?

[ Cc:'ing Sam. ]

> --- linux-2.6.22-rc4/mm/page_alloc.c    2007-06-11 18:09:49.000000000 +0200
> +++ 2.6.22-rc4-init-attribs/mm/page_alloc.c     2007-06-11 09:10:42.000000000 +0200
> @@ -126,13 +126,13 @@ static unsigned long __meminitdata dma_r
>      #endif
>    #endif
>
> -  struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
> -  int __meminitdata nr_nodemap_entries;
> -  unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
> -  unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
> +  static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
> +  static int __meminitdata nr_nodemap_entries;
> +  static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
> +  static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
>  #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
> -  unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES];
> -  unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES];
> +  static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
> +  static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];

Umm, can't really comment on mm/ code, but this could've been a
separate patch ... (the simple non-static to static conversions, at least)

Satyam
