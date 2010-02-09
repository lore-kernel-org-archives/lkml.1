Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0BIQgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:36:45 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44528 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab0BIQgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UDssI8DM+6BKn9Pqhc97kGV/94I29TvnG32y1WS88AkWu3N/58LwJarFsAnOm5/x7C
         YQw9a2S06JK3lk9bnbaD/A3FJPre94jAoym2m8ugG9yhcQa8ZZbk7PW24XBEmE2am2js
         HIhsihwxV0vF3wStoAY4H+OrB0oDTreQeVL+k=
Message-ID: <4B718F11.2010402@tuffmail.co.uk>
Date: Tue, 09 Feb 2010 16:36:33 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Mel Gorman <mel@csn.ul.ie>,
       hugh.dickins@tiscali.co.uk, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: s2disk hang update
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>	 <201001022138.42575.rjw@sisk.pl>	 <9b2b86521002020621n7c6a0582n66688d4e6810ca97@mail.gmail.com>	 <201002022134.20366.rjw@sisk.pl> <9b2b86521002030314s6f84b482v8cd680be556f8a4d@mail.gmail.com>
In-Reply-To: <9b2b86521002030314s6f84b482v8cd680be556f8a4d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> On 2/2/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>   
>> On Tuesday 02 February 2010, Alan Jenkins wrote:
>>     
>>> On 1/2/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>       
>>>> On Saturday 02 January 2010, Alan Jenkins wrote:
>>>> Hi,
>>>>
>>>>         
>>>>> I've been suffering from s2disk hangs again.  This time, the hangs
>>>>> were always before the hibernation image was written out.
>>>>>
>>>>> They're still frustratingly random.  I just started trying to work out
>>>>> whether doubling PAGES_FOR_IO makes them go away, but they went away
>>>>> on their own again.
>>>>>
>>>>> I did manage to capture a backtrace with debug info though.  Here it
>>>>> is for 2.6.33-rc2.  (It has also happened on rc1).  I was able to get
>>>>> the line numbers (using gdb, e.g.  "info line
>>>>> *stop_machine_create+0x27"), having built the kernel with debug info.
>>>>>
>>>>> [top of trace lost due to screen height]
>>>>> ? sync_page	(filemap.c:183)
>>>>> ? wait_on_page_bit	(filemap.c:506)
>>>>> ? wake_bit_function	(wait.c:174)
>>>>> ? shrink_page_list	(vmscan.c:696)
>>>>> ? __delayacct_blkio_end	(delayacct.c:94)
>>>>> ? finish_wait	(list.h:142)
>>>>> ? congestion_wait	(backing-dev.c:761)
>>>>> ? shrink_inactive_list	(vmscan.c:1193)
>>>>> ? scsi_request_fn	(spinlock.h:306)
>>>>> ? blk_run_queue	(blk-core.c:434)
>>>>> ? shrink_zone	(vmscan.c:1484)
>>>>> ? do_try_to_free_pages	(vmscan.c:1684)
>>>>> ? try_to_free_pages	(vmscan.c:1848)
>>>>> ? isolate_pages_global	(vmscan.c:980)
>>>>> ? __alloc_pages_nodemask	(page_alloc.c:1702)
>>>>> ? __get_free_pages	(page_alloc.c:1990)
>>>>> ? copy_process	(fork.c:237)
>>>>> ? do_fork	(fork.c:1443)
>>>>> ? rb_erase
>>>>> ? __switch_to
>>>>> ? kthread
>>>>> ? kernel_thread
>>>>> ? kthread
>>>>> ? kernel_thread_helper
>>>>> ? kthreadd
>>>>> ? kthreadd
>>>>> ? kernel_thread_helper
>>>>>
>>>>> INFO: task s2disk:2174 blocked for more than 120 seconds
>>>>>           
>>>> This looks like we have run out of memory while creating a new kernel
>>>> thread
>>>> and we have blocked on I/O while trying to free some space (quite
>>>> obviously,
>>>> because the I/O doesn't work at this point).
>>>>         
>>> For context, the kernel thread being created here is the stop_machine
>>> thread.  It is created by disable_nonboot_cpus(), called from
>>> hibernation_snapshot().  See e.g. this hung task backtrace -
>>>
>>> http://picasaweb.google.com/lh/photo/BkKUwZCrQ2ceBIM9ZOh7Ow?feat=directlink
>>>
>>>       
>>>> I think it should help if you increase PAGES_FOR_IO, then.
>>>>         
>>> Ok, it's been happening again on 2.6.33-rc6.  Unfortunately increasing
>>> PAGES_FOR_IO doesn't help.
>>>
>>> I've been using a test patch to make PAGES_FOR_IO tunable at run time.
>>>  I get the same hang if I increase it by a factor of 10, to 10240:
>>>
>>> # cd /sys/module/kernel/parameters/
>>> # ls
>>> consoleblank  initcall_debug  PAGES_FOR_IO  panic  pause_on_oops
>>> SPARE_PAGES
>>> # echo 10240 > PAGES_FOR_IO
>>> # echo 2560 > SPARE_PAGES
>>> # cat SPARE_PAGES
>>> 2560
>>> # cat PAGES_FOR_IO
>>> 10240
>>>
>>> I also added a debug patch to try and understand the calculations with
>>> PAGES_FOR_IO in hibernate_preallocate_memory().  I still don't really
>>> understand them and there could easily be errors in my debug patch,
>>> but the output is interesting.
>>>
>>> Increasing PAGES_FOR_IO by almost 10000 has the expected effect of
>>> decreasing "max_size" by the same amount.  However it doesn't appear
>>> to increase the number of free pages at the critical moment.
>>>
>>> PAGES_FOR_IO = 1024:
>>> http://picasaweb.google.com/lh/photo/DYQGvB_4hvCvVuxZf2ibxg?feat=directlink
>>>
>>> PAGES_FOR_IO = 10240:
>>> http://picasaweb.google.com/lh/photo/AIkV_ZBwt22nzN-JdOJCWA?feat=directlink
>>>
>>>
>>> You may remember that I was originally able to avoid the hang by
>>> reverting commit 5f8dcc2.  It doesn't revert cleanly any more.
>>> However, I tried applying my test&debug patches on top of 5f8dcc2~1
>>> (just before the commit that triggered the hang).  That kernel
>>> apparently left ~5000 pages free at hibernation time, v.s. ~1200 when
>>> testing the same scenario on 2.6.33-rc6.  (As before, the number of
>>> free pages remained the same if I increased PAGES_FOR_IO to 10240).
>>>       
>> I think the hang may be avoided by using this patch
>> http://patchwork.kernel.org/patch/74740/
>> but the hibernation will fail instead.
>>
>> Can you please repeat your experiments with the patch below applied and
>> report back?
>>
>> Rafael
>>     
>
> It causes hibernation to succeed <grin>.
>   

Perhaps I spoke too soon.  I see the same hang if I run too many 
applications.  The first hibernation fails with "not enough swap" as 
expected, but the second or third attempt hangs (with the same backtrace 
as before).

The patch definitely helps though.  Without the patch, I see a hang the 
first time I try to hibernate with too many applications running.

Regards
Alan
