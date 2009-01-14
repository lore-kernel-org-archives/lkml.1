Return-Path: <linux-kernel-owner+w=401wt.eu-S1765365AbZANRYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765365AbZANRYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765316AbZANRYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:24:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765312AbZANRXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:23:55 -0500
Message-ID: <496E1F80.20009@redhat.com>
Date: Wed, 14 Jan 2009 19:23:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
References: <1231774622.4371.96.camel@laptop> <496B6C23.8000808@redhat.com> <1231780388.4371.185.camel@laptop> <496B7EBC.6020208@redhat.com> <1231951599.14825.18.camel@laptop> <20090114170445.GA18964@wotan.suse.de>
In-Reply-To: <20090114170445.GA18964@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> (no they're not, Nick's ticket locks still spin on a shared cacheline
>> IIRC -- the MCS locks mentioned could fix this)
>>     
>
> It reminds me. I wrote a basic variation of MCS spinlocks a while back. And
> converted dcache lock to use it, which showed large dbench improvements on
> a big machine (of course for different reasons than the dbench improvements
> in this threaed).
>
> http://lkml.org/lkml/2008/8/28/24
>
> Each "lock" object is sane in size because given set of spin-local queues may
> only be used once per lock stack. But any spinlocks within a mutex acquisition
> will always be at the bottom of such a stack anyway, by definition.
>
> If you can use any code or concept for your code, that would be great.
>   

Does it make sense to replace 'nest' with a per-cpu counter that's 
incremented on each lock?  I guest you'd have to search for the value of 
nest on unlock, but it would a very short search (typically length 1, 2 
if lock sorting is used to avoid deadlocks).

I think you'd need to make the lock store the actual node pointer, not 
the cpu number, since the values of nest would be different on each cpu.

That would allow you to replace spinlocks with mcs_locks wholesale.

-- 
error compiling committee.c: too many arguments to function

