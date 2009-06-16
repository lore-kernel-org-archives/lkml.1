Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbZFPTTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbZFPTTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZFPTTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:19:25 -0400
Received: from verein.lst.de ([213.95.11.210]:37634 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZFPTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:19:25 -0400
Date: Tue, 16 Jun 2009 21:18:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup find_task_by_pid variants
Message-ID: <20090616191832.GA23048@lst.de>
References: <20090514165750.GA15934@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514165750.GA15934@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anyone going to pick this up?

On Thu, May 14, 2009 at 06:57:50PM +0200, Christoph Hellwig wrote:
> 
> find_task_by_pid_type_ns is only used to implement find_task_by_vpid and
> find_task_by_pid_ns, but both of them pass PIDTYPE_PID as first argument.
> So just fold find_task_by_pid_type_ns into find_task_by_pid_ns and use
> find_task_by_pid_ns to implement find_task_by_vpid.
> 
> While we're at it also remove the exports for find_task_by_pid_ns and
> find_task_by_vpid - we don't have any modular callers left as the only
> modular caller of he old pre pid namespace find_task_by_pid (gfs2)
> was switched to pid_task which operates on a struct pid pointer instead
> of a pid_t.  Given the confusion about pid_t values vs namespace that's
> generally the better option anyway and I think we're better of restricting
> modules to do it that way.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h	2009-05-13 20:16:59.469784235 +0200
> +++ linux-2.6/include/linux/sched.h	2009-05-13 20:17:11.410661577 +0200
> @@ -1837,9 +1837,6 @@ extern struct pid_namespace init_pid_ns;
>  /*
>   * find a task by one of its numerical ids
>   *
> - * find_task_by_pid_type_ns():
> - *      it is the most generic call - it finds a task by all id,
> - *      type and namespace specified
>   * find_task_by_pid_ns():
>   *      finds a task by its pid in the specified namespace
>   * find_task_by_vpid():
> @@ -1848,9 +1845,6 @@ extern struct pid_namespace init_pid_ns;
>   * see also find_vpid() etc in include/linux/pid.h
>   */
>  
> -extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
> -		struct pid_namespace *ns);
> -
>  extern struct task_struct *find_task_by_vpid(pid_t nr);
>  extern struct task_struct *find_task_by_pid_ns(pid_t nr,
>  		struct pid_namespace *ns);
> Index: linux-2.6/kernel/pid.c
> ===================================================================
> --- linux-2.6.orig/kernel/pid.c	2009-05-13 20:16:59.487810414 +0200
> +++ linux-2.6/kernel/pid.c	2009-05-13 20:21:47.987661606 +0200
> @@ -378,26 +378,15 @@ EXPORT_SYMBOL(pid_task);
>  /*
>   * Must be called under rcu_read_lock() or with tasklist_lock read-held.
>   */
> -struct task_struct *find_task_by_pid_type_ns(int type, int nr,
> -		struct pid_namespace *ns)
> +struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
>  {
> -	return pid_task(find_pid_ns(nr, ns), type);
> +	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
>  }
>  
> -EXPORT_SYMBOL(find_task_by_pid_type_ns);
> -
>  struct task_struct *find_task_by_vpid(pid_t vnr)
>  {
> -	return find_task_by_pid_type_ns(PIDTYPE_PID, vnr,
> -			current->nsproxy->pid_ns);
> -}
> -EXPORT_SYMBOL(find_task_by_vpid);
> -
> -struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
> -{
> -	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, ns);
> +	return find_task_by_pid_ns(vnr, current->nsproxy->pid_ns);
>  }
> -EXPORT_SYMBOL(find_task_by_pid_ns);
>  
>  struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
>  {
---end quoted text---
