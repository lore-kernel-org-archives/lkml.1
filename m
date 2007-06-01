Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbXFAJv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbXFAJv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 05:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbXFAJvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 05:51:49 -0400
Received: from ms-smtp-07.tampabay.rr.com ([65.32.5.139]:54028 "EHLO
	ms-smtp-07.tampabay.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757762AbXFAJvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 05:51:47 -0400
Message-ID: <465FEC22.7090807@cfl.rr.com>
Date: Fri, 01 Jun 2007 05:51:30 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: markh@compro.net
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: floppy.c soft lockup
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net>
In-Reply-To: <465F2D96.9060502@compro.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Oleg Nesterov wrote:
>> On 05/31, Mark Hounschell wrote:
>>> Oleg Nesterov wrote:
>>>> On 05/31, Mark Hounschell wrote:
>>>>> Basically the main RT-process (which is a CPU bound process on processor-2) signals a
>>>>> thread to do some I/O. That RT-thread (running on the other processor) does a simple 
>>>> If the main RT-process monopolizes processor-2, flush_workqueue() (or cancel_work_sync())
>>>> can hang of course, we can do nothing.
>>>>
>>>>> ioctl(Q->DevSpec1, FDSETPRM, &medprm)
>>>>>
>>>>> and there is no return from the call. That thread is hung.
>>>> What happens if you kill the main RT-process?
>>>>
>>> When I kill the main process all its threads also go away. Including the floppy thread.
>>> Nothing notable happens with this kernel.
>> Aha, I missed the word "thread", this is the single process.
>>
>> Still, this means that flush_workqueue() completes when other sub-threads go away,
>> otherwise the thread doing ioctl() couldn't exit.
>>
>> Thank you very much.
>>
>> So, the main question is: is it possible that one of RT processes/threads pins itself
>> to some CPU and eats 100% cpu power?
>>
> 
> The main process is pinned to a processor(2) with all _non-kernel_  processes/threads forced over to processor 1.
> Any already affinitized processes or kernel threads are left as is. Only user land stuff is moved. The main process
> is for sure _not_ relinquishing it's processor(2) intentionally. All the I/O threads, floppy included, are running
> on the other processor(1). During this failure only 1 or 2 of the I/O threads are actually doing anything.
> I assume that what ever is going on in the kernel/floppy driver on behalf of the floppy thread is being done on processor 1? 
> Processor 1 has lots of CPU time available. Processor 2 is running balls to the wall.
>  
>>>                                            On previous (2.6.18) I would get a dump
>>> from the floppy driver in the syslog when I killed the process.
>> Could you send me this output? just in case...
>>
> 
> Today, 2.6.18 is doing the same as 2.6.22-rc3. I hate it when that happens. Maybe it was
> on my box at home. I'll verify when I get there. Nothing from here now though.
> 

Those syslog dumps must have been a result of something I was doing
while trying to pinpoint my problem. I do not get these now. Sorry.

>>>> --- OLD/drivers/block/floppy.c~	2007-04-03 13:04:58.000000000 +0400
>>>> +++ OLD/drivers/block/floppy.c	2007-05-31 20:50:18.000000000 +0400
>>>> @@ -862,6 +862,8 @@ static void set_fdc(int drive)
>>>>  		FDCS->reset = 1;
>>>>  }
>>>>  
>>>> +static DECLARE_WORK(floppy_work, NULL);
>>>> +
>>>>  /* locks the driver */
>>>>  static int _lock_fdc(int drive, int interruptible, int line)
>>>>  {
>>>> @@ -893,7 +895,7 @@ static int _lock_fdc(int drive, int inte
>>>>  		set_current_state(TASK_RUNNING);
>>>>  		remove_wait_queue(&fdc_wait, &wait);
>>>>  
>>>> -		flush_scheduled_work();
>>>> +		cancel_work_sync(&floppy_work);
>>>>  	}
>>>>  	command_status = FD_COMMAND_NONE;
>>>>  
>>>> @@ -992,8 +994,6 @@ static void empty(void)
>>>>  {
>>>>  }
>>>>  
>>>> -static DECLARE_WORK(floppy_work, NULL);
>>>> -
>>>>  static void schedule_bh(void (*handler) (void))
>>>>  {
>>>>  	PREPARE_WORK(&floppy_work, (work_func_t)handler);
>>>>
>>> The patch does make it work.
>> I do not understand floppy.c, absolutely, so I am not sure this patch is correct.
>>
>> Even if correct, this patch doesn't solve this problem (if we really understand
>> what's going on). cancel_work_sync() may still hang if floppy_work->func() runs
>> on the starved CPU. This is unlikely, but possible.
>>
>> Thanks!
>>
>> Oleg.
>>

Thanks and Regards
Mark
