Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYCNVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYCNVC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYCNVCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:02:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478AbYCNVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:02:17 -0400
Date: Fri, 14 Mar 2008 14:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: ananth@in.ibm.com, jkenisto@us.ibm.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, prasanna@in.ibm.com, shaohua.li@intel.com,
       davem@davemloft.net, fche@redhat.com
Subject: Re: [PATCH -mm 1/5] list.h: add list_singleton
Message-Id: <20080314140007.a7b495d7.akpm@linux-foundation.org>
In-Reply-To: <47DAE2C4.2060303@redhat.com>
References: <47DAE2C4.2060303@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 16:40:36 -0400
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Add list_singleton to check a list has just one entry.
> 
> list_singleton is useful to check whether a list_head which
> have been temporarily allocated for listing objects can be
> released or not.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  include/linux/list.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: 2.6.25-rc5-mm1/include/linux/list.h
> ===================================================================
> --- 2.6.25-rc5-mm1.orig/include/linux/list.h
> +++ 2.6.25-rc5-mm1/include/linux/list.h
> @@ -211,6 +211,15 @@ static inline int list_empty_careful(con
>  	return (next == head) && (next == head->prev);
>  }
> 
> +/**
> + * list_singleton - tests whether a list has just one entry.
> + * @head: the list to test.
> + */
> +static inline int list_singleton(const struct list_head *head)
> +{
> +	return !list_empty(head) && (head->next == head->prev);
> +}
> +

This hurts my brain.

If your usage pattern is:

struct foo {
	...
	struct list_head bar_list;	/* A list of `struct bar's */
};

struct bar {
	struct list_head list;		/* Attached to foo.bar_list */
	...
};

then yes, list_singleton() makes sense.

But in other usage patterns it does not:

struct foo {
	struct bar *bar_list;
	...
};

struct bar {
	struct list_head list;		/* All the other bars go here */
	...
};

In the second case, emptiness is signified by foo.bar_list==NULL.  And in
this case, code which does

	if (foo->bar_list && list_singleton(&foo->bar_list->list))

will fail if there is a single item on the list!

The second usage pattern is uncommon and list_empty() also returns
misleading answers when list_heads are used this way.

So I guess we can proceed with your list_singleton(), but I'd just like to
flag this possible confusion, see what people think..

