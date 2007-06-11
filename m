Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbXFKUeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbXFKUeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXFKUeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:34:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:42468 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbXFKUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ngJDhXTkI2TgqWeFxDPF2HEW3y1AdcRMKUHaBkzMTENpm+rcb4RsC3y1zQIF82xV6ags+8cvBnmcGixCqeW9BRh4ypP+SC7xUJ6reKaVq4oYzAeXZH2oA8z/Ou/3jQVISjfbB1MInZf9wJXq8aTug3VQ0f3Ab732/KT8oETbXug=
Date: Tue, 12 Jun 2007 00:40:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, hch@lst.de
Subject: [PATCH 2/2] PTRACE_POKEDATA consolidation
Message-ID: <20070611204043.GD5715@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Identical implementations of PTRACE_POKEDATA go into
simple_ptrace_pokedata() function.

AFAICS, fix bug on xtensa where successful PTRACE_POKEDATA will nevertheless
return EPERM.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/ptrace.c         |    4 +---
 arch/arm/kernel/ptrace.c           |    7 +------
 arch/arm26/kernel/ptrace.c         |    7 +------
 arch/avr32/kernel/ptrace.c         |    6 +-----
 arch/cris/arch-v10/kernel/ptrace.c |    7 +------
 arch/cris/arch-v32/kernel/ptrace.c |    7 +------
 arch/frv/kernel/ptrace.c           |    4 +---
 arch/h8300/kernel/ptrace.c         |    5 +----
 arch/i386/kernel/ptrace.c          |    5 +----
 arch/m32r/kernel/ptrace.c          |   12 +++---------
 arch/m68k/kernel/ptrace.c          |    3 +--
 arch/m68knommu/kernel/ptrace.c     |    5 +----
 arch/mips/kernel/ptrace.c          |    6 +-----
 arch/powerpc/kernel/ptrace.c       |    6 +-----
 arch/s390/kernel/ptrace.c          |    5 +----
 arch/sh/kernel/ptrace.c            |    5 +----
 arch/sh64/kernel/ptrace.c          |    5 +----
 arch/um/kernel/ptrace.c            |    6 +-----
 arch/v850/kernel/ptrace.c          |    6 +-----
 arch/x86_64/kernel/ptrace.c        |    5 +----
 arch/xtensa/kernel/ptrace.c        |    5 +----
 include/linux/ptrace.h             |    1 +
 kernel/ptrace.c                    |    8 ++++++++
 23 files changed, 32 insertions(+), 98 deletions(-)

--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -315,9 +315,7 @@ do_sys_ptrace(long request, long pid, long addr, long data,
 	/* When I and D space are separate, this will have to be fixed.  */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		tmp = data;
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 1);
-		ret = (copied == sizeof(tmp)) ? 0 : -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the specified register */
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -677,12 +677,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = access_process_vm(child, addr, &data,
-						sizeof(unsigned long), 1);
-			if (ret == sizeof(unsigned long))
-				ret = 0;
-			else
-				ret = -EIO;
+			ret = simple_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR:
--- a/arch/arm26/kernel/ptrace.c
+++ b/arch/arm26/kernel/ptrace.c
@@ -551,12 +551,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = access_process_vm(child, addr, &data,
-						sizeof(unsigned long), 1);
-			if (ret == sizeof(unsigned long))
-				ret = 0;
-			else
-				ret = -EIO;
+			ret = simple_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR:
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -176,11 +176,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* Write the word in data at location addr */
 	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
-		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
-		if (ret == sizeof(data))
-			ret = 0;
-		else
-			ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR:
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -103,12 +103,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		/* Write the word at location address. */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = 0;
-			
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-			
-			ret = -EIO;
+			ret = simple_ptrace_pokedata(child, addr, data);
 			break;
  
  		/* Write the word at location address in the USER area. */
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -146,12 +146,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		/* Write the word at location address. */
 		case PTRACE_POKETEXT:
 		case PTRACE_POKEDATA:
-			ret = 0;
-
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-
-			ret = -EIO;
+			ret = simple_ptrace_pokedata(child, addr, data);
 			break;
 
  		/* Write the word at location address in the USER area. */
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -168,9 +168,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = -EIO;
 		if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
 			break;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) != sizeof(data))
-			break;
-		ret = 0;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -111,10 +111,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
       /* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKETEXT: /* write the word at location addr. */
 		case PTRACE_POKEDATA:
-			ret = 0;
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-			ret = -EIO;
+			ret = simple_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -387,10 +387,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -619,15 +619,9 @@ do_ptrace(long request, struct task_struct *child, long addr, long data)
 	 */
 	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
-		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
-		if (ret == sizeof(data)) {
-			ret = 0;
-			if (request == PTRACE_POKETEXT) {
-				invalidate_cache();
-			}
-		} else {
-			ret = -EIO;
-		}
+		ret = simple_ptrace_pokedata(child, addr, data);
+		if (ret == 0 && request == PTRACE_POKETEXT)
+			invalidate_cache();
 		break;
 
 	/*
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -157,8 +157,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT:	/* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) != sizeof(data))
-			goto out_eio;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR:	/* write the word at location addr in the USER area */
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -151,10 +151,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		/* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKETEXT: /* write the word at location addr. */
 		case PTRACE_POKEDATA:
-			ret = 0;
-			if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-				break;
-			ret = -EIO;
+			ret = simple_ptrace_pokedata(child, addr, data);
 			break;
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -305,11 +305,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: {
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -292,11 +292,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* If I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-				== sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	/* write the word at location addr in the USER area */
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -314,10 +314,7 @@ do_ptrace_normal(struct task_struct *child, long request, long addr, long data)
 		/* Remove high order bit from address (only for 31 bit). */
 		addr &= PSW_ADDR_INSN;
 		/* write the word at location addr. */
-		copied = access_process_vm(child, addr, &data, sizeof(data),1);
-		if (copied != sizeof(data))
-			return -EIO;
-		return 0;
+		return simple_ptrace_pokedata(child, addr, data);
 
 	case PTRACE_POKEUSR:
 		/* write the word at location addr in the USER area */
--- a/arch/sh/kernel/ptrace.c
+++ b/arch/sh/kernel/ptrace.c
@@ -127,10 +127,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/sh64/kernel/ptrace.c
+++ b/arch/sh64/kernel/ptrace.c
@@ -158,10 +158,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR:
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -64,11 +64,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = -EIO;
-		if (access_process_vm(child, addr, &data, sizeof(data), 
-				      1) != sizeof(data))
-			break;
-		ret = 0;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/v850/kernel/ptrace.c
+++ b/arch/v850/kernel/ptrace.c
@@ -126,11 +126,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		rval = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		rval = -EIO;
+		rval = simple_ptrace_pokedata(child, addr, data);
 		goto out;
 
 	/* Read/write the word at location ADDR in the registers.  */
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -359,10 +359,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -128,10 +128,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKETEXT: /* write the word at location addr. */
 	case PTRACE_POKEDATA:
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		ret = -EIO;
+		ret = simple_ptrace_pokedata(child, addr, data);
 		goto out;
 
 	case PTRACE_POKEUSR:
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -111,6 +111,7 @@ static inline void ptrace_unlink(struct task_struct *child)
 }
 
 int simple_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
+int simple_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 
 #ifndef force_successful_syscall_return
 /*
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -502,3 +502,11 @@ int simple_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
 		return -EIO;
 	return put_user(tmp, (unsigned long __user *)data);
 }
+
+int simple_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
+{
+	int copied;
+
+	copied = access_process_vm(tsk, addr, &data, sizeof(data), 1);
+	return (copied == sizeof(data)) ? 0 : -EIO;
+}

