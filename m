Return-Path: <linux-kernel-owner+w=401wt.eu-S935768AbXHGUyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768AbXHGUyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935420AbXHGUtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56136 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935453AbXHGUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:57 -0400
Date: Tue, 7 Aug 2007 13:44:39 -0700
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
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@qumranet.com>
Subject: [2.6.22.2 review 20/84] KVM: SVM: Reliably detect if SVM was
	disabled by BIOS
Message-ID: <20070807204439.GU23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-svm-reliably-detect-if-svm-was-disabled-by-bios.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds an implementation to the svm is_disabled function to
detect reliably if the BIOS disabled the SVM feature in the CPU. This
fixes the issues with kernel panics when loading the kvm-amd module on
machines where SVM is available but disabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/svm.c |    6 ++++++
 drivers/kvm/svm.h |    3 +++
 2 files changed, 9 insertions(+)

--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1727,6 +1727,12 @@ static void svm_inject_page_fault(struct
 
 static int is_disabled(void)
 {
+	u64 vm_cr;
+
+	rdmsrl(MSR_VM_CR, vm_cr);
+	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE))
+		return 1;
+
 	return 0;
 }
 
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -175,8 +175,11 @@ struct __attribute__ ((__packed__)) vmcb
 #define SVM_CPUID_FUNC 0x8000000a
 
 #define MSR_EFER_SVME_MASK (1ULL << 12)
+#define MSR_VM_CR       0xc0010114
 #define MSR_VM_HSAVE_PA 0xc0010117ULL
 
+#define SVM_VM_CR_SVM_DISABLE 4
+
 #define SVM_SELECTOR_S_SHIFT 4
 #define SVM_SELECTOR_DPL_SHIFT 5
 #define SVM_SELECTOR_P_SHIFT 7

-- 
