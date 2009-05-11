Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZEKG2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZEKG2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZEKG2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:28:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:41909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZEKG2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:28:11 -0400
Subject: Re: [PATCH -tip] x86: cpu/proc.c grouping of cpuid in /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A07A724.9010405@zytor.com>
References: <1241941217.3200.3.camel@localhost.localdomain>
	 <4A07A724.9010405@zytor.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 11:57:20 +0530
Message-Id: <1242023240.3089.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 21:18 -0700, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > Unification of cpuid_level.
> > Also added extended_cpuid_level to make it complete.
> > 
> > So cpuid* and cpufeature flag come in same group and /proc/cpuinfo
> > looks like on AMD box:
> > 
> > cpuid level     : 1
> > ext cpuid level : 0x8000001a
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Jaswinder,
> 
> /proc/cpuinfo is a userspace API.  You CANNOT change the format of it
> without breaking applications.
> 
> Therefore, any change which moves flags between fields or removes fields
> is unacceptable.  Adding new fields is possible, however.
> 

Here are 2 patches for adding new field extended_cpuid_level, please
choose PATCH whichever is more appropriate:

PATCH 1:
Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo

extended_cpuid_level also gives useful information like cpuid_level
and very useful for AMD processors.

Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 523bf39..1279e16 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -39,6 +39,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu\t\t: %s\n"
 		   "fpu_exception\t: %s\n"
 		   "cpuid level\t: %d\n"
+		   "ext cpuid level\t: 0x%x\n"
 		   "wp\t\t: %s\n",
 		   c->fdiv_bug ? "yes" : "no",
 		   c->hlt_works_ok ? "no" : "yes",
@@ -47,6 +48,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   c->hard_math ? "yes" : "no",
 		   fpu_exception ? "yes" : "no",
 		   c->cpuid_level,
+		   c->extended_cpuid_level,
 		   c->wp_works_ok ? "yes" : "no");
 }
 #else
@@ -56,8 +58,10 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu\t\t: yes\n"
 		   "fpu_exception\t: yes\n"
 		   "cpuid level\t: %d\n"
+		   "ext cpuid level\t: 0x%x\n"
 		   "wp\t\t: yes\n",
-		   c->cpuid_level);
+		   c->cpuid_level,
+		   c->extended_cpuid_level);
 }
 #endif
 
-- 
1.6.0.6


OR

PATCH 2:
Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo

extended_cpuid_level also gives useful information like cpuid_level
and very useful for AMD processors.

Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 523bf39..a965bf7 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -102,7 +102,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	show_cpuinfo_core(m, c, cpu);
 	show_cpuinfo_misc(m, c);
 
-	seq_printf(m, "flags\t\t:");
+	seq_printf(m, "ext cpuid level\t: 0x%x\n"
+		   "flags\t\t:",
+		   c->extended_cpuid_level);
 	for (i = 0; i < 32*NCAPINTS; i++)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
-- 
1.6.0.6



