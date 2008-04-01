Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYDAP7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYDAP7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYDAP7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:59:38 -0400
Received: from c-24-130-11-78.hsd1.ca.comcast.net ([24.130.11.78]:32794 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752374AbYDAP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:59:37 -0400
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 11:59:37 EDT
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org>
	<47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org>
Date: Tue, 01 Apr 2008 09:25:20 -0600
In-Reply-To: <47F203EC.7090806@openvz.org> (Pavel Emelyanov's message of "Tue,
	01 Apr 2008 13:44:12 +0400")
Message-ID: <m1od8tiom7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:
>>> I agree, that we should probably destroy this one when the task calls 
>>> unshare, but trying to keep this list relevant is useless.
>>>   
>> A very tricky question: Let's assume we have a process with two threads.
>> The undo structure is shared, as per opengroup standard.
>> Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
>> cannot destroy the undo structure, the other thread might be still 
>> interested in it.
>> If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
>> and without CLONE_SYSVSEM, then we must handle this case.
>
> Hm... I'd simply disable creating any new namespaces for threads.
> I think other namespaces developers agree with me. Serge, Suka, Eric
> what do you think?

I almost agree.  sys_unshare() in a multithreaded process breaks
all kinds of user space libs.  So you can only reasonably look at
the problem as what we do with linux tasks that share some things
and not others.  The posix/opengroup notion of processes and threads
are a distraction.

In this case requiring it appears that to require unsharing both
CLONE_SYSVSEM and CLONE_NEWIPC at the same time.  (i.e. unshare
of CLONE_SYSVSEM should fail if CLONE_NEWIPC is not also specified).

Then to make it work we make unshare of SYSVSEM succeed when it is
not shared.

This looks like about a 5 line patch or two.

The effect is because we don't support unsharing of SYSVSEM currently
we don't support a threaded process unsharing the ipc namespace.

Eric
