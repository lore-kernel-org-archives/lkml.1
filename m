Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbZIPWlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbZIPWlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760431AbZIPWk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:57 -0400
Received: from kroah.org ([198.145.64.141]:55394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569AbZIPWkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:18 2009
Message-Id: <20090916223718.746468813@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 37/45] KVM: VMX: Fix cr8 exiting control clobbering by EPT
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-fix-cr8-exiting-control-clobbering-by-ept.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gleb Natapov <gleb@redhat.com>

commit 5fff7d270bd6a4759b6d663741b729cdee370257 upstream.

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
@@ -1217,12 +1217,9 @@ static __init int setup_vmcs_config(stru
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


