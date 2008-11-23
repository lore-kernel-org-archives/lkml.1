Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbYKWUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbYKWUzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYKWUzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:55:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYKWUzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:55:07 -0500
Date: Sun, 23 Nov 2008 22:55:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, roland@redhat.com, mingo@elte.hu,
       rnalumasu@gmail.com
Subject: do_wait() vs do_notify_parent_cldstop() theoretical race?
Message-ID: <20081123215511.GB9097@redhat.com>
References: <200811212015.mALKFMs4019558@imap1.linux-foundation.org> <20081123213929.GA9097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123213929.GA9097@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at do_wait(), suddenly I am starting to suspect we have the
highly theoretical race with do_notify_parent_cldstop().

	do_wait:

		add_wait_queue(...);

		current->state = TASK_INTERRUPTIBLE;

		read_lock(tasklist_lock);

		... try to find the "interesting" task ...

		read_unlock(tasklist_lock);

		if (!retval)	// not found
			schedule();

We don't race with do_notify_parent() because it takes tasklist
for writing. But do_notify_parent_cldstop() can run in parallel
under read_lock(tasklist).

Now suppose that "->state = TASK_INTERRUPTIBLE" leaks deeply into
the critical section. In theory, it is possible that wait_consider_task()
checks task_is_stopped_or_traced() or SIGNAL_STOP_CONTINUED first, then
CPU sets state = TASK_INTERRUPTIBLE. And we can miss the event if
do_notify_parent_cldstop() happens in between.

No?

Oleg.

