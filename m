Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYFUW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYFUW5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYFUW5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:57:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:64449 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYFUW5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ARAma29fWPCcK3iSXGoyP96DdNPL3L3TdwYzuQplDSXcYWfi4Uwtq8YkxdukfHBM0p
         prldFPMzWb0PzLlgSqSH/O89rpZ9H3cNUPKapKOxkytiZfi1+jO50JUWC5uAzpcPsDgR
         ZEF1wQDetPAdgA1IImw81031gUc0H6XKk71is=
Message-ID: <19f34abd0806211557v6763bd3fo2d99d4f26cb0d3a5@mail.gmail.com>
Date: Sun, 22 Jun 2008 00:57:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: v2.6.26-rc7: BUG task_struct: Poison overwritten
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1214083307.3223.289.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621192400.GA2992@damson.getinternet.no>
	 <20080621192845.GB2992@damson.getinternet.no>
	 <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com>
	 <1214083307.3223.289.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 11:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> But it looks like there might be some cpu hotplug race with group
> scheduling - heiko (s390) and avi (x86_64) reported some cpu hotplug
> crashes. We're still looking into those.

Thanks.

I was poking around in kernel/sched.c and noticed something odd: In
migrate_dead(), we have this code:

        /*
         * Drop lock around migration; if someone else moves it,
         * that's OK. No task can be added to this CPU, so iteration is
         * fine.
         */
        spin_unlock_irq(&rq->lock);
        move_task_off_dead_cpu(dead_cpu, p);
        spin_lock_irq(&rq->lock);

which is fine in itself, I guess. But spin_unlock_irq() will enable
interrupts. And move_task_off_dead_cpu() has this comment:

/*
 * Figure out where task on dead CPU should go, use force if necessary.
 * NOTE: interrupts should be disabled by the caller
 */
static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
{

...but here, interrupts will not be disabled. On the other hand
__migrate_task_irq() (called by move_task_off_dead_cpu()) calls
local_irq_disable() itself... What do you think of this? Is the
comment wrong? Or is there a difference between "interrupts" and
"local_irq"?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
