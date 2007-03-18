Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbXCRTOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbXCRTOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbXCRTOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:14:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36706 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbXCRTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:14:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Catalin Marinas" <catalin.marinas@gmail.com>
Subject: [PATCH 4/4] tty: In tiocsctty when we steal a tty hang it up.
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
	<m1vegyjspz.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6rmjsev.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz2ajs6g.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy82jrwz.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqiqjrnx.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 18 Mar 2007 13:13:37 -0600
In-Reply-To: <m1bqiqjrnx.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 18 Mar 2007 13:08:34 -0600")
Message-ID: <m17itejrfi.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The linux implementation of TIOCSCTTY includes an extention
that provides for making a tty that is already the controlling
tty of another session our controlling tty.  To do this it must
steal the tty away from the previous group that used it as a
controlling tty.

The way we are currently stealing the controlling tty away is
weird.   In general there is a well defined process for loosing
the controlling tty.  TTY hangup processing.  However the linux
extension that steals the tty from another process group does
not invoke that.  And instead just forgets the controlling
tty of the processes that were part of the session.

I can not imagine how our current behaviour of stealling a tty
is correct or how a set of processes could deal with it reasonably.
So this patch modifies the tty stealing to call tty_vhangup
so we get full hanup processing when we steal a tty.

I did a quick survey of user space the only application I found using
this extended behaviour is sysvinit.  I perform a limited  amount of
testing and nothing appears to have broken with this change.  And I
did see sysvinit pass through this piece of code.

In terms of the tty leaks that started this patch series this fix
should remove the last path into proc_clear_tty that has a session
or a process group.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/tty_io.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 0843fcb..0f5a781 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2982,9 +2982,7 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 			/*
 			 * Steal it away
 			 */
-			read_lock(&tasklist_lock);
-			session_clear_tty(tty->session);
-			read_unlock(&tasklist_lock);
+			tty_vhangup(tty);
 		} else {
 			ret = -EPERM;
 			goto unlock;
-- 
1.5.0.g53756

