Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYAaPUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYAaPUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYAaPUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:20:21 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:37083 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYAaPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:20:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=x83XAf+T5D/4XjJkYCNaN07MNhH2ZZOXoTFhnwAGwmnB/CJ1OA5dVQuAUb/r0LLUN5BZ2MeUNsHd1hzYIkCRClMb//9nqKvudQfRNd/Vf2d/aw/Oerr6Kq4nUPtfQdp81Qniqe3BlwRuhJAqKv6EXSDp6J3sip+ZaUuEc6WSdaQ=
Date: Thu, 31 Jan 2008 23:17:41 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@karaya.com>, user-mode-linux-devel@lists.sourceforge.net
Subject: [git Patch] UML: a build error fix
Message-ID: <20080131151741.GE2471@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixed this error:

arch/um/kernel/skas/syscall.c: In function 'handle_syscall':
arch/um/kernel/skas/syscall.c:33: error: 'NR_syscalls' undeclared (first use in this function)
arch/um/kernel/skas/syscall.c:33: error: (Each undeclared identifier is reported only once
arch/um/kernel/skas/syscall.c:33: error: for each function it appears in.)
make[2]: *** [arch/um/kernel/skas/syscall.o] Error 1
make[1]: *** [arch/um/kernel/skas] Error 2
make: *** [arch/um/kernel] Error 2


Cc: Jeff Dike <jdike@karaya.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/um/include/sysdep-i386/kernel-offsets.h b/arch/um/include/sysdep-i386/kernel-offsets.h
index 5868526..da820d2 100644
--- a/arch/um/include/sysdep-i386/kernel-offsets.h
+++ b/arch/um/include/sysdep-i386/kernel-offsets.h
@@ -15,7 +15,11 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
+static char syscalls[] = {
+#include <asm/arch/unistd.h>
+};
 void foo(void)
 {
 #include <common-offsets.h>
+DEFINE(UM_NR_syscall_max, sizeof(syscalls) - 1);
 }
diff --git a/arch/um/include/sysdep-i386/syscalls.h b/arch/um/include/sysdep-i386/syscalls.h
index 57bd79e..fb1fd94 100644
--- a/arch/um/include/sysdep-i386/syscalls.h
+++ b/arch/um/include/sysdep-i386/syscalls.h
@@ -5,6 +5,7 @@
 
 #include "asm/unistd.h"
 #include "sysdep/ptrace.h"
+#include "kern_constants.h"
 
 typedef long syscall_handler_t(struct pt_regs);
 
@@ -23,3 +24,6 @@ extern syscall_handler_t *sys_call_table[];
 extern long sys_mmap2(unsigned long addr, unsigned long len,
 		      unsigned long prot, unsigned long flags,
 		      unsigned long fd, unsigned long pgoff);
+
+#define NR_syscalls (UM_NR_syscall_max + 1)
+
