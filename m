Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYEHNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYEHNeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYEHNdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:33:54 -0400
Received: from gw.goop.org ([64.81.55.164]:45954 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbYEHNdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:33:53 -0400
Message-ID: <48230137.9090705@goop.org>
Date: Thu, 08 May 2008 14:33:43 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH/RFC] stop_machine: make stop_machine_run more virtualization
 friendly
References: <200805081520.38310.borntraeger@de.ibm.com>
In-Reply-To: <200805081520.38310.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> On kvm I have seen some rare hangs in stop_machine when I used more guest
> cpus than hosts cpus. e.g. 32 guest cpus on 1 host cpu triggered the
> hang quite often. I could also reproduce the problem on a 4 way z/VM host with 
> a 64 way guest.
>   

I think that's one of those "don't do that then" cases ;)

> It turned out that the guest was consuming all available cpus mostly for
> spinning on scheduler locks like rq->lock. This is expected as the threads are 
> calling yield all the time. 
> The problem is now, that the host scheduling decisings together with the guest 
> scheduling decisions and spinlocks not being fair managed to create an 
> interesting scenario similar to a live lock. (Sometimes the hang resolved 
> itself after some minutes)
>   

I think x86 (at least) is now using ticket locks, which is fair.  Which 
kernel are you seeing this problem on?

> Changing stop_machine to yield the cpu to the hypervisor when yielding inside 
> the guest fixed the problem for me. While I am not completely happy with this 
> patch, I think it causes no harm and it really improves the situation for me.
>
> I used cpu_relax for yielding to the hypervisor, does that work on all 
> architectures?
>   

On x86, cpu_relax is just a "pause" instruction ("rep;nop").  We don't 
hook it in paravirt_ops, and while VT/SVM can be used to fault into the 
hypervisor on this instruction, I don't know if kvm actually does so.  
Either way, it wouldn't work for VMI, Xen or lguest.

    J

> p.s.: If you want to reproduce the problem, cpu hotplug and kprobes use 
> stop_machine_run and both triggered the problem after some retries. 
>
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Rusty Russell <rusty@rustcorp.com.au>
>
> ---
>  kernel/stop_machine.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> Index: kvm/kernel/stop_machine.c
> ===================================================================
> --- kvm.orig/kernel/stop_machine.c
> +++ kvm/kernel/stop_machine.c
> @@ -62,8 +62,7 @@ static int stopmachine(void *cpu)
>  		 * help our sisters onto their CPUs. */
>  		if (!prepared && !irqs_disabled)
>  			yield();
> -		else
> -			cpu_relax();
> +		cpu_relax();
>  	}
>  
>  	/* Ack: we are exiting. */
> @@ -106,8 +105,10 @@ static int stop_machine(void)
>  	}
>  
>  	/* Wait for them all to come to life. */
> -	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads)
> +	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads) {
>  		yield();
> +		cpu_relax();
> +	}
>  
>  	/* If some failed, kill them all. */
>  	if (ret < 0) {
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>   

