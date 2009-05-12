Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZELRAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZELRAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZELRAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:00:38 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:58628 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZELRAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:00:37 -0400
Message-ID: <4A09AB2E.8030002@nortel.com>
Date: Tue, 12 May 2009 11:00:30 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jussi Laako <jussi@sonarnerd.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net> <4A099670.5060902@nortel.com> <4A09A525.4080107@sonarnerd.net>
In-Reply-To: <4A09A525.4080107@sonarnerd.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2009 17:00:34.0466 (UTC) FILETIME=[2A5A8020:01C9D323]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> Chris Friesen wrote:
> 
>>If all you're trying to do is allow different threads to run at
>>different nice levels, what about extending sys_setpriority() to take a
>>"which" of PRIO_THREAD?  We'd probably have to call the syscall directly
>>until/unless libc picks up the new option.
> 
> 
> How would this be mapped to a POSIX standard API?

You'd call sys_setpriority.  Actually, you'd probably have to call
syscall(__NR_getpriority...) until glibc picks up the new option.

Then for the "which" field, instead of PRIO_PROCESS you would use a new
PRIO_THREAD (or PRIO_TASK, whichever makes more sense) which would only
set the nice level for the specific thread specified in the "who" field.

Of course, without glibc/pthreads support you would only be able to set
the nice level for the current thread since you don't have any way to
map from "pthread_t *" to tid.  And you wouldn't be able to create new
threads with a particular nice level already set.  But that argument
holds true for a new sched policy as well, because glibc checks the
policy internally and only knows about the normal three.

> I would like to see
> something which works straight out with
> pthread_setschedprio()/pthread_getschedparam(). In order it to work
> correctly it also needs sys_sched_get_priority_min and
> sys_sched_get_priority_max.

This option extends the "nice" API rather than the static priority API,
so all of the above would still have a static priority of 0 for SCHED_OTHER.

Chris
