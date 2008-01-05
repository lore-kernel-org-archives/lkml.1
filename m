Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYAEJah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYAEJah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYAEJa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:30:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbYAEJa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:30:27 -0500
Date: Sat, 5 Jan 2008 01:30:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Idle loadavg of ~1, maybe MD related
Message-Id: <20080105013037.a354b33a.akpm@linux-foundation.org>
In-Reply-To: <20071230100614.GX17327@curie-int.orbis-terrarum.net>
References: <20071230100614.GX17327@curie-int.orbis-terrarum.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 02:06:14 -0800 "Robin H. Johnson" <robbat2@gentoo.org> wrote:

> (Please CC me, I'm subbed to LKML).
> 
> My G5, while running practically nothing (just sshd and some to watch the
> load), has a weird cycle of load averages. I think it might be related to MD,
> simply because that's the only thing that is clocking up cputime.

Usually this is caused by a process which is stuck in "D" state
(uninterruptible sleep) when it shouldn't be.

Check this by running `ps aux' or whatever.

> A full cycle lasts approximately 27 minutes.
> Mins	Load
> 0-2		0.0-0.15 (stable, 0 level)
> 3-5		0.50, 0.80, 0.95 (fast increase)
> 6-21	0.95-1.10 (stable, 1 level)
> 22-24   0.9, 0.8, 0.1 (fast decrease, to 0 level)
> 25-27   0.2, 0.3, 0.15 (local maxima peak)
> 
> Here's a graph of it, spanning 230 minutes:
> http://dev.gentoo.org/~robbat2/20071230-g5-loadavg-bug.png
> 
> Processed data for the graph here:
> http://dev.gentoo.org/~robbat2/20071230-g5-loadavg-bug.txt
> 
> For the entire 230 minute period, there was _no_ disk I/O.
> Not recorded by iostat, nor generated.
> 
> # while true ; do uptime ; iostat -t 60 2  -N -d | tail -n15 ; done >/dev/shm/foo
> 
> Example of single output pass for the above loop:
>  00:59:37 up  8:32,  2 users,  load average: 0.02, 0.47, 0.66
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda               0.00         0.00         0.00          0          0
> sdb               0.00         0.00         0.00          0          0
> md1               0.00         0.00         0.00          0          0
> md0               0.00         0.00         0.00          0          0
> md2               0.00         0.00         0.00          0          0
> md3               0.00         0.00         0.00          0          0
> vg-usr            0.00         0.00         0.00          0          0
> vg-var            0.00         0.00         0.00          0          0
> vg-tmp            0.00         0.00         0.00          0          0
> vg-opt            0.00         0.00         0.00          0          0
> vg-home           0.00         0.00         0.00          0          0
> vg-usr_src        0.00         0.00         0.00          0          0
> vg-usr_portage     0.00         0.00         0.00          0          0
> 
> This is basically 1842c7f2 from Linus's tree, my own stuff is config'd out with
> =n for the moment. And the problem does still occur in the main tree.
> 
> Snippet from the head of 'top', sorting by cputime.
> 
> top - 01:59:08 up  9:32,  2 users,  load average: 1.04, 0.87, 0.70
> Tasks:  74 total,   1 running,  73 sleeping,   0 stopped,   0 zombie
> Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu1  :  0.0%us,  0.5%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu2  :  0.0%us,  0.2%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:  12074480k total,   292520k used, 11781960k free,    76812k buffers
> Swap:  8388536k total,        0k used,  8388536k free,   144276k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  4635 root      15  -5     0    0    0 S    0  0.0   8:14.33 md3_raid1
>  3121 root      15  -5     0    0    0 S    1  0.0   3:15.12 md2_raid1
>  3098 root      15  -5     0    0    0 S    0  0.0   3:07.83 md1_raid1
>  3076 root      15  -5     0    0    0 S    0  0.0   0:45.82 md0_raid1
>   829 root      15  -5     0    0    0 D    0  0.0   0:01.85 kwindfarm
>    13 root      15  -5     0    0    0 S    0  0.0   0:01.41 ksoftirqd/3
>    18 root      15  -5     0    0    0 S    0  0.0   0:01.39 events/3
>    10 root      15  -5     0    0    0 S    0  0.0   0:00.94 ksoftirqd/2
>     1 root      20   0  1900  652  576 S    0  0.0   0:00.89 init
> 32086 root      20   0  9336 2696 2076 S    0  0.0   0:00.87 sshd

>From that I'd suspect that kwindfarm is being a bad citizen.

If a process is consistently stuck in D state, run

	echo w > /proc/sysrq-trigger

then record the resulting dmesg output so we can see where it got stuck.
