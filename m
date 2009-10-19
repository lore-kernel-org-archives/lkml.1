Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbZJSVrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbZJSVrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZJSVro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:47:44 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:45041 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbZJSVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:47:43 -0400
Message-ID: <4ADCDE7F.4090501@librato.com>
Date: Mon, 19 Oct 2009 17:47:43 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr>
In-Reply-To: <4ADCCD68.9030003@free.fr>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Daniel Lezcano wrote:
> Sukadev Bhattiprolu wrote:
>> Daniel Lezcano [daniel.lezcano@free.fr] wrote:
>>   
>>> Sukadev Bhattiprolu wrote:
>>>     
>>>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
>>>>
>>>> To support application checkpoint/restart, a task must have the same pid it
>>>> had when it was checkpointed.  When containers are nested, the tasks within
>>>> the containers exist in multiple pid namespaces and hence have multiple pids
>>>> to specify during restart.
>>>>
>>>> This patchset implements a new system call, clone3() that lets a process
>>>> specify the pids of the child process.
>>>>

[...]

>>> Otherwise, shouldn't be more convenient to have something usable for
>>> everyone, let's say:
>>>
>>> cloneat(pid_t pid, pid_t desiredpid, ...);
>>>
>>> Where 'desiredpid' is a hint of for the kernel for the pid to be
>>> allocated (zero means the kernel will choose one for us) and the newly
>>> allocated task is the son of 'pid'.
>>>     
>> Hmm, so P1 would call cloneat() to create a child P3 _on behalf_ of process
>> P2 ?  I did not know we had a requirement for that. Can you explain the
>> use-case more ? IOW, why can't P2 create the child P3 by itself ?
>>   
> I forgot to mention a constraint with the specified pid : P2 has to be 
> child of P1.
> In other word, you can not specify a pid to clonat which is not your 
> descendant (including yourself).
> With this constraint I think there is no security issues.

Sounds dangerous. What if your descendant executed a setuid program ?

> 
> Concerning of forking on behalf of another process, we can consider it 
> is up to the caller / programmer to know what it does. If a process in 

Before the user can program with this syscall, _you_ need to define
the semantics of this syscall. For example, do you freeze that other
process to ensure that the clone is consistent ?

> the process hierarchy exec'ed a program and we cloneat this process and 
> then the program fails because of an "unexpected error", well, we should 
> have not done that. A similar example is when the IPC are removed while 
> they are used by some other processes.
> 
> Here it is a interesting use case:
>  * if you created a pid namespace, and, let's say, booted a system 
> container where the container init is the "init" process, then with this 
> call you can enter the container at any time by doing cloneat() followed 
> by an exec of your command. I think that was a requirement when there 
> were discussions around "sys_hijack".

Can you define more precisely what you mean by "enter" the container ?

If you simply want create a new process in the container, you can
achieve the same thing with a daemon, or a smart init process (in
there), or even ptrace tricks.

Also, there is a reason why sys_hijack() was hijacked away ... And
I honestly think that a syscall to force another process to clone
would be shot down by the kernel guys.

> Another point. It's another way to extend the exhausted clone  flags as 
> the cloneat can be called as a compatibility way, with cloneat(getpid(), 
> 0, ... )

Which is what the proposed new clone_....() does.

> 
>> Note also that 'desiredpid' must be a list of pids (one for each pid
>> namespaces that the child will belong to) and hence we need 'nr_pids'
>> to specify the list. Given that we are limited to 6 parameters to the
>> syscall, such parameters must be stuffed into 'struct clone_args'.
>>
>> So we should do something like:
>>
>> 	sys_clone3(u32 flags_low, pid_t pid, struct clone_args *carg,
>> 		pid_t *desired_pids)
>>
>> or (to match the name and parameters, move 'pid' parameter into clone_args)
>>   
> Well, hiding multiple clone in one clone call is ... weird. AFAIR, there 
> was a debate between kernel or userspace proctree creation but it looks 
> like it's done from the kernel with this call.

It isn't multiple clones in one clone. The syscall creates *one* single
process. We just ask the kernel to assign a specific pid to that process.

And because processes that live in nested pid-namespace own multiple
pids (one for each level), we need to specify multiple pids (one for
each level) for this single process that we create.

Then, to create the entire restart process tree, we have to call this
system call as many times as the number of processes to restart.

And yes, this is all done in userspace. The _only_ kernel-space help
is an interface to request specific pid(s) for each restarted process.

> I don't really see a difference between sys_restart(pid_t pid , int fd, 
> long flags) where pid_t is the topmost in the hierarchy, fd is a file 
> descriptor to a structure "pid_t * + struct clone_args *" and flags is 
> "PROCTREE".

What you describe here is the way openvz's kernel-side process tree
restart works. This is not the current approach.

> IMHO, it is nicer to recursively restore the process tree for the nested 
> pid namespaces, that will be really an userspace process tree creation 
> and cloneat will be your friend here :)

The restart.c utility from the userspace tools (user-cr) is your
friend here...  I'm sure you'll think it's nice :p

>>> That looks more consistent with the "<syscall>at" family, 'openat',
>>> 'faccessat', 'readlinkat', etc ... and usable for something else than
>>> the checkpoint / restart.
>>>     
>> The subtle difference though is that openat() does not open a file on
>> behalf of another process and so the 'at' suffix would not apply ?
>>   
> Yes and no, depending of where you put the cursor. If you consider the 
> 'at' suffix means a process context, then I agree with you, there is a 
> difference because the cloneat will be out of the current process 
> context. But if you consider the 'at' suffix as a context in general, 
> and openat means "relatively to a file descriptor" and cloneat means 
> "relatively to a pid namespace" the 'at' suffix may apply. But I agree 
> that we are so used to call the posix "fork", that cloneat sounds scary :)

At this point, I really couldn't care less about how we name the
new syscall.

Check out the containers IRC channel for the latest pearls:
clone_plus_with_aloe() and clone_plus_with_aloe_3_args() are
the prominent contenders, together with xerox() and ditto()...

There you go; these should be enough to keep the discussion
around on life support for at least another week.

I really really really hope we can settle down on *a* name,
*any* name, and move forward. Amen.

Oren.

