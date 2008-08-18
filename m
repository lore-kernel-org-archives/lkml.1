Return-Path: <linux-kernel-owner+w=401wt.eu-S1761905AbYHRS7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905AbYHRS7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYHRS5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:57:47 -0400
Received: from ns.suse.de ([195.135.220.2]:43240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbYHRS5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:57:46 -0400
Date: Mon, 18 Aug 2008 11:44:33 -0700
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
Subject: [patch 32/60] KVM: task switch: use seg regs provided by subarch
	instead of reading from GDT
Message-ID: <20080818184433.GG29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-task-switch-use-seg-regs-provided-by-subarch-instead-of-reading-from-gdt.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry-picked from commit 34198bf8426276a2ce1e97056a0f02d43637e5ae)

There is no guarantee that the old TSS descriptor in the GDT contains
the proper base address. This is the case for Windows installation's
reboot-via-triplefault.

Use guest registers instead. Also translate the address properly.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |   93 +++++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 63 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3251,54 +3251,6 @@ static u32 get_tss_base_addr(struct kvm_
 	return vcpu->arch.mmu.gva_to_gpa(vcpu, base_addr);
 }
 
-static int load_tss_segment32(struct kvm_vcpu *vcpu,
-			      struct desc_struct *seg_desc,
-			      struct tss_segment_32 *tss)
-{
-	u32 base_addr;
-
-	base_addr = get_tss_base_addr(vcpu, seg_desc);
-
-	return kvm_read_guest(vcpu->kvm, base_addr, tss,
-			      sizeof(struct tss_segment_32));
-}
-
-static int save_tss_segment32(struct kvm_vcpu *vcpu,
-			      struct desc_struct *seg_desc,
-			      struct tss_segment_32 *tss)
-{
-	u32 base_addr;
-
-	base_addr = get_tss_base_addr(vcpu, seg_desc);
-
-	return kvm_write_guest(vcpu->kvm, base_addr, tss,
-			       sizeof(struct tss_segment_32));
-}
-
-static int load_tss_segment16(struct kvm_vcpu *vcpu,
-			      struct desc_struct *seg_desc,
-			      struct tss_segment_16 *tss)
-{
-	u32 base_addr;
-
-	base_addr = get_tss_base_addr(vcpu, seg_desc);
-
-	return kvm_read_guest(vcpu->kvm, base_addr, tss,
-			      sizeof(struct tss_segment_16));
-}
-
-static int save_tss_segment16(struct kvm_vcpu *vcpu,
-			      struct desc_struct *seg_desc,
-			      struct tss_segment_16 *tss)
-{
-	u32 base_addr;
-
-	base_addr = get_tss_base_addr(vcpu, seg_desc);
-
-	return kvm_write_guest(vcpu->kvm, base_addr, tss,
-			       sizeof(struct tss_segment_16));
-}
-
 static u16 get_segment_selector(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_segment kvm_seg;
@@ -3456,20 +3408,26 @@ static int load_state_from_tss16(struct 
 }
 
 int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
-		       struct desc_struct *cseg_desc,
+		       u32 old_tss_base,
 		       struct desc_struct *nseg_desc)
 {
 	struct tss_segment_16 tss_segment_16;
 	int ret = 0;
 
-	if (load_tss_segment16(vcpu, cseg_desc, &tss_segment_16))
+	if (kvm_read_guest(vcpu->kvm, old_tss_base, &tss_segment_16,
+			   sizeof tss_segment_16))
 		goto out;
 
 	save_state_to_tss16(vcpu, &tss_segment_16);
-	save_tss_segment16(vcpu, cseg_desc, &tss_segment_16);
 
-	if (load_tss_segment16(vcpu, nseg_desc, &tss_segment_16))
+	if (kvm_write_guest(vcpu->kvm, old_tss_base, &tss_segment_16,
+			    sizeof tss_segment_16))
+		goto out;
+
+	if (kvm_read_guest(vcpu->kvm, get_tss_base_addr(vcpu, nseg_desc),
+			   &tss_segment_16, sizeof tss_segment_16))
 		goto out;
+
 	if (load_state_from_tss16(vcpu, &tss_segment_16))
 		goto out;
 
@@ -3479,20 +3437,26 @@ out:
 }
 
 int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
-		       struct desc_struct *cseg_desc,
+		       u32 old_tss_base,
 		       struct desc_struct *nseg_desc)
 {
 	struct tss_segment_32 tss_segment_32;
 	int ret = 0;
 
-	if (load_tss_segment32(vcpu, cseg_desc, &tss_segment_32))
+	if (kvm_read_guest(vcpu->kvm, old_tss_base, &tss_segment_32,
+			   sizeof tss_segment_32))
 		goto out;
 
 	save_state_to_tss32(vcpu, &tss_segment_32);
-	save_tss_segment32(vcpu, cseg_desc, &tss_segment_32);
 
-	if (load_tss_segment32(vcpu, nseg_desc, &tss_segment_32))
+	if (kvm_write_guest(vcpu->kvm, old_tss_base, &tss_segment_32,
+			    sizeof tss_segment_32))
+		goto out;
+
+	if (kvm_read_guest(vcpu->kvm, get_tss_base_addr(vcpu, nseg_desc),
+			   &tss_segment_32, sizeof tss_segment_32))
 		goto out;
+
 	if (load_state_from_tss32(vcpu, &tss_segment_32))
 		goto out;
 
@@ -3507,16 +3471,20 @@ int kvm_task_switch(struct kvm_vcpu *vcp
 	struct desc_struct cseg_desc;
 	struct desc_struct nseg_desc;
 	int ret = 0;
+	u32 old_tss_base = get_segment_base(vcpu, VCPU_SREG_TR);
+	u16 old_tss_sel = get_segment_selector(vcpu, VCPU_SREG_TR);
 
-	get_segment(vcpu, &tr_seg, VCPU_SREG_TR);
+	old_tss_base = vcpu->arch.mmu.gva_to_gpa(vcpu, old_tss_base);
 
+	/* FIXME: Handle errors. Failure to read either TSS or their
+	 * descriptors should generate a pagefault.
+	 */
 	if (load_guest_segment_descriptor(vcpu, tss_selector, &nseg_desc))
 		goto out;
 
-	if (load_guest_segment_descriptor(vcpu, tr_seg.selector, &cseg_desc))
+	if (load_guest_segment_descriptor(vcpu, old_tss_sel, &cseg_desc))
 		goto out;
 
-
 	if (reason != TASK_SWITCH_IRET) {
 		int cpl;
 
@@ -3534,8 +3502,7 @@ int kvm_task_switch(struct kvm_vcpu *vcp
 
 	if (reason == TASK_SWITCH_IRET || reason == TASK_SWITCH_JMP) {
 		cseg_desc.type &= ~(1 << 1); //clear the B flag
-		save_guest_segment_descriptor(vcpu, tr_seg.selector,
-					      &cseg_desc);
+		save_guest_segment_descriptor(vcpu, old_tss_sel, &cseg_desc);
 	}
 
 	if (reason == TASK_SWITCH_IRET) {
@@ -3547,10 +3514,10 @@ int kvm_task_switch(struct kvm_vcpu *vcp
 	kvm_x86_ops->cache_regs(vcpu);
 
 	if (nseg_desc.type & 8)
-		ret = kvm_task_switch_32(vcpu, tss_selector, &cseg_desc,
+		ret = kvm_task_switch_32(vcpu, tss_selector, old_tss_base,
 					 &nseg_desc);
 	else
-		ret = kvm_task_switch_16(vcpu, tss_selector, &cseg_desc,
+		ret = kvm_task_switch_16(vcpu, tss_selector, old_tss_base,
 					 &nseg_desc);
 
 	if (reason == TASK_SWITCH_CALL || reason == TASK_SWITCH_GATE) {

-- 
