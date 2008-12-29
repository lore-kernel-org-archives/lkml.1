Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYL2C2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYL2C2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 21:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYL2C2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 21:28:41 -0500
Received: from ozlabs.org ([203.10.76.45]:36386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYL2C2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 21:28:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH 7/8] cpumask: convert misc driver functions
Date: Mon, 29 Dec 2008 12:58:35 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Robert Richter <robert.richter@amd.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.672392000@polaris-admin.engr.sgi.com> <1229815359.2723.19.camel@hashbaz.i.decadent.org.uk>
In-Reply-To: <1229815359.2723.19.camel@hashbaz.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291258.36437.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 December 2008 09:52:39 Ben Hutchings wrote:
> I assume you're moving the allocation up to efx_probe_nic() because
> efx_wanted_rx_queues() and efx_probe_interrupts() cannot return failure.
> It really isn't worth exposing that detail up the call chain though.  I
> think it's acceptable for efx_wanted_rx_queues() to log an error message
> and return 1 in the exceedingly unlikely case that the allocation fails.

OK, fair call.  I was trying trying hard not to break anything.

How's this?

cpumask: convert drivers/net/sfc

Remove a cpumask from the stack.  Ben Hutchings indicated that printing
a warning and returning 1 was acceptable for the corner case where allocation
fails.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ben Hutchings <bhutchings@solarflare.com>

diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -854,20 +854,27 @@ static void efx_fini_io(struct efx_nic *
  * interrupts across them. */
 static int efx_wanted_rx_queues(void)
 {
-	cpumask_t core_mask;
+	cpumask_var_t core_mask;
 	int count;
 	int cpu;
 
-	cpus_clear(core_mask);
+	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
+		printk(KERN_WARNING
+		       "efx.c: allocation failure, irq balancing hobbled\n");
+		return 1;
+	}
+
+	cpumask_clear(core_mask);
 	count = 0;
 	for_each_online_cpu(cpu) {
-		if (!cpu_isset(cpu, core_mask)) {
+		if (!cpumask_test_cpu(cpu, core_mask)) {
 			++count;
-			cpumask_or(&core_mask, &core_mask,
+			cpumask_or(core_mask, core_mask,
 				   topology_core_cpumask(cpu));
 		}
 	}
 
+	free_cpumask_var(core_mask);
 	return count;
 }
 
