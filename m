Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbXKMOdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbXKMOdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXKMOdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:33:39 -0500
Received: from main.gmane.org ([80.91.229.2]:44803 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXKMOdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:33:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Boelstler <kernel@boelstler.net>
Subject: Strange delays / what usually happens every 10 min?
Date: Tue, 13 Nov 2007 15:24:38 +0100
Message-ID: <fhcc39$51b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: fw-emea.rohde-schwarz.com
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this issue has been already discussed on the kernelnewbies mailing list 
[1],[2] and suggested to be further discussed here.

I am currently working on a MPC8540-based custom board, which runs Linux
2.6.15 (arch/ppc). The original Linux sources have been modified to 
support that custom board. (Additional patches to support LTT are 
applied as well, though disabled in the running kernel)

I set up a periodically running kernel thread, which is delayed for a
single jiffy using schedule_timeout() in an infinite loop. It is used to
measure delays between invocations of that thread. For measuring the
distance in time the PPC's time base lower half register is used
(obtained using get_cycles() defined in asm/timex.h).

The thread calculates the delay to the previous run and only outputs the
result if a new maximum value has been determined (in respect to all
previous cycles). Further the thread outputs a warning if a very "high"
delay was determined. I.e. a delay greater than 5ms.

While running that test driver a delay of about 10ms _exactly_ occurs
every 10 minutes.

The kernel is configured using CONFIG_HZ=1000 and CONFIG_PREEMPT.
The CCB is at 333MHz, whereas the TBR update rate is 333 MHz / 8, i.e.
41,625 MHz.
Kernel configuration as a whole is found here: 
http://nopaste.info/5e4d0283bb.html

And now the funny part starts.
I got a response from Bruce Rowen on kernelnewbies, telling me that he 
came across the same problem. He increased his AMD-Geode-based platform 
to 1GB of RAM (256MB before) and also hit the 10-minutes-issue a few 
month ago (using Linux 2.6.13).
Going back to 256MB cured the problem. I did the same thing by 
instructing the boot loader in order to only use 256 MB of RAM (instead 
of 512MB) and yes, the 10-minutes-issue was gone as well.

Apart of some kernel threads almost all user processes have been killed
during the test. Only SSH and a bash were running (whereas a test with 
network interfaces completely disabled and only operated from a serial 
console turned out the same results).
The kernel comes with compiled in CIFS support, some kernel debugging
features like soft-lockup detection and preemption debugging. I.e. ps
lists the kernel threads ksoftirqd, watchdog, events, khelper, kthread,
kblockd, pdflush, aio, cifsoplockd and cifsdnotifyd.

An appropriate userspace test tool based on nanosleep() determined the
same results like the kernel thread:

root@mpc0:/# /tmp/wait.rt
looping 1 milli seconds nanosleep ...
15:26:16: #1 FRAME MAX 1996 us (at 4139773004 ticks)
15:26:16: #2 FRAME MAX 2002 us (at 4139856360 ticks)
15:26:16: #155 FRAME MAX 2102 us (at 4152597854 ticks)
15:41:37: #460398 FRAME MAX 8941 us (at 3813406605 ticks)
15:41:37: #460398 FRAME HIGH 8941 us (at 3813406605 ticks)
15:51:37: #760394 FRAME MAX 9936 us (at 3018602602 ticks)
15:51:37: #760394 FRAME HIGH 9936 us (at 3018602602 ticks)
16:01:37: #1060390 FRAME HIGH 9935 us (at 2223798809 ticks)
16:11:37: #1360386 FRAME HIGH 9934 us (at 1428994989 ticks)
16:21:37: #1660382 FRAME HIGH 9935 us (at 634191241 ticks)
[...]

Thanks for any help!

Cheers,

   Florian

[1] http://thread.gmane.org/gmane.linux.kernel.kernelnewbies/23419
[2] http://thread.gmane.org/gmane.linux.kernel.kernelnewbies/23426

