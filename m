Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbZL3Qx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbZL3Qx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZL3Qx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:53:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:34589 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZL3Qx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:53:56 -0500
Message-ID: <4B3B8577.6050801@windriver.com>
Date: Wed, 30 Dec 2009 10:53:11 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Jan Kiszka <jan.kiszka@web.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - dueto
 perf API changes
References: <4B227F2C.7050403@windriver.com> <20091212132428.GB22389@elte.hu> <20091212135216.GA18597@elte.hu> <4B2404C6.2050003@windriver.com> <20091230163903.GA5024@nowhere>
In-Reply-To: <20091230163903.GA5024@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2009 16:53:11.0882 (UTC) FILETIME=[92638AA0:01CA8970]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Sat, Dec 12, 2009 at 03:01:58PM -0600, Jason Wessel wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> Basically we have two options:
>>>
>>>  A- change kgdb to use the hw-breakpoints highlevel APIs (i'd prefer 
>>>     that)
>>>
>>>   
>>>       
>> Right now we can't because the high level code uses all sorts of mutexes
>> and sync points to get the hw breakpoints installs on the various
>> processors.  After I re-spun my RFC patch, I found another problem.  I
>> do use the high level code to create a block of 4 (struct perf_event **)
>> structures, but doing so ultimately calls the reserve hw breakpoint even
>> though they are marked as disabled when created.
>>
>> Should I, or can I change that behavior?
>>     
>
>
>
> We could probably have a helper that allocates a disabled breakpoint
> without reserving it.

I worked around that restriction for now, in the current version of the
kgdb patches.  When kgdb registers with the die notifier in its init
phase, it allocates the perf structures via the perf API and
subsequently disables the breakpoints with the low level API.

>  But the problem remains: you'll need to take
> locks when you eventually reserve it and when you activate it.
>
> The fact that it can happen from nmi is really a problem.
>
>   

I talked with Jan a bit with respect to this problem.  He recommended to
possibly allow kgdb to obtain hw breakpoints locklessly and to break
reservations that exist with the low level API.  The current patch in
the kgdb series does not break reservations, it only uses a slot that is
not already in use.  Let us call the scenarios A and B.

A) allow kgdb to break existing reservations
B) kgdb can use what is not reserved, without locks

What is missing right now is a notification mechanism and a separate
count for the debugger as to what is in use.   I tend to think that B is
the right default approach, but Jan was leaning towards scenario A.

> Is there any possibility that we know the user has started a
> kgdb session, and then reserve as much hardware breakpoints
> as we can in kgdb at this time?
>
>   

That is the way I implemented it the first time.  Reserve all the slots,
and then nothing else could use them.  That didn't work out too well
because then the user space could not make use of hw breakpoints,
granted this never worked before with user space + kernel space sharing
between ptrace and kgdb.

Jason.


