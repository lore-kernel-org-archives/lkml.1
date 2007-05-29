Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXE2EzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXE2EzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 00:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbXE2Ey5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 00:54:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43221 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbXE2Ey5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 00:54:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, jengelh@linux01.gwdg.de, holt@sgi.com,
       oleg@tv-sign.ru, roland@redhat.com
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <787b0d920705282023v22316e6bk709dc8d3aa3213d7@mail.gmail.com>
Date: Mon, 28 May 2007 22:53:36 -0600
In-Reply-To: <787b0d920705282023v22316e6bk709dc8d3aa3213d7@mail.gmail.com>
	(Albert Cahalan's message of "Mon, 28 May 2007 23:23:02 -0400")
Message-ID: <m1646c8c33.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Albert Cahalan" <acahalan@gmail.com> writes:

> Jan Engelhardt writes:
>> On Apr 10 2007 17:47, Jan Engelhardt wrote:
>>> On Apr 8 2007 20:57, Oleg Nesterov wrote:
>
>>>> Anyway, re-parenting to swapper breaks pstree, it doesn't
>>>> show kernel threads. And if ->parent == /sbin/init, we can't
>>>> remove us from ->children (unless we forbid sub-thread-of-init
>>>> exec). So the only safe change is set ->exit_state = -1.
>>>
>>> Then we have to fix pstree and all that. (In fact, I'm
>>> trying to patch `ps f` to DTRT ;p)
>>
>> Done that and the result is that `ps afwx` now looks like:
>>
>>   PID TTY      STAT   TIME COMMAND
>>  2722 ?        S      0:00 [lockd]
> ...
>>     3 ?        S<     0:00 [events/0]
>>     2 ?        SN     0:00 [ksoftirqd/0]
>>     1 ?        Ss     0:02 init [3]
>>   537 ?        S<s    0:02  \_ /sbin/udevd --daemon
>>  1600 ?        Ss     0:00  \_ /usr/bin/dbus-daemon --system
>>  1692 ?        Ss     0:00  \_ /sbin/acpid
>>  1923 ?        Ss     0:00  \_ /sbin/resmgrd
> ...
>> -    if(self_pid==1 && ADOPTED(processes[i]) && forest_type!='u')
>> +    if(ADOPTED(processes[i]) && forest_type!='u')
>
> That's not compatible because init's children are now in the
> logical place. Since the days of procps-1.x.x or earlier,
> such processes have been listed at top level.
>
> BTW, what does "ps -ejH" do for you, with and without the patch?

ps -ejH displays everything.  For 2.6.22 we will only have kthreadd
as a sibling of init with ppid == 0.  Depending on what happens
in the evolution of how we start kernel thread we may be able
to remove kthreadd and have all kthreads with a ppid of 0, but only
time will tell.

> I'd be a lot happier about breaking compatibility in this area
> if I could get a functional adoption flag. That is, I really
> would like to show a process as child of init if it naturally
> was created as a child of init. It's less informative to have
> fake children showing up the same as real ones. The original
> parent PID would do. (BTW, the original parent name and/or
> grandparent PID would be great to have) As a bonus, the kernel
> could reap these processes more quickly than init can... and
> then maybe we can stop caring if init is alive.

Having the kernel not reparent user processes to init is an interesting
idea, especially when those processes have not existed.  I'm not
certain that is POSIX complaint and otherwise backwards compatible.

Eric



