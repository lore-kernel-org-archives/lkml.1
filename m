Return-Path: <linux-kernel-owner+w=401wt.eu-S938109AbXFHHfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938109AbXFHHfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938367AbXFHHXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:30 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58329 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938359AbXFHHX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:27 -0400
Message-Id: <20070608072148.210100000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 04/54] i386: Fix K8/core2 oprofile on multiple CPUs
Content-Disposition: inline; filename=i386-fix-k8-core2-oprofile-on-multiple-cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andi Kleen <ak@suse.de>

Only try to allocate MSRs once instead of for every CPU.

This assumes the MSRs are the same on all CPUs which is currently
true. P4-HT is a special case for different SMT threads, but the code
always saves/restores all MSRs so it works identical.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/i386/oprofile/nmi_int.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- linux-2.6.21.4.orig/arch/i386/oprofile/nmi_int.c
+++ linux-2.6.21.4/arch/i386/oprofile/nmi_int.c
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

-- 
