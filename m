Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZIWWfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZIWWfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIWWfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:35:36 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:50116 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZIWWfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:35:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOs/ukqrR7PE/2dsb2JhbAC+b4hPAY92BYQb
X-IronPort-AV: E=Sophos;i="4.44,440,1249257600"; 
   d="scan'208";a="207652935"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Reduce verbosity of "PAT enabled" kernel message
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Sep 2009 15:35:35 -0700
Message-ID: <adavdj92sso.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Sep 2009 22:35:35.0928 (UTC) FILETIME=[2B1CAF80:01CA3C9E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On modern systems, the kernel prints the message

    x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106

once for every CPU.  This gets kind of ridiculous on huge systems; for
example, on a 64-thread system I was lucky enough to get:

    dmesg| grep 'PAT enabled' | wc
         64     704    5174

There is already a BUG() if non-boot CPUs have PAT capabilities that
don't match the boot CPU, so just print the message on the boot CPU.
(I kept the print after the wrmsrl() that enables PAT, so that the log
output continues to mean that the system survived enabling PAT on the
boot CPU)

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/mm/pat.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 7257cf3..e78cd0e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -81,6 +81,7 @@ enum {
 void pat_init(void)
 {
 	u64 pat;
+	bool boot_cpu = !boot_pat_state;
 
 	if (!pat_enabled)
 		return;
@@ -122,8 +123,10 @@ void pat_init(void)
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
-	printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
-	       smp_processor_id(), boot_pat_state, pat);
+
+	if (boot_cpu)
+		printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
+		       smp_processor_id(), boot_pat_state, pat);
 }
 
 #undef PAT
