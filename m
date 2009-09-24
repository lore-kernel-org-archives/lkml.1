Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZIXJin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZIXJin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZIXJii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:38:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:47601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZIXJih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:38:37 -0400
Date: Thu, 24 Sep 2009 09:37:43 GMT
From: tip-bot for Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, rdreier@cisco.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, rolandd@cisco.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, rdreier@cisco.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, rolandd@cisco.com,
       mingo@elte.hu
In-Reply-To: <adavdj92sso.fsf@cisco.com>
References: <adavdj92sso.fsf@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Reduce verbosity of "PAT enabled" kernel message
Message-ID: <tip-e23a8b6a8f319c0f08b6ccef2dccbb37e7603dc2@git.kernel.org>
Git-Commit-ID: e23a8b6a8f319c0f08b6ccef2dccbb37e7603dc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 09:37:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e23a8b6a8f319c0f08b6ccef2dccbb37e7603dc2
Gitweb:     http://git.kernel.org/tip/e23a8b6a8f319c0f08b6ccef2dccbb37e7603dc2
Author:     Roland Dreier <rdreier@cisco.com>
AuthorDate: Wed, 23 Sep 2009 15:35:35 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 11:35:19 +0200

x86: Reduce verbosity of "PAT enabled" kernel message

On modern systems, the kernel prints the message

    x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106

once for every CPU.

This gets kind of ridiculous on huge systems; for example, on a
64-thread system I was lucky enough to get:

    dmesg| grep 'PAT enabled' | wc
         64     704    5174

There is already a BUG() if non-boot CPUs have PAT capabilities
that don't match the boot CPU, so just print the message on the
boot CPU. (I kept the print after the wrmsrl() that enables PAT,
so that the log output continues to mean that the system survived
enabling PAT on the boot CPU)

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <adavdj92sso.fsf@cisco.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
