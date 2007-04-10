Return-Path: <linux-kernel-owner+w=401wt.eu-S1031019AbXDJQTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031019AbXDJQTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031007AbXDJQTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:19:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46851 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031019AbXDJQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:19:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu>
	<m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
	<20070410150650.GA9946@elte.hu>
	<m1tzvoxniv.fsf@ebiederm.dsl.xmission.com>
	<20070410155314.GA16267@elte.hu>
Date: Tue, 10 Apr 2007 10:17:56 -0600
In-Reply-To: <20070410155314.GA16267@elte.hu> (Ingo Molnar's message of "Tue,
	10 Apr 2007 17:53:14 +0200")
Message-ID: <m1mz1gxky3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > so ... is anyone pursuing this? This would allow us to make 
>> > sys_wait4() faster and more scalable: no tasklist_lock bouncing for 
>> > example.
>> 
>> which part?
>
> all of it :) Everything you mentioned makes sense quite a bit. The 
> thread signal handling of do_wait was added in a pretty arbitrary 
> fashion so i doubt there are strong requirements in that area. Apps 
> might have grown to get used to it meanwhile though, so we've got to do 
> it carefully.

I'm looking at.  If only because there is a reasonable chance doing this
will fix the races with a threaded init.

However I just found something nasty.  The wait __WNOTHREAD flag.

And my quick search seems to find at least one user space applications
that uses it, and it is widely documented so I suspect there are
others :(

I played with moving the lists into signal_struct, and short of
architecture specific users of task->children all I had to touch
were:

 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    5 +-
 kernel/exit.c             |  159 +++++++++++++++++++++------------------------
 kernel/fork.c             |    2 +-
 mm/oom_kill.c             |    4 +-

So it should be relatively easy to change this child lists around...

Eric
