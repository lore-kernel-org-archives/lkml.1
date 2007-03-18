Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXCRSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXCRSqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbXCRSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:46:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49329 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbXCRSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:46:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Catalin Marinas" <catalin.marinas@gmail.com>
Subject: [PATCH] tty: Fix two reported pid leaks
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	<m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	<m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
	<m1slc4luf5.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703161544h2961670dh8f5e499fd2dc0ce5@mail.gmail.com>
Date: Sun, 18 Mar 2007 12:45:44 -0600
In-Reply-To: <b0943d9e0703161544h2961670dh8f5e499fd2dc0ce5@mail.gmail.com>
	(Catalin Marinas's message of "Fri, 16 Mar 2007 22:44:14 +0000")
Message-ID: <m1vegyjspz.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These leaks were reported by: Catalin Marinas <catalin.marians@gmail.com>
and I have been able to very by inspection they are possible.

When converting tty_io.c to store pids as struct pid pointers instead
of pid_t values it appears I overlooked two places where we stop using
the pid value.  The very obvious one is in do_tty_hangup, and the one
the less obvious one in __proc_set_tty.

When looking into the code __proc_set_tty only has pids that need to
be put because of failures of other parts of the code to properly
perform hangup processing.   Fixing the leak here in __proc_set_tty
is easy and obviously correct so I am doing that first.

Fixing the places that should be performing hangup processing is much
less obviously correct.  So those I'm aiming those patches at -mm.
for now, so the can age a while before they are merged.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/tty_io.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e453268..7a32df5 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1376,6 +1376,8 @@ static void do_tty_hangup(struct work_struct *work)
 	read_unlock(&tasklist_lock);
 
 	tty->flags = 0;
+	put_pid(tty->session);
+	put_pid(tty->pgrp);
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
@@ -3841,6 +3843,9 @@ static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tt
 {
 	struct pid *old_pgrp;
 	if (tty) {
+		/* We should not have a session or pgrp to here but.... */
+		put_pid(tty->session);
+		put_pid(tty->pgrp);
 		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
 	}
-- 
1.5.0.g53756

