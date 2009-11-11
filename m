Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZKKCIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZKKCIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZKKCIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:08:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbZKKCIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:08:37 -0500
Message-ID: <4AFA1C70.5070700@cn.fujitsu.com>
Date: Wed, 11 Nov 2009 10:07:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: bblum@andrew.cmu.edu, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by
 tgid at	once
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com> <4AF84C68.7010803@free.fr> <4AF8C20C.1070003@cn.fujitsu.com> <4AF93FE5.1080009@free.fr>
In-Reply-To: <4AF93FE5.1080009@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hi Ben,
>>>
>>> The current code (with or without your patch) may lead to an error
>>> because the fork hook can fail and the exit hook is called in all the
>>> cases making the fork / exit asymmetric.
>>>
>>>     
>>
>> The _current_ code won't lead to this error, because the fork hook
>> can't fail.
>>   
> Right, as no subsystem is using both hooks right now, the bug is never
> triggered and the current code won't lead to an error.
> But from my POV, there is a bug hidden in a corner waiting for a
> subsystem to make use of the fail-able fork / exit :)
> 

Actually the freezer subsystem is using the fork hook, but it doesn't
need to be able to fail it.

I don't think we can claim this a bug. If there is a new subsystem
that needs fail-able fork hook, it has to extent the hook interface
and adjust the code to meet its needs.

We always adjust our code to meet new needs, don't we?

>>> I will take the usual example with a cgroup with a counter of tasks, in
>>> the fork hook it increments the counter, in the exit hook it decrements
>>> the counter. There is one process in the cgroup, hence the counter value
>>> is 1. Now this process forks and the fork hook fails before the task
>>> counter is incremented to 2, this is not detected in copy process
>>> function because the cgroup_fork_callbacks does not return an error, so
>>> the process will be forked without error and when the process will exits
>>> the counter will be decremented reaching 0 instead of 1.
>>>
>>> IMO, the correct fix should be to make the fork hook to return an error
>>> and have the cgroup to call the exit method of the subsystem where the
>>> fork hook was called. For example, there are 10 subsystems using the
>>> fork / exit hooks, when the a process forks, the fork callbacks is
>>> called for these subsystems but, let's say, the 3rd fails. So we undo,
>>> by calling the exit hooks of the first two.
>>>
>>> I wrote a patchset to consolidate the hooks called in the cgroup for
>>> fork and exit, and one of them does a rollback for the fork hook when an
>>> error occurs. I added an attachment the patch as an example.
>>>
>>>     
>>
>> I'd like to see this patch sent with another patch that needs this
>> fail-able fork() hook.
>>
>> Note this patch is not doing a _fix_, but does an extension. And
>> for now, this extension is not needed.
>>   
> I don't know, may be it could be interesting to implement that before
> more subsystems make use of these hooks.
> This is not critical, that can be sent later, separately from this
> patchset of course.
> 

We tend to remove code that is not used. For example, we may remove
subsys->bind() interface, because no one is using it, though it has
been there for years.

So adding things that are not used is normally not good.

