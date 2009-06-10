Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbZFJW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbZFJW1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZFJW1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:27:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZFJW1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:27:07 -0400
Date: Thu, 11 Jun 2009 00:27:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Oprofile updates for v2.6.31
Message-ID: <20090610222703.GA9929@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest oprofile-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (3):
      oprofile: re-add force_arch_perfmon option
      oprofile: remove undocumented oprofile.p4force option
      oprofile: add support for Core i7 and Atom

Robert Richter (1):
      oprofile: introduce module_param oprofile.cpu_type


 Documentation/kernel-parameters.txt |    8 ++++++++
 arch/x86/oprofile/nmi_int.c         |   27 +++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 90b3924..6ce5f48 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1650,6 +1650,14 @@ and is between 256 and 4096 characters. It is defined in the file
 	oprofile.timer=	[HW]
 			Use timer interrupt instead of performance counters
 
+	oprofile.cpu_type=	Force an oprofile cpu type
+			This might be useful if you have an older oprofile
+			userland or if you want common events.
+			Format: { archperfmon }
+			archperfmon: [X86] Force use of architectural
+				perfmon on Intel CPUs instead of the
+				CPU specific event set.
+
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
 			See also Documentation/scsi/st.txt.
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 202864a..3b285e6 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -356,14 +356,11 @@ static void exit_sysfs(void)
 #define exit_sysfs() do { } while (0)
 #endif /* CONFIG_PM */
 
-static int p4force;
-module_param(p4force, int, 0);
-
 static int __init p4_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
-	if (!p4force && (cpu_model > 6 || cpu_model == 5))
+	if (cpu_model > 6 || cpu_model == 5)
 		return 0;
 
 #ifndef CONFIG_SMP
@@ -389,10 +386,25 @@ static int __init p4_init(char **cpu_type)
 	return 0;
 }
 
+static int force_arch_perfmon;
+static int force_cpu_type(const char *str, struct kernel_param *kp)
+{
+	if (!strcmp(str, "archperfmon")) {
+		force_arch_perfmon = 1;
+		printk(KERN_INFO "oprofile: forcing architectural perfmon\n");
+	}
+
+	return 0;
+}
+module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
+
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
+	if (force_arch_perfmon && cpu_has_arch_perfmon)
+		return 0;
+
 	switch (cpu_model) {
 	case 0 ... 2:
 		*cpu_type = "i386/ppro";
@@ -414,6 +426,13 @@ static int __init ppro_init(char **cpu_type)
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 26:
+		arch_perfmon_setup_counters();
+		*cpu_type = "i386/core_i7";
+		break;
+	case 28:
+		*cpu_type = "i386/atom";
+		break;
 	default:
 		/* Unknown */
 		return 0;
