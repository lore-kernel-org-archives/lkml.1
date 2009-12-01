Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZLARwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZLARwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZLARwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:52:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61100 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZLARwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l1smhp+8A9mk6nCb6o+uhgDnNB7anh/J3OIvL58Ze/8n36hXm14ouzZLUH7zu0Mynh
         EvzcOIM8uKPMi9emNS0LJ6HXW0mbED+wQqzZ0nE+5b+I0RGdAXxsGqDGWeVlqm5uE2KX
         /XntQxeXTQOAagXeIBFm9gLRx4b7vYD5dRj+o=
Date: Tue, 1 Dec 2009 18:52:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] trace_syscalls: Simplify syscall profile
Message-ID: <20091201175221.GB5080@nowhere>
References: <4B14D2A1.8060304@cn.fujitsu.com> <tip-3bbe84e9d385205d638035ee9dcc4db1b486ea08@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-3bbe84e9d385205d638035ee9dcc4db1b486ea08@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 04:43:44PM +0000, tip-bot for Lai Jiangshan wrote:
> -int reg_prof_syscall_enter(char *name)
> +int prof_sysenter_enable(struct ftrace_event_call *call)
>  {
>  	int ret = 0;
>  	int num;
>  
> -	num = syscall_name_to_nr(name);
> -	if (num < 0 || num >= NR_syscalls)
> -		return -ENOSYS;
> +	num = ((struct syscall_metadata *)call->data)->syscall_nr;



Now that you use the above construct very often. Could you please
wrap it using a quick helper?

This will be more proper than having this explicit scary cast
everywhere :)

Thanks.


>  
>  	mutex_lock(&syscall_trace_lock);
>  	if (!sys_prof_refcount_enter)
> @@ -543,13 +541,11 @@ int reg_prof_syscall_enter(char *name)
>  	return ret;
>  }
>  
> -void unreg_prof_syscall_enter(char *name)
> +void prof_sysenter_disable(struct ftrace_event_call *call)
>  {
>  	int num;
>  
> -	num = syscall_name_to_nr(name);
> -	if (num < 0 || num >= NR_syscalls)
> -		return;
> +	num = ((struct syscall_metadata *)call->data)->syscall_nr;
>  
>  	mutex_lock(&syscall_trace_lock);
>  	sys_prof_refcount_enter--;
> @@ -625,14 +621,12 @@ end_recursion:
>  	local_irq_restore(flags);
>  }
>  
> -int reg_prof_syscall_exit(char *name)
> +int prof_sysexit_enable(struct ftrace_event_call *call)
>  {
>  	int ret = 0;
>  	int num;
>  
> -	num = syscall_name_to_nr(name);
> -	if (num < 0 || num >= NR_syscalls)
> -		return -ENOSYS;
> +	num = ((struct syscall_metadata *)call->data)->syscall_nr;
>  
>  	mutex_lock(&syscall_trace_lock);
>  	if (!sys_prof_refcount_exit)
> @@ -648,13 +642,11 @@ int reg_prof_syscall_exit(char *name)
>  	return ret;
>  }
>  
> -void unreg_prof_syscall_exit(char *name)
> +void prof_sysexit_disable(struct ftrace_event_call *call)
>  {
>  	int num;
>  
> -	num = syscall_name_to_nr(name);
> -	if (num < 0 || num >= NR_syscalls)
> -		return;
> +	num = ((struct syscall_metadata *)call->data)->syscall_nr;
>  
>  	mutex_lock(&syscall_trace_lock);
>  	sys_prof_refcount_exit--;

