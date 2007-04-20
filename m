Return-Path: <linux-kernel-owner+w=401wt.eu-S1767197AbXDTTWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767197AbXDTTWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767200AbXDTTWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:22:06 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:57548 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767197AbXDTTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:22:05 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 15:22:04 EDT
Subject: Fault Injection issues: stacktrace x86_64 and failslab NUMA
From: Scott Porter <scott@opengridcomputing.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 13:55:54 -0500
Message-Id: <1177095354.25165.48.camel@scott-desktop.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm attempting to use Fault Injection stacktrace filtering on an x86_64
platform (see config details below) and finding problems:

(1) Apparently stacktrace on x86_64 isn't always reliable but the fault
injection code path to save a stack trace looks *completely* unreliable

(2) CONFIG_NUMA and failslab don't mix -- the NUMA code successfully
allocates after the fault injection code thinks it has failed!

Details:

(1) When the fault injection code is saving a stack trace to compare
require-start/require-end addresses, it employs the following code in
arch/x86_64/kernel/traps.c where the task is the currently running
thread:

        if (!stack) {
                unsigned long dummy;
                stack = &dummy;
                if (tsk && tsk != current)
                        stack = (unsigned long *)tsk->thread.rsp;
        }

Can anyone explain how this code could possibly get a valid stack
pointer using "&dummy" on an automatic variable defined in the middle of
a routine that has arguments and other auto variables?  When I look at
the stack buffer that is saved it contains only entries for
"should_fail()" and so fail_stacktrace() NEVER matches on the start/end
addresses.

Prior to this patch:

  2006-09-26 Andi Kleen [PATCH] Merge stacktrace and show_trace

the save_stack_trace() routine would get the current thread stack
pointer this way:

-       if (!task || task == current) {
-               /* Grab rbp right from our regs: */
-               asm ("mov %%rbp, %0" : "=r" (stack));

Any pointers you can give to help me understand x86_64 stack frames
and/or how this code should work is appreciated!

I'd like to take advantage of the Fault Injection capabilities to debug
error paths in a driver but without reliable stacktrace it looks like
I'm left to invent my own kmalloc() error injection methods.  Anybody
know how to interpose (a la LD_PRELOAD) on exported kernel interfaces
like kmalloc() for a loadable kernel module?!  I'm thinking that Fault
Injection for failslab and fail-page-alloc provided as a separate
loadable module would be more appealing than having to add debug code
into the kernel anyways?

(2) The fault injection code in mm/slab.c within ____cache_alloc()
returns NULL when should_failslab() returns true.  HOWEVER, later code
in __cache_alloc() compiled in with NUMA_BUILD (via CONFIG_NUMA)
successfully allocates memory from another node and prevents the error
injection from really failing:

    if (!objp)
            objp = ____cache_alloc(cachep, flags);
    /*
     * We may just have run out of memory on the local node.
     * ____cache_alloc_node() knows how to locate memory on other nodes
     */
    if (NUMA_BUILD && !objp)
            objp = ____cache_alloc_node(cachep, flags, numa_node_id());

Not sure what the best way is to deal with this (other than turning off
CONFIG_NUMA!).

Config details:

2.6.20.1 x86_64
CONFIG_DEBUG_KERNEL=y
CONFIG_STACKTRACE=y
CONFIG_FRAME_POINTER=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_NUMA=y



