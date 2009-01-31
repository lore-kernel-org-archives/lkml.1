Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbZAaDE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbZAaDE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZAaCre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:34 -0500
Received: from kroah.org ([198.145.64.141]:55337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756484AbZAaCrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:23 -0500
Date: Fri, 30 Jan 2009 18:42:48 -0800
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
       alan@lxorguk.ukuu.org.uk, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Richard Henderson <rth@twiddle.net>
Subject: [patch 17/43] alpha: fix vmalloc breakage
Message-ID: <20090131024248.GR12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alpha-fix-vmalloc-breakage.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

commit 822c18f2e38cbc775792ab65ace4f9198678dec9 upstream.

On alpha, we have to map some stuff in the VMALLOC space very early in the
boot process (to make SRM console callbacks work and so on, see
arch/alpha/mm/init.c).  For old VM allocator, we just manually placed a
vm_struct onto the global vmlist and this worked for ages.

Unfortunately, the new allocator isn't aware of this, so it constantly
tries to allocate the VM space which is already in use, making vmalloc on
alpha defunct.

This patch forces KVA to import vmlist entries on init.

[akpm@linux-foundation.org: remove unneeded check (per Johannes)]
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,6 +23,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/bootmem.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -960,6 +961,8 @@ EXPORT_SYMBOL(vm_map_ram);
 
 void __init vmalloc_init(void)
 {
+	struct vmap_area *va;
+	struct vm_struct *tmp;
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -972,6 +975,14 @@ void __init vmalloc_init(void)
 		vbq->nr_dirty = 0;
 	}
 
+	/* Import existing vmlist entries. */
+	for (tmp = vmlist; tmp; tmp = tmp->next) {
+		va = alloc_bootmem(sizeof(struct vmap_area));
+		va->flags = tmp->flags | VM_VM_AREA;
+		va->va_start = (unsigned long)tmp->addr;
+		va->va_end = va->va_start + tmp->size;
+		__insert_vmap_area(va);
+	}
 	vmap_initialized = true;
 }
 

