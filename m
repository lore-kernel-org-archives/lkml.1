Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbZEFV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbZEFV6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761391AbZEFVya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:30 -0400
Received: from kroah.org ([198.145.64.141]:56970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761337AbZEFVy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:56 2009
Message-Id: <20090506214756.590967464@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Jan Kiszka <jan.kiszka@siemens.com>,
       Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 10/58] KVM: Fix overlapping check for memory slots
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-overlapping-check-for-memory-slots.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kiszka <jan.kiszka@web.de>

upstream commit: 4cd481f68dde99ac416003b825c835f71e364393

When checking for overlapping slots on registration of a new one, kvm
currently also considers zero-length (ie. deleted) slots and rejects
requests incorrectly. This finally denies user space from joining slots.
Fix the check by skipping deleted slots and advertise this via a
KVM_CAP_JOIN_MEMORY_REGIONS_WORKS.

Cc: stable@kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/kvm.h |    2 ++
 virt/kvm/kvm_main.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -396,6 +396,8 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_USER_NMI
 #define KVM_CAP_USER_NMI 22
 #endif
+/* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
+#define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
 
 /*
  * ioctls for VM fds
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1005,7 +1005,7 @@ int __kvm_set_memory_region(struct kvm *
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
 		struct kvm_memory_slot *s = &kvm->memslots[i];
 
-		if (s == memslot)
+		if (s == memslot || !s->npages)
 			continue;
 		if (!((base_gfn + npages <= s->base_gfn) ||
 		      (base_gfn >= s->base_gfn + s->npages)))
@@ -1997,6 +1997,7 @@ static long kvm_dev_ioctl_check_extensio
 	switch (arg) {
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
+	case KVM_CAP_JOIN_MEMORY_REGIONS_WORKS:
 		return 1;
 	default:
 		break;


