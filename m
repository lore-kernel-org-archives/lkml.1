Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbXCSTJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbXCSTJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXCSTJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:09:17 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57571 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXCSTJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:09:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
	<m1mz29xi8g.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0703191112500.2101@alien.or.mcafeemobile.com>
Date: Mon, 19 Mar 2007 13:08:26 -0600
In-Reply-To: <Pine.LNX.4.64.0703191112500.2101@alien.or.mcafeemobile.com>
	(Davide Libenzi's message of "Mon, 19 Mar 2007 11:53:02 -0700 (PDT)")
Message-ID: <m11wjlxd91.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Mon, 19 Mar 2007, Eric W. Biederman wrote:
>
>> Davide Libenzi <davidel@xmailserver.org> writes:
>> 
>> > struct signalfd_siginfo {
>> > 	__u32 signo;	/* si_signo */
>> > 	__s32 err;	/* si_errno */
>> > 	__s32 code;	/* si_code */
>> > 	__u32 pid;	/* si_pid */
>> > 	__u32 uid;	/* si_uid */
>> > 	__s32 fd;	/* si_fd */
>> > 	__u32 tid;	/* si_fd */  
>> > 	__u32 band;	/* si_band */
>> > 	__u32 overrun;	/* si_overrun */
>> > 	__u32 trapno;	/* si_trapno */
>> > 	__s32 status;	/* si_status */
>> > 	__s32 svint;	/* si_int */
>> > 	__u64 svptr;	/* si_ptr */
>> > 	__u64 utime;	/* si_utime */
>> > 	__u64 stime;	/* si_stime */
>> > 	__u64 addr;	/* si_addr */
>> > };
>> 
>> Shouldn't we pad this to 128 bytes like we do siginfo in case there are
>> more fields we need to include, or we need to extend the size of some
>> field?
>
> Yes, I guess we can.

I'm just a little paranoid about ABI's.  There is always something
that crops up.  And while we can probably cope by simply having another
version of the signalfd or whatever your syscall is, but having to do
that at the first sign of trouble sucks.  Especially since we would have
to maintain two versions indefinitely.

>> > +
>> > +struct signalfd_ctx {
>> > +	struct list_head lnk;
>> > +	wait_queue_head_t wqh;
>> > +	sigset_t sigmask;
>> > +	struct task_struct *tsk;
>> > +};
>> 
>> I think you want to use a struct pid *pid instead of a pointer to the
>> task struct here.  It is slightly less efficient (one more
>> dereference) but it means that we won't pin the task struct in memory
>> indefinitely.  Pinning the task_struct like this makes for a very
>> interesting way to get around the limits on the number of processes a
>> user can have.
>
> Hmm, when the task is detached from the sighand, we get a notify, so I 
> could do a put from there. This would avoid the extra de-reference. I need 
> to verify locking though ...

Ok.  That sounds more efficient than playing with struct pid pointers,
if it works.

Eric
