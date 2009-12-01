Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZLAHhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZLAHhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZLAHhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:37:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:41001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZLAHhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:37:21 -0500
Date: Tue, 1 Dec 2009 07:36:38 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091119202341.GA4420@sgi.com>
References: <20091119202341.GA4420@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Correct the implementation of is_untracked_pat_range()
Message-ID: <tip-ccef086454d4c97e7b722e9303390207d681cb4c@git.kernel.org>
Git-Commit-ID: ccef086454d4c97e7b722e9303390207d681cb4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccef086454d4c97e7b722e9303390207d681cb4c
Gitweb:     http://git.kernel.org/tip/ccef086454d4c97e7b722e9303390207d681cb4c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 30 Nov 2009 21:33:51 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 30 Nov 2009 21:33:51 -0800

x86, mm: Correct the implementation of is_untracked_pat_range()

The semantics the PAT code expect of is_untracked_pat_range() is "is
this range completely contained inside the untracked region."  This
means that checkin 8a27138924f64d2f30c1022f909f74480046bc3f was
technically wrong, because the implementation needlessly confusing.

The sane interface is for it to take a semiclosed range like just
about everything else (as evidenced by the sheer number of "- 1"'s
removed by that patch) so change the actual implementation to match.

Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <20091119202341.GA4420@sgi.com>
---
 arch/x86/include/asm/e820.h        |    6 +++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 68b4e0e..761249e 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -133,9 +133,13 @@ extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 
+/*
+ * Returns true iff the specified range [s,e) is completely contained inside
+ * the ISA region.
+ */
 static inline bool is_ISA_range(u64 s, u64 e)
 {
-	return s >= ISA_START_ADDRESS && e < ISA_END_ADDRESS;
+	return s >= ISA_START_ADDRESS && e <= ISA_END_ADDRESS;
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 597a47b..1e09417 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -39,7 +39,7 @@ static u64 gru_start_paddr, gru_end_paddr;
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
-	return start >= gru_start_paddr && end < gru_end_paddr;
+	return start >= gru_start_paddr && end <= gru_end_paddr;
 }
 
 static bool uv_is_untracked_pat_range(u64 start, u64 end)
