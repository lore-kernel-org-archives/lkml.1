Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYGQJa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYGQJa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYGQJas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:30:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40467 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYGQJar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:30:47 -0400
Date: Thu, 17 Jul 2008 11:26:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: john stultz <johnstul@us.ibm.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [crash, bisected] I2C,  kobject (ffff81003e8c4160): tried to
	init an initialized object
Message-ID: <20080717092655.GA6115@elte.hu>
References: <20080714224945.629446fa@hyperion.delvare> <20080716082352.GA30483@elte.hu> <20080716110702.3ca61eb2@hyperion.delvare> <20080716120801.3e9b4c80@hyperion.delvare> <20080716141826.1d88d05e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716141826.1d88d05e@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jean,

-tip testing found another (similar) i2c crash with latest -git, on a 
Core2Duo laptop:

calling  nforce2_init+0x0/0x1b
initcall nforce2_init+0x0/0x1b returned 0 after 0 msecs
calling  nforce2_s4985_init+0x0/0x275
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c04af2cf>] i2c_smbus_xfer+0x27/0x3f0
*pdpt = 00000000009cb001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 

Pid: 1, comm: swapper Not tainted (2.6.26-tip #3033)
EIP: 0060:[<c04af2cf>] EFLAGS: 00010246 CPU: 0
EIP is at i2c_smbus_xfer+0x27/0x3f0
EAX: 00000003 EBX: 00000000 ECX: 00000000 EDX: 00000018
ESI: 00000003 EDI: 00000018 EBP: f7c6ff24 ESP: f7c6fea8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7c6e000 task=f7c70000 task.ti=f7c6e000)
Stack: 00000035 00030000 00000000 c0104237 00000000 00000046 00000046 00000000 
       00000000 f7c6ff50 c09debf0 0001007b fffe007b 000000d8 ffffffef c01213cb 
       00000060 00000286 f7c6ff1c 00000004 00000286 00000246 f7c6ff24 c014673a 
Call Trace:
 [<c0104237>] ? common_interrupt+0x23/0x28
 [<c01213cb>] ? vprintk+0x290/0x29b
 [<c014673a>] ? ftrace_record_ip+0x19f/0x1e6
 [<c01a1385>] ? sysfs_add_file_mode+0x57/0x76
 [<c099632f>] ? nforce2_s4985_init+0x2d/0x275
 [<c013319c>] ? ktime_get_ts+0x51/0x55
 [<c01331b8>] ? ktime_get+0x18/0x34
 [<c0971887>] ? kernel_init+0x11f/0x24a
 [<c0996302>] ? nforce2_s4985_init+0x0/0x275
 [<c011cbe8>] ? schedule_tail+0x1e/0x4d
 [<c01037aa>] ? ret_from_fork+0x6/0x1c
 [<c0971768>] ? kernel_init+0x0/0x24a
 [<c0971768>] ? kernel_init+0x0/0x24a
 [<c0104477>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 70 e8 ca 51 c5 ff 89 45 8c 8b 75 0c 83 e1 14 8a 45 08 89 d7 8b 5d 8c 88 45 8b 89 f0 88 45 8a <8b> 43 0c 83 78 04 00 0f b7 c1 89 45 84 74 3a 83 c3 20 89 d8 e8 
EIP: [<c04af2cf>] i2c_smbus_xfer+0x27/0x3f0 SS:ESP 0068:f7c6fea8
Kernel panic - not syncing: Fatal exception
Pid: 1, comm: swapper Tainted: G      D   2.6.26-tip #3033
 [<c01208ee>] panic+0x44/0xeb
 [<c0104c8d>] die+0x123/0x13a
 [<c0110f38>] do_page_fault+0x632/0x6f2
 [<c0110906>] ? do_page_fault+0x0/0x6f2
 [<c06585ca>] error_code+0x72/0x78
 [<c04af2cf>] ? i2c_smbus_xfer+0x27/0x3f0
 [<c0104237>] ? common_interrupt+0x23/0x28
 [<c01213cb>] ? vprintk+0x290/0x29b
 [<c014673a>] ? ftrace_record_ip+0x19f/0x1e6
 [<c01a1385>] ? sysfs_add_file_mode+0x57/0x76
 [<c099632f>] nforce2_s4985_init+0x2d/0x275
 [<c013319c>] ? ktime_get_ts+0x51/0x55
 [<c01331b8>] ? ktime_get+0x18/0x34
 [<c0971887>] kernel_init+0x11f/0x24a
 [<c0996302>] ? nforce2_s4985_init+0x0/0x275
 [<c011cbe8>] ? schedule_tail+0x1e/0x4d
 [<c01037aa>] ? ret_from_fork+0x6/0x1c
 [<c0971768>] ? kernel_init+0x0/0x24a
 [<c0971768>] ? kernel_init+0x0/0x24a
 [<c0104477>] kernel_thread_helper+0x7/0x10
 =======================

the config is:

  http://redhat.com/~mingo/misc/config-Thu_Jul_17_10_47_42_CEST_2008.bad

this too seems to have a sysfs angle. I have tried 
a3cf859321486f69506326146ab3e2fd15c05c3f, is that supposed to have fixed 
all previous problems?

	Ingo
