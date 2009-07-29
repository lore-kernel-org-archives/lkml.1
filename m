Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZG2AXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZG2AXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZG2AXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:23:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZG2AXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:23:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=BbxH/0EXjw0BLx+BU5uKXuE0pF/QjcnrZMO9mLAij0z8UjA2jF6MIkrQ9u0eFOxt7
	u2GK2lJiN+EXKI1plRhlQ==
MIME-Version: 1.0
In-Reply-To: <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724100220.GF11101@hawkmoon.kerlabs.com>
	 <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com>
Date: Tue, 28 Jul 2009 17:23:01 -0700
Message-ID: <2f86c2480907281723n7452c7f5l5a475e8120dccd83@mail.gmail.com>
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

On Fri, Jul 24, 2009 at 2:52 PM, Benjamin Blum<bblum@google.com> wrote:
> On Fri, Jul 24, 2009 at 3:02 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>> On 23/07/09 20:22 -0700, Ben Blum wrote:
>>> @@ -408,6 +409,15 @@ You can attach the current shell task by echoing 0:
>>>
>>>  # echo 0 > tasks
>>>
>>> +The cgroup.procs file is useful for managing all tasks in a threadgroup at
>>> +once. It works the same way as the tasks file, but moves all tasks in the
>>> +threadgroup with the specified tgid.
>>> +
>>> +Writing the pid of a task that's not the threadgroup leader (i.e., a pid
>>> +that isn't a tgid) is treated as invalid. Writing a '0' to cgroup.procs will
>>> +attach the writing task and all tasks in its threadgroup, but is invalid if
>>> +the writing task is not the leader of the threadgroup.
>>> +
>>
>> This restriction sounds unfortunate and I'm not sure that there are good reasons
>> for it (see below).
>
> Would it be preferable to allow any thread in a threadgroup to move
> the whole group to a new cgroup? Would that undermine the desired
> restriction of the tasks file in which a thread needs to have
> sufficient perms to move a thread that's not itself, or is the task
> file's restriction there undesirable in the case of threadgroups?

Still wondering on what to do about this. Noting that this restriction
approximately parallels the behaviour you'd get from using the tasks
file, I think it'd be safer to leave it like this then possibly in the
future lift the restriction, rather than make it currently lifted then
decide in the future that we want to re-impose it.

>>> +      * to move all tasks to the new cgroup. the only fail case henceforth
>>> +      * is if the threadgroup leader has PF_EXITING set (in which case all
>>> +      * the other threads get killed) - if other threads happen to be
>>
>> This statement is wrong. A thread group leader can have PF_EXITING (and even
>> become zombie) while other sub-threads continue their execution. For instance it
>> is perfectly valid for a thread group leader to call sys_exit(), and no other
>> thread will be affected.
>
> Is that the case? Then, what becomes of his task_struct when he's
> gone, since presumably all the sub-threads will need it. Does it just
> hang around?
>
> If so, would the desired behaviour be to proceed with moving all
> sub-threads if the leader is exiting? (That's not a very big change
> code-wise)
>

I've fixed this, and also implemented the rwsem as threadgroup-local.
If there's no more discussion on this version of the patch, I'll send
out the revised series soon.
