Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZIPWmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZIPWmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760392AbZIPWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:48 -0400
Received: from kroah.org ([198.145.64.141]:55375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760412AbZIPWkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:18 2009
Message-Id: <20090916223717.952693286@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 32/45] KVM guest: do not batch pte updates from interrupt context
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-guest-do-not-batch-pte-updates-from-interrupt-context.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

commit 6ba661787594868512a71c129062ebd57d0c01e7 upstream.

Commit b8bcfe997e4 made paravirt pte updates synchronous in interrupt
context.

Unfortunately the KVM pv mmu code caches the lazy/nonlazy mode
internally, so a pte update from interrupt context during a lazy mmu
operation can be batched while it should be performed synchronously.

https://bugzilla.redhat.com/show_bug.cgi?id=518022

Drop the internal mode variable and use paravirt_get_lazy_mode(), which
returns the correct state.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/kvm.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,7 +34,6 @@
 struct kvm_para_state {
 	u8 mmu_queue[MMU_QUEUE_SIZE];
 	int mmu_queue_len;
-	enum paravirt_lazy_mode mode;
 };
 
 static DEFINE_PER_CPU(struct kvm_para_state, para_state);
@@ -77,7 +76,7 @@ static void kvm_deferred_mmu_op(void *bu
 {
 	struct kvm_para_state *state = kvm_para_state();
 
-	if (state->mode != PARAVIRT_LAZY_MMU) {
+	if (paravirt_get_lazy_mode() != PARAVIRT_LAZY_MMU) {
 		kvm_mmu_op(buffer, len);
 		return;
 	}
@@ -185,10 +184,7 @@ static void kvm_release_pt(unsigned long
 
 static void kvm_enter_lazy_mmu(void)
 {
-	struct kvm_para_state *state = kvm_para_state();
-
 	paravirt_enter_lazy_mmu();
-	state->mode = paravirt_get_lazy_mode();
 }
 
 static void kvm_leave_lazy_mmu(void)
@@ -197,7 +193,6 @@ static void kvm_leave_lazy_mmu(void)
 
 	mmu_queue_flush(state);
 	paravirt_leave_lazy_mmu();
-	state->mode = paravirt_get_lazy_mode();
 }
 
 static void __init paravirt_ops_setup(void)


