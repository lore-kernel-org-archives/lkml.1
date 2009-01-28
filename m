Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZA1ASM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZA1ASM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZA1ARz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:17:55 -0500
Received: from relay3.sgi.com ([192.48.171.31]:35013 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769AbZA1ARy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:17:54 -0500
To: tj@kernel.org
Subject: Re: [PATCH 07/10] x86: uv cleanup
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LRy9o-0005WD-7N@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 27 Jan 2009 18:19:52 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Tejun,

I appreciate your consolidation and cleanup of the UV code, relative
to 32 vs 64.

I have a question about the addition of the
        WARN_ON(!in_atomic());
in uv_flush_tlb_others().
The patch is
http://marc.info/?l=linux-kernel&m=123252788121855&w=2

I expect this function to always entered preemptable.  
Could you explain a bit about your thought behind this WARN_ON?

Thanks.
-Cliff




const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
                                          struct mm_struct *mm,
                                          unsigned long va, unsigned int cpu)
{
        static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
        struct cpumask *flush_mask = &__get_cpu_var(flush_tlb_mask);
        int i;
        int bit;
        int blade;
        int uv_cpu;
        int this_blade;
        int locals = 0;
        struct bau_desc *bau_desc;

        WARN_ON(!in_atomic());

        cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));

        uv_cpu = uv_blade_processor_id();
        this_blade = uv_numa_blade_id();

