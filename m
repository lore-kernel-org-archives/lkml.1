Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZBWUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZBWUe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZBWUeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:34:18 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47479 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZBWUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:34:18 -0500
Date: Mon, 23 Feb 2009 14:33:56 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix recursive lock in free_uid()/free_user_ns()
Message-ID: <20090223203356.GA30533@us.ibm.com>
References: <20090223125554.30814.79080.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223125554.30814.79080.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> free_uid() and free_user_ns() are corecursive when CONFIG_USER_SCHED=n, but
> free_user_ns() is called from free_uid() by way of uid_hash_remove(), which
> requires uidhash_lock to be held.  free_user_ns() then calls free_uid() to
> complete the destruction.
> 
> Fix this by deferring the destruction of the user_namespace.

Crap.  I think when I did this I looked at put_user_ns() I though it
was calling free_user_ns() through an rcu callback (mis-read kref_put).

> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks, David and Alexey.

-serge

> ---
> 
>  include/linux/user_namespace.h |    1 +
>  kernel/user_namespace.c        |   21 +++++++++++++++++----
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 315bcd3..cc4f453 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -13,6 +13,7 @@ struct user_namespace {
>  	struct kref		kref;
>  	struct hlist_head	uidhash_table[UIDHASH_SZ];
>  	struct user_struct	*creator;
> +	struct work_struct	destroyer;
>  };
> 
>  extern struct user_namespace init_user_ns;
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 7908431..076c7c8 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -60,12 +60,25 @@ int create_user_ns(struct cred *new)
>  	return 0;
>  }
> 
> -void free_user_ns(struct kref *kref)
> +/*
> + * Deferred destructor for a user namespace.  This is required because
> + * free_user_ns() may be called with uidhash_lock held, but we need to call
> + * back to free_uid() which will want to take the lock again.
> + */
> +static void free_user_ns_work(struct work_struct *work)
>  {
> -	struct user_namespace *ns;
> -
> -	ns = container_of(kref, struct user_namespace, kref);
> +	struct user_namespace *ns =
> +		container_of(work, struct user_namespace, destroyer);
>  	free_uid(ns->creator);
>  	kfree(ns);
>  }
> +
> +void free_user_ns(struct kref *kref)
> +{
> +	struct user_namespace *ns =
> +		container_of(kref, struct user_namespace, kref);
> +
> +	INIT_WORK(&ns->destroyer, free_user_ns_work);
> +	schedule_work(&ns->destroyer);
> +}
>  EXPORT_SYMBOL(free_user_ns);
