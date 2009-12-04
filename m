Return-Path: <linux-kernel-owner+w=401wt.eu-S932534AbZLDWfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbZLDWfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932513AbZLDWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:35:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbZLDWfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:35:32 -0500
Message-ID: <4B198F27.8050409@gmail.com>
Date: Fri, 04 Dec 2009 23:37:27 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: tigran@aivazian.fsnet.co.uk, andreas.herrmann3@amd.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/31] Constify struct microcode_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct microcode_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/include/asm/microcode.h  |   14 +++++++-------
 arch/x86/kernel/microcode_amd.c   |    4 ++--
 arch/x86/kernel/microcode_core.c  |    2 +-
 arch/x86/kernel/microcode_intel.c |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index ef51b50..514ba37 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -12,13 +12,13 @@ struct device;
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 
 struct microcode_ops {
-	enum ucode_state (*request_microcode_user) (int cpu,
+	enum ucode_state (* const request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
-	enum ucode_state (*request_microcode_fw) (int cpu,
+	enum ucode_state (* const request_microcode_fw) (int cpu,
 				struct device *device);
 
-	void (*microcode_fini_cpu) (int cpu);
+	void (* const microcode_fini_cpu) (int cpu);
 
 	/*
 	 * The generic 'microcode_core' part guarantees that
@@ -38,18 +38,18 @@ struct ucode_cpu_info {
 extern struct ucode_cpu_info ucode_cpu_info[];
 
 #ifdef CONFIG_MICROCODE_INTEL
-extern struct microcode_ops * __init init_intel_microcode(void);
+extern const struct microcode_ops * __init init_intel_microcode(void);
 #else
-static inline struct microcode_ops * __init init_intel_microcode(void)
+static inline const struct microcode_ops * __init init_intel_microcode(void)
 {
 	return NULL;
 }
 #endif /* CONFIG_MICROCODE_INTEL */
 
 #ifdef CONFIG_MICROCODE_AMD
-extern struct microcode_ops * __init init_amd_microcode(void);
+extern const struct microcode_ops * __init init_amd_microcode(void);
 #else
-static inline struct microcode_ops * __init init_amd_microcode(void)
+static inline const struct microcode_ops * __init init_amd_microcode(void)
 {
 	return NULL;
 }
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index f4c538b..9a7238c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -346,7 +346,7 @@ static void microcode_fini_cpu_amd(int cpu)
 	uci->mc = NULL;
 }
 
-static struct microcode_ops microcode_amd_ops = {
+static const struct microcode_ops microcode_amd_ops = {
 	.request_microcode_user           = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info_amd,
@@ -354,7 +354,7 @@ static struct microcode_ops microcode_amd_ops = {
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
 };
 
-struct microcode_ops * __init init_amd_microcode(void)
+const struct microcode_ops * __init init_amd_microcode(void)
 {
 	return &microcode_amd_ops;
 }
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 378e9a8..b5a6ea9 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -90,7 +90,7 @@ MODULE_LICENSE("GPL");
 
 #define MICROCODE_VERSION	"2.00"
 
-static struct microcode_ops	*microcode_ops;
+static const struct microcode_ops	*microcode_ops;
 
 /*
  * Synchronization.
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0d334dd..0f9b41d 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -460,7 +460,7 @@ static void microcode_fini_cpu(int cpu)
 	uci->mc = NULL;
 }
 
-static struct microcode_ops microcode_intel_ops = {
+static const struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
@@ -468,7 +468,7 @@ static struct microcode_ops microcode_intel_ops = {
 	.microcode_fini_cpu               = microcode_fini_cpu,
 };
 
-struct microcode_ops * __init init_intel_microcode(void)
+const struct microcode_ops * __init init_intel_microcode(void)
 {
 	return &microcode_intel_ops;
 }

