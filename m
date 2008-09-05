Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYIEVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYIEVlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYIEVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:40:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54830 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751862AbYIEVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:40:21 -0400
Message-Id: <20080905214019.821172000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 05 Sep 2008 14:40:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] smp: reduce stack requirements for smp_call_function_mask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  * Cleanup cpumask_t usages in smp_call_function_mask function chain
    to prevent stack overflow problem when NR_CPUS=4096.

  * Reduce the number of passed cpumask_t variables in the following
    call chain for x86_64:

	smp_call_function_mask -->
	    arch_send_call_function_ipi->
		    smp_ops.send_call_func_ipi -->
			    genapic->send_IPI_mask

    Since the smp_call_function_mask() is an EXPORTED function, we
    cannot change it's calling interface for a patch to 2.6.27.

    The smp_ops.send_call_func_ipi interface is internal only and
    has two arch provided functions:

	arch/x86/kernel/smp.c:  .send_call_func_ipi = native_send_call_func_ipi
	arch/x86/xen/smp.c:     .send_call_func_ipi = xen_smp_send_call_function_ipi
	arch/x86/mach-voyager/voyager_smp.c:    (uses native_send_call_func_ipi)

    Therefore modifying the internal interface to use a cpumask_t pointer
    is straight-forward.

    The changes to genapic are much more extensive and are affected by the
    recent additions of the x2apic modes, so they will be done for 2.6.28 only.

Based on 2.6.27-rc5-git6.

Applies to linux-2.6.tip/master (with FUZZ).

Signed-off-by: Mike Travis <travis@sgi.com>
---

