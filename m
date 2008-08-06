Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYHFShh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYHFShh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYHFShX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:37:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55154 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbYHFShW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:37:22 -0400
Message-ID: <23052053.1218047754579.JavaMail.oracle@acsmt304.oracle.com>
Date: Wed, 6 Aug 2008 13:35:54 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?Jochen_Vo=DF?= <jochen.voss@googlemail.com>,
       "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Subject: Re: [PATCH 2/4] list.h: add list_cut_position()
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080806182724.GI5605@tesla>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <1217890089-12100-1-git-send-email-lrodriguez@atheros.com> <20080804160011.ec964f1f.randy.dunlap@oracle.com> <20080804231320.GG6447@tesla> <ef1cd66f0808050152g1dd8b96cl2df820607d480f0f@mail.gmail.com> <20080806182724.GI5605@tesla>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds list_cut_position() which lets you cut a list into
> two lists given a pivot in the list.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 453916b..6c02a83 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -214,6 +214,46 @@ static inline int list_is_singular(const
> struct list_head *head)
>  	return !list_empty(head) && (head->next == head->prev);
>  }
>  
> +static inline void __list_cut_position(struct list_head *list,
> +		struct list_head *head, struct list_head *entry)
> +{
> +	struct list_head *new_first = entry->next;
> +	list->next = head->next;
> +	list->next->prev = list;
> +	list->prev = entry;
> +	entry->next = list;
> +	head->next = new_first;
> +	new_first->prev = head;
> +}
> +
> +/**
> + * list_cut_position - cut a list into two
> + *
> + * This helper moves the initial part of @head, up to and
> + * including @entry, from @head to @list. You should
> + * pass on @entry an element you know is on @head. @list
> + * should be an empty list or a list you do not care about
> + * losing its data.
> + *
> + * @list: a new list to add all removed entries
> + * @head: a list with entries
> + * @entry: an entry within head, could be the head itself
> + *	and if so we won't cut the list
> + */

For kernel-doc notation, the parameters need to follow the function name+short description.
After that, a longer description can be added.  I.e., please move the parameters up to
above the longer description...

> +static inline void list_cut_position(struct list_head *list,
> +		struct list_head *head, struct list_head *entry)
> +{
> +	if (list_empty(head))
> +		return;
> +	if (list_is_singular(head) &&
> +		(head->next != entry && head != entry))
> +		return;
> +	if (entry == head)
> +		INIT_LIST_HEAD(list);
> +	else
> +		__list_cut_position(list, head, entry);
> +}
> +
>  static inline void __list_splice(const struct list_head *list,
>  				 struct list_head *head)
>  {

