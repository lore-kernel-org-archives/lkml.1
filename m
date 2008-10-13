Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYJMVwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYJMVwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbYJMVwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:52:18 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:62717 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbYJMVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:52:17 -0400
Message-Id: <20081013215007.634620563@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 23:50:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au
Cc: jens.axboe@oracle.com, mingo@elte.hu, akpm@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC v2 0/6] Convert stop_machine to use a workqueue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2: This is version 2 which converts stop_machine to a workqueue based
           implementation as suggested by Rusty instead of trying to extend
           the current kernel thread approach.

This patch series would allow to convert s390 to the generic IPI interface.
We can't to that currently since our etr/stp code relies on the old semantics
of smp_call_function that guarantee that the function only returns after all
receiving cpus have acknowledged the IPI. That way it is known that all other
cpus are running in an interrupt handler with interrupts disabled.
This is not true anymore with the generic IPI infrastructure.

So one idea was to use stop_machine in order to synchronize all cpus. Rusty
was kind enough to extend it so that it is now possible to run a function
on several cpus, instead of just one.
However we need to be able to do that without allocating any memory. That's
what this patch set is about: it changes the current stop_machine code to
use a workqueue instead of kernel threads to synchronize all cpus.
This has the advantage that all per cpu workqueue threads are already running
when stop_machine gets called and therefore no memory needs to be allocated.
In addition stop_machine cant't fail anymore (free_module() relies on that).

A few things that need to be addressed:
- stop_machine gets called from initcalls, so we need to make sure that it
  is already initialized and has its workqueue started before that. For that
  a pre_smp initcall (early_initcall) is used to initialize it.
- the stop_machine kernel threads used to be rt kernel threads. Workqueues
  are normal threads. To get high priority threads a new interface
  create_rt_workqueue is introduced.

Patch 1 Moves the call to init_workqueue before pre smp initcalls
Patch 2 introduces create_rt_workqueue
Patch 3 converts stop_machine to use an rt workqueue
Patch 4 adds special case handling for num_online_cpus == 1 to stop_machine
        - Patch 4 is only needed if there would be a stop_machine call before
          the pre smp initcalls have been executed. As far as I can see there
          is currently none.
Patch 5 converts the s390 etr and stp code to use stop_machine
Patch 6 converts s390 to the generic IPI interface

Thanks,
Heiko
