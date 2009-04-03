Return-Path: <linux-kernel-owner+w=401wt.eu-S1763615AbZDCMh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763615AbZDCMh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZDCMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:37:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:43028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZDCMhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:37:45 -0400
Subject: Re: [patch 4/4] Intel IOMMU Suspend/Resume Support - Code Clean Up
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
In-Reply-To: <20090327212321.520992000@intel.com>>
References: <20090327212241.234500000@intel.com> >
	  <20090327212321.520992000@intel.com>>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 13:37:17 +0100
Message-Id: <1238762237.3494.13.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 14:22 -0700, Fenghua Yu wrote:
> plain text document attachment (iommu_sr_4.patch)
> A new macro list_for_each_entry_selected_do() is defined for linked list.
> iommu uses this macro to have concise and more readable code.
> 
> It's defined as generic code. Hopefully it could be used in other places.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

This is overkill, surely? It would be easier to do...

#define for_each_active_iommu(i, drhd)					\
	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
		if (i=drhd->iommu, !drhd->ignored)

#define for_each_iommu(i, drhd)						\
	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
		if (i=drhd->iommu, 1)

Or if you really want to avoid it eating a stray 'else' then

#define for_each_active_iommu(i, drhd)					\
	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
		if (i=drhd->iommu, drhd->ignored) {} else

#define for_each_iommu(i, drhd)						\
	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
		if (i=drhd->iommu, 0) {} else


> ---
> 
>  include/linux/dmar.h |    8 ++++++++
>  include/linux/list.h |   42 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index 2f34274..146d54b 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -44,6 +44,14 @@ extern struct list_head dmar_drhd_units;
>  #define for_each_drhd_unit(drhd) \
>  	list_for_each_entry(drhd, &dmar_drhd_units, list)
>  
> +#define for_each_active_iommu(i, drhd)					\
> +	list_for_each_entry_selected_do(drhd, &dmar_drhd_units, list,	\
> +				!drhd->ignored, {i = drhd->iommu; })
> +
> +#define for_each_iommu(i, drhd)						\
> +	list_for_each_entry_selected_do(drhd, &dmar_drhd_units, list,	\
> +				1, {i = drhd->iommu; })
> +
>  extern int dmar_table_init(void);
>  extern int dmar_dev_scope_init(void);
>  
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 969f6e9..6580f43 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -530,6 +530,48 @@ static inline void list_splice_tail_init(struct list_head *list,
>  	     &pos->member != (head); 					\
>  	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
>  
> +/**
> + * list_first_entry_selected - get the first selected element from a list
> + * @pos:	the type * to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the list_struct within the struct.
> + * @selector:	the selector to select the first entry.
> + */
> +#define list_first_entry_selected(pos, head, member, selector)		  \
> +	pos = list_entry((head)->next, typeof(*pos), member),		  \
> +	pos = ({while (!(selector) && (&pos->member != (head)))		  \
> +		pos = list_entry(pos->member.next, typeof(*pos), member); \
> +		pos; })
> +
> +/**
> + * list_next_entry_selected - get the next selected element from a list
> + * @pos:	the type * to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the list_struct within the struct.
> + * @selector:	the selector to select the next entry.
> + */
> +#define list_next_entry_selected(pos, head, member, selector)		  \
> +	pos = list_entry(pos->member.next, typeof(*pos), member),	  \
> +	pos = ({while (!(selector) && (&pos->member != (head)))		  \
> +		pos = list_entry(pos->member.next, typeof(*pos), member); \
> +		pos; })
> +
> +/**
> + * list_for_each_entry_selected_do - iterate over list of given type and
> + * selected entries. Do something on each selected entry.
> + * @pos:	the type * to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the list_struct within the struct.
> + * @selector:	the selector to select entries.
> + * @to_do:	things to do on each selected entry.
> + */
> +#define list_for_each_entry_selected_do(pos, head, member, selector, to_do) \
> +	for (list_first_entry_selected(pos, head, member, selector),	    \
> +		({if (&pos->member != (head)) to_do});			    \
> +		prefetch(pos->member.next), &pos->member != (head);	    \
> +		list_next_entry_selected(pos, head, member, selector),	    \
> +		({if (&pos->member != (head)) to_do}))
> +
>  /*
>   * Double linked lists with a single pointer list head.
>   * Mostly useful for hash tables where the two pointer list head is
> 
-- 
dwmw2

