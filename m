Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZGPJSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZGPJSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZGPJSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:18:38 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:53047 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZGPJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AA+2l6pXPpotLsab9xsoUf+OfCTnCHl+bQBo/ZhXohlDQ03XuaVseZHdv5Qm0UJtfk
         RtKucVydjWXLHOQyXUnYMVuVKXIf6lcQYUpHWe7NlLH2h6pHQ3NTd0vNW1XRWyAWJU6u
         6+xg3dbJv8Ebxf8DjzUA/5VQDg4g8irYMJnbE=
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 17:18:37 +0800
Message-ID: <3877989d0907160218l4a28791v90ad22cc048c3440@mail.gmail.com>
Subject: [RFC patch] delete improper hot pluggable code of memory affinity
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd22f281f4ae6046ecf2852
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd22f281f4ae6046ecf2852
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

The current kernel code *wrongly* interprets Hot Pluggable bit of
Memory Affinity Structure (SRAT table in ACPI spec).
if Hot Pluggable bit is set and CONFIG_MEMORY_HOTPLUG_SPARSE is NOT
set, the memory Affinity will
be ignored. And a faked Node will be used...

An alternative is to enable CONFIG_MEMORY_HOTPLUG_SPARSE *always*
along with acpi_numa_memory_affinity_init.
Please decide which one is appropriate.

The downside of this patch is *some useful info* is lost and a follow
up patch is needed.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming


Signed-off-by: Yu Luming <luming.yu@intel.com>

 srat_64.c |   16 ----------------
 1 file changed, 16 deletions(-)


diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 2dfcbf9..82423e5 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -172,11 +172,6 @@ acpi_numa_processor_affinity_init(struct
acpi_srat_cpu_affinity *pa)
 	       pxm, apic_id, node);
 }

-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-static inline int save_add_info(void) {return 1;}
-#else
-static inline int save_add_info(void) {return 0;}
-#endif
 /*
  * Update nodes_add[]
  * This code supports one contiguous hot add area per node
@@ -249,9 +244,6 @@ acpi_numa_memory_affinity_init(struct
acpi_srat_mem_affinity *ma)
 	}
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		return;
-
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		return;
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
@@ -291,14 +283,6 @@ acpi_numa_memory_affinity_init(struct
acpi_srat_mem_affinity *ma)
 	e820_register_active_regions(node, start >> PAGE_SHIFT,
 				     end >> PAGE_SHIFT);

-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
-		update_nodes_add(node, start, end);
-		/* restore nodes[node] */
-		*nd = oldnode;
-		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
-	}
-
 	node_memblk_range[num_node_memblks].start = start;
 	node_memblk_range[num_node_memblks].end = end;
 	memblk_nodeid[num_node_memblks] = node;

--000e0cd22f281f4ae6046ecf2852
Content-Type: application/octet-stream; name="0.patch"
Content-Disposition: attachment; filename="0.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fx79g3yw0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3NyYXRfNjQuYyBiL2FyY2gveDg2L21tL3NyYXRfNjQu
YwppbmRleCAyZGZjYmY5Li44MjQyM2U1IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9tbS9zcmF0XzY0
LmMKKysrIGIvYXJjaC94ODYvbW0vc3JhdF82NC5jCkBAIC0xNzIsMTEgKzE3Miw2IEBAIGFjcGlf
bnVtYV9wcm9jZXNzb3JfYWZmaW5pdHlfaW5pdChzdHJ1Y3QgYWNwaV9zcmF0X2NwdV9hZmZpbml0
eSAqcGEpCiAJICAgICAgIHB4bSwgYXBpY19pZCwgbm9kZSk7CiB9CiAKLSNpZmRlZiBDT05GSUdf
TUVNT1JZX0hPVFBMVUdfU1BBUlNFCi1zdGF0aWMgaW5saW5lIGludCBzYXZlX2FkZF9pbmZvKHZv
aWQpIHtyZXR1cm4gMTt9Ci0jZWxzZQotc3RhdGljIGlubGluZSBpbnQgc2F2ZV9hZGRfaW5mbyh2
b2lkKSB7cmV0dXJuIDA7fQotI2VuZGlmCiAvKgogICogVXBkYXRlIG5vZGVzX2FkZFtdCiAgKiBU
aGlzIGNvZGUgc3VwcG9ydHMgb25lIGNvbnRpZ3VvdXMgaG90IGFkZCBhcmVhIHBlciBub2RlCkBA
IC0yNDksOSArMjQ0LDYgQEAgYWNwaV9udW1hX21lbW9yeV9hZmZpbml0eV9pbml0KHN0cnVjdCBh
Y3BpX3NyYXRfbWVtX2FmZmluaXR5ICptYSkKIAl9CiAJaWYgKChtYS0+ZmxhZ3MgJiBBQ1BJX1NS
QVRfTUVNX0VOQUJMRUQpID09IDApCiAJCXJldHVybjsKLQotCWlmICgobWEtPmZsYWdzICYgQUNQ
SV9TUkFUX01FTV9IT1RfUExVR0dBQkxFKSAmJiAhc2F2ZV9hZGRfaW5mbygpKQotCQlyZXR1cm47
CiAJc3RhcnQgPSBtYS0+YmFzZV9hZGRyZXNzOwogCWVuZCA9IHN0YXJ0ICsgbWEtPmxlbmd0aDsK
IAlweG0gPSBtYS0+cHJveGltaXR5X2RvbWFpbjsKQEAgLTI5MSwxNCArMjgzLDYgQEAgYWNwaV9u
dW1hX21lbW9yeV9hZmZpbml0eV9pbml0KHN0cnVjdCBhY3BpX3NyYXRfbWVtX2FmZmluaXR5ICpt
YSkKIAllODIwX3JlZ2lzdGVyX2FjdGl2ZV9yZWdpb25zKG5vZGUsIHN0YXJ0ID4+IFBBR0VfU0hJ
RlQsCiAJCQkJICAgICBlbmQgPj4gUEFHRV9TSElGVCk7CiAKLQlpZiAobWEtPmZsYWdzICYgQUNQ
SV9TUkFUX01FTV9IT1RfUExVR0dBQkxFKSB7Ci0JCXVwZGF0ZV9ub2Rlc19hZGQobm9kZSwgc3Rh
cnQsIGVuZCk7Ci0JCS8qIHJlc3RvcmUgbm9kZXNbbm9kZV0gKi8KLQkJKm5kID0gb2xkbm9kZTsK
LQkJaWYgKChuZC0+c3RhcnQgfCBuZC0+ZW5kKSA9PSAwKQotCQkJbm9kZV9jbGVhcihub2RlLCBu
b2Rlc19wYXJzZWQpOwotCX0KLQogCW5vZGVfbWVtYmxrX3JhbmdlW251bV9ub2RlX21lbWJsa3Nd
LnN0YXJ0ID0gc3RhcnQ7CiAJbm9kZV9tZW1ibGtfcmFuZ2VbbnVtX25vZGVfbWVtYmxrc10uZW5k
ID0gZW5kOwogCW1lbWJsa19ub2RlaWRbbnVtX25vZGVfbWVtYmxrc10gPSBub2RlOwo=
--000e0cd22f281f4ae6046ecf2852--
