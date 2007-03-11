Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXCKTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXCKTOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXCKTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:14:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42823 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbXCKTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:14:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/7] Data structures changes for RSS accounting
References: <45ED7DEC.7010403@sw.ru> <45ED8181.2060905@sw.ru>
Date: Sun, 11 Mar 2007 13:13:26 -0600
In-Reply-To: <45ED8181.2060905@sw.ru> (Pavel Emelianov's message of "Tue, 06
	Mar 2007 17:58:09 +0300")
Message-ID: <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov <xemul@sw.ru> writes:

> Adds needed pointers to mm_struct and page struct,
> places hooks to core code for mm_struct initialization
> and hooks in container_init_early() to preinitialize
> RSS accounting subsystem.

An extra pointer in struct page is unlikely to fly.
Both because it increases the size of a size critical structure,
and because conceptually it is ridiculous.

If you are limiting the RSS size you are counting the number of pages in
the page tables.  You don't care about the page itself.

With the rmap code it is relatively straight forward to see if this is
the first time a page has been added to a page table in your rss
group, or if this is the last reference to a particular page in your
rss group.  The counters should only increment the first time a
particular page is added to your rss group.  The counters should only
decrement when it is the last reference in your rss subsystem.

This allow important little cases like glibc to be properly accounted
for. One of the key features of a rss limit is that the kernel can
still keep pages that you need in-core, that are accessible with just
a minor fault.  Directly owning pages works directly against that
principle.


> diff -upr linux-2.6.20.orig/include/linux/mm_types.h
> linux-2.6.20-0/include/linux/mm_types.h
> --- linux-2.6.20.orig/include/linux/mm_types.h 2007-02-04 21:44:54.000000000
> +0300
> +++ linux-2.6.20-0/include/linux/mm_types.h 2007-03-06 13:33:28.000000000 +0300
> @@ -62,6 +62,9 @@ struct page {
>  	void *virtual;			/* Kernel virtual address (NULL if
>  					   not kmapped, ie. highmem) */
>  #endif /* WANT_PAGE_VIRTUAL */
> +#ifdef CONFIG_RSS_CONTAINER
> +	struct page_container *rss_container;
> +#endif
>  };
>  
>  #endif /* _LINUX_MM_TYPES_H */

Eric
