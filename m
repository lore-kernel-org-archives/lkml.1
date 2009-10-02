Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZJBBcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZJBBcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZJBBcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:23 -0400
Received: from kroah.org ([198.145.64.141]:32846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbZJBBcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:05 2009
Message-Id: <20091002012405.835199387@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: [001/136] KVM: VMX: Fix EPT with WP bit change during paging
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-fix-ept-with-wp-bit-change-during-paging.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sheng Yang <sheng@linux.intel.com>

commit 95eb84a7588d7d7afd3096807efc052adc7479e1 upstream

QNX update WP bit when paging enabled, which is not covered yet. This one
fix QNX boot with EPT.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1572,7 +1572,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, vcpu->arch.cr4);
 		*hw_cr0 |= X86_CR0_PE | X86_CR0_PG;
-		*hw_cr0 &= ~X86_CR0_WP;
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
@@ -1581,9 +1580,10 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			       CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, vcpu->arch.cr4);
-		if (!(vcpu->arch.cr0 & X86_CR0_WP))
-			*hw_cr0 &= ~X86_CR0_WP;
 	}
+
+	if (!(cr0 & X86_CR0_WP))
+		*hw_cr0 &= ~X86_CR0_WP;
 }
 
 static void ept_update_paging_mode_cr4(unsigned long *hw_cr4,
-- 
1.5.4.5



