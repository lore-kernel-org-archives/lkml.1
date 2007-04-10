Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXDJOxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXDJOxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXDJOxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:53:01 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39497 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbXDJOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:53:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu>
Date: Tue, 10 Apr 2007 08:51:43 -0600
In-Reply-To: <20070410134814.GA28016@elte.hu> (Ingo Molnar's message of "Tue,
	10 Apr 2007 15:48:14 +0200")
Message-ID: <m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > no. Two _completely separate_ lists.
>> >
>> > i.e. a to-be-reaped task will still be on the main list _too_. The 
>> > main list is for all the PID semantics rules. The reap-list is just 
>> > for wait4() processing. The two would be completely separate.
>> 
>> And what pray tell except for heuristics is the list of children used 
>> for?
>
> on a second thought: the p->children list is needed for the whole 
> child/parent task tree, which is needed for sys_getppid().

Yes, something Oleg said made me realize that.

As long as the reparent isn't to complex it isn't required that we
have exactly one list .

> The question 
> is, does anything require us to reparent to within the same thread 
> group?

I think my head is finally on straight about this question.

Currently there is the silly linux specific parent death signal
(pdeath_signal).  Oleg's memory was a better than mine on this score.

However there is no indication that the parent death signal being sent
when a thread leader dies is actually correct, or even interesting.
It probably should only be sent when getppid changes.

So with pdeath_signal fixed that is nothing that requires us to
reparent within the same thread group.

I'm trying to remember what the story is now.  There is a nasty
race somewhere with reparenting, a threaded parent setting SIGCHLD to
SIGIGN, and non-default signals that results in an zombie that no one
can wait for and reap.  It requires being reparented twice to trigger.

Anyway it is a real mess and if we can remove the stupid multi-headed
child lists things would become much simpler and the problem could
not occur.

Plus the code would become much simpler...

utrace appears to have removed the ptrace_children list and the
special cases that entailed.

Eric

