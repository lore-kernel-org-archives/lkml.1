Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbXDZLLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbXDZLLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030621AbXDZLLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:11:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:51108 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbXDZLLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:11:04 -0400
Date: Thu, 26 Apr 2007 14:15:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Message-ID: <20070426101547.GA97@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426100922.GB12892@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Gautham R Shenoy wrote:
>
> On Wed, Apr 25, 2007 at 04:54:10PM -0700, Andrew Morton wrote:
> > On Thu, 26 Apr 2007 01:10:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Hi,
> > > 
> > > The BUG_ON in khthread_bind (line 165 in kthread.c) triggers for me during
> > > attempted suspend to disk, when disable_nonboot_cpus() calls _cpu_down()
> > > (on x86_64).
> > 
> Caused due to Oleg's patch http://lkml.org/lkml/2007/4/13/93.
> 
> Agreed that most of the time a kthread_create(p) is followed by a
> kthread_bind(p), in which case the assertion 
> WARN_ON(p->state != TASK_UNINTERRUPTIBLE) makes sense.
> 
> But, in cpu hotplug case, we need to rebind the stop_machine_run thread
> from the cpu which has just been offlined to any online cpu.
> (kernel/cpu.c line 180)

I can't understand why do we need to re-bind this thread. We are doing
kthread_stop()->wake_up() below, at this point move_task_off_dead_cpu()
has already cared about this task, no?

> We only need to ensure in kthread_bind that the task which is being
> bound is not running or exiting. Doesn't matter if it's sleeping in 
> TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE state.

We need to ensure that this task can't be woken after return from
wait_task_inactive(k), otherwise set_task_cpu() after that is not safe.

TASK_INTERRUPTIBLE doesn't protect us from freezing.

Couldn't we just remove this kthread_bind() ?

Oleg.

