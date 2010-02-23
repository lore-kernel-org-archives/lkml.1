Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0BWWcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:32:04 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0BWWcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:32:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=g1uQT3wFgQu7BJ2eiMwlp6bw6VKfVNzc5qQB0EI84Dsh6c9AZ0qfqwI8eTfNLVcGd
	kFVdE9SgDblVnTHibkIVQ==
Date: Tue, 23 Feb 2010 14:31:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <4B839E9D.8020604@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002231427190.8693@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <4B827043.3060305@cn.fujitsu.com>
 <alpine.DEB.2.00.1002221339160.14426@chino.kir.corp.google.com> <4B838490.1050908@cn.fujitsu.com> <alpine.DEB.2.00.1002230046160.12015@chino.kir.corp.google.com> <4B839E9D.8020604@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Miao Xie wrote:

> > Cpu hotplug sets top_cpuset's cpus_allowed to cpu_active_mask by default, 
> > regardless of what was onlined or offlined.  cpus_attach in the context of 
> > your patch (in cpuset_attach()) passes cpu_possible_mask to 
> > set_cpus_allowed_ptr() if the task is being attached to top_cpuset, my 
> > question was why don't we pass cpu_active_mask instead?  In other words, I 
> > think we should do
> > 
> > 	cpumask_copy(cpus_attach, cpu_active_mask);
> > 
> > when attached to top_cpuset like my patch did.
> 
> If we pass cpu_active_mask to set_cpus_allowed_ptr(), task->cpus_allowed just contains
> the online cpus. In this way, if we do cpu hotplug(such as: online some cpu), we must
> update cpus_allowed of all tasks in the top cpuset.
> 
> But if we pass cpu_possible_mask, we needn't update cpus_allowed of all tasks in the
> top cpuset. And when the kernel looks for a cpu for task to run, the kernel will use
> cpu_active_mask to filter out offline cpus in task->cpus_allowed. Thus, it is safe.
> 

That is terribly inconsistent between top_cpuset and all descendants; all 
other cpusets require that task->cpus_allowed be a subset of 
cpu_online_mask, including those descendants that allow all cpus (and all 
mems).
