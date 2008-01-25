Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYAYVVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYAYVVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbYAYVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:21:31 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26260 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbYAYVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:21:30 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 4/8] X86: export information about NPT to generic x86
 code
Date: Fri, 25 Jan 2008 21:53:09 +0100
Message-ID: <1201294393-22613-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0583 (UTC)
 FILETIME=[4DD78E70:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493B52IW8829088-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic x86 code has to know if the specific implementation uses Nested
Paging. In the generic code Nested Paging is called Hardware Assisted Paging
(HAP) to avoid confusion with (future) HAP implementations of other vendors.
This patch exports the availability of HAP to the generic x86 code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c         |    7 +++++++
 arch/x86/kvm/vmx.c         |    7 +++++++
 include/asm-x86/kvm_host.h |    2 ++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2e718ff..d0bfdd8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1678,6 +1678,11 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
+static bool svm_hap_enabled(void)
+{
+	return npt_enabled;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -1734,6 +1739,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.inject_pending_vectors = do_interrupt_requests,
 
 	.set_tss_addr = svm_set_tss_addr,
+
+	.hap_enabled = svm_hap_enabled,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 00a00e4..8feb775 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2631,6 +2631,11 @@ static void __init vmx_check_processor_compat(void *rtn)
 	}
 }
 
+static bool vmx_hap_enabled(void)
+{
+	return false;
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -2688,6 +2693,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.inject_pending_vectors = do_interrupt_requests,
 
 	.set_tss_addr = vmx_set_tss_addr,
+
+	.hap_enabled = vmx_hap_enabled,
 };
 
 static int __init vmx_init(void)
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 67ae307..45a9d05 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -392,6 +392,8 @@ struct kvm_x86_ops {
 				       struct kvm_run *run);
 
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
+
+	bool (*hap_enabled)(void);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
-- 
1.5.3.7



