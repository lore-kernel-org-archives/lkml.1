Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZDGJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZDGJRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZDGJRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:17:09 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33876 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbZDGJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:17:07 -0400
Date: Tue, 7 Apr 2009 11:17:00 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrea Righi <righi.andrea@gmail.com>
cc: Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: commit 66c1ca breaks fbdev mode switching
In-Reply-To: <20090406214528.GA17259@linux>
Message-ID: <alpine.LRH.2.00.0904071105040.24773@vixen.sonytel.be>
References: <498817E2.3020008@gmail.com> <1233783983-28802-1-git-send-email-righi.andrea@gmail.com> <200903221748.42871.arvidjaar@gmail.com> <200903221857.20473.rjw@sisk.pl> <20090322145219.ad294615.akpm@linux-foundation.org> <20090406204718.ce4909b3.krzysztof.h1@poczta.fm>
 <20090406214528.GA17259@linux>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Andrea Righi wrote:
> On Mon, Apr 06, 2009 at 08:47:18PM +0200, Krzysztof Helt wrote:
> > The commit 66c1ca breaks fbdev mode switching. The first mode
> > (selected with mode_option or during boot) is ok but every mode
> > switch with fbset locks up computer. If the commit is reverted
> > mode switching works correctly.
> > 
> > I do not understand why. I would be grateful if someone else
> > can confirm the problem as well.
> > 
> > The commit's details are:
> > 
> > commit 66c1ca019078220dc1bf968f2bb18421100ef147
> > Author: Andrea Righi <righi.andrea@gmail.com>
> > Date:   Tue Mar 31 15:25:18 2009 -0700
> > 
> >     fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
> 
> Any lockdep info or oops? it just locks up the system?

# echo d > /proc/sysrq-trigger

[  187.654947] INFO: lockdep is turned off.

Strange, I do have lockdep enabled:

CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y

# echo w > /proc/sysrq-trigger 

[  243.301997] SysRq : Show Blocked State
[  243.302007]   task                        PC stack   pid father
[  243.302017] events/0      D 0000000000000000     0     9      2
[  243.302025] Call Trace:
[  243.302038] [c0000000060cb680] [c0000000060cb730] 0xc0000000060cb730 (unreliable)
[  243.302055] [c0000000060cb850] [c00000000001088c] .__switch_to+0xec/0x14c
[  243.302068] [c0000000060cb8e0] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  243.302078] [c0000000060cba10] [c0000000003c459c] .schedule+0x1c/0x3c
[  243.302087] [c0000000060cba90] [c0000000003c4798] .schedule_timeout+0x40/0x1f8
[  243.302098] [c0000000060cbb80] [c0000000003c65b4] .__down+0x70/0xc4
[  243.302110] [c0000000060cbc40] [c000000000073f3c] .down+0x44/0x6c
[  243.302123] [c0000000060cbcd0] [c0000000000532c0] .acquire_console_sem+0x30/0x64
[  243.302143] [c0000000060cbd50] [c00000000024511c] .console_callback+0x20/0x19c
[  243.302156] [c0000000060cbdf0] [c00000000006940c] .worker_thread+0x23c/0x364
[  243.302165] [c0000000060cbf00] [c00000000006e5d4] .kthread+0x78/0xc4
[  243.302177] [c0000000060cbf90] [c000000000021450] .kernel_thread+0x54/0x70
[  243.302184] events/1      D 0000000000000000     0    10      2
[  243.302192] Call Trace:
[  243.302199] [c0000000060d3660] [c0000000060d3710] 0xc0000000060d3710 (unreliable)
[  243.302210] [c0000000060d3830] [c00000000001088c] .__switch_to+0xec/0x14c
[  243.302220] [c0000000060d38c0] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  243.302229] [c0000000060d39f0] [c0000000003c459c] .schedule+0x1c/0x3c
[  243.302238] [c0000000060d3a70] [c0000000003c4798] .schedule_timeout+0x40/0x1f8
[  243.302248] [c0000000060d3b60] [c0000000003c65b4] .__down+0x70/0xc4
[  243.302257] [c0000000060d3c20] [c000000000073f3c] .down+0x44/0x6c
[  243.302267] [c0000000060d3cb0] [c0000000000532c0] .acquire_console_sem+0x30/0x64
[  243.302278] [c0000000060d3d30] [c00000000021ac88] .fb_flashcursor+0x44/0x3bc
[  243.302288] [c0000000060d3df0] [c00000000006940c] .worker_thread+0x23c/0x364
[  243.302298] [c0000000060d3f00] [c00000000006e5d4] .kthread+0x78/0xc4
[  243.302307] [c0000000060d3f90] [c000000000021450] .kernel_thread+0x54/0x70
[  243.302322] ps3fb         D 0000000000000000     0   370      2
[  243.302330] Call Trace:
[  243.302337] [c0000000061077a0] [c000000006107850] 0xc000000006107850 (unreliable)
[  243.302348] [c000000006107970] [c00000000001088c] .__switch_to+0xec/0x14c
[  243.302358] [c000000006107a00] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  243.302367] [c000000006107b30] [c0000000003c459c] .schedule+0x1c/0x3c
[  243.302376] [c000000006107bb0] [c0000000003c4798] .schedule_timeout+0x40/0x1f8
[  243.302386] [c000000006107ca0] [c0000000003c65b4] .__down+0x70/0xc4
[  243.302396] [c000000006107d60] [c000000000073f3c] .down+0x44/0x6c
[  243.302406] [c000000006107df0] [c0000000000532c0] .acquire_console_sem+0x30/0x64
[  243.302417] [c000000006107e70] [c000000000228d0c] .ps3fbd+0x4c/0x9c
[  243.302426] [c000000006107f00] [c00000000006e5d4] .kthread+0x78/0xc4
[  243.302435] [c000000006107f90] [c000000000021450] .kernel_thread+0x54/0x70
[  243.302466] fbset         D 000000000ff59878     0  2069   2065
[  243.302474] Call Trace:
[  243.302481] [c000000006d43040] [c000000006d430f0] 0xc000000006d430f0 (unreliable)
[  243.302492] [c000000006d43210] [c00000000001088c] .__switch_to+0xec/0x14c
[  243.302502] [c000000006d432a0] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  243.302512] [c000000006d433d0] [c0000000003c587c] .mutex_lock_nested+0x268/0x414
[  243.302521] [c000000006d434d0] [c000000000214200] .lock_fb_info+0x28/0x64
[  243.302531] [c000000006d43560] [c0000000002208f8] .fbcon_event_notify+0x144/0x89c
[  243.302542] [c000000006d436b0] [c000000000074174] .notifier_call_chain+0xac/0x124
[  243.302552] [c000000006d43760] [c000000000074510] .__blocking_notifier_call_chain+0x70/0xb0
[  243.302565] [c000000006d43810] [c000000000213bd0] .fb_notifier_call_chain+0x28/0x40
[  243.302575] [c000000006d43890] [c000000000215dec] .fb_set_var+0x2d4/0x314
[  243.302583] [c000000006d43a10] [c000000000215f68] .do_fb_ioctl+0x13c/0x4bc
[  243.302592] [c000000006d43c10] [c0000000002163dc] .fb_compat_ioctl+0xf4/0x834
[  243.302606] [c000000006d43d50] [c0000000001292c4] .compat_sys_ioctl+0x11c/0x448
[  243.302616] [c000000006d43e30] [c0000000000074dc] syscall_exit+0x0/0x40

and a bit later:

[  608.812517] INFO: task events/0:9 blocked for more than 480 seconds.
[  608.812523] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  608.812529] events/0      D 0000000000000000     0     9      2
[  608.812538] Call Trace:
[  608.812550] [c0000000060cb680] [c0000000060cb730] 0xc0000000060cb730 (unreliable)
[  608.812567] [c0000000060cb850] [c00000000001088c] .__switch_to+0xec/0x14c
[  608.812580] [c0000000060cb8e0] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  608.812590] [c0000000060cba10] [c0000000003c459c] .schedule+0x1c/0x3c
[  608.812599] [c0000000060cba90] [c0000000003c4798] .schedule_timeout+0x40/0x1f8
[  608.812610] [c0000000060cbb80] [c0000000003c65b4] .__down+0x70/0xc4
[  608.812622] [c0000000060cbc40] [c000000000073f3c] .down+0x44/0x6c
[  608.812635] [c0000000060cbcd0] [c0000000000532c0] .acquire_console_sem+0x30/0x64
[  608.812647] [c0000000060cbd50] [c00000000024511c] .console_callback+0x20/0x19c
[  608.812659] [c0000000060cbdf0] [c00000000006940c] .worker_thread+0x23c/0x364
[  608.812669] [c0000000060cbf00] [c00000000006e5d4] .kthread+0x78/0xc4
[  608.812681] [c0000000060cbf90] [c000000000021450] .kernel_thread+0x54/0x70
[  608.812687] INFO: lockdep is turned off.
[  608.812693] INFO: task events/1:10 blocked for more than 480 seconds.
[  608.812698] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  608.812703] events/1      D 0000000000000000     0    10      2
[  608.812711] Call Trace:
[  608.812718] [c0000000060d3660] [c0000000060d3710] 0xc0000000060d3710 (unreliable)
[  608.812729] [c0000000060d3830] [c00000000001088c] .__switch_to+0xec/0x14c
[  608.812738] [c0000000060d38c0] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  608.812748] [c0000000060d39f0] [c0000000003c459c] .schedule+0x1c/0x3c
[  608.812757] [c0000000060d3a70] [c0000000003c4798] .schedule_timeout+0x40/0x1f8
[  608.812767] [c0000000060d3b60] [c0000000003c65b4] .__down+0x70/0xc4
[  608.812776] [c0000000060d3c20] [c000000000073f3c] .down+0x44/0x6c
[  608.812786] [c0000000060d3cb0] [c0000000000532c0] .acquire_console_sem+0x30/0x64
[  608.812797] [c0000000060d3d30] [c00000000021ac88] .fb_flashcursor+0x44/0x3bc
[  608.812807] [c0000000060d3df0] [c00000000006940c] .worker_thread+0x23c/0x364
[  608.812816] [c0000000060d3f00] [c00000000006e5d4] .kthread+0x78/0xc4
[  608.812826] [c0000000060d3f90] [c000000000021450] .kernel_thread+0x54/0x70
[  608.812832] INFO: lockdep is turned off.
[  608.812868] INFO: task fbset:2069 blocked for more than 480 seconds.
[  608.812872] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  608.812878] fbset         D 000000000ff59878     0  2069   2065
[  608.812886] Call Trace:
[  608.812893] [c000000006d43040] [c000000006d430f0] 0xc000000006d430f0 (unreliable)
[  608.812904] [c000000006d43210] [c00000000001088c] .__switch_to+0xec/0x14c
[  608.812914] [c000000006d432a0] [c0000000003c449c] .__schedule+0x9b8/0xa9c
[  608.812924] [c000000006d433d0] [c0000000003c587c] .mutex_lock_nested+0x268/0x414
[  608.812933] [c000000006d434d0] [c000000000214200] .lock_fb_info+0x28/0x64
[  608.812943] [c000000006d43560] [c0000000002208f8] .fbcon_event_notify+0x144/0x89c
[  608.812954] [c000000006d436b0] [c000000000074174] .notifier_call_chain+0xac/0x124
[  608.812964] [c000000006d43760] [c000000000074510] .__blocking_notifier_call_chain+0x70/0xb0
[  608.812978] [c000000006d43810] [c000000000213bd0] .fb_notifier_call_chain+0x28/0x40
[  608.812987] [c000000006d43890] [c000000000215dec] .fb_set_var+0x2d4/0x314
[  608.812996] [c000000006d43a10] [c000000000215f68] .do_fb_ioctl+0x13c/0x4bc
[  608.813005] [c000000006d43c10] [c0000000002163dc] .fb_compat_ioctl+0xf4/0x834
[  608.813018] [c000000006d43d50] [c0000000001292c4] .compat_sys_ioctl+0x11c/0x448
[  608.813028] [c000000006d43e30] [c0000000000074dc] syscall_exit+0x0/0x40
[  608.813034] INFO: lockdep is turned off.

As evidenced by the compat_sys_ioctl, this is a 32-bit userland on ppc64.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
