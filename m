Return-Path: <linux-kernel-owner+w=401wt.eu-S1766823AbXDSPum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766823AbXDSPum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766825AbXDSPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:50:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:57812 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766823AbXDSPul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:50:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL] kvm oops fix
Date: Thu, 19 Apr 2007 18:50:39 +0300
Message-Id: <1176997839110-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'linus' branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git

To get a one-liner fixing a host oops running  non-pae guests.

Avi Kivity (1):
      KVM: Fix off-by-one when writing to a nonpae guest pde

---

 drivers/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
commit 6b8d0f9b180cb93513bb65f705b299370f0357a1
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Apr 18 11:18:18 2007 +0300

    KVM: Fix off-by-one when writing to a nonpae guest pde
    
    Nonpae guest pdes are shadowed by two pae ptes, so we double the offset
    twice: once to account for the pte size difference, and once because we
    need to shadow pdes for a single guest pde.
    
    But when writing to the upper guest pde we also need to truncate the
    lower bits, otherwise the multiply shifts these bits into the pde index
    and causes an access to the wrong shadow pde.  If we're at the end of the
    page (accessing the very last guest pde) we can even overflow into the
    next host page and oops.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index e85b4c7..cab26f3 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1171,6 +1171,7 @@ void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 			 * and zap two pdes instead of one.
 			 */
 			if (level == PT32_ROOT_LEVEL) {
+				page_offset &= ~7; /* kill rounding error */
 				page_offset <<= 1;
 				npte = 2;
 			}
