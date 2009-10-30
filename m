Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbZJ3QXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbZJ3QXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbZJ3QXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:23:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45889 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbZJ3QXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:23:21 -0400
Message-ID: <4AEB12F0.9090006@us.ibm.com>
Date: Fri, 30 Oct 2009 09:23:12 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
References: <4AE63E3D.8030903@us.ibm.com> <4AEA3F15.2070900@us.ibm.com> <4AEA4547.30102@us.ibm.com> <200910301013.46923.arnd@arndb.de>
In-Reply-To: <200910301013.46923.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 30 October 2009, Darren Hart wrote:
>> Darren Hart wrote:
>> This appears to work fine. Can anyone think of a reason why this is an unsafe
>> thing to do? I'll have to create a much more elaborate test case and review
>> the glibc code of course to make sure the glibc mutex state isn't compromised.
> 
> The only reason I can see against it is the need to use one of the
> rt signal numbers from library code, which may conflict with other
> users of the signal. Being able to avoid a signal altogether would
> be really nice, as in the futex_cancel extension you mentioned.

For the reason you mention, consumption of a signal number, the 
futex_cancel extension was how I originally set out to tackle this. 
However, Thomas and Peter both seemed to feel that the signal approach 
was a more standard way of interrupting a unix system call. One trick to 
the futex_cancel approach will be identifying which thread to cancel - 
since no other futex operation is thread specific. I suspect just 
overloading one of the argument to pass a TID would address that nicely. 
  This would allow us to return ECANCELED from the kernel, which I think 
is a much more direct implementation.

Peter and Thomas, could you comment on why the signal approach might be 
preferred over the futex_cancel extension?

>> /* Need some kind of per-thread variable here */
>> jmp_buf env;
>> pthread_mutex_t mutex;
> 
> Maybe instead of per-thread variables (which should work
> fine), you could do
> 
> typedef struct {
> 	jmp_buf env;
> 	pthread_mutex_t mutex;
> } interruptible_mutex_t;


I don't quite follow. There will be a 1:many relationship between 
mutex:threads, but there should be a 1:1 relationship between 
threads:env. Since multiple threads can block on one mutex, the above 
struct wouldn't provide the necessary number of env to set the jmp point 
for each one.... am I misunderstanding your suggestion?

>> 	/* ensure the child has blocked on the lock */
>> 	sleep(1);
> 
> In a real application, you might want to add some logic to avoid
> this kind of race. For the test case, you probably need to do it
> with the sleep.

This would likely need to be handled within glibc, just as it manages 
the sequence counters for the condvars to deal with wake-up races.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
