Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZFKF4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZFKF4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZFKFz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:55:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZFKFz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:55:59 -0400
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1244689688.2560.268.camel@ymzhang>
References: <1244689688.2560.268.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Jun 2009 07:55:56 +0200
Message-Id: <1244699756.6691.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 11:08 +0800, Zhang, Yanmin wrote:
> I investigate a fio hang issue. When I run fio multi-process
> testing on many disks, fio traps into kernel and doesn't exit
> (mostly hit once after runing sub test cases for ﻿hundreds of times).
> 
> Oprofile data shows kernel consumes time with some futex functions.
> Command kill couldn't kill the process and machine reboot also hangs.
> 
> Eventually, I locate the root cause as a bug of futex. Kernel enters
> a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
> By unknown reason (might be an issue of fio or glibc), parameter uaddr2
> points to an area which is READONLY. So futex_atomic_op_inuser returns
> -EFAULT when trying to changing the data at uaddr2, but later get_user
> still succeeds becasue the area is READONLY. Then go back to retry.
> 
> I create a simple test case to trigger it, which just shmat an READONLY
> area for address uaddr2.
> 
> It could be used as a DOS attack.

commit 2070887fdeacd9c13f3e805e3f0086c9f22a4d93
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue May 19 23:04:59 2009 +0200

    futex: fix restart in wait_requeue_pi

    If the waiter has been requeued to the outer PI futex and is
    interrupted by a signal and the thread handles the signal then
    ERESTART_RESTARTBLOCK is changed to EINTR and the restart block is
    discarded. That way we return an unexcpected EINTR to user space
    instead of ending up in futex_lock_pi_restart.

    But we do not need to restart the syscall because we know that the
    condition has changed since we have been requeued. If we would simply
    restart the syscall then we would drop out via the comparison of the
    user space value with EWOULDBLOCK.

    The user space side needs to handle EWOULDBLOCK anyway as the
    enqueueing on the inner futex can race with a requeue/wake. So we can
    simply return EWOULDBLOCK to user space which also signals that we did
    not take the outer futex and let user space handle it in the same way
    it has to handle the requeue/wake race.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


