Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZCRAfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZCRAfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZCRAf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:35:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56498 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZCRAf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:35:28 -0400
Date: Tue, 17 Mar 2009 19:35:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: struct user_namespace::creator
Message-ID: <20090318003524.GA14054@us.ibm.com>
References: <20090317233417.GA6195@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317233417.GA6195@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> What is struct user_namespace::creator needed for?

It will be needed so that we can restrict the user namespace
to the privileges afforded its creators.  So if uid 500
creates a new user namespace, uid 0 in that user namespace
can be 'privileged' inside the user_namespace, but be
restricted so it can never do anything which uid 500 in the
parent namespace could not do.

> The scheme when struct user pins struct user_namespace which frees
> ->creator which is supposed to pind user_ns is really icky.
> 
> I tried this (inclomplete) patch and nothing bad happened so far
> with CLONE_NEWUSER:
> 
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -12,7 +12,6 @@
>  struct user_namespace {
>  	struct kref		kref;
>  	struct hlist_head	uidhash_table[UIDHASH_SZ];
> -	struct user_struct	*creator;
>  	struct work_struct	destroyer;
>  };
> 
> diff --git a/kernel/user.c b/kernel/user.c
> index fbb300e..1cecb8c 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -22,7 +22,6 @@ struct user_namespace init_user_ns = {
>  	.kref = {
>  		.refcount	= ATOMIC_INIT(1),
>  	},
> -	.creator = &root_user,
>  };
>  EXPORT_SYMBOL_GPL(init_user_ns);
> 
> @@ -48,9 +47,8 @@ static struct kmem_cache *uid_cachep;
>   */
>  static DEFINE_SPINLOCK(uidhash_lock);
> 
> -/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->creator */
>  struct user_struct root_user = {
> -	.__count	= ATOMIC_INIT(2),
> +	.__count	= ATOMIC_INIT(1),	/* init_cred */
>  	.processes	= ATOMIC_INIT(1),
>  	.files		= ATOMIC_INIT(0),
>  	.sigpending	= ATOMIC_INIT(0),
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -12,10 +12,6 @@
>  #include <linux/cred.h>
> 
>  /*
> - * Create a new user namespace, deriving the creator from the user in the
> - * passed credentials, and replacing that user with the new root user for the
> - * new namespace.
> - *
>   * This is called by copy_creds(), which will finish setting the target task's
>   * credentials.
>   */
> @@ -42,7 +38,6 @@ int create_user_ns(struct cred *new)
>  	}
> 
>  	/* set the new root user in the credentials under preparation */
> -	ns->creator = new->user;
>  	new->user = root_user;
>  	new->uid = new->euid = new->suid = new->fsuid = 0;
>  	new->gid = new->egid = new->sgid = new->fsgid = 0;
> @@ -69,7 +64,6 @@ static void free_user_ns_work(struct work_struct *work)
>  {
>  	struct user_namespace *ns =
>  		container_of(work, struct user_namespace, destroyer);
> -	free_uid(ns->creator);
>  	kfree(ns);
>  }
