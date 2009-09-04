Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbZIDUW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbZIDUW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933995AbZIDUWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:22:37 -0400
Received: from kroah.org ([198.145.64.141]:36124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933976AbZIDUOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:51 2009
Message-Id: <20090904200851.157785189@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 08/48] KVM: Load real mode segments correctly
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-load-real-mode-segments-correctly.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit f4bbd9aaaae23007e4d79536d35a30cbbb11d407)

Real mode segments to not reference the GDT or LDT; they simply compute
base = selector * 16.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3294,11 +3294,33 @@ static int load_segment_descriptor_to_kv
 	return 0;
 }
 
+int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int seg)
+{
+	struct kvm_segment segvar = {
+		.base = selector << 4,
+		.limit = 0xffff,
+		.selector = selector,
+		.type = 3,
+		.present = 1,
+		.dpl = 3,
+		.db = 0,
+		.s = 1,
+		.l = 0,
+		.g = 0,
+		.avl = 0,
+		.unusable = 0,
+	};
+	kvm_x86_ops->set_segment(vcpu, &segvar, seg);
+	return 0;
+}
+
 int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 				int type_bits, int seg)
 {
 	struct kvm_segment kvm_seg;
 
+	if (!(vcpu->arch.cr0 & X86_CR0_PE))
+		return kvm_load_realmode_segment(vcpu, selector, seg);
 	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
 		return 1;
 	kvm_seg.type |= type_bits;


