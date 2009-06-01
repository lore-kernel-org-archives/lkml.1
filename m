Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZFAQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZFAQaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZFAQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:30:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41764 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZFAQaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:30:09 -0400
Date: Mon, 1 Jun 2009 12:29:55 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: fishy code in arch/x86/kernel/tsc.c:time_cpufreq_notifier()
Message-ID: <20090601162955.GA15237@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20090601142104.GA15907@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601142104.GA15907@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 10:21:04AM -0400, Christoph Hellwig wrote:
 > Just notice the following error from gcc 4.4:
 > 
 > arch/x86/kernel/tsc.c: In function 'time_cpufreq_notifier':
 > arch/x86/kernel/tsc.c:634: warning: 'dummy' may be used uninitialized in this function
 > 
 > where we do have CONFIG_SMP set, freq->flags & CPUFREQ_CONST_LOOPS is
 > true and ref_freq is false.
 > 
 > Can that case actually happen?
 
I think you're right, though the circumstances for hitting it are really
low. Nearly all SMP capable cpufreq drivers set CPUFREQ_CONST_LOOPS.
powernow-k8 is really the only exception. The older CPUs were typically
only ever UP. (powernow-k7 never supported SMP for eg)

It's probably worth fixing.

I think the patch below is closer to the actual intent, with the bonus
of being a lot more readable.

Sanity check?

	Dave

Fix possible uninitialized use of dummy, by just removing it,
and making the setting of lpj more obvious.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d57de05..78c54ea 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -631,17 +631,15 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				void *data)
 {
 	struct cpufreq_freqs *freq = data;
-	unsigned long *lpj, dummy;
+	unsigned long *lpj;
 
 	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
 		return 0;
 
-	lpj = &dummy;
-	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
+	lpj = &boot_cpu_data.loops_per_jiffy;
 #ifdef CONFIG_SMP
+	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
 		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
-#else
-	lpj = &boot_cpu_data.loops_per_jiffy;
 #endif
 
 	if (!ref_freq) {

