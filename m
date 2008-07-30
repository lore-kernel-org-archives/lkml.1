Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYGaAGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYGaAGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYGaAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:06:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:35977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYGaAGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:06:03 -0400
Date: Wed, 30 Jul 2008 16:58:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sheng Yang <sheng.yang@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 08/62] KVM: VMX: Fix a wrong usage of vmcs_config
Message-ID: <20080730235802.GH12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-vmx-fix-a-wrong-usage-of-vmcs_config.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Sheng Yang <sheng.yang@intel.com>

Original-Commit-Hash: 406046a9638a455876b030853862e576a4378d29

The function ept_update_paging_mode_cr0() write to
CPU_BASED_VM_EXEC_CONTROL based on vmcs_config.cpu_based_exec_ctrl. That's
wrong because the variable may not consistent with the content in the
CPU_BASE_VM_EXEC_CONTROL MSR.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1420,7 +1420,7 @@ static void ept_update_paging_mode_cr0(u
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-			     vmcs_config.cpu_based_exec_ctrl |
+			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) |
 			     (CPU_BASED_CR3_LOAD_EXITING |
 			      CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
@@ -1430,7 +1430,7 @@ static void ept_update_paging_mode_cr0(u
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-			     vmcs_config.cpu_based_exec_ctrl &
+			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
 			     ~(CPU_BASED_CR3_LOAD_EXITING |
 			       CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;

-- 
