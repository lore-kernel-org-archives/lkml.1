Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYBLFRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYBLFRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYBLFQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:16:59 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60451 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYBLFQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:16:59 -0500
Date: Mon, 11 Feb 2008 21:16:55 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid
	context at include/asm/uaccess_32.h:449
Message-ID: <20080212051655.GA28136@us.ibm.com>
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com> <20080209162643.fd3822f1.akpm@linux-foundation.org> <20080210212528.GA17442@us.ibm.com> <20080211222855.GA9138@us.ibm.com> <a44ae5cd0802111957mf196288m1fe5fd4219911336@mail.gmail.com> <a44ae5cd0802112017o4c29cd0dia38335821c0f3c3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0802112017o4c29cd0dia38335821c0f3c3f@mail.gmail.com>
X-Operating-System: Linux 2.6.23 (x86_64)
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.02.2008 [23:17:40 -0500], Miles Lane wrote:
> I don't believe it is related to this patch, but while testing,

Does this not happen with the patch reverted? I'd be really surprised if
this had any effect on your fans... You could always just revert the
patch you bisected down to from 2.6.24-git20 (it just closes a race in
hugetlbfs code, which you're not going to hit with the commands below),
to see if it is a pre-existing condition in 2.6.25-rc0.

> I tried running "find /proc | xargs cat" and "find /proc | xargs head"
> and "find /proc | xargs tail" and "ls -aR /" all at once.  Everything
> seemed to be running great.  Firefox continued to be highly
> responsive.  I did notice that one of the command line processes had
> stopped scrolling text.  After sending my approval message just now

( Thanks for that message, btw )

> , I killed all the command line processes.  Then I noticed that the
> frequency scaling monitor remained pegged for both CPUs in my Duo 2
> Core processor.  I ran top, and everything looked okay.  As far as I
> can tell, top thinks the CPU is mostly idling.  However, as I write
> this my fan is going full speed.  I looked in my dmesg output and see
> no sign of an OOPS, a BUG or and INFO message.
> 
> top - 23:01:03 up 13 min,  2 users,  load average: 0.13, 0.70, 0.58
> Tasks: 128 total,   2 running, 126 sleeping,   0 stopped,   0 zombie
> Cpu(s):  1.5%us,  1.6%sy,  0.0%ni, 96.9%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   2060928k total,   855628k used,  1205300k free,   155704k buffers
> Swap:   570268k total,        0k used,   570268k free,   259780k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  3879 root      20   0  356m  16m 8212 R    2  0.8   1:58.43 Xorg
>  4377 miles     20   0 20948 8276 6992 S    1  0.4   0:07.75 multiload-apple
>  5099 miles     20   0 75368  22m  12m S    1  1.1   0:01.06 gnome-terminal
>  5176 miles     20   0  2304 1108  836 R    1  0.1   0:00.47 top
>     9 root      -2  -5     0    0    0 S    0  0.0   0:00.25 group_balance
>  3344 messageb  20   0  3028 1212  732 S    0  0.1   0:00.85 dbus-daemon
>  3406 haldaemo  20   0  6112 3764 3152 S    0  0.2   0:00.81 hald
>     1 root      20   0  2972 1856  532 S    0  0.1   0:00.77 init
>     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd
> 
> 
> [  868.025460] power_supply BAT1: uevent
> [  868.025467] power_supply BAT1: POWER_SUPPLY_NAME=BAT1
> [  868.025475] power_supply BAT1: Static prop TYPE=Battery
> [  868.025480] power_supply BAT1: 12 dynamic props
> [  868.025486] power_supply BAT1: prop STATUS=Full
> [  868.025491] power_supply BAT1: prop PRESENT=1
> [  868.025496] power_supply BAT1: prop TECHNOLOGY=Li-ion
> [  868.025503] power_supply BAT1: prop VOLTAGE_MIN_DESIGN=14800000
> [  868.025508] power_supply BAT1: prop VOLTAGE_NOW=16715000
> [  868.025515] power_supply BAT1: prop CURRENT_NOW=0
> [  868.025520] power_supply BAT1: prop CHARGE_FULL_DESIGN=4800000
> [  868.025526] power_supply BAT1: prop CHARGE_FULL=4164000
> [  868.025532] power_supply BAT1: prop CHARGE_NOW=4160000
> [  868.025539] power_supply BAT1: prop MODEL_NAME=MAL42b
> [  868.025545] power_supply BAT1: prop MANUFACTURER=SMP-PAN24
> [  868.025552] power_supply BAT1: prop SERIAL_NUMBER=
> [  738.719569] power_supply BAT1: uevent
> [  738.719576] power_supply BAT1: POWER_SUPPLY_NAME=BAT1
> [  738.719583] power_supply BAT1: Static prop TYPE=Battery
> [  738.719587] power_supply BAT1: 12 dynamic props
> [  738.719592] power_supply BAT1: prop STATUS=Full
> [  738.719597] power_supply BAT1: prop PRESENT=1
> [  738.719603] power_supply BAT1: prop TECHNOLOGY=Li-ion
> [  738.719609] power_supply BAT1: prop VOLTAGE_MIN_DESIGN=14800000
> [  738.719616] power_supply BAT1: prop VOLTAGE_NOW=16715000
> [  738.719622] power_supply BAT1: prop CURRENT_NOW=0
> [  738.719627] power_supply BAT1: prop CHARGE_FULL_DESIGN=4800000
> [  738.719633] power_supply BAT1: prop CHARGE_FULL=4164000
> [  738.719639] power_supply BAT1: prop CHARGE_NOW=4160000
> [  738.719646] power_supply BAT1: prop MODEL_NAME=MAL42b
> [  738.719652] power_supply BAT1: prop MANUFACTURER=SMP-PAN24
> [  738.719658] power_supply BAT1: prop SERIAL_NUMBER=
> [  738.722095] power_supply ACAD: uevent
> [  738.722099] power_supply ACAD: POWER_SUPPLY_NAME=ACAD
> [  738.722105] power_supply ACAD: Static prop TYPE=Mains
> [  738.722110] power_supply ACAD: 1 dynamic props
> [  738.722114] power_supply ACAD: prop ONLINE=1
> 
> I just ran:
> cpufreq-selector  -c 0 -f 800
> cpufreq-selector  -c 1 -f 800
> 
> Now everything is quite and running normally, except that Gnome seems
> to no longer be increasing the frequency of the CPUs with the ondemand
> governor.
> 
> top - 23:10:58 up 23 min,  2 users,  load average: 0.09, 0.17, 0.34
> Tasks: 132 total,   1 running, 131 sleeping,   0 stopped,   0 zombie
> Cpu(s):  6.4%us,  3.7%sy,  0.0%ni, 89.8%id,  0.2%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   2060928k total,   948740k used,  1112188k free,   156636k buffers
> Swap:   570268k total,        0k used,   570268k free,   260544k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  5240 miles     20   0  254m 106m  22m S   10  5.3   0:39.51 firefox-bin
>  3879 root      20   0  357m  16m 8664 S    4  0.8   2:27.28 Xorg
>  4377 miles     20   0 20948 8276 6992 S    2  0.4   0:15.21 multiload-apple
>  5099 miles     20   0 75552  23m  12m S    1  1.1   0:02.31 gnome-terminal
>  5682 root      20   0  2304 1108  836 R    1  0.1   0:00.52 top
>     7 root      15  -5     0    0    0 S    0  0.0   0:00.37 ksoftirqd/1
>  4170 miles     20   0 15584 3656 2788 S    0  0.2   0:01.43 gnome-screensav
>     1 root      20   0  2972 1856  532 S    0  0.1   0:00.77 init
> 
> Not sure how to explore this further.

Nor am I. You might be able to bisect it down by just putting

# CONFIG_HUGETLBFS is no set

in your .config and seeing where it was introduced, that will avoid the
sysctl that had the BUG altogether.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
