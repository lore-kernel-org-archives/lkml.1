Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXLTMCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXLTMCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760871AbXLTMAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760133AbXLTMAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 23/43] powerpc compat_ptrace_request
Message-Id: <20071220115849.4CD4626F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes some duplicated code by calling the new generic
compat_ptrace_request from powerpc's compat_sys_ptrace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace32.c |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index fea6206..6612304 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -27,6 +27,7 @@
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/signal.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -112,20 +113,6 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		goto out_tsk;
 
 	switch (request) {
-	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned int tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, (u32 __user *)data);
-		break;
-	}
-
 	/*
 	 * Read 4 bytes of the other process' storage
 	 *  data is a pointer specifying where the user wants the
@@ -225,19 +212,6 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		break;
 	}
 
-	/* If I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA: {
-		unsigned int tmp;
-		tmp = data;
-		ret = 0;
-		if (access_process_vm(child, addr, &tmp, sizeof(tmp), 1)
-				== sizeof(tmp))
-			break;
-		ret = -EIO;
-		break;
-	}
-
 	/*
 	 * Write 4 bytes into the other process' storage
 	 *  data is the 4 bytes that the user wants written
@@ -337,10 +311,6 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		break;
 	}
 
-	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message, (unsigned int __user *) data);
-		break;
-
 	case PTRACE_GETREGS: { /* Get all pt_regs from the child. */
 		int ui;
 	  	if (!access_ok(VERIFY_WRITE, (void __user *)data,
@@ -402,7 +372,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = compat_ptrace_request(child, request, addr, data);
 		break;
 	}
 out_tsk:
-- 
1.5.3.6

