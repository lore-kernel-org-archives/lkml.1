Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768Ab0AEUlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0AEUlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140Ab0AEUli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:41:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38966 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0AEUlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:41:37 -0500
Message-ID: <4B43A3FB.9050009@us.ibm.com>
Date: Tue, 05 Jan 2010 12:41:31 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@gmail.com>,
       "Hansen, Dave" <haveblue@us.ibm.com>
Subject: Re: [PATCH v2] futex: remove rw parameter from get_futex_key()
References: <20091225083305.AA78.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.0912301437420.3369@sister.anvils> <20100105162633.45A2.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.1001051108150.26884@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1001051108150.26884@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 5 Jan 2010, KOSAKI Motohiro wrote:

>> From c3e2dfdff84b9b720e646fd6dd3c38fff293c7e6 Mon Sep 17 00:00:00 2001
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Date: Tue, 5 Jan 2010 11:33:00 +0900
>> Subject: [PATCH] futex: remove rw parameter from get_futex_key()
>>
>> Currently, futex have two problem.
>>
>> A) current futex doesn't handle private file mappings properly.
>>
>> get_futex_key() use PageAnon() to distinguish file and anon. it can
>> makes following bad scenario.
>>
>>   1) thread-A call futex(private-mapping, FUTEX_WAIT). it makes to
>>      sleep on file mapping object.
>>   2) thread-B write a variable and it makes cow.
>>   3) thread-B call futex(private-mapping, FUTEX_WAKE). it wake up
>>      sleeped thread on the anonymous page. (but it's nothing)
>>

Excellent test case, thank you! Would you consider preparing a patch to 
futextest?

http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary

I did some experimentation here and found that:

o The test works if the *_PRIVATE op codes are used.
   This is because the futex keys are generated using only the virtual
   address of the page, which doesn't change on a COW.
o If the waiter writes to the val first, it works.
   This forces the COW before the waiter generates it's futex key.

So the waiter's key is generated based on the page cache page address 
for shared futexes when the value hasn't been written to prior to wait.

The only scenario where I could think of wanting this behavior is if 
another process were to try and wake the waiter via the same file backed 
page. However, as I understand it, the re-use of the same page for 
unwritten-to private pages is an optimization and can't be relied upon. 
So this scenario is out.  Another would be to use the futex as a very 
simple wait queue where the value is never changed. In this case 
however, the implementation is racy as the value check is effectively 
negated, so this use case is also out.

As such, I see no reason not to always use VERIFY_WRITE and force a COW 
prior to generating the futex_key for shared futexes. It is not 
necessary for private futexes however as they use only the virtual address.

I am not sure on whether or not it makes sense to avoid the VERIFY_WRITE 
on the private futexes. Could be it is just more code for negligible 
benefit. Thoughts?

--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
