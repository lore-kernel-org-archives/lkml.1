Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYD3Lf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYD3Lf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbYD3Lfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:35:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5297 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668AbYD3Lfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:35:46 -0400
Date: Wed, 30 Apr 2008 13:35:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function  calls
Message-ID: <20080430113542.GZ12774@kernel.dk>
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-3-git-send-email-jens.axboe@oracle.com> <481786A5.7010604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481786A5.7010604@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> >-int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
> >-			       void *info, int wait)
> >  
> [...]
> >-	/* Send a message to other CPUs and wait for them to respond */
> >-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
> >-
> >-	/* Make sure other vcpus get a chance to run if they need to. */
> >-	yield = false;
> >-	for_each_cpu_mask(cpu, mask)
> >-		if (xen_vcpu_stolen(cpu))
> >-			yield = true;
> >-
> >-	if (yield)
> >-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
> >  
> 
> I added this to deal with the case where you're sending an IPI to 
> another VCPU which isn't currently running on a real cpu.  In this case 
> you could end up spinning while the other VCPU is waiting for a real CPU 
> to run on.  (Basically the same problem that spinlocks have in a virtual 
> environment.)
> 
> However, this is at best a partial solution to the problem, and I never 
> benchmarked if it really makes a difference.  Since any other virtual 
> environment would have the same problem, its best if we can solve it 
> generically.  (Of course a synchronous single-target cross-cpu call is a 
> simple cross-cpu rpc, which could be implemented very efficiently in the 
> host/hypervisor by simply doing a vcpu context switch...)

So, what would your advice be? Seems safe enough to ignore for now and
attack it if it becomes a real problem.

-- 
Jens Axboe

