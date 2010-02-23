Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0BWOYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:24:35 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33464 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab0BWOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:24:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gENa6zoI86zrfhGE+v/JH0E5bfAETFHwKO45zxUP0gY3tcZ3SsOq3qWzQWn9fjH56h
         s/aUrqgtOCiFtXUuKiDJynE7tyGEfs4pVv+n2QeE0GfVUnMlq29jfzl9uyQIo1f8Nts9
         iRW4qpsTxmjeGKHWaFfeHXjR/7Rzy2DLqxCKY=
MIME-Version: 1.0
In-Reply-To: <201002222017.55588.rjw@sisk.pl>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
	 <201002212147.07987.rjw@sisk.pl> <4B82A440.6010701@googlemail.com>
	 <201002222017.55588.rjw@sisk.pl>
Date: Tue, 23 Feb 2010 14:24:25 +0000
Message-ID: <9b2b86521002230624g20661564mc35093ee0423ff77@mail.gmail.com>
Subject: Re: s2disk hang update
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 22 February 2010, Alan Jenkins wrote:
>> Rafael J. Wysocki wrote:
>> > On Friday 19 February 2010, Alan Jenkins wrote:
>> >
>> >> On 2/18/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>
>> >>> On Thursday 18 February 2010, Alan Jenkins wrote:
>> >>>
>> >>>> On 2/17/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>>>
>> >>>>> On Wednesday 17 February 2010, Alan Jenkins wrote:
>> >>>>>
>> >>>>>> On 2/16/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>>>>>
>> >>>>>>> On Tuesday 16 February 2010, Alan Jenkins wrote:
>> >>>>>>>
>> >>>>>>>> On 2/16/10, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
>> >>>>>>>>
>> >>>>>>>>> On 2/15/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>>>>>>>>
>> >>>>>>>>>> On Tuesday 09 February 2010, Alan Jenkins wrote:
>> >>>>>>>>>>
>> >>>>>>>>>>> Perhaps I spoke too soon.  I see the same hang if I run too
>> >>>>>>>>>>> many
>> >>>>>>>>>>> applications.  The first hibernation fails with "not enough
>> >>>>>>>>>>> swap"
>> >>>>>>>>>>> as
>> >>>>>>>>>>> expected, but the second or third attempt hangs (with the same
>> >>>>>>>>>>> backtrace
>> >>>>>>>>>>> as before).
>> >>>>>>>>>>>
>> >>>>>>>>>>> The patch definitely helps though.  Without the patch, I see a
>> >>>>>>>>>>> hang
>> >>>>>>>>>>> the
>> >>>>>>>>>>> first time I try to hibernate with too many applications
>> >>>>>>>>>>> running.
>> >>>>>>>>>>>
>> >>>>>>>>>> Well, I have an idea.
>> >>>>>>>>>>
>> >>>>>>>>>> Can you try to apply the appended patch in addition and see if
>> >>>>>>>>>> that
>> >>>>>>>>>> helps?
>> >>>>>>>>>>
>> >>>>>>>>>> Rafael
>> >>>>>>>>>>
>> >>>>>>>>> It doesn't seem to help.
>> >>>>>>>>>
>> >>>>>>>> To be clear: It doesn't stop the hang when I hibernate with too
>> >>>>>>>> many
>> >>>>>>>> applications.
>> >>>>>>>>
>> >>>>>>>> It does stop the same hang in a different case though.
>> >>>>>>>>
>> >>>>>>>> 1. boot with init=/bin/bash
>> >>>>>>>> 2. run s2disk
>> >>>>>>>> 3. cancel the s2disk
>> >>>>>>>> 4. repeat steps 2&3
>> >>>>>>>>
>> >>>>>>>> With the patch, I can run 10s of iterations, with no hang.
>> >>>>>>>> Without the patch, it soon hangs, (in disable_nonboot_cpus(), as
>> >>>>>>>> always).
>> >>>>>>>>
>> >>>>>>>> That's what happens on 2.6.33-rc7.  On 2.6.30, there is no
>> >>>>>>>> problem.
>> >>>>>>>> On 2.6.31 and 2.6.32 I don't get a hang, but dmesg shows an
>> >>>>>>>> allocation
>> >>>>>>>> failure after a couple of iterations ("kthreadd: page allocation
>> >>>>>>>> failure. order:1, mode:0xd0").  It looks like it might be the
>> >>>>>>>> same
>> >>>>>>>> stop_machine thread allocation failure that causes the hang.
>> >>>>>>>>
>> >>>>>>> Have you tested it alone or on top of the previous one?  If you've
>> >>>>>>> tested it
>> >>>>>>> alone, please apply the appended one in addition to it and retest.
>> >>>>>>>
>> >>>>>>> Rafael
>> >>>>>>>
>> >>>>>> I did test with both patches applied together -
>> >>>>>>
>> >>>>>> 1. [Update] MM / PM: Force GFP_NOIO during suspend/hibernation and
>> >>>>>> resume
>> >>>>>> 2. "reducing the number of pages that we're going to keep
>> >>>>>> preallocated
>> >>>>>> by
>> >>>>>> 20%"
>> >>>>>>
>> >>>>> In that case you can try to reduce the number of preallocated pages
>> >>>>> even
>> >>>>> more,
>> >>>>> ie. change "/ 5" to "/ 2" (for example) in the second patch.
>> >>>>>
>> >>>> It still hangs if I try to hibernate a couple of times with too many
>> >>>> applications.
>> >>>>
>> >>> Hmm.  I guess I asked that before, but is this a 32-bit or 64-bit
>> >>> system and
>> >>> how much RAM is there in the box?
>> >>>
>> >>> Rafael
>> >>>
>> >> EeePC 701.  32 bit.  512Mb RAM.  350Mb swap file, on a "first-gen" SSD.
>> >>
>> >
>> > Hmm.  I'd try to make  free_unnecessary_pages() free all of the
>> > preallocated
>> > pages and see what happens.
>> >
>>
>> It still hangs in hibernation_snapshot() / disable_nonboot_cpus().
>> After apparently freeing over 400Mb / 100,000 pages of preallocated ram.
>>
>>
>>
>> There is a change which I missed before.  When I applied your first
>> patch ("Force GFP_NOIO during suspend" etc.), it did change the hung
>> task backtraces a bit.  I don't know if it tells us anything.
>>
>> Without the patch, there were two backtraces.  The first backtrace
>> suggested a problem allocating pages for a kernel thread (at
>> copy_process() / try_to_free_pages()).  The second showed that this
>> problem was blocking s2disk (at hibernation_snapshot() /
>> disable_nonboot_cpus() / stop_machine_create()).
>>
>> With the GFP_NOIO patch, I see only the s2disk backtrace.
>
> Can you please post this backtrace?

Sure.  It's rather like the one I posted before, except

a) it only shows the one hung task (s2disk)
b) this time I had lockdep enabled
c) this time most of the lines don't have question marks.


Kernel verson:
- mainline v2.6.33-rc8-164-gaea187c, with the one patch "Force GFP_NOIO..."

Image:
http://picasaweb.google.com/lh/photo/f9KRZT2l9wCmVt-Jdggd9g?feat=directlink


INFO: task s2disk:1916 blocked for more than 120 seconds
 ...
 Call Trace:
 ? _raw_spin_unlock
 schedule_timeout+0x22	(timer.c:1366)
 ? mark_held_locks
 ? _raw_spin_unlock_irq
 ? trace_hardirqs_on_caller
 ? trace_hardirqs_on
 wait_for_common+0xb8	(sched.c:5844)
 ? default_wake_function
 wait_for_completion+0x12	(sched.c:5879)
 kthread_create+0x75	(kthread.c:133)
 ? worker_thread+0x0
 create_workqueue_thread+0x38	(workqueue.c:921)
 ? worker_thread+0x0
 __create_workqueue_key+0x156	(workqueue.c:1006)
 stop_machine_create+0x32	(stop_machine.c:121)
 disable_nonboot_cpus+0xe	(cpu.c:370)
 hibernation_snapshot+0x94	(hibernate.c:266)
 snapshot_ioctl+0x21b	(user.c:256)
 ...
 sys_ioctl+0x41 (ioctl.c:624)


Thanks
Alan
