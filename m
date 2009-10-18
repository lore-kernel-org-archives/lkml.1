Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZJROhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZJROhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 10:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbZJROhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 10:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZJROhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 10:37:18 -0400
Date: Sun, 18 Oct 2009 16:36:16 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH] UM: Remove BKL from sys_execve
Message-ID: <alpine.LFD.2.00.0910181633130.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d71a5e17b985a8fefaa88e3a6fe4896878886ba Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 16:17:57 +0200
Subject: [PATCH] UM: Remove BKL from sys_execve

The BKL in sys_execve is likely the result of a cut-and-paste from a time,
when it was needed. However, it is no longer required here. Remove to be
in sync with other architectures.

(See arch/x86/kernel/process_64.c for example)

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/um/kernel/exec.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index fda30d2..d39aa36 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -5,7 +5,6 @@
 
 #include "linux/stddef.h"
 #include "linux/fs.h"
-#include "linux/smp_lock.h"
 #include "linux/ptrace.h"
 #include "linux/sched.h"
 #include "asm/current.h"
@@ -76,13 +75,11 @@ long sys_execve(char __user *file, char __user *__user *argv,
 	long error;
 	char *filename;
 
-	lock_kernel();
 	filename = getname(file);
 	error = PTR_ERR(filename);
-	if (IS_ERR(filename)) goto out;
+	if (IS_ERR(filename))
+		return error;
 	error = execve1(filename, argv, env);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
-- 
1.6.0.6

