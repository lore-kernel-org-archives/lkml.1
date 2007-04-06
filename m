Return-Path: <linux-kernel-owner+w=401wt.eu-S934100AbXDFSDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbXDFSDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934079AbXDFSDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:03:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46043 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700AbXDFSDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:03:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Robin Holt <holt@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru>
Date: Fri, 06 Apr 2007 12:02:44 -0600
In-Reply-To: <20070406163100.GA554@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 6 Apr 2007 20:31:01 +0400")
Message-ID: <m1abxl754r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/06, Eric W. Biederman wrote:
>>
>> Thinking about it I do agree with Linus that two lists sounds like the
>> right solution because it ensures we always have O(1) time when
>> waiting for a zombie.
>
> Well. I bet this will be painful, and will uglify the code even more.
>
> do_wait() has to iterate over 2 lists, __ptrace_unlink() should check
> ->exit_state, etc...

Well I would prefer to iterate over 2 lists as opposed to N lists that
we have now.

The __ptrace_unlink issue sounds moderately valid although a ptraced
zombie is down right peculiar.

>>                        I'd like to place the list head for the zombie
>> list in the signal_struct and not in the task_struct so our
>> performance continues to be O(1) when we have a threaded process.
>
> Sure. It would be nice to move ->children into signal_struct at first.
> Except this change breaks (in fact fixes) ->pdeath_signal behaviour.

Actually this should be independent of the pdeath_signal issue.
As long as we record pdeath_signal per task_struct we can continue
to implement the existing semantics.

Although we really should fix pdeath_signal and push the patch to
-mm.  We only didn't do that because the original patch was a
bug fix for stable kernels, and we didn't have time to verify fixing
pdeath_signal would not break anything else.

>> The big benefit of the zombie list over your proposed list reordering
>> is that waitpid can return immediately when we don't have zombies to
>> wait for, but we have lots of children.
>
> TASK_TRACED/TASK_STOPPED ?

Well it doesn't fix everything yet but it does fix the common case.
I wonder if it would make sense to have other lists as well.

Regardless of how this fixes scaling someone needs to dig in there load
up all the messy state in their head and clean up, simplify,
and optimize this mess.

We still have the stupid case where we can create unkillable
zombies from user space with a threaded init.

I think it is safe to say that this part of the code has reach the point
of fragility where it is hard to maintain.  A clear sign that it is time to
refactor something.

Eric
