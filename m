Return-Path: <linux-kernel-owner+w=401wt.eu-S1161293AbXCNOlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161293AbXCNOlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161304AbXCNOlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:41:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53159 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161293AbXCNOlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:41:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Catalin Marinas" <catalin.marinas@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Possible "struct pid" leak from tty_io.c
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	<m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
Date: Wed, 14 Mar 2007 08:40:43 -0600
In-Reply-To: <b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	(Catalin Marinas's message of "Wed, 14 Mar 2007 09:59:21 +0000")
Message-ID: <m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


How does this look?

I don't have the setup to test this easily, but this bit makes seems to make
sense.  I will keep code reviewing and see if I can convince myself that this
is correct or incorrect in the mean time...

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e453268..fc125ac 100644
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
@@ -3841,6 +3843,8 @@ static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tt
 {
 	struct pid *old_pgrp;
 	if (tty) {
+		put_pid(tty->session);
+		put_pid(tty->pgrp);
 		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
 	}
