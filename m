Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbYD3Mbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbYD3Mbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYD3Mbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:31:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19371 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYD3Mbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:31:42 -0400
Date: Wed, 30 Apr 2008 14:31:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function calls
Message-ID: <20080430123136.GB12774@kernel.dk>
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-3-git-send-email-jens.axboe@oracle.com> <481786A5.7010604@goop.org> <20080430113542.GZ12774@kernel.dk> <20080430122001.GS11126@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430122001.GS11126@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30 2008, Paul E. McKenney wrote:
> On Wed, Apr 30, 2008 at 01:35:42PM +0200, Jens Axboe wrote:
> > On Tue, Apr 29 2008, Jeremy Fitzhardinge wrote:
> > > Jens Axboe wrote:
> > > >-int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
> > > >-			       void *info, int wait)
> > > >  
> > > [...]
> > > >-	/* Send a message to other CPUs and wait for them to respond */
> > > >-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
> > > >-
> > > >-	/* Make sure other vcpus get a chance to run if they need to. */
> > > >-	yield = false;
> > > >-	for_each_cpu_mask(cpu, mask)
> > > >-		if (xen_vcpu_stolen(cpu))
> > > >-			yield = true;
> > > >-
> > > >-	if (yield)
> > > >-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
> > > >  
> > > 
> > > I added this to deal with the case where you're sending an IPI to 
> > > another VCPU which isn't currently running on a real cpu.  In this case 
> > > you could end up spinning while the other VCPU is waiting for a real CPU 
> > > to run on.  (Basically the same problem that spinlocks have in a virtual 
> > > environment.)
> > > 
> > > However, this is at best a partial solution to the problem, and I never 
> > > benchmarked if it really makes a difference.  Since any other virtual 
> > > environment would have the same problem, its best if we can solve it 
> > > generically.  (Of course a synchronous single-target cross-cpu call is a 
> > > simple cross-cpu rpc, which could be implemented very efficiently in the 
> > > host/hypervisor by simply doing a vcpu context switch...)
> > 
> > So, what would your advice be? Seems safe enough to ignore for now and
> > attack it if it becomes a real problem.
> 
> How about an arch-specific function/macro invoked in the spin loop?
> The generic implementation would do nothing, but things like Xen
> could implement as above.

Xen could just stuff that bit into its arch_send_call_function_ipi(),
something like the below should be fine. My question to Jeremy was more
of the order of whether it should be kept or not, I guess it's safer to
just keep it and retain the existing behaviour (and let Jeremy/others
evaluate it at will later on). Note that I got rid of the yield bool and
break when we called the hypervisor.

Jeremy, shall I add this?

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 2dfe093..064e6dc 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -352,7 +352,17 @@ static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 
 void xen_smp_send_call_function_ipi(cpumask_t mask)
 {
+	int cpu;
+
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+
+	/* Make sure other vcpus get a chance to run if they need to. */
+	for_each_cpu_mask(cpu, mask) {
+		if (xen_vcpu_stolen(cpu)) {
+			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+			break;
+		}
+	}
 }
 
 void xen_smp_send_call_function_single_ipi(int cpu)

-- 
Jens Axboe

