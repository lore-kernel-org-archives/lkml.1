Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZGKL3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZGKL3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGKL3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:29:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZGKL3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:29:06 -0400
Date: Sat, 11 Jul 2009 13:28:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com
Subject: -tip: ACPICA: Do not schedule during early init
Message-ID: <20090711112804.GA27200@elte.hu>
References: <20090710125755.559739294@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710125755.559739294@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Matt suggested, whereupon Linus sayeth:
> 
>  "This looks like a good patch. Please make it so"
> 
> Compile and boot tested on x86_64 only.

I wanted to wait with his for .32, but Linus applied it yesterday so 
lets hope it's all fine on all architectures ;-)

There's one new test failure on x86 caused by this commit: a 
scheduling-while-atomic assert during early ACPI init - fixed by the 
patch below. It triggers on two separate test-systems.

Btw., that ACPI_PREEMPTION_POINT() wrapper is both superfluous (we 
should not wrap something as obvious as a cond_resched()) and shows 
signs of problems:

#define ACPI_PREEMPTION_POINT() \
        do { \
                if (!irqs_disabled()) \
                        cond_resched(); \
        } while (0)

that should have been 1) an inline function 2) should not check for 
whether irqs are off. If we need to check for irqs-off like this 
then this is a sign that either the code flow is too unbalanced 
(mixing different things into the same function), or that the 
preemption point has been applied at a too low level.

So a followup cleanup would likely be in order, especially that this 
was the last (and only) call site of ACPI_PREEMPTION_POINT(). I'd 
suggest to remove it.

( I'm not sure what prompted the addition of this rescheduling point 
  - if there was a strong reason for it then we should probably add
  back the preemption point to the place that is causing the
  latency. )

	Ingo

-------------------->
>From 2b2b96115287177600c0158c95e87c5ab44f8379 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 11 Jul 2009 13:15:04 +0200
Subject: [PATCH] ACPICA: Do not schedule during early init

-tip testing found a test failure on x86, a scheduling-while-atomic
bug during early ACPI init:

[    0.048083] ACPI: Core revision 20090521
[    0.051854] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.052076] no locks held by swapper/0.
[    0.053000] Pid: 0, comm: swapper Not tainted 2.6.31-rc2-tip-01240-gd51b6ef-dirty #69901
[    0.053997] Call Trace:
[    0.055006]  [<ffffffff8107afe2>] __schedule_bug+0x80/0x9c
[    0.057001]  [<ffffffff81f1160a>] schedule+0xe6/0x5de
[    0.058000]  [<ffffffff8151531f>] ? acpi_os_release_object+0x1c/0x34
[    0.059002]  [<ffffffff8154d16c>] ? acpi_ut_exit+0x40/0x5c
[    0.060020]  [<ffffffff8107e1dc>] __cond_resched+0x37/0x69
[    0.060998]  [<ffffffff81f11d55>] _cond_resched+0x37/0x56
[    0.061999]  [<ffffffff81546748>] acpi_ps_complete_op+0x412/0x457
[    0.062998]  [<ffffffff8154588d>] ? acpi_ps_next_parse_state+0x14a/0x16b
[    0.064019]  [<ffffffff81546e87>] acpi_ps_parse_loop+0x47e/0x513
[    0.064998]  [<ffffffff81545418>] acpi_ps_parse_aml+0x177/0x4a2
[    0.065998]  [<ffffffff8154a83b>] ? acpi_get_table_by_index+0x138/0x159
[    0.066998]  [<ffffffff81543c0d>] acpi_ns_one_complete_parse+0x1d1/0x220
[    0.068019]  [<ffffffff81543cd7>] acpi_ns_parse_table+0x7b/0x148
[    0.068997]  [<ffffffff8154b229>] ? acpi_tb_allocate_owner_id+0x95/0xb4
[    0.069997]  [<ffffffff8153e62d>] acpi_ns_load_table+0xc5/0x1b8
[    0.070998]  [<ffffffff8288a140>] ? early_idt_handler+0x0/0x71
[    0.072018]  [<ffffffff8154aa03>] acpi_tb_load_namespace+0x9d/0x1ba
[    0.072996]  [<ffffffff8288a140>] ? early_idt_handler+0x0/0x71
[    0.073996]  [<ffffffff8154ab5a>] acpi_load_tables+0x3a/0x99
[    0.074997]  [<ffffffff828bef2e>] acpi_early_init+0x71/0x11a
[    0.076997]  [<ffffffff8288a140>] ? early_idt_handler+0x0/0x71
[    0.077996]  [<ffffffff8288b0eb>] start_kernel+0x39f/0x3c1
[    0.078995]  [<ffffffff8288a140>] ? early_idt_handler+0x0/0x71
[    0.080016]  [<ffffffff8288a140>] ? early_idt_handler+0x0/0x71
[    0.080995]  [<ffffffff8288a2ce>] x86_64_start_reservations+0xb9/0xd4
[    0.081995]  [<ffffffff8288a000>] ? __init_begin+0x0/0x140
[    0.082995]  [<ffffffff8288a3ed>] x86_64_start_kernel+0x104/0x127
[    0.088045] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.089999] no locks held by swapper/0.
[    0.090993] Pid: 0, comm: swapper Not tainted 2.6.31-rc2-tip-01240-gd51b6ef-dirty #69901

The problem is that drivers/acpi/acpica/psloop.c has this line:

        ACPI_PREEMPTION_POINT();

Which does not mix well with this early init stage - we have 
preemption disabled and the init task has not started up yet, so we 
really should not schedule.

Remove this explicit preemption point.

Cc: Len Brown <len.brown@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/acpica/psloop.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/psloop.c b/drivers/acpi/acpica/psloop.c
index c5f6ce1..28cd67a 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -720,8 +720,6 @@ acpi_ps_complete_op(struct acpi_walk_state *walk_state,
 		*op = NULL;
 	}
 
-	ACPI_PREEMPTION_POINT();
-
 	return_ACPI_STATUS(AE_OK);
 }
 
