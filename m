Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZIXN2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZIXN2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZIXN2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZIXN2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:28:40 -0400
Date: Thu, 24 Sep 2009 15:33:19 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: BUG: sleeping function called from invalid context at 
 kernel/mutex.c:280
Message-ID: <20090924153319.0fa902d3@leela>
In-Reply-To: <7b6bb4a50909230227h50cccb0enb02d42664dd61872@mail.gmail.com>
References: <7b6bb4a50909230227h50cccb0enb02d42664dd61872@mail.gmail.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Wed, 23 Sep 2009 17:27:08 +0800 Xiaotian Feng napsal(a):
> Hi,
> 
>     I got following messages when I resume from suspend with 2.6.31.
> Is there anything wrong? Thanks.
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
> Regards
> Xiaotian

I've just noticed the same in the latest git.
sysdev_resume() runs with IRQs disabled, but clocksource_resume() uses
a mutex. Hmm, in 2.6.30 it used to be spinlock. This was changed to
mutex by:

commit 75c5158f70c065b9704b924503d96e8297838f79
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Fri Aug 14 15:47:30 2009 +0200

    timekeeping: Update clocksource with stop_machine
    
    update_wall_time calls change_clocksource HZ times per second to
    check if a new clock source is available. In close to 100% of all
    calls there is no new clock. Replace the tick based check by an
    update done with stop_machine.

Michal
