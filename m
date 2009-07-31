Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZGaTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZGaTsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZGaTsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 15:48:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZGaTsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 15:48:15 -0400
Date: Fri, 31 Jul 2009 15:48:05 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] information leak in sigaltstack
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately the stack_t data structure was defined before people
cared much about 64-bit architectures.  It has a hole in the middle.
And this hole is creating an information leak in the sigaltstack
syscall.

When the second parameter to sigaltstack is non-NULL the current stack
information is passed to the caller by filling in the members of the
stack_t structure and then the whole structure is copied using
copy_to_user.  This unfortunately leaves the whole after flags
uninitialized.

The following patch should fix the issue.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>


diff --git a/kernel/signal.c b/kernel/signal.c
index ccf1cee..612d6b7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2455,6 +2455,9 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 	int error;
 
 	if (uoss) {
+		if (offsetof(stack_t, ss_flags) + sizeof(oss.ss_flags) !=
+		    offsetof(stack_t, ss_size))
+			memset(&oss, '\0', sizeof(oss));
 		oss.ss_sp = (void __user *) current->sas_ss_sp;
 		oss.ss_size = current->sas_ss_size;
 		oss.ss_flags = sas_ss_flags(sp);
