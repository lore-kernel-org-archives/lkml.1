Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbZCaXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbZCaXYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbZCaXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:31 -0400
Received: from sous-sol.org ([216.99.217.87]:33140 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756929AbZCaXU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:28 -0400
Message-Id: <20090331231459.449970529@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
       Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 14/45] KVM: SVM: set accessed bit for VMCB segment selectors
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=kvm-svm-set-accessed-bit-for-vmcb-segment-selectors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andre Przywara <andre.przywara@amd.com>

upstream commit: 1fbdc7a58512a6283e10fd27108197679db95ffa

In the segment descriptor _cache_ the accessed bit is always set
(although it can be cleared in the descriptor itself). Since Intel
checks for this condition on a VMENTRY, set this bit in the AMD path
to enable cross vendor migration.

Cc: stable@kernel.org
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Acked-By: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/svm.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -760,20 +760,37 @@ static void svm_get_segment(struct kvm_v
 	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
 	var->g = (s->attrib >> SVM_SELECTOR_G_SHIFT) & 1;
 
-	/*
-	 * SVM always stores 0 for the 'G' bit in the CS selector in
-	 * the VMCB on a VMEXIT. This hurts cross-vendor migration:
-	 * Intel's VMENTRY has a check on the 'G' bit.
-	 */
-	if (seg == VCPU_SREG_CS)
+	switch (seg) {
+	case VCPU_SREG_CS:
+		/*
+		 * SVM always stores 0 for the 'G' bit in the CS selector in
+		 * the VMCB on a VMEXIT. This hurts cross-vendor migration:
+		 * Intel's VMENTRY has a check on the 'G' bit.
+		 */
 		var->g = s->limit > 0xfffff;
-
-	/*
-	 * Work around a bug where the busy flag in the tr selector
-	 * isn't exposed
-	 */
-	if (seg == VCPU_SREG_TR)
+		break;
+	case VCPU_SREG_TR:
+		/*
+		 * Work around a bug where the busy flag in the tr selector
+		 * isn't exposed
+		 */
 		var->type |= 0x2;
+		break;
+	case VCPU_SREG_DS:
+	case VCPU_SREG_ES:
+	case VCPU_SREG_FS:
+	case VCPU_SREG_GS:
+		/*
+		 * The accessed bit must always be set in the segment
+		 * descriptor cache, although it can be cleared in the
+		 * descriptor, the cached bit always remains at 1. Since
+		 * Intel has a check on this, set it here to support
+		 * cross-vendor migration.
+		 */
+		if (!var->unusable)
+			var->type |= 0x1;
+		break;
+	}
 
 	var->unusable = !var->present;
 }

