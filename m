Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947Ab0ARSuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0ARSuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921Ab0ARSuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:50:11 -0500
Received: from kroah.org ([198.145.64.141]:46235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab0ARSuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:50:07 -0500
Date: Mon, 18 Jan 2010 10:44:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.44
Message-ID: <20100118184438.GB25918@kroah.com>
References: <20100118184421.GA25918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118184421.GA25918@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index dfd6ec4..78f4d74 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .43
+EXTRAVERSION = .44
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index 73cb6a3..15a369e 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -641,10 +641,14 @@ static int emulate_spe(struct pt_regs *regs, unsigned int reg,
  */
 static int emulate_vsx(unsigned char __user *addr, unsigned int reg,
 		       unsigned int areg, struct pt_regs *regs,
-		       unsigned int flags, unsigned int length)
+		       unsigned int flags, unsigned int length,
+		       unsigned int elsize)
 {
 	char *ptr;
+	unsigned long *lptr;
 	int ret = 0;
+	int sw = 0;
+	int i, j;
 
 	flush_vsx_to_thread(current);
 
@@ -653,19 +657,35 @@ static int emulate_vsx(unsigned char __user *addr, unsigned int reg,
 	else
 		ptr = (char *) &current->thread.vr[reg - 32];
 
-	if (flags & ST)
-		ret = __copy_to_user(addr, ptr, length);
-        else {
-		if (flags & SPLT){
-			ret = __copy_from_user(ptr, addr, length);
-			ptr += length;
+	lptr = (unsigned long *) ptr;
+
+	if (flags & SW)
+		sw = elsize-1;
+
+	for (j = 0; j < length; j += elsize) {
+		for (i = 0; i < elsize; ++i) {
+			if (flags & ST)
+				ret |= __put_user(ptr[i^sw], addr + i);
+			else
+				ret |= __get_user(ptr[i^sw], addr + i);
 		}
-		ret |= __copy_from_user(ptr, addr, length);
+		ptr  += elsize;
+		addr += elsize;
 	}
-	if (flags & U)
-		regs->gpr[areg] = regs->dar;
-	if (ret)
+
+	if (!ret) {
+		if (flags & U)
+			regs->gpr[areg] = regs->dar;
+
+		/* Splat load copies the same data to top and bottom 8 bytes */
+		if (flags & SPLT)
+			lptr[1] = lptr[0];
+		/* For 8 byte loads, zero the top 8 bytes */
+		else if (!(flags & ST) && (8 == length))
+			lptr[1] = 0;
+	} else
 		return -EFAULT;
+
 	return 1;
 }
 #endif
@@ -764,16 +784,25 @@ int fix_alignment(struct pt_regs *regs)
 
 #ifdef CONFIG_VSX
 	if ((instruction & 0xfc00003e) == 0x7c000018) {
-		/* Additional register addressing bit (64 VSX vs 32 FPR/GPR */
+		unsigned int elsize;
+
+		/* Additional register addressing bit (64 VSX vs 32 FPR/GPR) */
 		reg |= (instruction & 0x1) << 5;
 		/* Simple inline decoder instead of a table */
+		/* VSX has only 8 and 16 byte memory accesses */
+		nb = 8;
 		if (instruction & 0x200)
 			nb = 16;
-		else if (instruction & 0x080)
-			nb = 8;
-		else
-			nb = 4;
+
+		/* Vector stores in little-endian mode swap individual
+		   elements, so process them separately */
+		elsize = 4;
+		if (instruction & 0x80)
+			elsize = 8;
+
 		flags = 0;
+		if (regs->msr & MSR_LE)
+			flags |= SW;
 		if (instruction & 0x100)
 			flags |= ST;
 		if (instruction & 0x040)
@@ -783,7 +812,7 @@ int fix_alignment(struct pt_regs *regs)
 			flags |= SPLT;
 			nb = 8;
 		}
-		return emulate_vsx(addr, reg, areg, regs, flags, nb);
+		return emulate_vsx(addr, reg, areg, regs, flags, nb, elsize);
 	}
 #endif
 	/* A size of 0 indicates an instruction we don't support, with
diff --git a/arch/powerpc/kernel/fpu.S b/arch/powerpc/kernel/fpu.S
index a088c06..2436df3 100644
--- a/arch/powerpc/kernel/fpu.S
+++ b/arch/powerpc/kernel/fpu.S
@@ -145,6 +145,11 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)
 	beq	1f
 	PPC_LL	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
 	li	r3,MSR_FP|MSR_FE0|MSR_FE1
+#ifdef CONFIG_VSX
+BEGIN_FTR_SECTION
+	oris	r3,r3,MSR_VSX@h
+END_FTR_SECTION_IFSET(CPU_FTR_VSX)
+#endif
 	andc	r4,r4,r3		/* disable FP for previous task */
 	PPC_STL	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
 1:
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 4dd70cf..f6a2372 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -493,7 +493,15 @@ _GLOBAL(giveup_altivec)
 	stvx	vr0,r4,r3
 	beq	1f
 	ld	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
+#ifdef CONFIG_VSX
+BEGIN_FTR_SECTION
+	lis	r3,(MSR_VEC|MSR_VSX)@h
+FTR_SECTION_ELSE
+	lis	r3,MSR_VEC@h
+ALT_FTR_SECTION_END_IFSET(CPU_FTR_VSX)
+#else
 	lis	r3,MSR_VEC@h
+#endif
 	andc	r4,r4,r3		/* disable FP for previous task */
 	std	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
 1:
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 894b599..ef96b29 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -276,7 +276,7 @@ static void untag_chunk(struct node *p)
 		owner->root = NULL;
 	}
 
-	for (i = j = 0; i < size; i++, j++) {
+	for (i = j = 0; j <= size; i++, j++) {
 		struct audit_tree *s;
 		if (&chunk->owners[j] == p) {
 			list_del_init(&p->list);
@@ -289,7 +289,7 @@ static void untag_chunk(struct node *p)
 		if (!s) /* result of earlier fallback */
 			continue;
 		get_tree(s);
-		list_replace_init(&chunk->owners[i].list, &new->owners[j].list);
+		list_replace_init(&chunk->owners[j].list, &new->owners[i].list);
 	}
 
 	list_replace_rcu(&chunk->hash, &new->hash);
@@ -372,15 +372,17 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	for (n = 0; n < old->count; n++) {
 		if (old->owners[n].owner == tree) {
 			spin_unlock(&hash_lock);
-			put_inotify_watch(watch);
+			put_inotify_watch(&old->watch);
 			return 0;
 		}
 	}
 	spin_unlock(&hash_lock);
 
 	chunk = alloc_chunk(old->count + 1);
-	if (!chunk)
+	if (!chunk) {
+		put_inotify_watch(&old->watch);
 		return -ENOMEM;
+	}
 
 	mutex_lock(&inode->inotify_mutex);
 	if (inotify_clone_watch(&old->watch, &chunk->watch) < 0) {
@@ -422,7 +424,8 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&hash_lock);
 	inotify_evict_watch(&old->watch);
 	mutex_unlock(&inode->inotify_mutex);
-	put_inotify_watch(&old->watch);
+	put_inotify_watch(&old->watch); /* pair to inotify_find_watch */
+	put_inotify_watch(&old->watch); /* and kill it */
 	return 0;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index de2b649..efcdc95 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -884,7 +884,8 @@ static void print_fatal_signal(struct pt_regs *regs, int signr)
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
-			__get_user(insn, (unsigned char *)(regs->ip + i));
+			if (get_user(insn, (unsigned char *)(regs->ip + i)))
+				break;
 			printk("%02x ", insn);
 		}
 	}
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 32afff8..d6beca9 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1436,6 +1436,9 @@ static int do_ebt_set_ctl(struct sock *sk,
 {
 	int ret;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch(cmd) {
 	case EBT_SO_SET_ENTRIES:
 		ret = do_replace(user, len);
@@ -1455,6 +1458,9 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	struct ebt_replace tmp;
 	struct ebt_table *t;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
 
