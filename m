Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZDOPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZDOPJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbZDOPJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:09:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbZDOPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:09:02 -0400
Date: Wed, 15 Apr 2009 08:05:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>, Ali Gholami Rudi <ali@rudi.ir>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090415054417.GA5272@elte.hu>
Message-ID: <alpine.LFD.2.00.0904150755170.4132@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Ingo Molnar wrote:
> 
> fuller log below. I think this is because smp_call_function_many() 
> was essentially unused before - an IPI function should not trigger 
> this warning, it will naturally be called in preemptible context. 

Yeah, that thing is buggy. It just does "this_cpu = smp_processor_id()". 

But I have to admit that the breakage is documented. Both the "other 
CPU's" part _and_ the "preemption must be disabled when calling".

So it's not a bug, it's a "feature". 

Which is obviously not to say that the thing isn't complete crap.

This patch should fix it - not by fixing smp_call_function_many(), but by 
just living with the breakage. Andrew already sent out a patch that just 
avoided the function entirely, but at least some systems are likely to be 
able to do one single broadcast IPI with this, so it's at least in theory 
still better to use that smp_call_function_many() function, even though it 
has braindamaged semantics.

		Linus

---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 837c2c4..ecdb682 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -204,7 +204,13 @@ static void drv_read(struct drv_cmd *cmd)
 
 static void drv_write(struct drv_cmd *cmd)
 {
+	int this_cpu;
+
+	this_cpu = get_cpu();
+	if (cpumask_test_cpu(this_cpu, cmd->mask))
+		do_drv_write(cmd);
 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
+	put_cpu();
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
