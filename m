Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbYCJIaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbYCJIaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYCJI3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:29:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:31166 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYCJI3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=l9c49SV4+xk3hALqHqTx4oeo2n30sY9V+NxI5r+E0lC71lJQ0ee4tJVzslTBo3/Pf0nHwzL4g10aI+xqraNUD8kxuEVBLkGvmeUwKCWl/E0RuvTnDfYIr/XlzX/GsrG4fbC/iA1ixZVrrU/apRzXUBVpztmYEt2SSxa+ez2YldI=
Date: Mon, 10 Mar 2008 16:23:51 +0800 (CST)
Message-Id: <20080310.162351.21322673.xiyou.wangcong@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, gvaughan@jpl.nasa.gov, akpm@osdl.org,
       jeremy@goop.org
Subject: Re: [PATCH] Fix check after use in kernel/exit.c
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080309114844.GC30331@elte.hu>
References: <20080308085322.GA29628@elte.hu>
	<20080308.165821.119846418.xiyou.wangcong@gmail.com>
	<20080309114844.GC30331@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 9 Mar 2008 12:48:44 +0100

> 
> * WANG Cong <xiyou.wangcong@gmail.com> wrote:
> 
> > > actually, i unapplied it again because the patch is wrong: 
> > > mm_release() has side-effects for kernel threads such as the 
> > > deactivate_mm() [which is important even if the user-mm is NULL]. If 
> > > the NULL mm dereference can really trigger then it should be avoided 
> > > within mm_release().
> > 
> > Do you mean that the NULL check should be moved into mm_release()?
> 
> yes - we need to run deactivate_mm() for kernel threads.


Thank you for your kind hints.

Here is an updated version. Please check.

---->

From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH] Fix check after use in kernel/exit.c

As suggested by Ingo, the NULL deference check should be moved
into mm_release().

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 kernel/exit.c |    2 --
 kernel/fork.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 53872bf..b88244a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -583,8 +583,6 @@ static void exit_mm(struct task_struct * tsk)
 	struct mm_struct *mm = tsk->mm;
 
 	mm_release(tsk, mm);
-	if (!mm)
-		return;
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_waiters
diff --git a/kernel/fork.c b/kernel/fork.c
index dd249c3..7683c5f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -464,6 +464,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
 	struct completion *vfork_done = tsk->vfork_done;
 
+	if (!mm)
+		return;
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-- 
1.5.2.4


