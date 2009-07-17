Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZGQW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZGQW0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZGQW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:26:38 -0400
Received: from mail.crca.org.au ([67.207.131.56]:49204 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862AbZGQW0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:26:38 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4A60FAB2.6030906@crca.org.au>
Date: Sat, 18 Jul 2009 08:26:58 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nathan Lynch <ntl@pobox.com>,
       Nigel Cunningham <nigel@tuxonice.net>, stable@kernel.org,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
References: <20090717121545.489258927@linutronix.de>  <20090717122103.225652146@linutronix.de> <1247833910.15751.61.camel@twins> <alpine.LFD.2.00.0907171441020.11571@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907171441020.11571@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Thomas Gleixner wrote:
> On Fri, 17 Jul 2009, Peter Zijlstra wrote:
> 
>> On Fri, 2009-07-17 at 12:25 +0000, Thomas Gleixner wrote:
>>> plain text document attachment (freezer-fix-accounting-for-real.patch)
>>> commit e3c8ca8336 (sched: do not count frozen tasks toward load) broke
>>> the nr_uninterruptible accounting on freeze/thaw. On freeze the task
>>> is excluded from accounting with a check for (task->flags &
>>> PF_FROZEN), but that flag is cleared before the task is thawed. So
>>> while we prevent that the freezing task with state
>>> TASK_UNINTERRUPTIBLE is accounted to nr_uninterruptible we decrement
>>> nr_uninterruptible on thaw.
>>>
>>> Use a separate flag which is handled by the freezing task itself. Set
>>> it before calling the scheduler with TASK_UNINTERRUPTIBLE state and
>>> clear it after we return from frozen state.
>> Right, so I'm wondering why we don't fully revert e3c8ca8336 to begin
>> with.
> 
> Fine with me, but it seems that the cgroup folks have some luser space
> stuff looking at proc/loadavg which goes berserk when loadavg
> increases rapidly due to freezing. OTOH that stuff seems to be
> oblivious to the fact that the commit in question brings loadavg
> irreversibly to 0 when you do enough freeze/thaw cycles.

That's right. I don't remember the exact details (it's been ages since
this was first reported to me), but sendmail (IIRC) was looking at the
load average and stopping delivery until it dropped sufficiently.

Historically, my solution has been to save and restore the load average
values (on the theory that hibernation should be transparent to
userspace), but I dropped that in favour of this approach.

Regards,

Nigel
