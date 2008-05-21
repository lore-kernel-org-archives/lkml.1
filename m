Return-Path: <linux-kernel-owner+w=401wt.eu-S936302AbYEUDym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936302AbYEUDym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936057AbYEUDub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:50:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49430 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936056AbYEUDu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:50:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru>
Date: Tue, 20 May 2008 20:47:16 -0700
In-Reply-To: <20080325135645.GA96@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 25 Mar 2008 16:56:45 +0300")
Message-ID: <m18wy45nej.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@tv-sign.ru>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0497]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the very delayed response.  I have been moving and overwhelmed
with everything.

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 03/25, Atsushi Tsuji wrote:
>> 
>> This patch avoid taking tasklist_lock in kill_something_info() when
>> the pid is -1. It can convert to rcu_read_lock() for this case because
>> group_send_sig_info() doesn't need tasklist_lock.
>> 
>> This patch is for 2.6.25-rc5-mm1.
>> 

> Hmm. Yes, group_send_sig_info() doesn't need tasklist_lock. But we
> take tasklist_lock to "freeze" the tasks list, so that we can't miss
> a new forked process.
>
> Same for __kill_pgrp_info(), we take tasklist to kill the whole group
> "atomically".
>
>
> However. Is it really needed? copy_process() returns -ERESTARTNOINTR
> if signal_pending(), and the new task is always placed at the tail
> of the list. Looks like nobody can escape the signal, at least fatal
> or SIGSTOP.


Call me paranoid but I don't think there is any guarantee without a lock
that we will hit the -ERESTARTNOITR check for new processes.  I think we
have a slight race where the fork process may not have received the signal
(because it is near the tail of the list) but the new process would be
added to the list immediately after we read it's pointer.

> Note also that copy_process() does list_add_tail_rcu(p->tasks) under
> ->siglock, this means kill_something_info() must see the new childs
> after group_send_sig_info() drops ->siglock.

That is subtle.  Switching to the per task siglock for protection.

> Except: We don't send the signal to /sbin/init. This means that (say)
> kill(-1, SIGKILL) can miss the task forked by init. Note that this
> task could be forked even before we start kill_something_info(), but
> without tasklist there is no guarantee we will see it on the ->tasks
> list.

Actually we do sent the signal to init but we shouldn't, if we want
our semantics straight.  And we drop the signal early enough we might
not see it.

> I think this is the only problem with this change.
>
> Eric, Roland?

That is a very subtle idea.  I wish I could convince myself it would
work and be maintainable.

> (Unfortunately, attach_pid() adds the task to the head of hlist, this
>  means we can't avoid tasklist for __kill_pgrp_info).

Probably.  If there wasn't a chance of sending a signal twice we
could rescan the list if the head changed.

What we might be able to do is to switch the tasklist_lock into a seq_lock.
like was done for the dcache.  The challenge is how to avoid resending
a signal when we retry.  Store the sequence number in the sighand_struct?

If we had a magic place that children could check. To see if they belonged
to a group of processes that was exiting that might help.

Grr.  I just can't see any solution that is cheaper and that I can
verify will be correct.

Eric
