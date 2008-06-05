Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYFEUaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYFEUaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYFEU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:29:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48247 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752348AbYFEU34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:29:56 -0400
Date: Thu, 5 Jun 2008 15:29:53 -0500
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, peterz@infradead.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing
 cpus_allowed
Message-Id: <20080605152953.dcfefa47.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of questions on this:

 1) Sometimes threads are bound to a set of CPUs, such as the CPUs
    on a particular node:

	drivers/pci/pci-driver.c:       set_cpus_allowed_ptr(current, nodecpumask);
	net/sunrpc/svc.c:               set_cpus_allowed_ptr(current, nodecpumask);

    Such cases can't invoke kthread_bind(), as that only binds to a single CPU.
    I only see one place in your patch that sets PF_THREAD_BOUND; would it make
    sense for such multi-CPU binds as above to be PF_THREAD_BOUND as well?

 2) Sometimes calls to kthread_bind are binding to any online cpu, such as in:

	drivers/infiniband/hw/ehca/ehca_irq.c:	kthread_bind(cct->task, any_online_cpu(cpu_online_map));

    In such cases, the PF_THREAD_BOUND seems inappropriate.  The caller of
    kthread_bind() really doesn't seem to care where that thread is bound;
    they just want it on a CPU that is still online.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
