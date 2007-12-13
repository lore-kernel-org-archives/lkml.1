Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXLMHGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXLMHGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762185AbXLMG4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbXLMG4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:49 -0500
Date: Wed, 12 Dec 2007 22:52:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Eddie Dong <eddie.dong@intel.com>, Qing He <qing.he@intel.com>
Subject: [patch 26/60] KVM: VMX: Reset mmu context when entering real mode
Message-ID: <20071213065214.GA6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-vmx-reset-mmu-context-when-entering-real-mode.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eddie Dong <eddie.dong@intel.com>

patch 8668a3c468ed55d19514117a5a959d91d3d03823 in mainline.

Resetting an SMP guest will force AP enter real mode (RESET) with
paging enabled in protected mode. While current enter_rmode() can
only handle mode switch from nonpaging mode to real mode which leads
to SMP reboot failure.

Fix by reloading the mmu context on entering real mode.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/mmu.c |    1 +
 drivers/kvm/vmx.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1066,6 +1066,7 @@ int kvm_mmu_reset_context(struct kvm_vcp
 	destroy_kvm_mmu(vcpu);
 	return init_kvm_mmu(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -957,6 +957,7 @@ static void enter_rmode(struct kvm_vcpu 
 	fix_rmode_seg(VCPU_SREG_GS, &vcpu->rmode.gs);
 	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
 
+	kvm_mmu_reset_context(vcpu);
 	init_rmode_tss(vcpu->kvm);
 }
 

-- 
