Return-Path: <linux-kernel-owner+w=401wt.eu-S1767779AbXDFPj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767779AbXDFPj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767778AbXDFPj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:39:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57535 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767777AbXDFPjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:39:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
Date: Fri, 06 Apr 2007 09:38:24 -0600
In-Reply-To: <20070406104301.GB19755@lnx-holt.americas.sgi.com> (Robin Holt's
	message of "Fri, 6 Apr 2007 05:43:01 -0500")
Message-ID: <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

>> So I think we have some options once we get the kernel threads out
>> of the way.  Getting the kernel threads out of the way would seem
>> to be the first priority.
>
> I think both avenues would probably be the right way to proceeed.
> Getting kthreads to not be parented by init would be an opportunity
> for optimization.
>
> I think organizing the zombie tasks to be easily reaped also has merit.
> Rapidly forking/exiting processes like udevd during the boot of a
> different machine were also shown to benefit significantly from this
> patch.  That machine had 512 cpus and 4608 disk devices, we dropped the
> device discovery under udevd by 30%.  This, honestly, surprised us.
> It makes some sense now that I think about it.  This would be a case
> where improving the zombie handling would be beneficial to more than
> just kthreads.

How hard is tasklist_lock hit on these systems?

How hard is the pid hash hit on these systems?

My hunch is that if you are doing a lot of forking and exiting
zombie reaping isn't the only problem you are observing.

Thinking about it I do agree with Linus that two lists sounds like the
right solution because it ensures we always have O(1) time when
waiting for a zombie.  I'd like to place the list head for the zombie
list in the signal_struct and not in the task_struct so our
performance continues to be O(1) when we have a threaded process.

The big benefit of the zombie list over your proposed list reordering
is that waitpid can return immediately when we don't have zombies to
wait for, but we have lots of children.  So it looks like a universal
benefit and about as good as it is possible to make zombie handling
of waitpid.

Eric
