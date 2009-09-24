Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZIXQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZIXQIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZIXQIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbZIXQIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:08:52 -0400
Date: Thu, 24 Sep 2009 18:13:19 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:280
Message-ID: <20090924181319.17ed46c9@leela>
In-Reply-To: <20090924172952.49697825@mschwide.boeblingen.de.ibm.com>
References: <7b6bb4a50909230227h50cccb0enb02d42664dd61872@mail.gmail.com>
	<20090924153319.0fa902d3@leela>
	<20090924172952.49697825@mschwide.boeblingen.de.ibm.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Thu, 24 Sep 2009 17:29:52 +0200 Martin Schwidefsky napsal(a):
> On Thu, 24 Sep 2009 15:33:19 +0200
> Michal Schmidt <mschmidt@redhat.com> wrote:
> > I've just noticed the same in the latest git.
> > sysdev_resume() runs with IRQs disabled, but clocksource_resume()
> > uses a mutex. Hmm, in 2.6.30 it used to be spinlock. This was
> > changed to mutex by:
> > 
> > commit 75c5158f70c065b9704b924503d96e8297838f79
> > Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Date:   Fri Aug 14 15:47:30 2009 +0200
> > 
> >     timekeeping: Update clocksource with stop_machine
> >     
> >     update_wall_time calls change_clocksource HZ times per second to
> >     check if a new clock source is available. In close to 100% of
> > all calls there is no new clock. Replace the tick based check by an
> >     update done with stop_machine.
> 
> Hmm, the spinlock to mutex conversion is necessary to make it possible
> to use stop_machine to install the new clocksource. At the same time
> clocksource_resume is called early in the resume cycle with interrupts
> disabled and may not take a mutex. Question is: does it have to? There
> shouldn't be any processes running that can change the list of
> installed clocksources. Can you test if this patch fixes the problem?
> 
> --
> Subject: [PATCH] clocksource: resume clocksource without taking the
> clocksource mutex
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> git commit 75c5158f70c065b9 converted the clocksource spinlock to a
> mutex. This causes the following BUG:
> 
> BUG: sleeping function called from invalid context at
> kernel/mutex.c:280 in_atomic(): 0, irqs_disabled(): 1, pid: 2473,
> name: pm-suspend 2 locks held by pm-suspend/2473:
>  #0:  (&buffer->mutex){......}, at: [<ffffffff8115ab13>]
> sysfs_write_file+0x3c/0x137
>  #1:  (pm_mutex){......}, at: [<ffffffff810865b5>]
> enter_state+0x39/0x130 Pid: 2473, comm: pm-suspend Not tainted 2.6.31
> #1 Call Trace:
>  [<ffffffff810792f0>] ? __debug_show_held_locks+0x22/0x24
>  [<ffffffff8104a2ef>] __might_sleep+0x107/0x10b
>  [<ffffffff8141fca9>] mutex_lock_nested+0x25/0x43
>  [<ffffffff81073537>] clocksource_resume+0x1c/0x60
>  [<ffffffff81072902>] timekeeping_resume+0x1e/0x1c8
>  [<ffffffff812aee62>] __sysdev_resume+0x25/0xcf
>  [<ffffffff812aef79>] sysdev_resume+0x6d/0xae
>  [<ffffffff810864f8>] suspend_devices_and_enter+0x12b/0x1af
>  [<ffffffff8108665b>] enter_state+0xdf/0x130
>  [<ffffffff81085dc3>] state_store+0xb6/0xd3
>  [<ffffffff81204c73>] kobj_attr_store+0x17/0x19
>  [<ffffffff8115abd2>] sysfs_write_file+0xfb/0x137
>  [<ffffffff811057d2>] vfs_write+0xae/0x10b
>  [<ffffffff81208392>] ? __up_read+0x1a/0x7f
>  [<ffffffff811058ef>] sys_write+0x4a/0x6e
>  [<ffffffff81011b82>] system_call_fastpath+0x16/0x1b
> 
> clocksource_resume is called early in the resume process, there
> is only one cpu, no processes are running and the interrupts are
> disabled. It is therefore possible to resume the clocksources
> without taking the clocksource mutex.
> 
> Reported-by: Xiaotian Feng <xtfeng@gmail.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Yes, this fixes the problem.
Tested-by: Michal Schmidt <mschmidt@redhat.com>
