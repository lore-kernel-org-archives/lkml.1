Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZJPTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZJPTnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZJPTnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:43:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34787 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZJPTnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:43:10 -0400
Date: Fri, 16 Oct 2009 12:44:51 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, Louis.Rilling@kerlabs.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091016194451.GA28706@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD8C7E4.9000903@free.fr>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano [daniel.lezcano@free.fr] wrote:
> Sukadev Bhattiprolu wrote:
>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
>>
>> To support application checkpoint/restart, a task must have the same pid it
>> had when it was checkpointed.  When containers are nested, the tasks within
>> the containers exist in multiple pid namespaces and hence have multiple pids
>> to specify during restart.
>>
>> This patchset implements a new system call, clone3() that lets a process
>> specify the pids of the child process.
>>
>> Patches 1 through 7 are helper patches, needed for choosing a pid for the
>> child process.
>>
>> PATCH 9 defines a prototype of the new system call. PATCH 10 adds some
>> documentation on the new system call, some/all of which will eventually
>> go into a man page.
>>   
>
> Sorry for jumping so late in the discussion and for having maybe my
> remarks pointless...
>
> If this syscall is only for checkpoint / restart, why this shouldn't be
> used with a future generic sys_restart syscall ?

As I tried to explain in PATCH 0/9, the ability to choose a pid is only
for C/R but we are also trying to clone-flags so we won't need yet
another variant of clone() fairly soon.

> Otherwise, shouldn't be more convenient to have something usable for
> everyone, let's say:
>
> cloneat(pid_t pid, pid_t desiredpid, ...);
>
> Where 'desiredpid' is a hint of for the kernel for the pid to be
> allocated (zero means the kernel will choose one for us) and the newly
> allocated task is the son of 'pid'.

Hmm, so P1 would call cloneat() to create a child P3 _on behalf_ of process
P2 ?  I did not know we had a requirement for that. Can you explain the
use-case more ? IOW, why can't P2 create the child P3 by itself ?

Note also that 'desiredpid' must be a list of pids (one for each pid
namespaces that the child will belong to) and hence we need 'nr_pids'
to specify the list. Given that we are limited to 6 parameters to the
syscall, such parameters must be stuffed into 'struct clone_args'.

So we should do something like:

	sys_clone3(u32 flags_low, pid_t pid, struct clone_args *carg,
		pid_t *desired_pids)

or (to match the name and parameters, move 'pid' parameter into clone_args)

> That looks more consistent with the "<syscall>at" family, 'openat',
> 'faccessat', 'readlinkat', etc ... and usable for something else than
> the checkpoint / restart.

The subtle difference though is that openat() does not open a file on
behalf of another process and so the 'at' suffix would not apply ?

>
> Thanks
>  -- Daniel
