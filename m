Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZGAAst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZGAAst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbZGAAeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:14 -0400
Received: from kroah.org ([198.145.64.141]:60057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761353AbZGAAeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:13 2009
Message-Id: <20090701002413.536284495@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 007/108] KVM: Disable large pages on misaligned memory slots
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-disable-large-pages-on-misaligned-memory-slots.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit ac04527f7947020c5890090b2ac87af4e98d977e upstream.

If a slots guest physical address and host virtual address unequal (mod
large page size), then we would erronously try to back guest large pages
with host large pages.  Detect this misalignment and diable large page
support for the trouble slot.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/kvm_main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -919,7 +919,7 @@ int __kvm_set_memory_region(struct kvm *
 {
 	int r;
 	gfn_t base_gfn;
-	unsigned long npages;
+	unsigned long npages, ugfn;
 	int largepages;
 	unsigned long i;
 	struct kvm_memory_slot *memslot;
@@ -1010,6 +1010,14 @@ int __kvm_set_memory_region(struct kvm *
 			new.lpage_info[0].write_count = 1;
 		if ((base_gfn+npages) % KVM_PAGES_PER_HPAGE)
 			new.lpage_info[largepages-1].write_count = 1;
+		ugfn = new.userspace_addr >> PAGE_SHIFT;
+		/*
+		 * If the gfn and userspace address are not aligned wrt each
+		 * other, disable large page support for this slot
+		 */
+		if ((base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE - 1))
+			for (i = 0; i < largepages; ++i)
+				new.lpage_info[i].write_count = 1;
 	}
 
 	/* Allocate page dirty bitmap if needed */


