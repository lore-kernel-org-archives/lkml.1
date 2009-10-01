Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZJAXnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZJAXnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZJAXng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:43:36 -0400
Received: from kroah.org ([198.145.64.141]:42024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbZJAXiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:20 2009
Message-Id: <20091001233319.941189720@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Gleb Natapov <gleb@redhat.com>
Subject: [patch 08/30] KVM: VMX: Fix cr8 exiting control clobbering by EPT
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-fix-cr8-exiting-control-clobbering-by-ept.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gleb Natapov <gleb@redhat.com>

(cherry picked from commit 5fff7d270bd6a4759b6d663741b729cdee370257)
Don't call adjust_vmx_controls() two times for the same control.
It restores options that were dropped earlier.  This loses us the cr8
exit control, which causes a massive performance regression Windows x64.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1206,12 +1206,9 @@ static __init int setup_vmcs_config(stru
 	if (_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) {
 		/* CR3 accesses and invlpg don't need to cause VM Exits when EPT
 		   enabled */
-		min &= ~(CPU_BASED_CR3_LOAD_EXITING |
-			 CPU_BASED_CR3_STORE_EXITING |
-			 CPU_BASED_INVLPG_EXITING);
-		if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
-					&_cpu_based_exec_control) < 0)
-			return -EIO;
+		_cpu_based_exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
+					     CPU_BASED_CR3_STORE_EXITING |
+					     CPU_BASED_INVLPG_EXITING);
 		rdmsr(MSR_IA32_VMX_EPT_VPID_CAP,
 		      vmx_capability.ept, vmx_capability.vpid);
 	}


