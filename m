Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXLMHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXLMHFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761872AbXLMG4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55264 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761832AbXLMG4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:38 -0500
Date: Wed, 12 Dec 2007 22:52:06 -0800
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
       kvm-devel@lists.sourceforge.net, Amit Shah <amit.shah@qumranet.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 23/60] KVM: SVM: Fix FPU leak while emulating clts
Message-ID: <20071213065206.GX6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-svm-fix-fpu-leak-while-emulating-clts.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Amit Shah <amit.shah@qumranet.com>

patch 404fb881b82cf0cf6981832f8d31a7484e4dee81 in mainline.

The clts code didn't use set_cr0 properly, so our lazy FPU
processing wasn't being done by the clts instruction at all.

(this isn't called on Intel as the hardware does the decode for us)

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/kvm_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1163,10 +1163,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	unsigned long cr0;
-
-	cr0 = vcpu->cr0 & ~CR0_TS_MASK;
-	kvm_arch_ops->set_cr0(vcpu, cr0);
+	kvm_arch_ops->set_cr0(vcpu, vcpu->cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
 

-- 
