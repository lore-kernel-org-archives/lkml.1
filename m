Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0BATT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:19:29 -0500
Received: from verein.lst.de ([213.95.11.210]:39475 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0BATT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:19:27 -0500
Date: Mon, 1 Feb 2010 20:19:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com
Cc: akpm@linux-foundation.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] use ptrace_request to handle {PEEK,POKE}{TEXT,DATA}
Message-ID: <20100201191906.GB11874@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call generic_ptrace_peekdata/generic_ptrace_pokedata or even
opencoding it when we can leave that to ptrace_request.  Excepted are
those architecures not calling ptrace_request at all (m68knommu, h8300
and microblaze), and those having weird ABIs (alpha for the peek variants)
or needing additional cache flushing.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/arm/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ptrace.c	2010-01-15 23:53:14.699003982 +0100
+++ linux-2.6/arch/arm/kernel/ptrace.c	2010-01-26 17:43:49.134004189 +0100
@@ -715,23 +715,10 @@ long arch_ptrace(struct task_struct *chi
 		/*
 		 * read word at location "addr" in the child process.
 		 */
-		case PTRACE_PEEKTEXT:
-		case PTRACE_PEEKDATA:
-			ret = generic_ptrace_peekdata(child, addr, data);
-			break;
-
 		case PTRACE_PEEKUSR:
 			ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
 			break;
 
-		/*
-		 * write the word at location addr.
-		 */
-		case PTRACE_POKETEXT:
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
-
 		case PTRACE_POKEUSR:
 			ret = ptrace_write_user(child, addr, data);
 			break;
Index: linux-2.6/arch/avr32/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/ptrace.c	2010-01-15 23:53:14.708003943 +0100
+++ linux-2.6/arch/avr32/kernel/ptrace.c	2010-01-26 17:43:49.142004787 +0100
@@ -147,22 +147,11 @@ long arch_ptrace(struct task_struct *chi
 
 	switch (request) {
 	/* Read the word at location addr in the child process */
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	case PTRACE_PEEKUSR:
 		ret = ptrace_read_user(child, addr,
 				       (unsigned long __user *)data);
 		break;
 
-	/* Write the word in data at location addr */
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	case PTRACE_POKEUSR:
 		ret = ptrace_write_user(child, addr, data);
 		break;
Index: linux-2.6/arch/cris/arch-v10/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/ptrace.c	2010-01-15 23:53:14.725004085 +0100
+++ linux-2.6/arch/cris/arch-v10/kernel/ptrace.c	2010-01-26 17:43:49.154004008 +0100
@@ -82,12 +82,6 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
-		/* Read word at location address. */ 
-		case PTRACE_PEEKTEXT:
-		case PTRACE_PEEKDATA:
-			ret = generic_ptrace_peekdata(child, addr, data);
-			break;
-
 		/* Read the word at location address in the USER area. */
 		case PTRACE_PEEKUSR: {
 			unsigned long tmp;
@@ -101,12 +95,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 		
-		/* Write the word at location address. */
-		case PTRACE_POKETEXT:
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
- 
  		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
Index: linux-2.6/arch/cris/arch-v32/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/ptrace.c	2010-01-15 23:53:14.734023252 +0100
+++ linux-2.6/arch/cris/arch-v32/kernel/ptrace.c	2010-01-26 17:43:49.171004353 +0100
@@ -143,12 +143,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-		/* Write the word at location address. */
-		case PTRACE_POKETEXT:
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
-
 		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
Index: linux-2.6/arch/m32r/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/ptrace.c	2010-01-15 23:53:14.757254286 +0100
+++ linux-2.6/arch/m32r/kernel/ptrace.c	2010-01-26 17:43:49.196003900 +0100
@@ -598,14 +598,6 @@ arch_ptrace(struct task_struct *child, l
 
 	switch (request) {
 	/*
-	 * read word at location "addr" in the child process.
-	 */
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
-	/*
 	 * read the word at location addr in the USER area.
 	 */
 	case PTRACE_PEEKUSR:
@@ -617,9 +609,8 @@ arch_ptrace(struct task_struct *child, l
 	 * write the word at location addr.
 	 */
 	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
 		ret = generic_ptrace_pokedata(child, addr, data);
-		if (ret == 0 && request == PTRACE_POKETEXT)
+		if (ret == 0)
 			invalidate_cache();
 		break;
 
Index: linux-2.6/arch/microblaze/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/ptrace.c	2010-01-15 23:53:14.776253915 +0100
+++ linux-2.6/arch/microblaze/kernel/ptrace.c	2010-01-26 17:49:02.239254508 +0100
@@ -78,26 +78,6 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long copied;
 
 	switch (request) {
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
-		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
-		rval = -EIO;
-		if (copied != sizeof(val))
-			break;
-		rval = put_user(val, (unsigned long *)data);
-		break;
-
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
-		rval = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		rval = -EIO;
-		break;
-
 	/* Read/write the word at location ADDR in the registers. */
 	case PTRACE_PEEKUSR:
 	case PTRACE_POKEUSR:
Index: linux-2.6/arch/mips/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/ptrace.c	2010-01-15 23:53:14.792004038 +0100
+++ linux-2.6/arch/mips/kernel/ptrace.c	2010-01-26 17:43:49.253004303 +0100
@@ -260,12 +260,6 @@ long arch_ptrace(struct task_struct *chi
 	int ret;
 
 	switch (request) {
-	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	/* Read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
 		struct pt_regs *regs;
@@ -390,12 +384,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 
-	/* when I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	case PTRACE_POKEUSR: {
 		struct pt_regs *regs;
 		ret = 0;
Index: linux-2.6/arch/um/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/ptrace.c	2010-01-15 23:53:14.844003754 +0100
+++ linux-2.6/arch/um/kernel/ptrace.c	2010-01-26 17:43:49.276003735 +0100
@@ -42,23 +42,11 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long __user *p = (void __user *)(unsigned long)data;
 
 	switch (request) {
-	/* read word at location addr. */
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		ret = peek_user(child, addr, data);
 		break;
 
-	/* write the word at location addr. */
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
 		ret = poke_user(child, addr, data);
Index: linux-2.6/arch/xtensa/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/ptrace.c	2010-01-15 23:53:14.852004145 +0100
+++ linux-2.6/arch/xtensa/kernel/ptrace.c	2010-01-26 17:43:49.315254186 +0100
@@ -250,20 +250,10 @@ long arch_ptrace(struct task_struct *chi
 	int ret = -EPERM;
 
 	switch (request) {
-	case PTRACE_PEEKTEXT:	/* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	case PTRACE_PEEKUSR:	/* read register specified by addr. */
 		ret = ptrace_peekusr(child, addr, (void __user *) data);
 		break;
 
-	case PTRACE_POKETEXT:	/* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	case PTRACE_POKEUSR:	/* write register specified by addr. */
 		ret = ptrace_pokeusr(child, addr, data);
 		break;
Index: linux-2.6/arch/alpha/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/ptrace.c	2010-01-15 23:53:14.691006315 +0100
+++ linux-2.6/arch/alpha/kernel/ptrace.c	2010-01-26 17:43:49.334254716 +0100
@@ -285,12 +285,6 @@ long arch_ptrace(struct task_struct *chi
 		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
 		break;
 
-	/* When I and D space are separate, this will have to be fixed.  */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	case PTRACE_POKEUSR: /* write the specified register */
 		DBG(DBG_MEM, ("poke $%ld<-%#lx\n", addr, data));
 		ret = put_reg(child, addr, data);
