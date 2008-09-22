Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYIVK3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYIVK3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIVK3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:29:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYIVK3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:29:00 -0400
Date: Mon, 22 Sep 2008 12:28:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: robert.richter@amd.com, akpm@linux-foundation.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] oprofile: BUG: using smp_processor_id() in
	preemptible code
Message-ID: <20080922102834.GA32692@elte.hu>
References: <1221908320-7183-1-git-send-email-righi.andrea@gmail.com> <20080922102524.GB30137@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922102524.GB30137@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > +	local_irq_save(flags);
> >  	__get_cpu_var(switch_index) = 0;
> > +	local_irq_restore(flags);
> 
> either use __raw_get_cpu_var() if we are for sure not preemptible 
> here, or fix the preemption status of this codepath.

i've applied the patch below instead to tip/oprofile - agreed?

	Ingo

------------>
>From 45f197ade73ba95681b9803680c75352fc0a1c0a Mon Sep 17 00:00:00 2001
From: Andrea Righi <righi.andrea@gmail.com>
Date: Sat, 20 Sep 2008 12:58:40 +0200
Subject: [PATCH] x86, oprofile: BUG: using smp_processor_id() in preemptible code

Add __raw access before setting per cpu variable switch_index, to avoid
the following BUG:

[  449.166827] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/6998
[  449.166848] caller is op_nmi_init+0xf0/0x2b0 [oprofile]
[  449.166855] Pid: 6998, comm: modprobe Not tainted 2.6.27-rc5-mm1 #29
[  449.166860] Call Trace:
[  449.166872]  [<ffffffff80362d67>] debug_smp_processor_id+0xd7/0xe0
[  449.166887]  [<ffffffffa00181c0>] op_nmi_init+0xf0/0x2b0 [oprofile]
[  449.166902]  [<ffffffffa0018000>] oprofile_init+0x0/0x60 [oprofile]
[  449.166915]  [<ffffffffa00180a9>] oprofile_arch_init+0x9/0x30 [oprofile]
[  449.166928]  [<ffffffffa001801e>] oprofile_init+0x1e/0x60 [oprofile]
[  449.166937]  [<ffffffff8020903b>] _stext+0x3b/0x160
[  449.166946]  [<ffffffff80477985>] __mutex_unlock_slowpath+0xe5/0x190
[  449.166955]  [<ffffffff80262c1a>] trace_hardirqs_on_caller+0xca/0x140
[  449.166965]  [<ffffffff8026f7fc>] sys_init_module+0xdc/0x210
[  449.166972]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Acked-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/oprofile/nmi_int.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index fb4902b..4108d02 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -551,7 +551,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	}
 
 	/* default values, can be overwritten by model */
-	__get_cpu_var(switch_index) = 0;
+	__raw_get_cpu_var(switch_index) = 0;
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
 	ops->shutdown = nmi_shutdown;
