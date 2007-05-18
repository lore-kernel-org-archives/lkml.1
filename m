Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXEREbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXEREbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 00:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbXEREa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 00:30:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:37145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbXEREa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 00:30:57 -0400
From: Andi Kleen <ak@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch] fix oprofile SMP ...
Date: Fri, 18 May 2007 06:30:12 +0200
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@redhat.com>
References: <Pine.LNX.4.64.0705171911290.5172@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705171911290.5172@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705180630.12319.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007 04:18, Davide Libenzi wrote:
> This fixed oprofile being broken on x86-64 SMP. The current reservation
> runs on all CPUs, but the ones following the first, will fail since the
> reservation bitmap has an 1 in the MSR entry.
> The reservation code should really run once, and their addresses used on
> other CPUs. There are other solutions to this, but this is the simplest
> and shorter one that came in my mind. Tested in my dual Opteron 252, and
> working fine here.
> Andi, if you don't like both Ben and my patch, would you mind fixing
> oprofile yourself in some way?

Thanks, but I already did a very similar patch myself

-Andi

i386: Fix K8/core2 oprofile on multiple CPUs

Only try to allocate MSRs once instead of for every CPU.

This assumes the MSRs are the same on all CPUs which is currently
true. P4-HT is a special case for different SMT threads, but the code 
always saves/restores all MSRs so it works identical.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/oprofile/nmi_int.c
===================================================================
--- linux.orig/arch/i386/oprofile/nmi_int.c
+++ linux/arch/i386/oprofile/nmi_int.c
@@ -131,7 +131,6 @@ static void nmi_save_registers(void * du
 {
 	int cpu = smp_processor_id();
 	struct op_msrs * msrs = &cpu_msrs[cpu];
-	model->fill_in_addresses(msrs);
 	nmi_cpu_save_registers(msrs);
 }
 
@@ -195,6 +194,7 @@ static struct notifier_block profile_exc
 static int nmi_setup(void)
 {
 	int err=0;
+	int cpu;
 
 	if (!allocate_msrs())
 		return -ENOMEM;
@@ -207,6 +207,13 @@ static int nmi_setup(void)
 	/* We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
 	 */
+
+	/* Assume saved/restored counters are the same on all CPUs */
+	model->fill_in_addresses(&cpu_msrs[0]);
+	for_each_possible_cpu (cpu) {
+		if (cpu != 0)
+			cpu_msrs[cpu] = cpu_msrs[0];
+	}
 	on_each_cpu(nmi_save_registers, NULL, 0, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
 	nmi_enabled = 1;
