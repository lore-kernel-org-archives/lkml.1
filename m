Return-Path: <linux-kernel-owner+w=401wt.eu-S1765669AbZD3RkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765669AbZD3RkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764705AbZD3RIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:36 -0400
Received: from kroah.org ([198.145.64.141]:56859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764401AbZD3RIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165748.851313284@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:00 -0700
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: [patch 71/88] KVM: mmu_notifiers release method
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu_notifiers-release-method.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------


(cherry picked from 85db06e514422ae429b5f85742d8111b70bd56f3)

The destructor for huge pages uses the backing inode for adjusting
hugetlbfs accounting.

Hugepage mappings are destroyed by exit_mmap, after
mmu_notifier_release, so there are no notifications through
unmap_hugepage_range at this point.

The hugetlbfs inode can be freed with pages backed by it referenced
by the shadow. When the shadow releases its reference, the huge page
destructor will access a now freed inode.

Implement the release operation for kvm mmu notifiers to release page
refs before the hugetlbfs inode is gone.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -553,11 +553,19 @@ static int kvm_mmu_notifier_clear_flush_
 	return young;
 }
 
+static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
+				     struct mm_struct *mm)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	kvm_arch_flush_shadow(kvm);
+}
+
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.invalidate_page	= kvm_mmu_notifier_invalidate_page,
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
+	.release		= kvm_mmu_notifier_release,
 };
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 


