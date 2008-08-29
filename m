Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYH2WI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYH2WI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYH2WIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:08:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25202 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYH2WIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fkJ6++VovHvNH5UMaKP9gv+xs2UIRKo+dSX6T9Hd+D3tSVWgHA+biViOvNkFL8NUiN
         q+f2/IiOrKzvccLorSpBJt/JhL8Wlhrqnv+BByvHWt57ILfnpiqQYPahSiwzWv3vvn+g
         cElWb/0YjnrRvT1CGCHWGe4BLANo98L1sP1wQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] dyn_array: using %pF instead of print_fn_descriptor_symbol
Date: Fri, 29 Aug 2008 15:07:49 -0700
Message-Id: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


diff --git a/init/dyn_array.c b/init/dyn_array.c
index c4cd902..e85b1d6 100644
--- a/init/dyn_array.c
+++ b/init/dyn_array.c
@@ -17,10 +17,9 @@ void __init pre_alloc_dyn_array(void)
 	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
+		printk(KERN_DEBUG "dyn_array %pF size:%#lx nr:%d align:%#lx\n",
+			da->name, da->size, *da->nr, da->align);
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyn_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
-			da->size, *da->nr, da->align);
 		total_size += roundup(size, da->align);
 		if (da->align > max_align)
 			max_align = da->align;
@@ -42,11 +41,10 @@ void __init pre_alloc_dyn_array(void)
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyn_array %s ", da->name);
-
 		phys = roundup(phys, da->align);
+		printk(KERN_DEBUG "dyn_array %pF ==> [%#lx - %#lx]\n",
+			da->name, phys, phys + size);
 		*da->name = phys_to_virt(phys);
-		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
 
 		phys += size;
 
@@ -74,10 +72,9 @@ unsigned long __init per_cpu_dyn_array_size(unsigned long *align)
 	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
+		printk(KERN_DEBUG "per_cpu_dyn_array %pF size:%#lx nr:%d align:%#lx\n",
+			da->name, da->size, *da->nr, da->align);
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
-			da->size, *da->nr, da->align);
 		total_size += roundup(size, da->align);
 		if (da->align > max_align)
 			max_align = da->align;
@@ -104,15 +101,15 @@ void __init per_cpu_alloc_dyn_array(int cpu, char *ptr)
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
-
 		phys = roundup(phys, da->align);
+		printk(KERN_DEBUG "per_cpu_dyn_array %pF ==> [%#lx - %#lx]\n",
+			da->name, phys, phys + size);
+
 		addr = (unsigned long)da->name;
 		addr += per_cpu_offset(cpu);
 		array = (void **)addr;
 		*array = phys_to_virt(phys);
 		*da->name = *array; /* so init_work could use it directly */
-		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
 
 		phys += size;
 
