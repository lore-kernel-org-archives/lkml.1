Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYKMIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYKMIEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYKMIEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:04:33 -0500
Received: from e500-t.bruker.de ([149.236.160.250]:36936 "HELO e500.bruker.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752546AbYKMIEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:04:32 -0500
Date: Thu, 13 Nov 2008 09:04:11 +0100 (CET)
From: Michael Dressel <Michael.Dressel@bruker-biospin.de>
X-X-Sender: midr@eleven.esr.bruker.de
To: Ian Kent <raven@themaw.net>
cc: Michael Dressel <Michael.Dressel@bruker-biospin.de>,
       linux-kernel@vger.kernel.org, bart.vanassche@gmail.com
Subject: Re: pthread_mutex_lock hangs on unlocked mutex
In-Reply-To: <alpine.LFD.2.00.0811131433580.10195@zeus.themaw.net>
Message-ID: <alpine.LSU.2.00.0811130839250.9837@eleven.esr.bruker.de>
References: <alpine.LSU.2.00.0811070856260.5231@eleven.esr.bruker.de> <alpine.LFD.2.00.0811131433580.10195@zeus.themaw.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 13 Nov 2008 08:04:11.0985 (UTC) FILETIME=[69BE9C10:01C94566]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Ian Kent wrote:

> On Fri, 7 Nov 2008, Michael Dressel wrote:
>
>> Hi,
>>
>> (I'm not subscribed to the list, please CC me.)
>>
>> in our software three processes are using several pthread mutexes.
>> Sometimes a process hangs inside pthread_mutex_lock even though the mutex is
>> not locked. I can tell it's not locked because another process is still
>> running and locking and unlocking the mutex.
>
> pthreads is implemented in glibc.
> If you really think there is a bug in the ptheads implementation then
> the glibc maintainers will require you to produce a simple example program
> which demonstrates the bug before it's accepted as a bug.

Yes.
I have not found any report related exactly to my problem in the
mailing lists or bug reports. But to be sure I didn't overlook something
I posted my problem. It looks like it's unique to me.

I failed to produce a simple example demonstrating the problem. In our
code we use timers and real time signals and we change process masks
with sigprocmask. If there is a bug at all (I don't think so) a
program to demonstrate that bug would potentially have to do all of
these things and would therefore not be simple.

Following Bart Van Assche's suggestion.
I did use valgrind (the default tool and helgrind) but I did not find
anything obviously related to my problem.

>
> When you say processes you mean threads, right?
>

No. We don't use threads. The mutexes are used between processes. I used
them because they feature recursion.

> If you can't produce such an example program and you can you prove (to
> yourself) there are no use after free or execution order issues with your
> code then your only option is to develop a workaround.
>

I found a workaround. We use normal semaphores now. This is possible
because we don't use multiple threads. In order to provide recursion I
had to implement a per process counter. This would not work if the
semaphore was required during signal handler execution. But this dose not
happen in our application.

> You code wouldn't happen to be doing thread synchronization with
> pthread_cond_wait()/pthread_cond_signal() would it?

No since we don't use multiple threads.

The reason why I wondered it is an issue (maybe configuration) of the
kernel was that sending a STOP CONT signal sequence to the hanging
process got it going again. So at least it is not a classical dead lock.

Cheers,
 	Michael

