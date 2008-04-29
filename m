Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYD2Ugk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYD2Ugk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYD2UgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:36:11 -0400
Received: from gw.goop.org ([64.81.55.164]:49859 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbYD2UgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:36:03 -0400
Message-ID: <481786A5.7010604@goop.org>
Date: Tue, 29 Apr 2008 13:35:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function
 calls
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1209453990-7735-3-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> -int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
> -			       void *info, int wait)
>   
[...]
> -	/* Send a message to other CPUs and wait for them to respond */
> -	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
> -
> -	/* Make sure other vcpus get a chance to run if they need to. */
> -	yield = false;
> -	for_each_cpu_mask(cpu, mask)
> -		if (xen_vcpu_stolen(cpu))
> -			yield = true;
> -
> -	if (yield)
> -		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
>   

I added this to deal with the case where you're sending an IPI to 
another VCPU which isn't currently running on a real cpu.  In this case 
you could end up spinning while the other VCPU is waiting for a real CPU 
to run on.  (Basically the same problem that spinlocks have in a virtual 
environment.)

However, this is at best a partial solution to the problem, and I never 
benchmarked if it really makes a difference.  Since any other virtual 
environment would have the same problem, its best if we can solve it 
generically.  (Of course a synchronous single-target cross-cpu call is a 
simple cross-cpu rpc, which could be implemented very efficiently in the 
host/hypervisor by simply doing a vcpu context switch...)

    J
