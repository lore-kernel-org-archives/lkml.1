Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbXDIRiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbXDIRiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXDIRiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:38:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXDIRiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:38:00 -0400
Message-ID: <461A79C4.20901@redhat.com>
Date: Mon, 09 Apr 2007 13:37:08 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>	<46159987.6090006@redhat.com>	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> I'm not sure anybody would really be unhappy with pptr pointing to some 
>> magic and special task that has pid 0 (which makes it clear to everybody 
>> that the parent is something special), and that has SIGCHLD set to SIG_IGN 
>> (which should make the exit case not even go through the zombie phase).
>>
>> I can't even imagine *how* you'd make a tool unhappy with that, since even 
>> tools like "ps" (and even more "pstree" won't read all the process states 
>> atomically, so they invariably will see parent pointers that don't even 
>> exist any more, because by the time they get to the parent, it has exited 
>> already.
> 
> Right.  pid == 1 being missing might cause some confusing having 
> but having ppid == 0 should be fine.  Heck pid == 1 already has 
> ppid == 0, so it is a value user space has had to deal with for a
> while.
> 
> In addition there was a period in 2.6 where most kernel threads
> and init had a pgid == 0 and a session  == 0, and nothing seemed
> to complain.
> 
> We should probably make all of the kernel threads children of
> init_task.  The initial idle thread on the first cpu that is the
> parent of pid == 1.   That will give the ppid == 0 naturally because
> the idle thread has pid == 0.

Linus, Eric, thanks for the history lesson.  I think it's safe to say 
that anything that breaks because of this sort of change was already 
broken anyway.

If we're going to scale to an obscene number of CPUs (which I believe 
was the original motivation on this thread) then putting the dead 
children on their own list will probably scale better.

	-- Chris
