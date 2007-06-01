Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbXFATw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbXFATw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761787AbXFATwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:52:51 -0400
Received: from ms-smtp-01.tampabay.rr.com ([65.32.5.131]:52881 "EHLO
	ms-smtp-01.tampabay.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761963AbXFATwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:52:51 -0400
Message-ID: <466078FF.2080508@cfl.rr.com>
Date: Fri, 01 Jun 2007 15:52:31 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Mark Hounschell <markh@compro.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
References: <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net> <20070601151605.GA108@tv-sign.ru> <4660534E.6050903@cfl.rr.com> <20070601183642.GA92@tv-sign.ru>
In-Reply-To: <20070601183642.GA92@tv-sign.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/01, Mark Hounschell wrote:
>> Oleg Nesterov wrote:
>>> Could you apply the trivial patch below, and change the i/o thread to do
>>>
>>> 		prctl(1234);				// hangs ???
>>> 		printf(something);
>>> 		ioctl(Q->DevSpec1, FDSETPRM, &medprm);	// this hangs
>>>
>>> to see if prctl() hangs or not? This way we can narrow the problem.
>>> (of course, you can just kill the above ioctl() if this is possible).
>>>
>>> Thanks!
>>>
>>> Oleg.
>>>
>>> --- OLD/kernel/sys.c~	2007-04-03 13:05:02.000000000 +0400
>>> +++ OLD/kernel/sys.c	2007-06-01 18:56:22.000000000 +0400
>>> @@ -2147,6 +2147,11 @@ asmlinkage long sys_prctl(int option, un
>>>  {
>>>  	long error;
>>>  
>>> +	if (option == 1234) {
>>> +		flush_scheduled_work();
>>> +		return 0;
>>> +	}
>>> +
>>>  	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
>>>  	if (error)
>>>  		return error;
>>>
>>> -
>>
>> Ok the prctl never returned. I just replaced the ioctl with it and added
>> a printf before and after. I only get the one before. The thread is hung
>> at this point just as if I'd done the ioctl?
> 
> Thanks. So we can rule out floppy.c. flush_scheduled_work/flush_workqueue
> is broken by this RT application. Imho, this is not the kernel problem.
> 
> Now I am very sure that the initial suspect was correct: cpu starvation.
> I can cook a debug patch to be 100% sure tomorrow, which kernel version is
> most convenient to you?
> 

2.6.22-rc3 is fine thanks.

Regards
Mark

