Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZJIFv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZJIFv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZJIFv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:51:26 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:47025 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZJIFv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=xLX0GmaPNV5+GalCSr9I0BfjaczqKIBxG5MFJ7jjv4MpwF1rNPzShTrbJzpaqcUT3c
         DFTnx6ZmcMHa3kL6FCW70z0YkolLJbXpAvEEY5owelYrQ58Ki+pELYVwP163kbDS5Tnq
         1bSpmwUhUY6BNg5SegCpUhK+xJg95GXZ7GJgs=
MIME-Version: 1.0
In-Reply-To: <a5b3ea7b0910082242s6ce8275dr7f962ce526e55cd2@mail.gmail.com>
References: <a5b3ea7b0910082242s6ce8275dr7f962ce526e55cd2@mail.gmail.com>
Date: Fri, 9 Oct 2009 13:50:49 +0800
Message-ID: <a5b3ea7b0910082250o659d4fd3l8f319fd6bde24f3d@mail.gmail.com>
Subject: Re: the select system call's implementation may have some bug in 
	preempt kernel mode
From: wu Jianfeng <stormplayer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A process may sleep for ever when he call select system call.
In detail, if the process was scheduled out just at the point it set
its state to TASK_INTERRUPTIBLE.

The events that may cause the process to be scheduled out is(in
preempt kernel) :
1) time interrupt and the process's time slice is exhausted.
2) an interrupt accured, and wake up another process with high priority.

int do_select(int n, fd_set_bits *fds, s64 *timeout)
{
	struct poll_wqueues table;
	poll_table *wait;
	int retval, i;

	rcu_read_lock();
	retval = max_select_fd(n, fds);
	rcu_read_unlock();

	if (retval < 0)
		return retval;
	n = retval;

	poll_initwait(&table);
	wait = &table.pt;
	if (!*timeout)
		wait = NULL;
	retval = 0;
	for (;;) {
		unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
		long __timeout;

		set_current_state(TASK_INTERRUPTIBLE);   ######## here set the
interrupt to  TASK_INTERRUPTIBLE state

               ########### if the process was schedued out here, it
will can never been waken up .
               ########### Because the process wasn't attached to any
file's waitqueue at this point yet

		inp = fds->in; outp = fds->out; exp = fds->ex;
		rinp = fds->res_in; routp = fds->res_out; rexp = fds->res_ex;

		for (i = 0; i < n; ++rinp, ++routp, ++rexp) {
			unsigned long in, out, ex, all_bits, bit = 1, mask, j;
			unsigned long res_in = 0, res_out = 0, res_ex = 0;
			struct file_operations *f_op = NULL;
			struct file *file = NULL;

			in = *inp++; out = *outp++; ex = *exp++;
			all_bits = in | out | ex;
			if (all_bits == 0) {
				i += __NFDBITS;
				continue;
			}

			for (j = 0; j < __NFDBITS; ++j, ++i, bit <<= 1) {
				if (i >= n)
					break;
				if (!(bit & all_bits))
					continue;
				file = fget(i);
				if (file) {
					f_op = file->f_op;
					mask = DEFAULT_POLLMASK;
					if (f_op && f_op->poll)
						mask = (*f_op->poll)(file, retval ? NULL : wait);
					fput(file);
					if ((mask & POLLIN_SET) && (in & bit)) {
						res_in |= bit;
						retval++;
					}
					if ((mask & POLLOUT_SET) && (out & bit)) {
						res_out |= bit;
						retval++;
					}
					if ((mask & POLLEX_SET) && (ex & bit)) {
						res_ex |= bit;
						retval++;
					}
				}
				cond_resched();
			}
			if (res_in)
				*rinp = res_in;
			if (res_out)
				*routp = res_out;
			if (res_ex)
				*rexp = res_ex;
		}
		wait = NULL;
		if (retval || !*timeout || signal_pending(current))
			break;
		if(table.error) {
			retval = table.error;
			break;
		}

		if (*timeout < 0) {
			/* Wait indefinitely */
			__timeout = MAX_SCHEDULE_TIMEOUT;
		} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT - 1)) {
			/* Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in a loop */
			__timeout = MAX_SCHEDULE_TIMEOUT - 1;
			*timeout -= __timeout;
		} else {
			__timeout = *timeout;
			*timeout = 0;
		}
		__timeout = schedule_timeout(__timeout);
		if (*timeout >= 0)
			*timeout += __timeout;
	}
	__set_current_state(TASK_RUNNING);

	poll_freewait(&table);

	return retval;
}
