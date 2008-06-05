Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYFEVM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYFEVM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYFEVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:12:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYFEVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:12:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=RrAQAg9qnPIS65q6Zwk1/KMqWVHgbBJSdDvNrv6qt0GflSOqH4/He1a9B+c8RNRHL
	780lOvJYhLgEDpd/iChMw==
Date: Thu, 5 Jun 2008 14:12:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: mingo@elte.hu, peterz@infradead.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing
 cpus_allowed
In-Reply-To: <20080605152953.dcfefa47.pj@sgi.com>
Message-ID: <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Paul Jackson wrote:

> A couple of questions on this:
> 
>  1) Sometimes threads are bound to a set of CPUs, such as the CPUs
>     on a particular node:
> 
> 	drivers/pci/pci-driver.c:       set_cpus_allowed_ptr(current, nodecpumask);
> 	net/sunrpc/svc.c:               set_cpus_allowed_ptr(current, nodecpumask);
> 
>     Such cases can't invoke kthread_bind(), as that only binds to a single CPU.
>     I only see one place in your patch that sets PF_THREAD_BOUND; would it make
>     sense for such multi-CPU binds as above to be PF_THREAD_BOUND as well?
> 

Not in the drivers/pci/pci-driver.c case because the setting of 
cpus_allowed to nodecpumask is only temporary (as is the disabling of the 
mempolicy).  It's just done for the probe callback and then reset to the 
old cpumask.  So any migration here would be lost.

I can't speculate about the net/sunrpc/svc.c case because I don't know if 
user migration is harmful or discouraged.  The behavior with my patch is 
the same for any calls to set_cpus_allowed_ptr() for tasks that haven't 
called kthread_bind(), so I'll leave that decision up to those who know 
best for this networking code.

>  2) Sometimes calls to kthread_bind are binding to any online cpu, such as in:
> 
> 	drivers/infiniband/hw/ehca/ehca_irq.c:	kthread_bind(cct->task, any_online_cpu(cpu_online_map));
> 
>     In such cases, the PF_THREAD_BOUND seems inappropriate.  The caller of
>     kthread_bind() really doesn't seem to care where that thread is bound;
>     they just want it on a CPU that is still online.
> 

This particular case is simply moving the thread to any online cpu so that 
it survives long enough for the subsequent kthread_stop() in 
destroy_comp_task().  So I don't see a problem with this instance.

A caller to kthread_bind() can always remove PF_THREAD_BOUND itself upon 
return, but I haven't found any cases in the tree where that is currently 
necessary.  And doing that would defeat the semantics of kthread_bind() 
where these threads are supposed to be bound to a specific cpu and not 
allowed to run on others.

		David
