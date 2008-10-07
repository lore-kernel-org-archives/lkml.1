Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYJGVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYJGVQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYJGVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:16:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYJGVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:16:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=QpbjbOvW6KSjDqvqAHqyindzpkQT1Y3ABFgChDLPIVNTsW+tA24pbiJYaTvzfjj6+
	xLtleROvY+yvc/WcF+InQ==
Date: Tue, 7 Oct 2008 14:15:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] x86: avoid dereferencing beyond stack + THREAD_SIZE
Message-ID: <alpine.DEB.1.10.0810071413210.20896@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for get_wchan() to dereference past task->stack + THREAD_SIZE 
while iterating through instruction pointers if fp equals the upper boundary, 
causing a kernel panic.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/process_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -729,12 +729,12 @@ unsigned long get_wchan(struct task_struct *p)
 	if (!p || p == current || p->state==TASK_RUNNING)
 		return 0; 
 	stack = (unsigned long)task_stack_page(p);
-	if (p->thread.sp < stack || p->thread.sp > stack+THREAD_SIZE)
+	if (p->thread.sp < stack || p->thread.sp >= stack+THREAD_SIZE)
 		return 0;
 	fp = *(u64 *)(p->thread.sp);
 	do { 
 		if (fp < (unsigned long)stack ||
-		    fp > (unsigned long)stack+THREAD_SIZE)
+		    fp >= (unsigned long)stack+THREAD_SIZE)
 			return 0; 
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))
