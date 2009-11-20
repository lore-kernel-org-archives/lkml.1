Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZKTNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZKTNKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZKTNK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:10:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:49437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZKTNK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:10:28 -0500
Date: Fri, 20 Nov 2009 13:09:54 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       aph@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       richard.guenther@gmail.com, law@redhat.com, akpm@linux-foundation.org,
       rostedt@goodmis.org, ddaney@caviumnetworks.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       aph@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       rostedt@goodmis.org, akpm@linux-foundation.org,
       richard.guenther@gmail.com, law@redhat.com, ddaney@caviumnetworks.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0911200206570.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911200206570.24119@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Prevent GCC 4.4.x (pentium-mmx et al) function prologue wreckage
Message-ID: <tip-746357d6a526d6da9d89a2ec645b28406e959c2e@git.kernel.org>
Git-Commit-ID: 746357d6a526d6da9d89a2ec645b28406e959c2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  746357d6a526d6da9d89a2ec645b28406e959c2e
Gitweb:     http://git.kernel.org/tip/746357d6a526d6da9d89a2ec645b28406e959c2e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Nov 2009 12:01:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 20 Nov 2009 14:06:46 +0100

x86: Prevent GCC 4.4.x (pentium-mmx et al) function prologue wreckage

When the kernel is compiled with -pg for tracing GCC 4.4.x inserts
stack alignment of a function _before_ the mcount prologue if the
-march=pentium-mmx is set and -mtune=generic is not set. This breaks
the assumption of the function graph tracer which expects that the
mcount prologue

       push %ebp
       mov  %esp, %ebp

is the first stack operation in a function because it needs to modify
the function return address on the stack to trap into the tracer
before returning to the real caller.

The generated code is:

        push   %edi
        lea    0x8(%esp),%edi
        and    $0xfffffff0,%esp
        pushl  -0x4(%edi)
        push   %ebp
        mov    %esp,%ebp

so the tracer modifies the copy of the return address which is stored
after the stack alignment and therefor does not trap the return which
in turn breaks the call chain logic of the tracer and leads to a
kernel panic.

Aside of the fact that the generated code is horrible for no good
reason other -march -mtune options generate the expected:

        push   %ebp
        mov    %esp,%ebp
        and    $0xfffffff0,%esp

which does the same and keeps everything intact.

After some experimenting we found out that this problem is restricted
to gcc4.4.x and to the following -march settings:

i586, pentium, pentium-mmx, k6, k6-2, k6-3, winchip-c6, winchip2, c3,
geode

By adding -mtune=generic the code generator produces always the
expected code.

So forcing -mtune=generic when CONFIG_FUNCTION_GRAPH_TRACER=y is not
pretty, but at the moment the only way to prevent that the kernel
trips over gcc-shrooms induced code madness.

Most distro kernels have CONFIG_X86_GENERIC=y anyway which forces
-mtune=generic as well so it will not impact those.

References: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=42109
	    http://lkml.org/lkml/2009/11/19/17

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <alpine.LFD.2.00.0911200206570.24119@localhost.localdomain>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
Cc: Jeff Law <law@redhat.com>
Cc: gcc@gcc.gnu.org
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Haley <aph@redhat.com>
Cc: Richard Guenther <richard.guenther@gmail.com>
Cc: stable@kernel.org
---
 arch/x86/Makefile_32.cpu |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 30e9a26..df7fdf8 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -46,6 +46,12 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
+# Work around the pentium-mmx code generator madness of gcc4.4.x which
+# does stack alignment by generating horrible code _before_ the mcount
+# prologue (push %ebp, mov %esp, %ebp) which breaks the function graph
+# tracer assumptions 
+cflags-$(CONFIG_FUNCTION_GRAPH_TRACER) += $(call cc-option,-mtune=generic)
+
 # Bug fix for binutils: this option is required in order to keep
 # binutils from generating NOPL instructions against our will.
 ifneq ($(CONFIG_X86_P6_NOP),y)
