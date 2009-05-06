Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbZEFV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbZEFV5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbZEFVy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:27 -0400
Received: from kroah.org ([198.145.64.141]:56953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760095AbZEFVyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:56 2009
Message-Id: <20090506214756.305441008@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 08/58] KVM: MMU: Fix off-by-one calculating large page count
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-fix-off-by-one-calculating-large-page-count.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

upstream commit: 99894a799f09cf9e28296bb16e75bd5830fd2c4e

The large page initialization code concludes there are two large pages spanned
by a slot covering 1 (small) page starting at gfn 1.  This is incorrect, and
also results in incorrect write_count initialization in some cases (base = 1,
npages = 513 for example).

Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 virt/kvm/kvm_main.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -964,6 +964,7 @@ int __kvm_set_memory_region(struct kvm *
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
+	int largepages;
 	unsigned long i;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
@@ -1039,11 +1040,8 @@ int __kvm_set_memory_region(struct kvm *
 			new.userspace_addr = 0;
 	}
 	if (npages && !new.lpage_info) {
-		int largepages = npages / KVM_PAGES_PER_HPAGE;
-		if (npages % KVM_PAGES_PER_HPAGE)
-			largepages++;
-		if (base_gfn % KVM_PAGES_PER_HPAGE)
-			largepages++;
+		largepages = 1 + (base_gfn + npages - 1) / KVM_PAGES_PER_HPAGE;
+		largepages -= base_gfn / KVM_PAGES_PER_HPAGE;
 
 		new.lpage_info = vmalloc(largepages * sizeof(*new.lpage_info));
 


