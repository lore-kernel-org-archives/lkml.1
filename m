Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZAFAih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZAFAih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZAFAi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:38:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbZAFAi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:38:28 -0500
Date: Mon, 5 Jan 2009 16:37:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: npiggin@suse.de, riel@redhat.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
Message-Id: <20090105163742.08777d73.akpm@linux-foundation.org>
In-Reply-To: <20090105103132.GD7645@localhost>
References: <20090105103132.GD7645@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 13:31:32 +0300
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> __nr_to_section should check for array bound overflow.
> We should better get NULL dereference then silently
> pass some memory snippet out of bounds to a caller.
> 

Are there actually any known problems here?

> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  include/linux/mmzone.h |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.git/include/linux/mmzone.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/mmzone.h
> +++ linux-2.6.git/include/linux/mmzone.h
> @@ -935,6 +935,12 @@ static inline unsigned long early_pfn_to
>  
>  struct page;
>  struct page_cgroup;
> +
> +/*
> + * NOTE: sizeof(struct mem_section) _must_ be power of 2
> + * otherwise SECTION_ROOT_MASK will be broken so be
> + * really cautious while modifying this structure
> + */
>  struct mem_section {
>  	/*
>  	 * This is, logically, a pointer to an array of struct
> @@ -980,9 +986,14 @@ extern struct mem_section mem_section[NR
>  
>  static inline struct mem_section *__nr_to_section(unsigned long nr)
>  {
> -	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
> +	unsigned long idx = SECTION_NR_TO_ROOT(nr);
> +
> +	if (WARN_ON(idx >= NR_SECTION_ROOTS))
> +		return NULL;
> +
> +	if (!mem_section[idx])
>  		return NULL;
> -	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
> +	return &mem_section[idx][nr & SECTION_ROOT_MASK];
>  }

The patch adds nearly 300 bytes of stuff to mm/sparse.o, and for what??
