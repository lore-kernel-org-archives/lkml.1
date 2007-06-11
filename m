Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbXFKUdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbXFKUdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXFKUd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:33:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:42163 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXFKUd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=p1osyvtj9ijcJ2vKSQAudiSz88GvCZVgCWeJdWb8KnC6VsC0ScTGPNcv8NjbZX/LO0MLfHt2eQmd7DQ25SvVFUgRjeTfMbn7Pf91gsyWpt37UUb9r3RxQigHpmkknmvQToR/xqqToa8FQWbmvQpvZNxFnWUPTQjX82l0t0RR4EQ=
Date: Tue, 12 Jun 2007 00:40:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, hch@lst.de
Subject: [PATCH 1/2] PTRACE_PEEKDATA consolidation
Message-ID: <20070611204006.GC5715@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Identical implementations of PTRACE_PEEKDATA go into
simple_ptrace_peekdata() function.

compile-tested on ~half of archs, playing with gdb on x86_64.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/kernel/ptrace.c           |    8 +-------
 arch/arm26/kernel/ptrace.c         |    8 +-------
 arch/avr32/kernel/ptrace.c         |    7 +------
 arch/cris/arch-v10/kernel/ptrace.c |   14 ++------------
 arch/frv/kernel/ptrace.c           |   12 ++----------
 arch/i386/kernel/ptrace.c          |   12 ++----------
 arch/m32r/kernel/ptrace.c          |    7 +------
 arch/m68k/kernel/ptrace.c          |    5 +----
 arch/m68knommu/kernel/ptrace.c     |   12 ++----------
 arch/mips/kernel/ptrace.c          |   12 ++----------
 arch/parisc/kernel/ptrace.c        |   13 ++-----------
 arch/powerpc/kernel/ptrace.c       |   12 ++----------
 arch/s390/kernel/ptrace.c          |    6 +-----
 arch/sh/kernel/ptrace.c            |   12 ++----------
 arch/sh64/kernel/ptrace.c          |   12 ++----------
 arch/um/kernel/ptrace.c            |   12 ++----------
 arch/v850/kernel/ptrace.c          |    8 ++------
 arch/x86_64/kernel/ptrace.c        |   12 ++----------
 arch/xtensa/kernel/ptrace.c        |   12 +-----------
 include/linux/ptrace.h             |    1 +
 kernel/ptrace.c                    |   11 +++++++++++
 21 files changed, 43 insertions(+), 165 deletions(-)

--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -657,7 +657,6 @@ static int ptrace_setcrunchregs(struct task_struct *tsk, void __user *ufp)
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	switch (request) {
@@ -666,12 +665,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 */
 		case PTRACE_PEEKTEXT:
 		case PTRACE_PEEKDATA:
-			ret = access_process_vm(child, addr, &tmp,
-						sizeof(unsigned long), 0);
-			if (ret == sizeof(unsigned long))
-				ret = put_user(tmp, (unsigned long __user *) data);
-			else
-				ret = -EIO;
+			ret = simple_ptrace_peekdata(child, addr, data);
 			break;
 
 		case PTRACE_PEEKUSR:
--- a/arch/arm26/kernel/ptrace.c
+++ b/arch/arm26/kernel/ptrace.c
@@ -531,7 +531,6 @@ static int ptrace_setfpregs(struct task_struct *tsk, void *ufp)
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	switch (request) {
@@ -540,12 +539,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 */
 		case PTRACE_PEEKTEXT:
 		case PTRACE_PEEKDATA:
-			ret = access_process_vm(child, addr, &tmp,
-						sizeof(unsigned long), 0);
-			if (ret == sizeof(unsigned long))
-				ret = put_user(tmp, (unsigned long *) data);
-			else
-				ret = -EIO;
+			ret = simple_ptrace_peekdata(child, addr, data);
 			break;
 
 		case PTRACE_PEEKUSR:
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -153,7 +153,6 @@ static int ptrace_setregs(struct task_struct *tsk, const void __user *uregs)
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	pr_debug("arch_ptrace(%ld, %d, %#lx, %#lx)\n",
@@ -166,11 +165,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* Read the word at location addr in the child process */
 	case PTRACE_PEEKTEXT:
 	case PTRACE_PEEKDATA:
-		ret = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (ret == sizeof(tmp))
-			ret = put_user(tmp, (unsigned long __user *)data);
-		else
-			ret = -EIO;
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
 
 	case PTRACE_PEEKUSR:
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -83,19 +83,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 		/* Read word at location address. */ 
 		case PTRACE_PEEKTEXT:
-		case PTRACE_PEEKDATA: {
-			unsigned long tmp;
-			int copied;
-
-			copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-			ret = -EIO;
-			
-			if (copied != sizeof(tmp))
-				break;
-			
-			ret = put_user(tmp,datap);
+		case PTRACE_PEEKDATA:
+			ret = simple_ptrace_peekdata(child, addr, data);
 			break;
-		}
 
 		/* Read the word at location address in the USER area. */
 		case PTRACE_PEEKUSR: {
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -112,20 +112,12 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		int copied;
-
+	case PTRACE_PEEKDATA:
 		ret = -EIO;
 		if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
 			break;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			break;
-
-		ret = put_user(tmp,(unsigned long *) data);
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 		/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -358,17 +358,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, datap);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -595,7 +595,6 @@ void ptrace_disable(struct task_struct *child)
 static int
 do_ptrace(long request, struct task_struct *child, long addr, long data)
 {
-	unsigned long tmp;
 	int ret;
 
 	switch (request) {
@@ -604,11 +603,7 @@ do_ptrace(long request, struct task_struct *child, long addr, long data)
 	 */
 	case PTRACE_PEEKTEXT:
 	case PTRACE_PEEKDATA:
-		ret = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (ret == sizeof(tmp))
-			ret = put_user(tmp,(unsigned long __user *) data);
-		else
-			ret = -EIO;
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
 
 	/*
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -128,10 +128,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT:	/* read word at location addr. */
 	case PTRACE_PEEKDATA:
-		i = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (i != sizeof(tmp))
-			goto out_eio;
-		ret = put_user(tmp, (unsigned long *)data);
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
 
 	/* read the word at location addr in the USER area. */
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -106,17 +106,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 		case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-		case PTRACE_PEEKDATA: {
-			unsigned long tmp;
-			int copied;
-
-			copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-			ret = -EIO;
-			if (copied != sizeof(tmp))
-				break;
-			ret = put_user(tmp,(unsigned long *) data);
+		case PTRACE_PEEKDATA:
+			ret = simple_ptrace_peekdata(child, addr, data);
 			break;
-		}
 
 		/* read the word at location addr in the USER area. */
 		case PTRACE_PEEKUSR: {
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -174,17 +174,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long __user *) data);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* Read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -87,10 +87,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
 	case PTRACE_PEEKDATA: {
-		int copied;
-
 #ifdef CONFIG_64BIT
 		if (__is_compat_task(child)) {
+			int copied;
 			unsigned int tmp;
 
 			addr &= 0xffffffffL;
@@ -105,15 +104,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		}
 		else
 #endif
-		{
-			unsigned long tmp;
-
-			copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-			ret = -EIO;
-			if (copied != sizeof(tmp))
-				goto out_tsk;
-			ret = put_user(tmp,(unsigned long *) data);
-		}
+			ret = simple_ptrace_peekdata(child, addr, data);
 		goto out_tsk;
 	}
 
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -256,17 +256,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long __user *) data);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -294,7 +294,6 @@ poke_user(struct task_struct *child, addr_t addr, addr_t data)
 static int
 do_ptrace_normal(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long tmp;
 	ptrace_area parea; 
 	int copied, ret;
 
@@ -304,10 +303,7 @@ do_ptrace_normal(struct task_struct *child, long request, long addr, long data)
 		/* Remove high order bit from address (only for 31 bit). */
 		addr &= PSW_ADDR_INSN;
 		/* read word at location addr. */
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			return -EIO;
-		return put_user(tmp, (unsigned long __force __user *) data);
+		return simple_ptrace_peekdata(child, addr, data);
 
 	case PTRACE_PEEKUSR:
 		/* read the word at location addr in the USER area. */
--- a/arch/sh/kernel/ptrace.c
+++ b/arch/sh/kernel/ptrace.c
@@ -91,17 +91,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long *) data);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/sh64/kernel/ptrace.c
+++ b/arch/sh64/kernel/ptrace.c
@@ -129,17 +129,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long *) data);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -52,17 +52,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 		/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		ret = -EIO;
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, p);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
         case PTRACE_PEEKUSR:
--- a/arch/v850/kernel/ptrace.c
+++ b/arch/v850/kernel/ptrace.c
@@ -117,15 +117,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	int rval;
 
 	switch (request) {
-		unsigned long val, copied;
+		unsigned long val;
 
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
 	case PTRACE_PEEKDATA:
-		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
-		rval = -EIO;
-		if (copied != sizeof(val))
-			break;
-		rval = put_user(val, (unsigned long *)data);
+		rval = simple_ptrace_peekdata(child, addr, data);
 		goto out;
 
 	case PTRACE_POKETEXT: /* write the word at location addr. */
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -313,17 +313,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long __user *) data);
+	case PTRACE_PEEKDATA:
+		ret = simple_ptrace_peekdata(child, addr, data);
 		break;
-	}
 
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -50,18 +50,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	switch (request) {
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
 	case PTRACE_PEEKDATA:
-	{
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp,(unsigned long *) data);
-
+		ret = simple_ptrace_peekdata(child, addr, data);
 		goto out;
-	}
 
 	/* Read the word at location addr in the USER area.  */
 
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -110,6 +110,7 @@ static inline void ptrace_unlink(struct task_struct *child)
 		__ptrace_unlink(child);
 }
 
+int simple_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
 
 #ifndef force_successful_syscall_return
 /*
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -491,3 +491,14 @@ asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 	return ret;
 }
 #endif /* __ARCH_SYS_PTRACE */
+
+int simple_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
+{
+	unsigned long tmp;
+	int copied;
+
+	copied = access_process_vm(tsk, addr, &tmp, sizeof(tmp), 0);
+	if (copied != sizeof(tmp))
+		return -EIO;
+	return put_user(tmp, (unsigned long __user *)data);
+}

