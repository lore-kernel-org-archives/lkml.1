Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbZA1VAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbZA1VAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbZA1U4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:56:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759449AbZA1U4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:56:36 -0500
Date: Wed, 28 Jan 2009 12:56:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, thomas.pi@arcor.de
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
Message-Id: <20090128125604.94ed3fe0.akpm@linux-foundation.org>
In-Reply-To: <bug-12562-10286@http.bugzilla.kernel.org/>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 28 Jan 2009 06:35:20 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12562
> 
>            Summary: High overhead while switching or synchronizing threads
>                     on different cores

Thanks for the report, and the testcase.

>            Product: Process Management
>            Version: 2.5
>      KernelVersion: 2.6.28
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Scheduler
>         AssignedTo: mingo@elte.hu
>         ReportedBy: thomas.pi@arcor.de

(There's testcase code in the bugzilla report)

(Seems to be a regression)

> 
> Hardware Environment: Core2Duo 2.4GHz / 4GB RAM 
> Software Environment: Ubuntu 8.10 + Vanilla 2.6.28
> 
> Hardware Environment: AMD64 X2 2.1GHz / 6GB RAM 
> Software Environment: Ubuntu 8.10 + Vanilla 2.6.28.2
> 
> Problem Description:
> The overhead on a dual core while switching between tasks is extremely high
> (>60% of cputime). If is produced by synchronization with pthread and
> mutex/cond. 
> 
> Executing the attaches program schedulingissue 1 1024 8 20, which create a
> producer and a consumer thread with eight 8kb big buffers. The producer creates
> 1024 random generated double values, consumer makes the same after receiving
> the buffer.
> 
> While executing the program the thoughtput is ~1.6 msg/s. While executing two
> instances of the program, the thoughtput is much higher (2 * 8.7 msg/s = 17,4
> msg/s). 
> 
> Small improvement while using jiffies as clocksource instead of acpi_pm or hpet
> (1.8 messages instead of 1.6). Disabling NO_HZ and HIGH_RESOLUTION_TIME gives
> no improvement. Much higher performance with kernel <= 2.6.24, but still four
> times slower.

Unclear.  What is four times slower than what?  You're saying that the
app progresses four times faster when there are two instances of it
running, rather than one instance?


> ---------------------------------------
> Linux bugs-laptop 2.6.28-hz-hrt #4 SMP Wed Jan 28 13:33:18 CET 2009 x86_64
> GNU/Linux
> acpi_pm (equal with htep)
> schedulerissue 1 1024 8 20
> All threads finished: 20 messages in 12.295 seconds / 1.627 msg/s
> schedulerissue 1 1024 8 200 & schedulerissue 1 1024 8 200
> All threads finished: 200 messages in 22.882 seconds / 8.741 msg/s
> All threads finished: 200 messages in 22.934 seconds / 8.721 msg/s
> ---------------------------------------
> Linux bugs-laptop 2.6.28-hz-hrt #4 SMP Wed Jan 28 13:33:18 CET 2009 x86_64
> GNU/Linux
> jiffies
> schedulerissue 1 1024 8 20
> All threads finished: 20 messages in 10.704 seconds / 1.868 msg/s
> schedulerissue 1 1024 8 200 & schedulerissue 1 1024 8 200
> All threads finished: 200 messages in 23.372 seconds / 8.557 msg/s
> All threads finished: 200 messages in 23.460 seconds / 8.525 msg/s
> --------------------------------------
> Linux bugs-laptop 2.6.24.7 #1 SMP Wed Jan 14 10:21:04 CET 2009 x86_64 GNU/Linux
> hpet 
> schedulerissue 1 1024 8 20
> All threads finished: 20 messages in 5.290 seconds / 3.781 msg/s
> schedulerissue 1 1024 8 200 & schedulerissue 1 1024 8 200
> All threads finished: 200 messages in 23.000 seconds / 8.695 msg/s
> All threads finished: 200 messages in 23.078 seconds / 8.666 msg/s
> 

Seems that 2.6.24 is faster than 2.6.28 with 20 messages, but 2.6.24
and 2.6.28 run at the same speed when 200 messages are sent?

If so, that seems rather odd, doesn't it?  Is it possible that cpufreq
does something bad once the CPU gets hot?


> AMD64 X2 @ 2.1GHz
> Linux bugs-desktop 2.6.28.2 #4 SMP Mon Jan 26 20:26:12 CET 2009 x86_64
> GNU/Linux
> acpi_pm
> schedulerissue 1 1024 8 20
> All threads finished: 20 messages in 9.288 seconds / 2.153 msg/s
> schedulerissue 1 1024 8 200
> All threads finished: 200 messages in 17.049 seconds / 11.731 msg/s
> All threads finished: 200 messages in 18.539 seconds / 10.788 msg/s



