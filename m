Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYJLNwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYJLNwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYJLNwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:52:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:60420 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYJLNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xmorAW6zebH69X3NZydKsS4pji9cnny5vQruynSUWLEc7Wtdy3EyoQ8Gu0R813BYSw
         w83xc2zARXrQWFMiJbIqlRAWWM2xQFndMOJqxxnW/hq7OfEBuzUs3/VZzi/w09o2YYDs
         ls3gPtWg+x+PZYAo4fVM5TctL2qQ0NizJ3anM=
Message-ID: <fbd277f20810120652o607cddcbse398c9b40f0892aa@mail.gmail.com>
Date: Sun, 12 Oct 2008 21:52:12 +0800
From: "bibo mao" <bibo.mao@gmail.com>
To: akpm@linux-foundation.org
Subject: [patch 1/1]pat: fix type check error on chk_conflict function
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On chk_conflict() function, if new->type does not match entry->type
  and type is not NULL, this does not go through conflict path. This
  patch fix this bug.

 Signed-off-by:  bibo.mao@gmail.com

----------------------------------------------------------------------
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 12cac5e..0632308 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -183,28 +183,29 @@ static unsigned long pat_x_mtrr_type(u64 start,
u64 end, unsigned long req_type)
 static int chk_conflict(struct memtype *new, struct memtype *entry,
 			unsigned long *type)
 {
-	if (new->type != entry->type) {
-		if (type) {
-			new->type = entry->type;
-			*type = entry->type;
-		} else
-			goto conflict;
-	}
+	int err = -EBUSY;
+
+	if (new->type != entry->type)
+		goto conflict;

 	 /* check overlaps with more than one entry in the list */
 	list_for_each_entry_continue(entry, &memtype_list, nd) {
 		if (new->end <= entry->start)
 			break;
-		else if (new->type != entry->type)
+		else if (new->type != entry->type) {
+			err = -EINVAL;
 			goto conflict;
+		}
 	}
 	return 0;

  conflict:
+	if (type)
+		*type = entry->type;
 	printk(KERN_INFO "%s:%d conflicting memory types "
 	       "%Lx-%Lx %s<->%s\n", current->comm, current->pid, new->start,
 	       new->end, cattr_name(new->type), cattr_name(entry->type));
-	return -EBUSY;
+	return err;
 }

 static struct memtype *cached_entry;
@@ -278,9 +279,6 @@ int reserve_memtype(u64 start, u64 end, unsigned
long req_type,
 	new->end = end;
 	new->type = actual_type;

-	if (new_type)
-		*new_type = actual_type;
-
 	spin_lock(&memtype_lock);

 	if (cached_entry && start >= cached_start)
@@ -326,6 +324,9 @@ int reserve_memtype(u64 start, u64 end, unsigned
long req_type,

 	spin_unlock(&memtype_lock);

+	if (new_type)
+		*new_type = actual_type;
+
 	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
 		start, end, cattr_name(new->type), cattr_name(req_type),
 		new_type ? cattr_name(*new_type) : "-");
@@ -474,15 +475,22 @@ void map_devmem(unsigned long pfn, unsigned long
size, pgprot_t vma_prot)
 	u64 addr = (u64)pfn << PAGE_SHIFT;
 	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+	int err;

-	reserve_memtype(addr, addr + size, want_flags, &flags);
-	if (flags != want_flags) {
+	err = reserve_memtype(addr, addr + size, want_flags, &flags);
+	if (err == -EBUSY) {
 		printk(KERN_INFO
 		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
 			current->comm, current->pid,
 			cattr_name(want_flags),
 			addr, (unsigned long long)(addr + size),
 			cattr_name(flags));
+	} else if (err == -EINVAL) {
+		printk(KERN_INFO
+		"%s:%d /dev/mem has both mapping type %s and %s for %Lx-%Lx \n",
+			current->comm, current->pid,
+			cattr_name(want_flags), cattr_name(flags),
+			addr, (unsigned long long)(addr + size));
 	}
 }
