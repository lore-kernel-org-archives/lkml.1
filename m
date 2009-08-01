Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZHARw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZHARw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 13:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZHARw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 13:52:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbZHARw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 13:52:26 -0400
Date: Sat, 1 Aug 2009 10:52:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] information leak in sigaltstack
In-Reply-To: <alpine.LFD.2.01.0907311716220.3304@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908011049490.3304@localhost.localdomain>
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain> <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain> <4A73641C.7070404@redhat.com>
 <alpine.LFD.2.01.0907311716220.3304@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Jul 2009, Linus Torvalds wrote:
> 
> Here's the patch I used, just for posterity. I can't decide if I really 
> want to commit this crap.

I think I like this version better. It's not wonderfully pretty, but 
to some degree it actually improves on code generation, even if it 
generates a bigger exception table. It now also copies the stack_t back to 
user space the same way it copies it _from_ user space, so in that sense 
it's actually very consistent.

		Linus
---
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Aug 2009 10:34:56 -0700
Subject: [PATCH] do_sigaltstack: avoid copying 'stack_t' as a structure to user space

Ulrich Drepper correctly points out that there is generally padding in
the structure on 64-bit hosts, and that copying the structure from
kernel to user space can leak information from the kernel stack in those
padding bytes.

Avoid the whole issue by just copying the three members one by one
instead, which also means that the function also can avoid the need for
a stack frame.  This also happens to match how we copy the new structure
from user space, so it all even makes sense.

[ The obvious solution of adding a memset() generates horrid code, gcc
  does really stupid things. ]

Reported-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/signal.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ccf1cee..f268372 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2454,11 +2454,9 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 	stack_t oss;
 	int error;
 
-	if (uoss) {
-		oss.ss_sp = (void __user *) current->sas_ss_sp;
-		oss.ss_size = current->sas_ss_size;
-		oss.ss_flags = sas_ss_flags(sp);
-	}
+	oss.ss_sp = (void __user *) current->sas_ss_sp;
+	oss.ss_size = current->sas_ss_size;
+	oss.ss_flags = sas_ss_flags(sp);
 
 	if (uss) {
 		void __user *ss_sp;
@@ -2501,13 +2499,16 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 		current->sas_ss_size = ss_size;
 	}
 
+	error = 0;
 	if (uoss) {
 		error = -EFAULT;
-		if (copy_to_user(uoss, &oss, sizeof(oss)))
+		if (!access_ok(VERIFY_WRITE, uoss, sizeof(*uoss)))
 			goto out;
+		error = __put_user(oss.ss_sp, &uoss->ss_sp) |
+			__put_user(oss.ss_size, &uoss->ss_size) |
+			__put_user(oss.ss_flags, &uoss->ss_flags);
 	}
 
-	error = 0;
 out:
 	return error;
 }
