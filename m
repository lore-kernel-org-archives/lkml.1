Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbZBXQVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbZBXQVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBXQVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:21:45 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:34375 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZBXQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JRqs6L9ucJynsVnUQFRnu7l2uvGmWq27Mp9MyxRZDMPvc8fXfOjjY/qpjMlGQVL7sy
         5WTW0lxqBEjeOdqpdV8bO+y3iD7CuSl6MZRg0846zJjeBJFYPKc+Ub9ZFPI1VPiRlR54
         SivaatCyPKt6GyrLiq3eIx/TX/NvdWJ9Hyeak=
Message-ID: <49A41E90.8090304@gmail.com>
Date: Tue, 24 Feb 2009 17:21:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: broken do_each_pid_{thread,task}
References: <494581D7.6000203@gmail.com> <m1wse29roy.fsf@frodo.ebiederm.org> <20081215104716.GB11106@redhat.com> <20081215170937.GA24080@redhat.com> <49A3F48E.5030008@gmail.com> <20090224154936.GA13837@redhat.com>
In-Reply-To: <20090224154936.GA13837@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.2.2009 16:49, Oleg Nesterov wrote:
> But why do you dislike it? Yes, the implementation of pid_for_each_task()
> is not simple. Partly because hlist_for_each_entry_rcu() is ugly and
> imho should be fixed (see btw http://marc.info/?t=120879441200004).
>
> But with this patch the callers become simpler, we can just do
>
> 	pid_for_each_task(pid, type, task)
> 		do_something(task);
>
> instead of
>
> 	 do_each_pid_task(pid, type, task) {
> 	 	do_something(task);
> 	 } while_each_pid_task(pid, type, task);
>
> and we can use break/continue safely.

I like what it does, not much how. Anyway I was thinking about 
hlist_for_each_entry_rcu_param or alike (which would take additional 
parameters for 3 `for' expressions to add to standard hlist for each 
ones), but I think it would be less readable than this:

>>> +#define pid_for_each_task(pid, type, p)	\
>>> +	for (p = (pid) ? (void*)(pid)->tasks[type].first : NULL;	\
>>> +	     rcu_dereference(p)&&   ({					\
>>> +		prefetch(((struct hlist_node*)p)->next);		\
>>> +		p = hlist_entry((void*)p, typeof(*p), pids[type].node);	\
>>> +		1; });							\
>>> +	     p = ((type) != PIDTYPE_PID) ?				\
>>> +		(void*)(p)->pids[type].node.next : NULL)
>>> +
>
> Really, is this too bad?

Well, it still can be worse :).

Ok, could you repost with commit log and proper CCs or merge anywhere to 
pull from?
