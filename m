Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYEOTdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYEOTdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYEOTcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:32:55 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:49892 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751665AbYEOTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:32:54 -0400
Message-ID: <482C8FD6.10808@gawab.com>
Date: Thu, 15 May 2008 12:32:38 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [regression bisected] HR-timers bug >=2.6.25
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've reported this problem previously:
http://lkml.org/lkml/2008/3/12/290
http://bugzilla.kernel.org/show_bug.cgi?id=10235
https://bugs.freedesktop.org/show_bug.cgi?id=15602

This bug is still in mainline as of 2.6.26-rc1. (affected versions 
2.6.25-rc0 - 2.6.26-rc1)

Ever since 2.6.25-rc3 (the first rc I tested), my screen would blank out 
when mode switching from the Ubuntu uplash to the gdm login. Normally 
after the boot splash, the screen goes black and "refreshes" to select 
the correct resolution. But when using a kernel newer than 2.6.24 the 
screen doesn't come back on - it stays blank. This doesn't happen every 
time, but a good majority of the time. The workaround is to disable the 
splash, and that fixes the problem almost completely.

I did a git bisect. Rebooting 3 times if the problem didn't occur just 
to make sure.
The git bisect reports that it's timing related - which is what Jesse 
Barnes said it could be.

> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:29 2008 +0100
>
> sched: high-res preemption tick
>
> Use HR-timers (when available) to deliver an accurate preemption tick.
>
> The regular scheduler tick that runs at 1/HZ can be too coarse when 
> nice level
> are used. The fairness system will still keep the cpu utilisation 
> 'fair' by
> then delaying the task that got an excessive amount of CPU time but try to
> minimize this by delivering preemption points spot-on.
>
> The average frequency of this extra interrupt is sched_latency / 
> nr_latency.
> Which need not be higher than 1/HZ, its just that the distribution 
> within the
> sched_latency period is important.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> :040000 040000 ab225228500f7a19d5ad20ca12ca3fc8ff5f5ad1
> f1742e1d225a72aecea9d6961ed989b5943d31d8 M      arch
> :040000 040000 25d85e4ef7a71b0cc76801a2526ebeb4dce180fe
> ae61510186b4fad708ef0211ac169decba16d4e5 M      include
> :040000 040000 9247cec7dd506c648ac027c17e5a07145aa41b26
> 950832cc1dc4d30923f593ecec883a06b45d62e9 M      kernel

> # bad: [29e8c3c304b62f31b799565c9ee85d42bd163f80] Linux 2.6.25-rc4
> # good: [49914084e797530d9baaf51df9eda77babc98fa8] Linux 2.6.24
> git-bisect start 'v2.6.25-rc4' 'v2.6.24'
> # bad: [bd45ac0c5daae35e7c71138172e63df5cf644cf6] Merge branch 'linux-2.6'
> git-bisect bad bd45ac0c5daae35e7c71138172e63df5cf644cf6
> # good: [a6f71745969d495d697d1ccd96385d2f7a963375] [POWERPC] 85xx: 
> Only invalidate TLB0 and TLB1
> git-bisect good a6f71745969d495d697d1ccd96385d2f7a963375
> # bad: [fb5b6095f320bd5a615049aa5fe8827ae9d1bf80] [NETFILTER]: 
> arp_tables: move entry and target checks to seperate functions
> git-bisect bad fb5b6095f320bd5a615049aa5fe8827ae9d1bf80
> # bad: [50d9a126240f9961cfdd063336bbeb91f77a7dce] Merge 
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
> git-bisect bad 50d9a126240f9961cfdd063336bbeb91f77a7dce
> # good: [102df6a785bd5ff22b0ca745f3107ab9780fc30b] V4L/DVB (6685): 
> ir-keymaps.c: extra keys on winfast Y04G0033 remote
> git-bisect good 102df6a785bd5ff22b0ca745f3107ab9780fc30b
> # good: [a999337b49fcdd2c4a475e97e4b8337ebdfa4abf] V4L/DVB (7078): 
> radio: fix sf16fmi section mismatch
> git-bisect good a999337b49fcdd2c4a475e97e4b8337ebdfa4abf
> # bad: [b31fde6db2b76a9f7f59bf016652b46cff43f8da] Merge 
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb
> git-bisect bad b31fde6db2b76a9f7f59bf016652b46cff43f8da
> # bad: [6478d8800b75253b2a934ddcb734e13ade023ad0] sched: remove the 
> !PREEMPT_BKL code
> git-bisect bad 6478d8800b75253b2a934ddcb734e13ade023ad0
> # good: [80bf3171dcdf0f5d236e2e48afe2a95c7ce23879] sched: clean up 
> pull_rt_task()
> git-bisect good 80bf3171dcdf0f5d236e2e48afe2a95c7ce23879
> # good: [eaf649e9fe6685f4c5a392cd0e16df5fd6660b7c] Preempt-RCU: CPU 
> Hotplug handling
> git-bisect good eaf649e9fe6685f4c5a392cd0e16df5fd6660b7c
> # bad: [6f505b16425a51270058e4a93441fe64de3dd435] sched: rt group 
> scheduling
> git-bisect bad 6f505b16425a51270058e4a93441fe64de3dd435
> # good: [78f2c7db6068fd6ef75b8c120f04a388848eacb5] sched: 
> SCHED_FIFO/SCHED_RR watchdog timer
> git-bisect good 78f2c7db6068fd6ef75b8c120f04a388848eacb5
> # good: [02b67cc3ba36bdba351d6c3a00593f4ec550d9d3] sched: do not do 
> cond_resched() when CONFIG_PREEMPT
> git-bisect good 02b67cc3ba36bdba351d6c3a00593f4ec550d9d3
> # bad: [fa85ae2418e6843953107cd6a06f645752829bc0] sched: rt time limit
> git-bisect bad fa85ae2418e6843953107cd6a06f645752829bc0
> # bad: [8f4d37ec073c17e2d4aa8851df5837d798606d6f] sched: high-res 
> preemption tick
> git-bisect bad 8f4d37ec073c17e2d4aa8851df5837d798606d6f


