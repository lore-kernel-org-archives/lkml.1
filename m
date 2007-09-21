Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbXIUTd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbXIUTd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761018AbXIUTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:33:48 -0400
Received: from mx2.netapp.com ([216.240.18.37]:46049 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbXIUTdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:33:47 -0400
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="106493196"
Subject: Re: [PATCH 11/22] CacheFiles: Permit the page lock state to be
	monitored
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, hch@infradead.org, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <20070921144800.8323.72246.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
	 <20070921144800.8323.72246.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 21 Sep 2007 15:33:45 -0400
Message-Id: <1190403225.6721.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 21 Sep 2007 19:33:46.0566 (UTC) FILETIME=[53D56660:01C7FC86]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 15:48 +0100, David Howells wrote:
> Add a function to install a monitor on the page lock waitqueue for a particular
> page, thus allowing the page being unlocked to be detected.
> 
> This is used by CacheFiles to detect read completion on a page in the backing
> filesystem so that it can then copy the data to the waiting netfs page.

Won't it in any case want to lock the page too? That would be the only
way to ensure that the page is still mapped into the address space when
you're writing it out...

Trond

> Signed-Off-By: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/pagemap.h |    5 +++++
>  mm/filemap.c            |   19 +++++++++++++++++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index d1049b6..452fdcf 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -220,6 +220,11 @@ static inline void wait_on_page_fscache_write(struct page *page)
>  extern void end_page_fscache_write(struct page *page);
>  
>  /*
> + * Add an arbitrary waiter to a page's wait queue
> + */
> +extern void add_page_wait_queue(struct page *page, wait_queue_t *waiter);
> +
> +/*
>   * Fault a userspace page into pagetables.  Return non-zero on a fault.
>   *
>   * This assumes that two userspace pages are always sufficient.  That's
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 21aeee9..e48e862 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -518,6 +518,25 @@ void fastcall wait_on_page_bit(struct page *page, int bit_nr)
>  EXPORT_SYMBOL(wait_on_page_bit);
>  
>  /**
> + * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
> + * @page - Page defining the wait queue of interest
> + * @waiter - Waiter to add to the queue
> + *
> + * Add an arbitrary @waiter to the wait queue for the nominated @page.
> + */
> +void add_page_wait_queue(struct page *page, wait_queue_t *waiter)
> +{
> +	wait_queue_head_t *q = page_waitqueue(page);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&q->lock, flags);
> +	__add_wait_queue(q, waiter);
> +	spin_unlock_irqrestore(&q->lock, flags);
> +}
> +
> +EXPORT_SYMBOL_GPL(add_page_wait_queue);
> +
> +/**
>   * unlock_page - unlock a locked page
>   * @page: the page
>   *
