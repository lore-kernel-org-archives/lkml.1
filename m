Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbZLIXl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbZLIXl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbZLIXlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:41:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:45864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758676AbZLIXly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:41:54 -0500
Message-ID: <4B203614.1010907@novell.com>
Date: Thu, 10 Dec 2009 08:43:16 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: stable@kernel.org
Cc: tony.luck@intel.com, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>
Subject: [PATCH -stable] vmalloc: conditionalize build of pcpu_get_vm_areas()
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <4B1E0E56.8020003@kernel.org> <4B1E1EE60200007800024364@vpn.id2.novell.com> <4B1E1513.3020000@kernel.org>
In-Reply-To: <4B1E1513.3020000@kernel.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_get_vm_areas() is used only when dynamic percpu allocator is used
by the architecture.  In 2.6.32, ia64 doesn't use dynamic percpu
allocator and has a macro which makes pcpu_get_vm_areas() buggy via
local/global variable aliasing and triggers compile warning.

The problem is fixed in upstream and ia64 uses dynamic percpu
allocators, so the only left issue is inclusion of unnecessary code
and compile warning on ia64 on 2.6.32.

Don't build pcpu_get_vm_areas() if legacy percpu allocator is in use.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: stable@kernel.org
---
Please note that this commit won't appear on upstream.

Thanks.

 include/linux/vmalloc.h |    2 ++
 mm/vmalloc.c            |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..3c123c3 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -115,9 +115,11 @@ extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
+#ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
 				     size_t align, gfp_t gfp_mask);
+#endif
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0f551a4..7758726 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1993,6 +1993,7 @@ void free_vm_area(struct vm_struct *area)
 }
 EXPORT_SYMBOL_GPL(free_vm_area);
 
+#ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 static struct vmap_area *node_to_va(struct rb_node *n)
 {
 	return n ? rb_entry(n, struct vmap_area, rb_node) : NULL;
@@ -2257,6 +2258,7 @@ err_free:
 	kfree(vms);
 	return NULL;
 }
+#endif
 
 /**
  * pcpu_free_vm_areas - free vmalloc areas for percpu allocator
