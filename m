Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZBXPwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZBXPwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZBXPw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:52:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbZBXPw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:52:29 -0500
Date: Tue, 24 Feb 2009 16:49:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: broken do_each_pid_{thread,task}
Message-ID: <20090224154936.GA13837@redhat.com>
References: <494581D7.6000203@gmail.com> <m1wse29roy.fsf@frodo.ebiederm.org> <20081215104716.GB11106@redhat.com> <20081215170937.GA24080@redhat.com> <49A3F48E.5030008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3F48E.5030008@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Jiri Slaby wrote:
>
> On 15.12.2008 18:09, Oleg Nesterov wrote:
>> On 12/15, Oleg Nesterov wrote:
>>> On 12/14, Eric W. Biederman wrote:
>>>> Although seeing the unexpected corner case it gets us into I think it would
>>>> be good to reconsider this test.
>>
>> So. I can't decide whether this patch is cleanup or the further
>> uglification, but if anyone likes it I will be happy to send it.
>
> FWIW I don't like the patch :)

Well, I agree, it is not very nice ;)

But why do you dislike it? Yes, the implementation of pid_for_each_task()
is not simple. Partly because hlist_for_each_entry_rcu() is ugly and
imho should be fixed (see btw http://marc.info/?t=120879441200004).

But with this patch the callers become simpler, we can just do

	pid_for_each_task(pid, type, task)
		do_something(task);

instead of

	 do_each_pid_task(pid, type, task) {
	 	do_something(task);
	 } while_each_pid_task(pid, type, task);

and we can use break/continue safely.

> Otherwise I'll add at least a big warning about using break/cont
> statements inside the loop.

Agreed, this would be nice.

>> +#define pid_for_each_task(pid, type, p)	\
>> +	for (p = (pid) ? (void*)(pid)->tasks[type].first : NULL;	\
>> +	     rcu_dereference(p)&&  ({					\
>> +		prefetch(((struct hlist_node*)p)->next);		\
>> +		p = hlist_entry((void*)p, typeof(*p), pids[type].node);	\
>> +		1; });							\
>> +	     p = ((type) != PIDTYPE_PID) ?				\
>> +		(void*)(p)->pids[type].node.next : NULL)
>> +

Really, is this too bad?

Oleg.

