Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbZIDUUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbZIDUUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934050AbZIDUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:20:12 -0400
Received: from kroah.org ([198.145.64.141]:36188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933989AbZIDUO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200853.421933556@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Sheng Yang <sheng@linux.intel.com>
Subject: [patch 21/48] KVM: VMX: Set IGMT bit in EPT entry
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-set-igmt-bit-in-ept-entry.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sheng Yang <sheng@linux.intel.com>

(cherry picked from commit 928d4bf747e9c290b690ff515d8f81e8ee226d97)

There is a potential issue that, when guest using pagetable without vmexit when
EPT enabled, guest would use PAT/PCD/PWT bits to index PAT msr for it's memory,
which would be inconsistent with host side and would cause host MCE due to
inconsistent cache attribute.

The patch set IGMT bit in EPT entry to ignore guest PAT and use WB as default
memory type to protect host (notice that all memory mapped by KVM should be WB).

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    3 ++-
 arch/x86/kvm/vmx.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3299,7 +3299,8 @@ static int __init vmx_init(void)
 		bypass_guest_pf = 0;
 		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
 			VMX_EPT_WRITABLE_MASK |
-			VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT);
+			VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT |
+			VMX_EPT_IGMT_BIT);
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
 				VMX_EPT_EXECUTABLE_MASK);
 		kvm_enable_tdp();
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -370,6 +370,7 @@ enum vmcs_field {
 #define VMX_EPT_READABLE_MASK			0x1ull
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
+#define VMX_EPT_IGMT_BIT    			(1ull << 6)
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
 


