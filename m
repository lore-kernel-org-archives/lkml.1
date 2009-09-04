Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZIDLt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZIDLt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 07:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZIDLtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 07:49:24 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62920 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZIDLtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 07:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OFL88f+M6faCxnWKdcC8z6bl6rLgnDOk/NcpCE9x9qTwx3RJnm9avhnUmP1U3bWAD6
         WiMlcNAguTWPTfWClZ8OzNmZH3a3fYd+5PdUfa2ozSx1Ulpj3lYc9pq3IMNzdbmb75WR
         Y33JPzfCR5NfGySN/L6ekLNNrzi+HMbJhFB7k=
Message-ID: <4AA0FEBF.7040104@gmail.com>
Date: Fri, 04 Sep 2009 13:49:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: suspend race -mm regression [Was: Power: fix suspend vt regression]
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com> <4A81E073.5080703@gmail.com> <4A9B9C1C.9020506@gmail.com> <200908312132.10904.rjw@sisk.pl>
In-Reply-To: <200908312132.10904.rjw@sisk.pl>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 09:32 PM, Rafael J. Wysocki wrote:
> On Monday 31 August 2009, Jiri Slaby wrote:
>> On 08/11/2009 11:19 PM, Jiri Slaby wrote:
>>> However there is still a race or something. Sometimes the suspend goes
>>> through, sometimes it doesn't. I will investigate this further.
>>
>> Hmm, this took a loong time to track down a bit. Code instrumentation by
>> outb(XX, 0x80) usually caused the issue to disappear.
>>
>> However I found out that it's caused by might_sleep() calls in
>> flush_workqueue() and flush_cpu_workqueue(). I.e. it looks like there is
>> a task which deadlocks/spins forever. If we won't reschedule to it,
>> suspend proceeds.
>>
>> I replaced the latter might_sleep() by show_state() and removed
>> refrigerated tasks afterwards. The thing is that I don't know if the
>> prank task is there. I need a scheduler to store "next" task pid or
>> whatever to see what it picked as "next" and so what will run due to
>> might_sched(). I can then show it on port 80 display and read it when
>> the hangup occurs.
>>
>> Depending on which might_sleep(), either flush_workqueue() never (well,
>> at least in next 5 minutes) proceeds to for_each_cpu() or
>> wait_for_completion() in flush_cpu_workqueue() never returns.
>>
>> It's a regression against some -rc1 based -next tree. Bisection
>> impossible, suspend needs to be run even 7 times before it occurs. Maybe
>> a s/might_sleep/yield/ could make it happen earlier (going to try)?
> 
> If /sys/class/rtc/rtc0/wakealarm works on this box, you can use it to trigger
> resume in a loop.
> 
> Basically, you can do
> 
> # echo 0 > /sys/class/rtc/rtc0/wakealarm
> # date +%s -d "+60 seconds" > /sys/class/rtc/rtc0/wakealarm
> 
> then go to suspend and it will resume the box in ~1 minute.

Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
cpu_hotplug-dont-affect-current-tasks-affinity.patch

Well, I don't know why, but when the kthread overthere runs under
suspend conditions and gets rescheduled (e.g. by the might_sleep()
inside) it never returns. pick_next_task always returns the idle task
from the idle queue. State of the thread is TASK_RUNNING.

Why is it not enqueued into some queue? I tried also
sched_setscheduler(current, FIFO, 99) in the thread itself. Unless I did
it wrong, it seems like a global scheduler problem?

Ingo, any ideas?

Thanks.
