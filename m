Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYH2XQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYH2XQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYH2XP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:15:27 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:54413 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbYH2XPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:15:25 -0400
Date: Fri, 29 Aug 2008 16:15:24 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: [PATCH 2/6] UML: Don't valgrind userspace
In-Reply-To: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
Message-ID: <alpine.DEB.1.00.0808291614430.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag to tell Valgrind to run the forked child natively.  Necessary
because Valgrind makes additional system calls to instrumented processes,
which confuse UML.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
---

Index: linux-2.6.27-rc5/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.27-rc5.orig/arch/um/os-Linux/skas/process.c	2008-08-29 15:50:24.000000000 -0700
+++ linux-2.6.27-rc5/arch/um/os-Linux/skas/process.c	2008-08-29 15:51:45.000000000 -0700
@@ -26,6 +26,7 @@
  #include "skas_ptrace.h"
  #include "user.h"
  #include "sysdep/stub.h"
+#include "valgrind.h"

  int is_skas_winch(int pid, int fd, void *data)
  {
@@ -297,8 +298,12 @@
  	flags = CLONE_FILES;
  	if (proc_mm)
  		flags |= CLONE_VM;
-	else
+	else {
  		flags |= SIGCHLD;
+#ifdef UML_CONFIG_VALGRIND_SUPPORT
+		flags |= VALGRIND_CLONE_LETGO;
+#endif
+	}

  	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
  	if (pid < 0) {
