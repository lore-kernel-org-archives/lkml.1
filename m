Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZAEKdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZAEKdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZAEKde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:33:34 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40596 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZAEKdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:33:33 -0500
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20090105103132.GD7645@localhost>
References: <20090105103132.GD7645@localhost>
Date: Mon, 05 Jan 2009 12:33:30 +0200
Message-Id: <1231151610.17195.38.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 13:31 +0300, Cyrill Gorcunov wrote:
> __nr_to_section should check for array bound overflow.
> We should better get NULL dereference then silently
> pass some memory snippet out of bounds to a caller.
> 
> Also add a comment about mem_section structure.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

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
>  extern int __section_nr(struct mem_section* ms);
>  extern unsigned long usemap_size(void);

