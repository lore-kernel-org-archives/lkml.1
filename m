Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXD1WAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXD1WAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXD1WAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:00:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:15001 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbXD1WAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UlL4dWp1/HEkgh6V7kojBi/zmrQ96JHC3/Z+6SrkbtrWS5ZCvAkB3I3XzxOr2JmSiIZ77jeqKb5zItDcYjZRgzyEXH9kCHANpWdkxqj8/dCbX2bbBSiebkMmH+/X5nglErbz5s7iLYNpp6cHVpUdhFGulTYH37Td+pkkur1Zezk=
Message-ID: <f9eabcda0704281500l58c3b791s97c499822b577140@mail.gmail.com>
Date: Sat, 28 Apr 2007 19:00:14 -0300
From: "Miguel Freitas" <mfreitas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: bug in RLIMIT_SIGPENDING
Cc: "Roland McGrath" <roland@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

summary: there seems to be a bug in RLIMIT_SIGPENDING accounting that
can cause it to go negative. associated with this fact, the given
process may get stuck forever trying to enter a 'clone' syscall.

long version:

- several people have experienced this problem of Xorg hanging forever
(100% cpu usage) trying to enter the 'clone' syscall to execute
xkbcomp.

- the syscall is aborted with ERESTARTNOINTR because there is a
SIGALRM signal pending. status shows:

SigQ:   1/18446744073709551615
SigPnd: 0000000000000000
ShdPnd: 0000000000002000
SigBlk: 0000000000000000
SigIgn: 0000000000301000
SigCgt: 0000000061c06ecb

note the weird SigQ value, is 64 bits' -1 for RLIMIT_SIGPENDING.

- the signal handler is executed (as confirmed under gdb).

- kernel will then force reentering the syscall by means of the
following code in handle_signal():

 case -ERESTARTNOINTR:
 regs->rax = regs->orig_rax;
 regs->rip -= 2;
 break;

- this effectively puts user space in a kind of spinlock that never ends.

- the code that sets signal handler is quoted here from Xorg gitweb:

1529 #define SMART_SCHEDULE_SIGNAL           SIGALRM
(...)
1588     bzero ((char *) &act, sizeof(struct sigaction));
1589
1590     /* Set up the timer signal function */
1591     act.sa_handler = SmartScheduleTimer;
1592     sigemptyset (&act.sa_mask);
1593     sigaddset (&act.sa_mask, SMART_SCHEDULE_SIGNAL);
1594     if (sigaction (SMART_SCHEDULE_SIGNAL, &act, 0) < 0)
1595     {
1596         perror ("sigaction for smart scheduler");
1597         return FALSE;
1598     }

- the code that sets the timer is quoted here from Xorg gitweb:

1548 Bool
1549 SmartScheduleStartTimer (void)
1550 {
1551 #ifdef SMART_SCHEDULE_POSSIBLE
1552     struct itimerval    timer;
1553
1554     SmartScheduleTimerStopped = FALSE;
1555     timer.it_interval.tv_sec = 0;
1556     timer.it_interval.tv_usec = SmartScheduleInterval * 1000;
1557     timer.it_value.tv_sec = 0;
1558     timer.it_value.tv_usec = SmartScheduleInterval * 1000;
1559     return setitimer (ITIMER_REAL, &timer, 0) >= 0;
1560 #endif
1561     return FALSE;
1562 }

- having this negative rlimit may cause problem to the
__sigqueue_alloc() kernel function. however, as far as i can see, this
would possibly prevent new signals from being enqueued - not existing
ones from being dequeued/cleared/whatever.

- bugzilla entry for the complete investigation can be seen here:

https://bugs.freedesktop.org/show_bug.cgi?id=10525

thanks,

Miguel
