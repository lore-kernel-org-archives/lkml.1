Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbZANLTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbZANLTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZANLS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:18:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37435 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZANLS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RiWi9bl3BgPLVfmDb067wNJxBNgiSFTMBdLk9LSgU/e51g0hF7wCPDUa9BHqk4Gp6b
         pxaAAhM5f1vBS1I4PdCSIEQfmKxs8o685tjmVdtVoSIIpIcLwehrbE4a+eW1bPkTuu6m
         BrdRhz+zxFfgefJ1yeK0j9Ll3CcX/PUv8tRGQ=
MIME-Version: 1.0
In-Reply-To: <1231901899.1709.18.camel@think.oraclecorp.com>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins>
	 <1231901899.1709.18.camel@think.oraclecorp.com>
Date: Wed, 14 Jan 2009 12:18:54 +0100
Message-ID: <b647ffbd0901140318g7e4ccab6m9bf03e9ac6acf797@mail.gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/14 Chris Mason <chris.mason@oracle.com>:
> On Tue, 2009-01-13 at 18:21 +0100, Peter Zijlstra wrote:
>> On Tue, 2009-01-13 at 08:49 -0800, Linus Torvalds wrote:
>> >
>> > So do a v10, and ask people to test.
>>
>> ---
>> Subject: mutex: implement adaptive spinning
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date: Mon Jan 12 14:01:47 CET 2009
>>
>> Change mutex contention behaviour such that it will sometimes busy wait on
>> acquisition - moving its behaviour closer to that of spinlocks.
>>
>
> I've spent a bunch of time on this one, and noticed earlier today that I
> still had bits of CONFIG_FTRACE compiling.  I wasn't actually tracing
> anything, but it seems to have had a big performance hit.
>
> The bad news is the simple spin got much much faster, dbench 50 coming
> in at 1282MB/s instead of 580MB/s.  (other benchmarks give similar
> results)
>
> v10 is better that not spinning, but its in the 5-10% range.  So, I've
> been trying to find ways to close the gap, just to understand exactly
> where it is different.
>
> If I take out:
>        /*
>         * If there are pending waiters, join them.
>         */
>        if (!list_empty(&lock->wait_list))
>                break;
>
>
> v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my
> spinning and aren't less fair.  But clearly this isn't a good solution.
>
> I tried a few variations, like only checking the wait list once before
> looping, which helps some.  Are there other suggestions on better tuning
> options?

(some thoughts/speculations)

Perhaps for highly-contanded mutexes the spinning implementation may
quickly degrade [*] to the non-spinning one (i.e. the current
sleep-wait mutex) and then just stay in this state until a moment of
time when there are no waiters  [**]  -- i.e.
list_empty(&lock->wait_list) == 1 and waiters can start spinning
again.

what may trigger [*]:

(1) obviously, an owner scheduling out.

Even if it happens rarely (otherwise, it's not a target scenario for
our optimization), due to the [**] it may take quite some time until
waiters are able to spin again.

let's say, waiters (almost) never block (and possibly, such cases
would be better off just using a spinlock after some refactoring, if
possible)

(2) need_resched() is triggered for one of the waiters.

(3) !owner && rt_task(p)

quite unlikely, but possible (there are 2 race windows).

Of course, the question is whether it really takes a noticeable amount
of time to get out of the [**] state.
I'd imagine it can be a case for highly-contended locks.

If this is the case indeed, then which of 1,2,3 gets triggered the most.

Have you tried removing need_resched() checks? So we kind of emulate
real spinlocks here.

>
> -chris
>

-- 
Best regards,
Dmitry Adamushko
