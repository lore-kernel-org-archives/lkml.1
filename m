Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZBESnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZBESnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZBESmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:42:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35674 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZBESmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:42:38 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       akataria@vmware.com, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 2/2] tell cpuinfo if we're running on top of KVM
Date: Thu,  5 Feb 2009 13:42:21 -0500
Message-Id: <1233859341-10419-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1233859341-10419-2-git-send-email-glommer@redhat.com>
References: <1233859341-10419-1-git-send-email-glommer@redhat.com>
 <1233859341-10419-2-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

KVM has a specific cpuid signature, for a long time now. It's currently
used in the kernel to advertise the possible availability of paravirt
functions, but it's safe to assume that any reasonably recent kvm
hypervisor will sign cpuid this way, regardless of any pv capability.

Use this information to fill in the hypervisor field in cpuinfo.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 091cd88..919c08d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -126,6 +126,7 @@ struct cpuinfo_x86 {
 
 #define X86_HYPER_VENDOR_NONE  0
 #define X86_HYPER_VENDOR_VMWARE 1
+#define X86_HYPER_VENDOR_KVM	2
 
 /*
  * capabilities of CPUs
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8c3fca7..251817a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -23,6 +23,7 @@
 
 #include <asm/processor.h>
 #include <asm/vmware.h>
+#include <asm/kvm_para.h>
 #include <asm/hypervisor.h>
 
 static inline void __cpuinit
@@ -30,6 +31,8 @@ detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 {
 	if (vmware_platform()) {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+	} else if (kvm_para_available()) {
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_KVM;
 	} else {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 	}
@@ -55,6 +58,8 @@ char * __cpuinit hypervisor_str(struct cpuinfo_x86 *c)
 {
 	if (c->x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
 		return "VMWare";
+	else if (c->x86_hyper_vendor == X86_HYPER_VENDOR_KVM)
+		return "KVM";
 	else
 		return "none";
 }
-- 
1.5.6.5

