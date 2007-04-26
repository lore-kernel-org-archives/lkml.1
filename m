Return-Path: <linux-kernel-owner+w=401wt.eu-S1031144AbXDZKWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031144AbXDZKWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031150AbXDZKWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:22:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38244 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031144AbXDZKWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:22:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: ego@in.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
References: <200704260110.22224.rjw@sisk.pl>
	<20070425165410.b73443b4.akpm@linux-foundation.org>
	<20070426100922.GB12892@in.ibm.com>
Date: Thu, 26 Apr 2007 04:20:40 -0600
In-Reply-To: <20070426100922.GB12892@in.ibm.com> (Gautham R. Shenoy's message
	of "Thu, 26 Apr 2007 15:39:22 +0530")
Message-ID: <m1bqhbmo7b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy <ego@in.ibm.com> writes:

> On Wed, Apr 25, 2007 at 04:54:10PM -0700, Andrew Morton wrote:
>> On Thu, 26 Apr 2007 01:10:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> 
>> > Hi,
>> > 
>> > The BUG_ON in khthread_bind (line 165 in kthread.c) triggers for me during
>> > attempted suspend to disk, when disable_nonboot_cpus() calls _cpu_down()
>> > (on x86_64).
>> 
> Caused due to Oleg's patch http://lkml.org/lkml/2007/4/13/93.
>
> Agreed that most of the time a kthread_create(p) is followed by a
> kthread_bind(p), in which case the assertion 
> WARN_ON(p->state != TASK_UNINTERRUPTIBLE) makes sense.
>
> But, in cpu hotplug case, we need to rebind the stop_machine_run thread
> from the cpu which has just been offlined to any online cpu.
> (kernel/cpu.c line 180)
> At this point, the thread would be in TASK_INTERRUPTIBLE waiting for us
> to call a kthread_stop on it.(kernel/kthread.c line 161)
>
> We only need to ensure in kthread_bind that the task which is being
> bound is not running or exiting. Doesn't matter if it's sleeping in 
> TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE state.

That will probably handle this problem.

However there is a weird interaction with process freezer.

The process freezer can come in and  wake up a kernel thread
to encourage it to call try_to_freeze_process while it is 
waiting to be bound.

How do we handle that evil race?

Eric


