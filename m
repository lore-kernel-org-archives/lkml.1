Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0BSPZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:25:24 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:2781 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754276Ab0BSPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:28 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEU-02-7NK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/11] KVM: SVM: Don't call instruction emulator for invd and wbinvd
Date: Fri, 19 Feb 2010 16:23:10 +0100
Message-ID: <1266592990-8911-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0933 (UTC) FILETIME=[736E8D50:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an intercept for WBINVD and INVD in SVM so we don't
need the instruction emulator. The primary reason is that
the current instruction emulator fails to emulate these
instructions and the rip is not advanced.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/emulate.c |    4 ++++
 arch/x86/kvm/svm.c     |   14 ++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9beda8e..0180cb1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1029,6 +1029,10 @@ done_prefixes:
 
 	/* Unrecognised? */
 	if (c->d == 0) {
+		/* Don't fail for invd and wbinvd*/
+		if (c->twobyte && (c->b == 0x08 || c->b == 0x09))
+			return 0;
+
 		DPRINTF("Cannot emulate %02x\n", c->b);
 		return -1;
 	}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8119355..5fd00e8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2117,6 +2117,16 @@ static int cpuid_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int invd_interception(struct vcpu_svm *svm)
+{
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
+	skip_emulated_instruction(&svm->vcpu);
+
+	/* Nop */
+
+	return 1;
+}
+
 static int iret_interception(struct vcpu_svm *svm)
 {
 	++svm->vcpu.stat.nmi_window_exits;
@@ -2418,7 +2428,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
-	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_INVD]                         = invd_interception,
 	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
@@ -2434,7 +2444,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
 	[SVM_EXIT_SKINIT]			= skinit_interception,
-	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
+	[SVM_EXIT_WBINVD]                       = invd_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
 	[SVM_EXIT_NPF]				= pf_interception,
-- 
1.6.6


