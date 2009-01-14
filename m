Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZANBQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZANBQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZANBQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:16:09 -0500
Received: from ozlabs.org ([203.10.76.45]:37000 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZANBQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:16:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not boot
Date: Wed, 14 Jan 2009 11:46:03 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Dieter Ries <clip2@gmx.de>,
       travis@sgi.com, linux-kernel@vger.kernel.org
References: <496A085E.8020604@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu>
In-Reply-To: <20090112112608.GB19388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141146.04563.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009 21:56:08 Ingo Molnar wrote:
> work_on_cpu() needs to be reworked to be more generally usable.

Yes, but how?  If we don't take the hotplug lock, we are relying on the
callers to "prove" the cpu can't go away.  But we've already shown that
we can't find this by inspection :(

> The commit introduces work_on_cpu() use into the cpufreq code,
> but that is subtly problematic from a lock hierarchy POV: the
> hotplug-cpu lock is an highlevel lock that is taken before
> lowlevel locks, and in this codepath we are called with the
> policy lock taken.

The easiest thing to do in this case is to use smp_call_function_single(),
since the thing we want to do is just rdmsr and wrmsr.

How about this instead of reverting?
Rusty.

fix: use smp_call_function_single() not work_on_cpu in acpi-cpufreq.c

get_measured_perf() gets called through twisty chains, and
work_on_cpu() has issues being called here as it takes the cpu hotplug
lock.

So we just use smp_call_function_single() which should work fine for
this case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -255,7 +255,7 @@ struct perf_cur {
 };
 
 
-static long read_measured_perf_ctrs(void *_cur)
+static void read_measured_perf_ctrs(void *_cur)
 {
 	struct perf_cur *cur = _cur;
 
@@ -264,8 +264,6 @@ static long read_measured_perf_ctrs(void
 
 	wrmsr(MSR_IA32_APERF, 0, 0);
 	wrmsr(MSR_IA32_MPERF, 0, 0);
-
-	return 0;
 }
 
 /*
@@ -288,7 +286,7 @@ static unsigned int get_measured_perf(st
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &cur))
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &cur, 1))
 		return 0;
 
 #ifdef __i386__
