Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbYHRS65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbYHRS65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbYHRS5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:57:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:36381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbYHRS5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:57:22 -0400
Date: Mon, 18 Aug 2008 11:44:31 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 31/60] KVM: task switch: segment base is linear address
Message-ID: <20080818184431.GF29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-task-switch-segment-base-is-linear-address.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 98899aa0e0bf5de05850082be0eb837058c09ea5)

The segment base is always a linear address, so translate before
accessing guest memory.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3207,6 +3207,7 @@ static void get_segment_descritptor_dtab
 static int load_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 					 struct desc_struct *seg_desc)
 {
+	gpa_t gpa;
 	struct descriptor_table dtable;
 	u16 index = selector >> 3;
 
@@ -3216,13 +3217,16 @@ static int load_guest_segment_descriptor
 		kvm_queue_exception_e(vcpu, GP_VECTOR, selector & 0xfffc);
 		return 1;
 	}
-	return kvm_read_guest(vcpu->kvm, dtable.base + index * 8, seg_desc, 8);
+	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, dtable.base);
+	gpa += index * 8;
+	return kvm_read_guest(vcpu->kvm, gpa, seg_desc, 8);
 }
 
 /* allowed just for 8 bytes segments */
 static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 					 struct desc_struct *seg_desc)
 {
+	gpa_t gpa;
 	struct descriptor_table dtable;
 	u16 index = selector >> 3;
 
@@ -3230,7 +3234,9 @@ static int save_guest_segment_descriptor
 
 	if (dtable.limit < index * 8 + 7)
 		return 1;
-	return kvm_write_guest(vcpu->kvm, dtable.base + index * 8, seg_desc, 8);
+	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, dtable.base);
+	gpa += index * 8;
+	return kvm_write_guest(vcpu->kvm, gpa, seg_desc, 8);
 }
 
 static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
@@ -3242,7 +3248,7 @@ static u32 get_tss_base_addr(struct kvm_
 	base_addr |= (seg_desc->base1 << 16);
 	base_addr |= (seg_desc->base2 << 24);
 
-	return base_addr;
+	return vcpu->arch.mmu.gva_to_gpa(vcpu, base_addr);
 }
 
 static int load_tss_segment32(struct kvm_vcpu *vcpu,

-- 
