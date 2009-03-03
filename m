Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbZCCLKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbZCCLKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZCCLKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:10:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:59560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZCCLKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:10:12 -0500
Date: Tue, 3 Mar 2009 11:09:27 GMT
From: Tim Blechmann <tim@klingt.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, stable@kernel.org, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, stable@kernel.org, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <20090303100412.GC10085@erda.amd.com>
References: <20090303100412.GC10085@erda.amd.com>
Subject: [tip:x86/urgent] x86: oprofile: don't set counter width from cpuid on Core2
Message-ID: <tip-780eef9492b16a1543a3b2ae9f9526a735fc9856@git.kernel.org>
Git-Commit-ID: 780eef9492b16a1543a3b2ae9f9526a735fc9856
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 11:09:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  780eef9492b16a1543a3b2ae9f9526a735fc9856
Gitweb:     http://git.kernel.org/tip/780eef9492b16a1543a3b2ae9f9526a735fc9856
Author:     "Tim Blechmann" <tim@klingt.org>
AuthorDate: Thu, 19 Feb 2009 17:34:03 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 12:04:22 +0100

x86: oprofile: don't set counter width from cpuid on Core2

Impact: fix stuck NMIs and non-working oprofile on certain CPUs

Resetting the counter width of the performance counters on Intel's
Core2 CPUs, breaks the delivery of NMIs, when running in x86_64 mode.

This should fix bug #12395:

  http://bugzilla.kernel.org/show_bug.cgi?id=12395

Signed-off-by: Tim Blechmann <tim@klingt.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <20090303100412.GC10085@erda.amd.com>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/oprofile/op_model_ppro.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index e9f80c7..10131fb 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -78,8 +78,18 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
-		if (counter_width < eax.split.bit_width)
-			counter_width = eax.split.bit_width;
+
+		/*
+		 * For Core2 (family 6, model 15), don't reset the
+		 * counter width:
+		 */
+		if (!(eax.split.version_id == 0 &&
+			current_cpu_data.x86 == 6 &&
+				current_cpu_data.x86_model == 15)) {
+
+			if (counter_width < eax.split.bit_width)
+				counter_width = eax.split.bit_width;
+		}
 	}
 
 	/* clear all counters */
