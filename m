Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbXIXEAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbXIXEAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 00:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750731AbXIXEAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 00:00:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49689 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXIXEAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 00:00:35 -0400
Date: Sun, 23 Sep 2007 23:00:35 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc6-mm1 - make access to tasks nsproxy ligther (fix)
Message-ID: <20070924040035.GB27284@sergelap.austin.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F2324E.9020707@fr.ibm.com> <46F23681.2030400@openvz.org> <46F2396D.7090404@fr.ibm.com> <46F2A8F6.4080508@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F2A8F6.4080508@fr.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (clg@fr.ibm.com):
> Cedric Le Goater wrote:
> > Pavel Emelyanov wrote:
> >> Looks sane :)
> >>
> >> [snip]
> >>
> >>> Index: 2.6.23-rc6-mm1/kernel/exit.c
> >>> ===================================================================
> >>> --- 2.6.23-rc6-mm1.orig/kernel/exit.c
> >>> +++ 2.6.23-rc6-mm1/kernel/exit.c
> >>> @@ -408,6 +408,8 @@ void daemonize(const char *name, ...)
> >>>  	current->fs = fs;
> >>>  	atomic_inc(&fs->count);
> >>>  
> >>> +	if (current->nsproxy != init_task.nsproxy)
> >>> +		get_nsproxy(init_task.nsproxy);
> >>>  	switch_task_namespaces(current, init_task.nsproxy);
> >> shouldn't we make the switch under this if() as well?
> > 
> > right. we can probably simplify switch_task_namespaces() and remove :
> > 
> > 	if (ns == new)
> > 		return;
> > 
> > I'll cook a better one today.
> 
> So I removed this test in
> 
> * daemonize() bc it is already done 
> * sys_unshare() bc the nsproxy is always new one 
> * exit_task_namespaces() bc it is called with NULL and the
>   task will die right after that.
> 
> C.
> 
> 
> make-access-to-tasks-nsproxy-lighter.patch breaks unshare()
> 
> when called from unshare(), switch_task_namespaces() takes an 
> extra refcount on the nsproxy, leading to a memory leak of 
> nsproxy objects. 
> 
> Now the problem is that we still need that extra ref when called 
> from daemonize(). Here's an ugly fix for it.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>

Looks good.  Thanks for catching the leak.

Acked-by: Serge E. Hallyn <serue@us.ibm.com>

> Cc: Pavel Emelyanov <xemul@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Oleg Nesterov <oleg@tv-sign.ru>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> ---
>  include/linux/nsproxy.h |    5 +++++
>  kernel/exit.c           |    5 ++++-
>  kernel/nsproxy.c        |    9 ---------
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> Index: 2.6.23-rc6-mm1/kernel/nsproxy.c
> ===================================================================
> --- 2.6.23-rc6-mm1.orig/kernel/nsproxy.c
> +++ 2.6.23-rc6-mm1/kernel/nsproxy.c
> @@ -25,11 +25,6 @@ static struct kmem_cache *nsproxy_cachep
> 
>  struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
> 
> -static inline void get_nsproxy(struct nsproxy *ns)
> -{
> -	atomic_inc(&ns->count);
> -}
> -
>  /*
>   * creates a copy of "orig" with refcount 1.
>   */
> @@ -205,11 +200,7 @@ void switch_task_namespaces(struct task_
>  	might_sleep();
> 
>  	ns = p->nsproxy;
> -	if (ns == new)
> -		return;
> 
> -	if (new)
> -		get_nsproxy(new);
>  	rcu_assign_pointer(p->nsproxy, new);
> 
>  	if (ns && atomic_dec_and_test(&ns->count)) {
> Index: 2.6.23-rc6-mm1/kernel/exit.c
> ===================================================================
> --- 2.6.23-rc6-mm1.orig/kernel/exit.c
> +++ 2.6.23-rc6-mm1/kernel/exit.c
> @@ -408,7 +408,10 @@ void daemonize(const char *name, ...)
>  	current->fs = fs;
>  	atomic_inc(&fs->count);
> 
> -	switch_task_namespaces(current, init_task.nsproxy);
> +	if (current->nsproxy != init_task.nsproxy) {
> +		get_nsproxy(init_task.nsproxy);
> +		switch_task_namespaces(current, init_task.nsproxy);
> +	}
> 
>  	exit_files(current);
>  	current->files = init_task.files;
> Index: 2.6.23-rc6-mm1/include/linux/nsproxy.h
> ===================================================================
> --- 2.6.23-rc6-mm1.orig/include/linux/nsproxy.h
> +++ 2.6.23-rc6-mm1/include/linux/nsproxy.h
> @@ -77,6 +77,11 @@ static inline void put_nsproxy(struct ns
>  	}
>  }
> 
> +static inline void get_nsproxy(struct nsproxy *ns)
> +{
> +	atomic_inc(&ns->count);
> +}
> +
>  #ifdef CONFIG_CONTAINER_NS
>  int ns_container_clone(struct task_struct *tsk);
>  #else
