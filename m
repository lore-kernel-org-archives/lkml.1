Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYEPFXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYEPFXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYEPFXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:23:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:24057 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbYEPFXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:23:13 -0400
Date: Fri, 16 May 2008 14:21:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hskinnemoen@atmel.com, nurhussein@gmail.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, arjan@infradead.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, kyle@parisc-linux.org, schwidefsky@de.ibm.com
Subject: [PATCH] lib: Taint kernel in common report_bug() WARN path.
Message-ID: <20080516052127.GB15431@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
	nurhussein@gmail.com, linux-kernel@vger.kernel.org,
	randy.dunlap@oracle.com, arjan@infradead.org, mingo@elte.hu,
	a.p.zijlstra@chello.nl, kyle@parisc-linux.org,
	schwidefsky@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 95b570c9cef3b12356454c7112571b7e406b4b51 introduced a
TAINT_WARN that was implemented for all architectures using the
generic warn_on_slowpath(), which excluded any architecture that
set HAVE_ARCH_WARN_ON.

As all of the architectures that implement their own WARN_ON()
all go through the report_bug() path (specifically handling
BUG_TRAP_TYPE_WARN), taint the kernel there as well for consistency.

Tested on avr32 and sh. Also relevant for s390, parisc, and powerpc.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/lib/bug.c b/lib/bug.c
index 530f38f..bfeafd6 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -37,6 +37,7 @@
  */
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/sched.h>
 
@@ -149,6 +150,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 			       (void *)bugaddr);
 
 		show_regs(regs);
+		add_taint(TAINT_WARN);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
