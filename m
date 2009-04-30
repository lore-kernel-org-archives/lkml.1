Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbZD3ReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbZD3ReW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764684AbZD3RIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:20 -0400
Received: from kroah.org ([198.145.64.141]:56733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764580AbZD3RIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:47 2009
Message-Id: <20090430165747.144930573@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:48 -0700
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
       alan@lxorguk.ukuu.org.uk, Amit Shah <amit.shah@redhat.com>,
       mtosatti@redhat.com, avi@redhat.com
Subject: [patch 59/88] KVM: SVM: Set the g bit of the cs selector for cross-vendor migration
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-svm-set-the-g-bit-of-the-cs-selector-for-cross-vendor-migration.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

(cherry picked from 25022acc3dd5f0b54071c7ba7c371860f2971b52)

The hardware does not set the 'g' bit of the cs selector and this breaks
migration from amd hosts to intel hosts. Set this bit if the segment
limit is beyond 1 MB.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/svm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -772,6 +772,15 @@ static void svm_get_segment(struct kvm_v
 	var->l = (s->attrib >> SVM_SELECTOR_L_SHIFT) & 1;
 	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
 	var->g = (s->attrib >> SVM_SELECTOR_G_SHIFT) & 1;
+
+	/*
+	 * SVM always stores 0 for the 'G' bit in the CS selector in
+	 * the VMCB on a VMEXIT. This hurts cross-vendor migration:
+	 * Intel's VMENTRY has a check on the 'G' bit.
+	 */
+	if (seg == VCPU_SREG_CS)
+		var->g = s->limit > 0xfffff;
+
 	var->unusable = !var->present;
 }
 


