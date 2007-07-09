Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbXGIUZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbXGIUZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGIUZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:25:42 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:7149 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbXGIUZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:25:42 -0400
Message-ID: <469299C5.1060402@fr.ibm.com>
Date: Mon, 09 Jul 2007 22:25:41 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 4/16] Change data structures for pid namespaces
References: <468DF6F7.1010906@openvz.org> <468DF7AC.10302@openvz.org>
In-Reply-To: <468DF7AC.10302@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> struct pid_namespace will have the kmem_cache to allocate
> the pids from, the parent, as they are hierarchical, and
> the level of nesting value.
> 
> struct pid will have a variable length array of pid_number-s
> one for each namespace this pid lives in. The level value
> shows the level of the namespace this pid lives in and thus -
> the number of elements in the numbers array.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> 
> ---
> 
>  include/linux/init_task.h     |    6 ++++++
>  include/linux/pid.h           |    9 +++++++++
>  include/linux/pid_namespace.h |    3 +++
>  kernel/pid.c                  |    3 ++-
>  4 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid.h linux-2.6.22-rc4-mm2-2/include/linux/pid.h
> --- linux-2.6.22-rc4-mm2.orig/include/linux/pid.h	2007-06-14 12:14:29.000000000 +0400
> +++ linux-2.6.22-rc4-mm2-2/include/linux/pid.h	2007-07-04 19:00:38.000000000 +0400
> @@ -40,6 +40,13 @@ enum pid_type
>   * processes.
>   */
> 
> +struct pid_number {
> +	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
> +	int nr;
> +	struct pid_namespace *ns;
> +	struct hlist_node pid_chain;
> +};
> +
>  struct pid
>  {
>  	atomic_t count;
> @@ -40,6 +40,8 @@ enum pid_type
>  	/* lists of tasks that use this pid */
>  	struct hlist_head tasks[PIDTYPE_MAX];
>  	struct rcu_head rcu;
> +	int level;
> +	struct pid_number numbers[1];
>  };
> 
>  extern struct pid init_struct_pid;
> diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid_namespace.h linux-2.6.22-rc4-mm2-2/include/linux/pid_namespace.h
> --- linux-2.6.22-rc4-mm2.orig/include/linux/pid_namespace.h	2007-06-14 12:14:29.000000000 +0400
> +++ linux-2.6.22-rc4-mm2-2/include/linux/pid_namespace.h	2007-07-04 19:00:39.000000000 +0400
> @@ -16,7 +15,10 @@ struct pidmap {
>  	struct kref kref;
>  	struct pidmap pidmap[PIDMAP_ENTRIES];
>  	int last_pid;
> +	int level;
>  	struct task_struct *child_reaper;
> +	struct kmem_cache *pid_cachep;

so, that looks like a good idea to have the cache in the pidmap. could you 
push that independently to see how it all fits together ?

thanks,

C.
