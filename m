Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZD3AEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZD3AEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZD3ADy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:03:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbZD3ADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:03:53 -0400
Date: Wed, 29 Apr 2009 16:59:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: torvalds@linux-foundation.org, nickpiggin@yahoo.com.au, mingo@elte.hu,
       kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       thomas.pi@arcor.dea, ylalym@gmail.com, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
Message-Id: <20090429165940.094efd0a.akpm@linux-foundation.org>
In-Reply-To: <20090429232546.GB15782@Krystal>
References: <20090429232546.GB15782@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 19:25:46 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Basically, the following execution :
> 
> dd if=/dev/zero of=/tmp/testfile
> 
> will slowly fill _all_ ram available without taking into account memory
> pressure.
> 
> This is because the dirty page accounting is incorrect in
> redirty_page_for_writepage.
> 
> This patch adds missing dirty page accounting in redirty_page_for_writepage().

The patch changes __set_page_dirty_nobuffers(), not
redirty_page_for_writepage().

__set_page_dirty_nobuffers() has a huge number of callers.

> --- linux-2.6-lttng.orig/mm/page-writeback.c	2009-04-29 18:14:48.000000000 -0400
> +++ linux-2.6-lttng/mm/page-writeback.c	2009-04-29 18:23:59.000000000 -0400
> @@ -1237,6 +1237,12 @@ int __set_page_dirty_nobuffers(struct pa
>  		if (!mapping)
>  			return 1;
>  
> +		/*
> +		 * Take care of setting back page accounting correctly.
> +		 */
> +		inc_zone_page_state(page, NR_FILE_DIRTY);
> +		inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
> +
>  		spin_lock_irq(&mapping->tree_lock);
>  		mapping2 = page_mapping(page);
>  		if (mapping2) { /* Race with truncate? */
> 

But __set_page_dirty_nobuffers() calls account_page_dirtied(), which
already does the above two operations.  afacit we're now
double-accounting.

Now, it's possible that the accounting goes wrong very occasionally in
the "/* Race with truncate?  */" case.  If the truncate path clears the
page's dirty bit then it will decrement the dirty-page accounting, but
this code path will fail to perform the increment of the dirty-page
accounting.  IOW, once this function has set PG_Dirty, it is committed
to altering some or all of the page-dirty accounting.

But afacit your test case will not trigger the race-with-truncate anyway?

Can you determine at approximately what frequency (pages-per-second)
this accounting leak is occurring in your test?

