Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736Ab0ARRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0ARRR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650Ab0ARRRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:17:21 -0500
Received: from mail.solarflare.com ([216.237.3.220]:29458 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0ARRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:17 -0500
Subject: Re: [PATCH] list.h: add list_for_each_struct_entry macro
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <20100118162338.GD4229@psychotron.lab.eng.brq.redhat.com>
References: <20100118162338.GD4229@psychotron.lab.eng.brq.redhat.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 18 Jan 2010 17:17:13 +0000
Message-Id: <1263835033.3667.23.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2010 17:18:04.0284 (UTC) FILETIME=[31C743C0:01CA9862]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17138.005
X-TM-AS-Result: No--23.429200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 17:23 +0100, Jiri Pirko wrote:
> When preparing to upcoming migration of mc_list (list of multicast MACs)
> to list_head, the need of traversing the list over one structure member
> appeared. I thought I'll do it locally but I decided that an intruduction
> the macro in list.h would be much clearer. Please kindly for a review.
> 
> Jirka
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 969f6e9..8350a94 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -420,6 +420,22 @@ static inline void list_splice_tail_init(struct list_head *list,
>  	     pos = list_entry(pos->member.prev, typeof(*pos), member))
>  
>  /**
> + * list_for_each_struct_entry  -       iterate over list of given type using
> + *                                     the struct member.
> + * @pos:       the type * to use as a loop cursor.
> + * @head:      the head for your list.
> + * @type:      the type of the struct.
> + * @posmember: the name ot the loop cursor within the struct.
> + * @member:    the name of the list_struct within the struct.
> + */
> +#define list_for_each_struct_entry(pos, head, type, posmember, member)		\
> +	for (pos = list_entry((head)->next, type, member)->posmember;		\

Surely &list_entry(...)->posmember ?

> +	     prefetch(container_of(pos, type, posmember)->member.next),		\
> +	     &container_of(pos, type, posmember)->member != (head);		\

It seems a bit dodgy to do this pointer arithmetic on a list node which
might be the list head.

> +	     pos = list_entry(container_of(pos, type, posmember)->member.next,	\
> +	     type, member)->posmember)

My version:

#define list_for_each_struct_entry(pos, head, type, posmember, member)	     \
	for (pos = list_empty(head) ? NULL :				     \
		&list_first_entry(head, type, member)->posmember;	     \
	     prefetch(container_of(pos, type, posmember)->member.next), pos; \
	     pos = list_is_last(&container_of(pos, type, posmember)->member, \
				head) ?	NULL :				     \
		&list_entry(container_of(pos, type, posmember)->member.next, \
			    type, member)->posmember)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

