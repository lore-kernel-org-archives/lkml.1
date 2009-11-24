Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZKXBNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZKXBNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbZKXBNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:13:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:59174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551AbZKXBNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:13:48 -0500
Date: Tue, 24 Nov 2009 01:13:30 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de
In-Reply-To: <20091119202341.GA4420@sgi.com>
References: <20091119202341.GA4420@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, platform: Change is_untracked_pat_range() to bool; cleanup init
Message-ID: <tip-eb41c8be89dbe079f49202774e04a79ccac48a09@git.kernel.org>
Git-Commit-ID: eb41c8be89dbe079f49202774e04a79ccac48a09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb41c8be89dbe079f49202774e04a79ccac48a09
Gitweb:     http://git.kernel.org/tip/eb41c8be89dbe079f49202774e04a79ccac48a09
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 23 Nov 2009 14:46:07 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 23 Nov 2009 17:09:59 -0800

x86, platform: Change is_untracked_pat_range() to bool; cleanup init

- Change is_untracked_pat_range() to return bool.
- Clean up the initialization of is_untracked_pat_range() -- by default,
  we simply point it at is_ISA_range() directly.
- Move is_untracked_pat_range to the end of struct x86_platform, since
  it is the newest field.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20091119202341.GA4420@sgi.com>
---
 arch/x86/include/asm/pat.h         |    2 --
 arch/x86/include/asm/x86_init.h    |    4 ++--
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++--
 arch/x86/kernel/x86_init.c         |    2 +-
 arch/x86/mm/pat.c                  |    5 -----
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 4c35dd0..e2c1668 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -24,6 +24,4 @@ int io_reserve_memtype(resource_size_t start, resource_size_t end,
 
 void io_free_memtype(resource_size_t start, resource_size_t end);
 
-int default_is_untracked_pat_range(u64 start, u64 end);
-
 #endif /* _ASM_X86_PAT_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 8112ed7..024cf3c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -113,16 +113,16 @@ struct x86_cpuinit_ops {
 
 /**
  * struct x86_platform_ops - platform specific runtime functions
- * @is_untracked_pat_range	exclude from PAT logic
  * @calibrate_tsc:		calibrate TSC
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
+ * @is_untracked_pat_range	exclude from PAT logic
  */
 struct x86_platform_ops {
-	int (*is_untracked_pat_range)(u64 start, u64 end);
 	unsigned long (*calibrate_tsc)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
+	bool (*is_untracked_pat_range)(u64 start, u64 end);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2477c9f..597a47b 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -37,12 +37,12 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
 
-static int is_GRU_range(u64 start, u64 end)
+static inline bool is_GRU_range(u64 start, u64 end)
 {
 	return start >= gru_start_paddr && end < gru_end_paddr;
 }
 
-static int uv_is_untracked_pat_range(u64 start, u64 end)
+static bool uv_is_untracked_pat_range(u64 start, u64 end)
 {
 	return is_ISA_range(start, end) || is_GRU_range(start, end);
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index bcc749e..861b8b5 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -70,8 +70,8 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 };
 
 struct x86_platform_ops x86_platform = {
-	.is_untracked_pat_range		= default_is_untracked_pat_range,
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
+	.is_untracked_pat_range		= is_ISA_range,
 };
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index b5bc08c..ef71251 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -349,11 +349,6 @@ static int free_ram_pages_type(u64 start, u64 end)
 	return 0;
 }
 
-int default_is_untracked_pat_range(u64 start, u64 end)
-{
-	return is_ISA_range(start, end);
-}
-
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
