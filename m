Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbZCaVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbZCaVBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762267AbZCaVBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:01:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762097AbZCaVBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:01:16 -0400
Date: Tue, 31 Mar 2009 22:57:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: what is_single_threaded() does?
Message-ID: <20090331205703.GA21030@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this helper by accident, and I am puzzled.

	/**
	 * is_single_threaded - Determine if a thread group is single-threaded or not
	 * @p: A task in the thread group in question
	 *
	 * This returns true if the thread group to which a task belongs is single
	 * threaded, false if it is not.
	 */

But this is not what the code does? The "t->mm == mm" check below means
it also returns false if ->mm is shared with another CLONE_VM process ?

Could you explain what is right, the comment or the code?

	bool is_single_threaded(struct task_struct *p)
	{
		struct task_struct *g, *t;
		struct mm_struct *mm = p->mm;

		if (atomic_read(&p->signal->count) != 1)
			goto no;

Is this correct? Let's suppose the main thread dies, and the thread group
has only one live thread. In that case signal->count == 2.


		if (atomic_read(&p->mm->mm_users) != 1) {
			read_lock(&tasklist_lock);
			do_each_thread(g, t) {

Why do_each_thread() ? for_each_process() is enough, all sub-threads use
the same ->mm.

				if (t->mm == mm && t != p)
					goto no_unlock;

What about use_mm() ? Looks like this needs PF_KTHREAD check.

			} while_each_thread(g, t);
			read_unlock(&tasklist_lock);
		}

		return true;

Perhaps it should be current_is_single_thread(void) ...

Oleg.

