Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab0CAOgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:36:49 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23582 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0CAOfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:04 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz936eMab9bhab78ozz1202hzzz32i2a8h6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXTZ-02-IRL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/7] KVM: SVM: Introduce direct access msr list
Date: Mon, 1 Mar 2010 15:34:36 +0100
Message-ID: <1267454080-2513-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0215 (UTC) FILETIME=[57061570:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a list with all msrs a guest might
have direct access to and changes the svm_vcpu_init_msrpm
function to use this list.
It also adds a check to set_msr_interception which triggers
a warning if a developer changes a msr intercept that is not
in the list.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   56 ++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c0c01a8..18d7938 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -118,6 +118,27 @@ struct vcpu_svm {
 
 #define MSR_INVALID			0xffffffffU
 
+static struct svm_direct_access_msrs {
+	u32 index;   /* Index of the MSR */
+	bool always; /* True if intercept is always on */
+} direct_access_msrs[] = {
+	{ .index = MSR_K6_STAR,				.always = true  },
+	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
+#ifdef CONFIG_X86_64
+	{ .index = MSR_GS_BASE,				.always = true  },
+	{ .index = MSR_FS_BASE,				.always = true  },
+	{ .index = MSR_KERNEL_GS_BASE,			.always = true  },
+	{ .index = MSR_LSTAR,				.always = true  },
+	{ .index = MSR_CSTAR,				.always = true  },
+	{ .index = MSR_SYSCALL_MASK,			.always = true  },
+#endif
+	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
+	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
+	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
+	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
+	{ .index = MSR_INVALID,				.always = false },
+};
+
 /* enable NPT for AMD64 and X86 with PAE */
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static bool npt_enabled = true;
@@ -437,6 +458,17 @@ err_1:
 
 }
 
+static bool valid_msr_intercept(u32 index)
+{
+	int i;
+
+	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
+		if (direct_access_msrs[i].index == index)
+			return true;
+
+	return false;
+}
+
 static void set_msr_interception(u32 *msrpm, unsigned msr,
 				 int read, int write)
 {
@@ -444,6 +476,12 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	unsigned long tmp;
 	u32 offset;
 
+	/*
+	 * If this warning triggers extend the direct_access_msrs list at the
+	 * beginning of the file
+	 */
+	WARN_ON(!valid_msr_intercept(msr));
+
 	offset    = svm_msrpm_offset(msr);
 	bit_read  = 2 * (msr & 0x0f);
 	bit_write = 2 * (msr & 0x0f) + 1;
@@ -459,18 +497,16 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 
 static void svm_vcpu_init_msrpm(u32 *msrpm)
 {
+	int i;
+
 	memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
 
-#ifdef CONFIG_X86_64
-	set_msr_interception(msrpm, MSR_GS_BASE, 1, 1);
-	set_msr_interception(msrpm, MSR_FS_BASE, 1, 1);
-	set_msr_interception(msrpm, MSR_KERNEL_GS_BASE, 1, 1);
-	set_msr_interception(msrpm, MSR_LSTAR, 1, 1);
-	set_msr_interception(msrpm, MSR_CSTAR, 1, 1);
-	set_msr_interception(msrpm, MSR_SYSCALL_MASK, 1, 1);
-#endif
-	set_msr_interception(msrpm, MSR_K6_STAR, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_SYSENTER_CS, 1, 1);
+	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+		if (!direct_access_msrs[i].always)
+			continue;
+
+		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
+	}
 }
 
 static void svm_enable_lbrv(struct vcpu_svm *svm)
-- 
1.7.0


