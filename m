Return-Path: <linux-kernel-owner+w=401wt.eu-S1030962AbXDRBYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030962AbXDRBYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXDRBYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:24:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030962AbXDRBYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:24:35 -0400
Subject: Re: [PATCH] sysctl_panic_on_oom broken
From: Larry Woodman <lwoodman@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
References: <462515CC.1080107@redhat.com>
	 <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 20:24:35 -0400
Message-Id: <1176855875.3959.7.camel@dhcp83-56.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-16) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 14:39 -0700, Christoph Lameter wrote:

> 
> It recreates the old problem that we OOM while we still have memory 
> in other parts of the system.

How, by the time we get here we have already decided we are going to
OOMkill or panic.  This change just obeys sysctl_panic_on_oom before
killing current.

-----------------------------------------------------------------------
        /* check if we are going to panic before enything else... */
        if (sysctl_panic_on_oom)
                panic("out of memory. panic_on_oom is selected\n");
        /*
         * Check if there were limitations on the allocation
         * NUMA) that may require different handling.
         */
        switch (constrained_alloc(zonelist, gfp_mask)) {
        case CONSTRAINT_MEMORY_POLICY:
                oom_kill_process(current, points,
                                "No available memory (MPOL_BIND)");
                break;

        case CONSTRAINT_CPUSET:
                oom_kill_process(current, points,
                                "No available memory in cpuset");
                break;

        case CONSTRAINT_NONE:
retry:
                /*
                 * Rambo mode: Shoot down a process and hope
                 * issues we may have.
                 */
                p = select_bad_process(&points);

                if (PTR_ERR(p) == -1UL)
                        goto out;

                /* Found nothing?!?! Either we hang or we panic. */


