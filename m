Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZCCLZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZCCLZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZCCLZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:25:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:41837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbZCCLZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:25:08 -0500
Date: Tue, 3 Mar 2009 11:24:40 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236078904.2675.17.camel@penberg-laptop>
References: <1236078904.2675.17.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: make sure initmem is writable on 64-bit
Message-ID: <tip-e087edd8c056292191bb989baf49f83ee509e624@git.kernel.org>
Git-Commit-ID: e087edd8c056292191bb989baf49f83ee509e624
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 11:24:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e087edd8c056292191bb989baf49f83ee509e624
Gitweb:     http://git.kernel.org/tip/e087edd8c056292191bb989baf49f83ee509e624
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Tue, 3 Mar 2009 13:15:04 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 12:21:18 +0100

x86: make sure initmem is writable on 64-bit

Impact: unification

This patch ports commit 3c1df68b848b39270752ff8d4b956cc4a4dce0f6 ("x86: make
sure initmem is writable") to the 64-bit version to unify implementations of
free_init_pages().

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <1236078904.2675.17.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..03da903 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -962,6 +962,13 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 		begin, PAGE_ALIGN(end));
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
+	/*
+	 * We just marked the kernel text read only above, now that
+	 * we are going to free part of that, we need to make that
+	 * writeable first.
+	 */
+	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
 	for (; addr < end; addr += PAGE_SIZE) {
