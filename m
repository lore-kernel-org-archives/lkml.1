Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbXKNS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbXKNS6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762816AbXKNS6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:58:24 -0500
Received: from ns.suse.de ([195.135.220.2]:60287 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762552AbXKNS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:58:22 -0500
Subject: patch uml-stop-using-libc-asm-page.h.patch queued to -stable tree
To: jdike@addtoit.com, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Wed, 14 Nov 2007 10:58:11 -0800
In-Reply-To: <20071101195325.GA8871@c2.user-mode-linux.org>
Message-Id: <20071114185819.E828214540D0@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: UML - Stop using libc asm/page.h

to the 2.6.23-stable tree.  Its filename is

     uml-stop-using-libc-asm-page.h.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Thu Nov  1 12:53:55 2007
From: Jeff Dike <jdike@addtoit.com>
Date: Thu, 1 Nov 2007 15:53:25 -0400
Subject: UML - Stop using libc asm/page.h
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20071101195325.GA8871@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 71f926f2ea61994470a53c9e11d3ef993197cada in mainline.

uml: stop using libc asm/page.h

Remove includes of asm/page.h from libc code.  This header seems to be
disappearing, and UML doesn't make much use of it anyway.

The one use, PAGE_SHIFT in stub.h, is handled by copying the constant from the
kernel side of the house in common_offsets.h.

[ jdike - added arch/um/kernel/skas/clone.c for -stable ]

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/include/common-offsets.h   |    1 +
 arch/um/include/sysdep-i386/stub.h |    3 +--
 arch/um/kernel/skas/clone.c        |    1 -
 arch/um/os-Linux/main.c            |    1 -
 arch/um/os-Linux/skas/mem.c        |    1 -
 arch/um/os-Linux/start_up.c        |    1 -
 arch/um/os-Linux/tt.c              |    1 -
 7 files changed, 2 insertions(+), 7 deletions(-)

--- a/arch/um/include/common-offsets.h
+++ b/arch/um/include/common-offsets.h
@@ -10,6 +10,7 @@ OFFSET(HOST_TASK_PID, task_struct, pid);
 
 DEFINE(UM_KERN_PAGE_SIZE, PAGE_SIZE);
 DEFINE(UM_KERN_PAGE_MASK, PAGE_MASK);
+DEFINE(UM_KERN_PAGE_SHIFT, PAGE_SHIFT);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 
 DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
--- a/arch/um/include/sysdep-i386/stub.h
+++ b/arch/um/include/sysdep-i386/stub.h
@@ -9,7 +9,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "stub-data.h"
 #include "kern_constants.h"
 #include "uml-config.h"
@@ -19,7 +18,7 @@ extern void stub_clone_handler(void);
 
 #define STUB_SYSCALL_RET EAX
 #define STUB_MMAP_NR __NR_mmap2
-#define MMAP_OFFSET(o) ((o) >> PAGE_SHIFT)
+#define MMAP_OFFSET(o) ((o) >> UM_KERN_PAGE_SHIFT)
 
 static inline long stub_syscall0(long syscall)
 {
--- a/arch/um/kernel/skas/clone.c
+++ b/arch/um/kernel/skas/clone.c
@@ -3,7 +3,6 @@
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "ptrace_user.h"
 #include "skas.h"
 #include "stub-data.h"
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -12,7 +12,6 @@
 #include <sys/resource.h>
 #include <sys/mman.h>
 #include <sys/user.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -9,7 +9,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
-#include <asm/page.h>
 #include <asm/unistd.h>
 #include "mem_user.h"
 #include "mem.h"
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -19,7 +19,6 @@
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include <sys/types.h>
 #include "kern_util.h"
 #include "user.h"
--- a/arch/um/os-Linux/tt.c
+++ b/arch/um/os-Linux/tt.c
@@ -17,7 +17,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"


Patches currently in stable-queue which might be from jdike@addtoit.com are

queue-2.6.23/uml-stop-using-libc-asm-page.h.patch
queue-2.6.23/uml-fix-kernel-vs-libc-symbols-clash.patch
queue-2.6.23/uml-stop-using-libc-asm-user.h.patch
