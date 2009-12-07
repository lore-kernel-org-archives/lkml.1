Return-Path: <linux-kernel-owner+w=401wt.eu-S933521AbZLGWLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbZLGWLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:11:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932807AbZLGWK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:10:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36106 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780AbZLGWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:10:55 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20091130100041.GA29610@infradead.org>
	<alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
	<20091130174638.GA9782@elte.hu>
	<alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	<1259616429.26472.499.camel@laptop>
	<alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	<alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
	<m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 07 Dec 2009 14:10:50 -0800
In-Reply-To: <20091207183226.GA20139@redhat.com> (Oleg Nesterov's message of "Mon\, 7 Dec 2009 19\:32\:26 +0100")
Message-ID: <m1aaxu305x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [rfc] "fair" rw spinlocks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 12/05, Eric W. Biederman wrote:
>>
>> Atomically sending signal to every member of a process group, is the
>> big fly in the ointment I am aware of.  Last time I looked I could
>> not see how to convert it rcu.
>
> I am not sure, but iirc we can do this lockless (under rcu_lock).
> We need to modify pid_link to use list_entry and attach_pid() should
> add the new task to the end. Of course we need more changes, but
> (again iirc) this is not too hard.

The problem is that even adding to the end of the list, we could run
into a deleted entry and not see the new end of the list.

Suppose when we start iterating the list we have:

  A -> B -> C -> D

Then someone deletes some of the entries while we are iterating the list.

A ->
 B' -> C' -> D'

We will continue on traversing through the deleted entries.

Then someone adds a new entry to the end of the list.

A-> N

Since we are at B', C' or D' we will never see the new entry on the
end of the list.

If there was a way to iterate a list with a guarantee that we always saw
new entries while we are traversing it I would love to see it.

Additionally we have the other possibility that if a child is forking
we send the signal to the parent after the child forks away but before
the child joins whichever list we are walking, and we complete our
traversal without seeing the child.

>> This is a pain because we occasionally signal a process group from
>> interrupt context.
>
> Only send_sigio/etc does so, right?

That seems right.  My memory is vague and as I recall you were the one
who found the senders in interrupt context.

> I didn't read the previous discussion yet (will try tomorrow), sorry
> if I am off-topic. But I think the nastiest problem with tasklist
> is that it protects parent/child relationship. We need per-process
> lock, but first we should change ptrace to avoid this lock somehow.
> (this is one of the goals of ptrace-utrace, but not "immediate").

That is another good one.  The discussion was roughly:
We should get rid of rwlocks.
tasklist_lock is a rwlock.
What prevents us from making tasklist_lock a spinlock etc.

On that score since we take tasklist_lock for write in ptrace_attach
and I presume in the other parent/child cases  I don't think that
issue prevents us from moving off of rwlocks for tasklist_lock.

Eric
