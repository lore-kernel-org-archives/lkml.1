Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbXC2VeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbXC2VeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXC2VeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:34:03 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbXC2VeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:34:01 -0400
Date: Thu, 29 Mar 2007 14:33:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm1
Message-Id: <20070329143358.ee8c354c.akpm@linux-foundation.org>
In-Reply-To: <48f7fe350703291332q5f2da2dar7c52afd34f79072a@mail.gmail.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
	<48f7fe350703291332q5f2da2dar7c52afd34f79072a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 16:32:19 -0400
"Ryan Hope" <rmh3093@gmail.com> wrote:

> I was not able to boot 2.6.21-rc3-mm* so I can not tell if this problem
> exists in that series but with 2.6.21-rc4-mm* and 2.6.21-rc5-mm* I can not
> get into Xorg.  I disabled frame buffer support but when X loads normally
> the display goes blank for a moment then the greeter gets started but with
> the mentioned kernels the screen just stays blank. Everyting worked fine in
> 2.6.21-rc2-mm* no I am not sure where the problem is. I am using the fglrx
> display driver for X if that help anyone.
> 

hm, don't know, sorry.

Are you able to get control back so you can see if there's anything
interesting in the kernel logs?  Maybe ssh in from another machine?

It's conceivable that reverting fix-sysfs-reclaim-crash.patch will fix it,
or applying the below.

If that doesn't help, or of you don't have the time to try it, please be
sure to test the next -mm kernels, let us know if the bug is still there?

It could of course be that the memory management changes in -mm broke the
fglrx driver.




Begin forwarded message:

Date: Wed, 28 Mar 2007 23:38:16 -0600
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sid Boyce <g3vbv@blueyonder.co.uk>, Adrian Bunk <bunk@stusta.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] pid:  Properly detect orphaned process groups in exit_notify



In commit 0475ac0845f9295bc5f69af45f58dff2c104c8d1 when converting
the converting the orphaned process group handling to use struct pid
I made a small mistake.  I accidentally replaced an == with a !=.

Besides just being a dumb thing to do apparently this has a bad side
effect.  The improper orphaned process group detection causes kwin to
die after a suspend/resume cycle.

I'm amazed this patch has been around as long as it has without anyone
else noticing something funny going on.

And the following people deserve credit for spotting and helping
to reproduce this.

Thanks to: Sid Boyce <g3vbv@blueyonder.co.uk>
Thanks to: "Michael Wu"

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

diff --git a/kernel/exit.c b/kernel/exit.c
index f132349..b55ed4c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -790,7 +790,7 @@ static void exit_notify(struct task_struct *tsk)
 	
 	pgrp = task_pgrp(tsk);
 	if ((task_pgrp(t) != pgrp) &&
-	    (task_session(t) != task_session(tsk)) &&
+	    (task_session(t) == task_session(tsk)) &&
 	    will_become_orphaned_pgrp(pgrp, tsk) &&
 	    has_stopped_jobs(pgrp)) {
 		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
