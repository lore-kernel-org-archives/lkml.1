Return-Path: <linux-kernel-owner+w=401wt.eu-S1765274AbZD3Rgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765274AbZD3Rgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764690AbZD3RI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:29 -0400
Received: from kroah.org ([198.145.64.141]:56798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762267AbZD3RIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165747.988695623@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:54 -0700
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
       alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
       mtosatti@redhat.com, avi@redhat.com
Subject: [patch 65/88] KVM: Really remove a slot when a user ask us so
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-really-remove-a-slot-when-a-user-ask-us-so.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Glauber Costa <glommer@redhat.com>

(cherry picked from 6f89724829cfd4ad6771a92fd4b8d59c90c7220c)

Right now, KVM does not remove a slot when we do a
register ioctl for size 0 (would be the expected behaviour).

Instead, we only mark it as empty, but keep all bitmaps
and allocated data structures present. It completely
nullifies our chances of reusing that same slot again
for mapping a different piece of memory.

In this patch, we destroy rmaps, and vfree() the
pointers that used to hold the dirty bitmap, rmap
and lpage_info structures.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -821,7 +821,10 @@ int __kvm_set_memory_region(struct kvm *
 		goto out_free;
 	}
 
-	kvm_free_physmem_slot(&old, &new);
+	kvm_free_physmem_slot(&old, npages ? &new : NULL);
+	/* Slot deletion case: we have to update the current slot */
+	if (!npages)
+		*memslot = old;
 #ifdef CONFIG_DMAR
 	/* map the pages in iommu page table */
 	r = kvm_iommu_map_pages(kvm, base_gfn, npages);


