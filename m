Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbXC2Fmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbXC2Fmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbXC2Fmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:42:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42676 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997AbXC2Fmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:42:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Adrian Bunk <bunk@stusta.de>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] pid:  Properly detect orphaned process groups in exit_notify
References: <ac10ef410703271555s6c4d7b95hc94091bae575600d@mail.gmail.com>
	<m1648lqzsf.fsf@ebiederm.dsl.xmission.com>
	<ac10ef410703280946oe46b0a5pdd5dcfb0419713ca@mail.gmail.com>
	<m14po5ozbx.fsf@ebiederm.dsl.xmission.com>
	<ac10ef410703281835o6d2c258fkd905467bfc089ffa@mail.gmail.com>
	<m1vegkn1bz.fsf@ebiederm.dsl.xmission.com>
	<ac10ef410703282142j2ab375fbi793cb4db908540f6@mail.gmail.com>
Date: Wed, 28 Mar 2007 23:38:16 -0600
In-Reply-To: <ac10ef410703282142j2ab375fbi793cb4db908540f6@mail.gmail.com>
	(Michael Wu's message of "Thu, 29 Mar 2007 00:42:43 -0400")
Message-ID: <m1y7lglid3.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
