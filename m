Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZGXVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZGXVw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZGXVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:52:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZGXVwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:52:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=SDj8GaJn+oXh5IQOByia87/adrCgZGZQEeffVHiLzJ5oEcBCgz1Wu8Vx7sez2LDqc
	3gHpOBa8j9pjgMvOf8aDg==
MIME-Version: 1.0
In-Reply-To: <20090724100220.GF11101@hawkmoon.kerlabs.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724100220.GF11101@hawkmoon.kerlabs.com>
Date: Fri, 24 Jul 2009 14:52:15 -0700
Message-ID: <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com>
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 3:02 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
> On 23/07/09 20:22 -0700, Ben Blum wrote:
>> @@ -408,6 +409,15 @@ You can attach the current shell task by echoing 0:
>>
>>  # echo 0 > tasks
>>
>> +The cgroup.procs file is useful for managing all tasks in a threadgroup at
>> +once. It works the same way as the tasks file, but moves all tasks in the
>> +threadgroup with the specified tgid.
>> +
>> +Writing the pid of a task that's not the threadgroup leader (i.e., a pid
>> +that isn't a tgid) is treated as invalid. Writing a '0' to cgroup.procs will
>> +attach the writing task and all tasks in its threadgroup, but is invalid if
>> +the writing task is not the leader of the threadgroup.
>> +
>
> This restriction sounds unfortunate and I'm not sure that there are good reasons
> for it (see below).

Would it be preferable to allow any thread in a threadgroup to move
the whole group to a new cgroup? Would that undermine the desired
restriction of the tasks file in which a thread needs to have
sufficient perms to move a thread that's not itself, or is the task
file's restriction there undesirable in the case of threadgroups?

>> +     /*
>> +      * step 2: now that we're guaranteed success wrt the css_sets, proceed
>
> I don't see how css_sets are guaranteed while cgroup_fork_mutex is not held and
> thus does not prevent new threads from being created right now. Could you
> elaborate on that?

Prefetching the css sets is independent of the fork lock/race issue.
The idea is that we build a list, kept locally, that has references on
all the css_sets we'll need to migrate each thread to the new cgroup.
Since ordinarily we might need to malloc a new css_set for a thread
before moving it, and it's possible that that could fail, we need to
do allocations for all threads to be moved before committing any of
them. As long as we have the list of prefetched css_sets, they'll stay
there, and at the end, we drop the extra references we took on them to
make that guarantee when tearing down the list.

>
>> +      * to move all tasks to the new cgroup. the only fail case henceforth
>> +      * is if the threadgroup leader has PF_EXITING set (in which case all
>> +      * the other threads get killed) - if other threads happen to be
>
> This statement is wrong. A thread group leader can have PF_EXITING (and even
> become zombie) while other sub-threads continue their execution. For instance it
> is perfectly valid for a thread group leader to call sys_exit(), and no other
> thread will be affected.

Is that the case? Then, what becomes of his task_struct when he's
gone, since presumably all the sub-threads will need it. Does it just
hang around?

If so, would the desired behaviour be to proceed with moving all
sub-threads if the leader is exiting? (That's not a very big change
code-wise)
