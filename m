Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbYF3QOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbYF3QOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYF3QNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:13:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56233 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYF3QNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:13:49 -0400
From: Eric Munson <ebmunson@us.ibm.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Eric Munson <ebmunson@us.ibm.com>
Subject: [PATCH V3] Keep 3 high personality bytes across exec
Date: Mon, 30 Jun 2008 09:12:13 -0700
Message-Id: <1214842333-21428-1-git-send-email-ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <20080628000813.GA19960@us.ibm.com>
References: <20080628000813.GA19960@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when a 32 bit process is exec'd on a powerpc 64 bit host the value
in the top three bytes of the personality is clobbered.  This patch adds a
check in the SET_PERSONALITY macro that will carry all the values in the top
three bytes across the exec.

These three bytes currently carry flags to disable address randomisation,
limit the address space, force zeroing of an mmapped page, etc.  Should an
application set any of these bits they will be maintained and honoured on
homogeneous environment but discarded and ignored on a heterogeneous
environment.  So if an application requires all mmapped pages to be initialised
to zero and a wrapper is used to setup the personality and exec the target,
these flags will remain set on an all 32 or all 64 bit envrionment, but they
will be lost in the exec on a mixed 32/64 bit environment.  Losing these bits
means that the same application would behave differently in different
environments.  Tested on a POWER5+ machine with 64bit kernel and a mixed
64/32 bit user space.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
V3
Based on 2.6.26-rc8

Changes from V2:
Use ~PER_MASK instead of PER_INHERIT
Remove PER_INHERIT
Rebase to 2.6.26-rc8

Changes from V1:
Updated changelog with a better description of why this change is useful

 include/asm-powerpc/elf.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index 9080d85..5eee73e 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -257,7 +257,8 @@ do {								\
 	else							\
 		clear_thread_flag(TIF_ABI_PENDING);		\
 	if (personality(current->personality) != PER_LINUX32)	\
-		set_personality(PER_LINUX);			\
+		set_personality(PER_LINUX |			\
+			(current->personality & (~PER_MASK)));	\
 } while (0)
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
-- 
1.5.6.1

