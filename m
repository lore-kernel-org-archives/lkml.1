Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbZIEA2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbZIEA2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934642AbZIEA2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:28:06 -0400
Received: from kroah.org ([198.145.64.141]:42243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934553AbZIEAVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:54 2009
Message-Id: <20090905001454.452097866@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 46/71] do_sigaltstack: avoid copying stack_t as a structure to user space
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=do_sigaltstack-avoid-copying-stack_t-as-a-structure-to-user-space.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0083fc2c50e6c5127c2802ad323adf8143ab7856 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2414,11 +2414,9 @@ do_sigaltstack (const stack_t __user *us
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
@@ -2461,13 +2459,16 @@ do_sigaltstack (const stack_t __user *us
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


