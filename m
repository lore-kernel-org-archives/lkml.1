Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXE2RQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXE2RQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXE2RQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:16:24 -0400
Received: from 125.14.124.24.cm.sunflower.com ([24.124.14.125]:18747 "EHLO
	mail.atipa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180AbXE2RQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:16:20 -0400
Message-ID: <465C5FDF.4070401@atipa.com>
Date: Tue, 29 May 2007 12:16:15 -0500
From: Roger Heflin <rheflin@atipa.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Apparent Deadlock with nfsd/jfs on 2.6.21.1 under bonnie.
References: <4649BED9.6090207@atipa.com>	 <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>	 <464C68A0.2050003@atipa.com> <1179413287.13965.24.camel@kleikamp.austin.ibm.com>
In-Reply-To: <1179413287.13965.24.camel@kleikamp.austin.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------030401080608010707040408"
X-OriginalArrivalTime: 29 May 2007 17:18:57.0734 (UTC) FILETIME=[71025660:01C7A215]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030401080608010707040408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dave Kleikamp wrote:
> On Thu, 2007-05-17 at 09:37 -0500, Roger Heflin wrote:
>> Dave Kleikamp wrote:
>>
>>> I don't have an answer to an ext3 deadlock, but this looks like a jfs
>>> problem that was recently fixed in linux-2.6.22-rc1.  I had intended to
>>> send it to the stable kernel after it was picked up in mainline, but
>>> hadn't gotten to it yet.
>>>
>>> The patch is here:
>>> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=05ec9e26be1f668ccba4ca54d9a4966c6208c611
>>>
>> Dave,
>>
>> That appears to have fixed the JFS hangup.
>>
>> MTBF before was about 1 hour, under the same test I am over 20 hours
>> and things appear to still be holding together.
> 
> Great.  The patch is queued for the 2.6.21 stable tree now.
> 
> Thanks,
> Shaggy

Dave,

Apparently there appears to be another different similar lockup,
The MTBF has risen from 1-2 hours without that patch to >100 hours,
so I am fairly sure the patch did correct the original lockup, or
at the very least make it a lot less likely.

I hit the machine across NFS for 5 days before it deadlocked, before
the patch I could only get an hour or two (2-4 different tries).

Given that pdflush is "D" it does not appear to be an NFS issue.

Included is the sysrq-t.

This is with 2.6.21.1 + the JFSIO patch.


--------------030401080608010707040408
Content-Type: text/plain;
 name="jdb.lockup.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="jdb.lockup.txt"

May 29 11:58:20 vault1 kernel: SysRq : Show State
May 29 11:58:20 vault1 kernel: 
May 29 11:58:20 vault1 kernel:                                  free                        sibling
May 29 11:58:20 vault1 kernel:   task                 PC        stack   pid father child younger older
May 29 11:58:20 vault1 kernel: init          S ffff81011f96fa98     0     1      0 (NOTLB)
May 29 11:58:20 vault1 kernel:  ffff81011fc89a18 0000000000000046 0000000000000000 ffff810037e10040
May 29 11:58:20 vault1 kernel:  ffff810037e10040 ffffffff802638fc 000000000000000a ffff810037e10040
May 29 11:58:20 vault1 kernel:  ffff81011fc78040 0000000000006e1f ffff810037e10248 0000000137e28000
May 29 11:58:20 vault1 kernel: Call Trace:
May 29 11:58:20 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:20 vault1 kernel:  [<ffffffff80261790>] schedule_timeout+0x8a/0xad
May 29 11:58:20 vault1 kernel:  [<ffffffff802913d9>] process_timeout+0x0/0x5
May 29 11:58:20 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:20 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:20 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:20 vault1 kernel:  [<ffffffff80209596>] __d_lookup+0x77/0x110
May 29 11:58:20 vault1 kernel:  [<ffffffff802095f2>] __d_lookup+0xd3/0x110
May 29 11:58:20 vault1 kernel:  [<ffffffff802635ce>] _spin_unlock+0x17/0x20
May 29 11:58:20 vault1 kernel:  [<ffffffff802095f2>] __d_lookup+0xd3/0x110
May 29 11:58:20 vault1 kernel:  [<ffffffff8020cff9>] do_lookup+0x63/0x1ae
May 29 11:58:20 vault1 kernel:  [<ffffffff8020d542>] dput+0x3c/0x12b
May 29 11:58:20 vault1 kernel:  [<ffffffff8020a2b6>] __link_path_walk+0xc87/0xde9
May 29 11:58:20 vault1 kernel:  [<ffffffff8028dc04>] _local_bh_enable+0xbb/0xd0
May 29 11:58:20 vault1 kernel:  [<ffffffff8022d806>] mntput_no_expire+0x1c/0x96
May 29 11:58:20 vault1 kernel:  [<ffffffff8020ed97>] link_path_walk+0xce/0xe0
May 29 11:58:20 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:20 vault1 kernel:  [<ffffffff8022d806>] mntput_no_expire+0x1c/0x96
May 29 11:58:20 vault1 kernel:  [<ffffffff8021b2bb>] cp_new_stat+0xe5/0xfd
May 29 11:58:20 vault1 kernel:  [<ffffffff80216b98>] sys_select+0x15a/0x183
May 29 11:58:20 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:20 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:20 vault1 kernel: 
May 29 11:58:20 vault1 kernel: migration/0   S ffff81011f2b9218     0     2      1 (L-TLB)
May 29 11:58:20 vault1 kernel:  ffff810037e1bec0 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:20 vault1 kernel:  0000000100000000 0000000000000002 0000000000000001 ffff81011fc6f040
May 29 11:58:20 vault1 kernel:  ffffffff8058a6e0 0000000000000f63 ffff81011fc6f248 0000000000000000
May 29 11:58:20 vault1 kernel: Call Trace:
May 29 11:58:21 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff80243daa>] migration_thread+0x1a2/0x23f
May 29 11:58:21 vault1 kernel:  [<ffffffff80243c08>] migration_thread+0x0/0x23f
May 29 11:58:21 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:21 vault1 kernel:  [<ffffffff80356044>] vgacon_cursor+0x0/0x1a5
May 29 11:58:21 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:21 vault1 kernel: 
May 29 11:58:21 vault1 kernel: ksoftirqd/0   S ffff81007fe18098     0     3      1 (L-TLB)
May 29 11:58:21 vault1 kernel:  ffff810037e1ff00 0000000000000046 0000000000000000 ffff81011fc72080
May 29 11:58:21 vault1 kernel:  ffff81011fc72080 00000000000721d2 0000000000000009 ffff81011fc72080
May 29 11:58:21 vault1 kernel:  ffffffff8058a6e0 000000000043167f ffff81011fc72288 00000000805ea150
May 29 11:58:21 vault1 kernel: Call Trace:
May 29 11:58:21 vault1 kernel:  [<ffffffff8026b5d6>] do_softirq+0x90/0x94
May 29 11:58:21 vault1 kernel:  [<ffffffff8028deb7>] ksoftirqd+0x0/0xbf
May 29 11:58:21 vault1 kernel:  [<ffffffff8028def2>] ksoftirqd+0x3b/0xbf
May 29 11:58:21 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:21 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:21 vault1 kernel: 
May 29 11:58:21 vault1 kernel: watchdog/0    S ffff81007fe18098     0     4      1 (L-TLB)
May 29 11:58:21 vault1 kernel:  ffff810037e21ef0 0000000000000046 0000000000000000 ffffffff8028dc04
May 29 11:58:21 vault1 kernel:  0000000000000007 0000000000000001 0000000000000001 ffff81011fc730c0
May 29 11:58:21 vault1 kernel:  ffffffff8058a6e0 000000000000034a ffff81011fc732c8 0000000000000000
May 29 11:58:21 vault1 kernel: Call Trace:
May 29 11:58:21 vault1 kernel:  [<ffffffff8028dc04>] _local_bh_enable+0xbb/0xd0
May 29 11:58:21 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:21 vault1 kernel:  [<ffffffff802b7437>] watchdog+0x4f/0x5f
May 29 11:58:21 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:21 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:21 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:21 vault1 kernel: 
May 29 11:58:21 vault1 kernel: migration/1   S ffff81011f2b9218     0     5      1 (L-TLB)
May 29 11:58:21 vault1 kernel:  ffff810037e23ec0 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:21 vault1 kernel:  0000000100000000 0000000000000002 0000000000000001 ffff81011fc74040
May 29 11:58:21 vault1 kernel:  ffff81011fc78040 00000000000013c6 ffff81011fc74248 0000000100000000
May 29 11:58:21 vault1 kernel: Call Trace:
May 29 11:58:21 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff80243daa>] migration_thread+0x1a2/0x23f
May 29 11:58:21 vault1 kernel:  [<ffffffff80243c08>] migration_thread+0x0/0x23f
May 29 11:58:21 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:21 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:21 vault1 kernel: 
May 29 11:58:21 vault1 kernel: ksoftirqd/1   S ffff81007f1149d8     0     6      1 (L-TLB)
May 29 11:58:21 vault1 kernel:  ffff81000428bf00 0000000000000046 0000000000000000 ffff81011fc75080
May 29 11:58:21 vault1 kernel:  ffff81011fc75080 00000000000ca563 000000000000000a ffff81011fc75080
May 29 11:58:21 vault1 kernel:  ffff81011fc78040 0000000000000c5d ffff81011fc75288 00000001806bc060
May 29 11:58:21 vault1 kernel: Call Trace:
May 29 11:58:21 vault1 kernel:  [<ffffffff8026b5d6>] do_softirq+0x90/0x94
May 29 11:58:21 vault1 kernel:  [<ffffffff8028deb7>] ksoftirqd+0x0/0xbf
May 29 11:58:21 vault1 kernel:  [<ffffffff8028def2>] ksoftirqd+0x3b/0xbf
May 29 11:58:21 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:21 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:21 vault1 kernel: 
May 29 11:58:21 vault1 kernel: watchdog/1    S ffff81007f1149d8     0     7      1 (L-TLB)
May 29 11:58:21 vault1 kernel:  ffff81000428def0 0000000000000046 0000000000000000 0000000000000001
May 29 11:58:21 vault1 kernel:  ffff81000428c000 ffff81008354ee00 0000000000000008 ffff81011fc760c0
May 29 11:58:21 vault1 kernel:  ffff81011fc78040 0000000000000336 ffff81011fc762c8 0000000100000001
May 29 11:58:21 vault1 kernel: Call Trace:
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:21 vault1 kernel:  [<ffffffff802b7437>] watchdog+0x4f/0x5f
May 29 11:58:21 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:21 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:21 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:21 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:21 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:22 vault1 kernel:  [<ffffffff802c038d>] next_zone+0x23/0x24
May 29 11:58:22 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:22 vault1 kernel: 
May 29 11:58:22 vault1 kernel: migration/2   S ffff81011f96e058     0     8      1 (L-TLB)
May 29 11:58:22 vault1 kernel:  ffff8100042b1ec0 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:22 vault1 kernel:  0000000100000000 0000000000000002 0000000000000001 ffff81011fc7a080
May 29 11:58:22 vault1 kernel:  ffff81007ff1d080 000000000000190d ffff81011fc7a288 0000000200000000
May 29 11:58:22 vault1 kernel: Call Trace:
May 29 11:58:22 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff80243daa>] migration_thread+0x1a2/0x23f
May 29 11:58:22 vault1 kernel:  [<ffffffff80243c08>] migration_thread+0x0/0x23f
May 29 11:58:22 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:22 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:22 vault1 kernel: 
May 29 11:58:22 vault1 kernel: ksoftirqd/2   S ffff81007e8de9d8     0     9      1 (L-TLB)
May 29 11:58:22 vault1 kernel:  ffff8100042b3f00 0000000000000046 0000000000000000 ffff81011fccd0c0
May 29 11:58:22 vault1 kernel:  ffff81011fccd0c0 00000000000d838b 000000000000000a ffff81011fccd0c0
May 29 11:58:22 vault1 kernel:  ffff81011fccf080 0000000000000a83 ffff81011fccd2c8 00000002042b3ef0
May 29 11:58:22 vault1 kernel: Call Trace:
May 29 11:58:22 vault1 kernel:  [<ffffffff8026b5d6>] do_softirq+0x90/0x94
May 29 11:58:22 vault1 kernel:  [<ffffffff8028deb7>] ksoftirqd+0x0/0xbf
May 29 11:58:22 vault1 kernel:  [<ffffffff8028def2>] ksoftirqd+0x3b/0xbf
May 29 11:58:22 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:22 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:22 vault1 kernel: 
May 29 11:58:22 vault1 kernel: watchdog/2    S ffff81007fe19218     0    10      1 (L-TLB)
May 29 11:58:22 vault1 kernel:  ffff8100042b5ef0 0000000000000046 0000000000000000 0000000000000001
May 29 11:58:22 vault1 kernel:  ffff8100042b4000 ffff81010255df00 0000000000000007 ffff81011fcce040
May 29 11:58:22 vault1 kernel:  ffff81011fccf080 000000000000024f ffff81011fcce248 0000000200000001
May 29 11:58:22 vault1 kernel: Call Trace:
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:22 vault1 kernel:  [<ffffffff802b7437>] watchdog+0x4f/0x5f
May 29 11:58:22 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:22 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:22 vault1 kernel:  [<ffffffff802c038d>] next_zone+0x23/0x24
May 29 11:58:22 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:22 vault1 kernel: 
May 29 11:58:22 vault1 kernel: migration/3   S ffff81007ebd24b8     0    11      1 (L-TLB)
May 29 11:58:22 vault1 kernel:  ffff8100042dbec0 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:22 vault1 kernel:  0000000100000000 0000000000000002 0000000000000001 ffff81011fcd10c0
May 29 11:58:22 vault1 kernel:  ffff81011fd360c0 0000000000001383 ffff81011fcd12c8 0000000300000000
May 29 11:58:22 vault1 kernel: Call Trace:
May 29 11:58:22 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff80243daa>] migration_thread+0x1a2/0x23f
May 29 11:58:22 vault1 kernel:  [<ffffffff80243c08>] migration_thread+0x0/0x23f
May 29 11:58:22 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:22 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:22 vault1 kernel: 
May 29 11:58:22 vault1 kernel: ksoftirqd/3   S ffff81007e8de9d8     0    12      1 (L-TLB)
May 29 11:58:22 vault1 kernel:  ffff8100042ddf00 0000000000000046 0000000000000000 ffff81011fd34040
May 29 11:58:22 vault1 kernel:  ffff81007fc350c0 000000000022a171 000000000000000a ffff81011fd34040
May 29 11:58:22 vault1 kernel:  ffff81011fd360c0 00000000000007f8 ffff81011fd34248 00000003042ddfd8
May 29 11:58:22 vault1 kernel: Call Trace:
May 29 11:58:22 vault1 kernel:  [<ffffffff8026b5d6>] do_softirq+0x90/0x94
May 29 11:58:22 vault1 kernel:  [<ffffffff8028deb7>] ksoftirqd+0x0/0xbf
May 29 11:58:22 vault1 kernel:  [<ffffffff8028def2>] ksoftirqd+0x3b/0xbf
May 29 11:58:22 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:22 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:22 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:22 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:22 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:22 vault1 kernel: 
May 29 11:58:23 vault1 kernel: watchdog/3    S ffff810037d4ba98     0    13      1 (L-TLB)
May 29 11:58:23 vault1 kernel:  ffff8100042e1ef0 0000000000000046 0000000000000000 0000000000000001
May 29 11:58:23 vault1 kernel:  ffff8100042e0000 ffff810102568d00 0000000000000001 ffff81011fd35080
May 29 11:58:23 vault1 kernel:  ffff81011fd360c0 00000000000002b1 ffff81011fd35288 0000000300000001
May 29 11:58:23 vault1 kernel: Call Trace:
May 29 11:58:23 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:23 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:23 vault1 kernel:  [<ffffffff802b7437>] watchdog+0x4f/0x5f
May 29 11:58:23 vault1 kernel:  [<ffffffff802b73e8>] watchdog+0x0/0x5f
May 29 11:58:23 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:23 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:23 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:23 vault1 kernel:  [<ffffffff802c038d>] next_zone+0x23/0x24
May 29 11:58:23 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:23 vault1 kernel: 
May 29 11:58:23 vault1 kernel: events/0      S ffff81007e8de118     0    14      1 (L-TLB)
May 29 11:58:23 vault1 kernel:  ffff81007fdfbea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:23 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fa61040
May 29 11:58:23 vault1 kernel:  ffffffff8058a6e0 0000000000009929 ffff81011fa61248 000000001fa61040
May 29 11:58:23 vault1 kernel: Call Trace:
May 29 11:58:23 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:23 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:23 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:23 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:23 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:23 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:23 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:23 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:23 vault1 kernel: 
May 29 11:58:23 vault1 kernel: events/1      S ffff81007e837b18     0    15      1 (L-TLB)
May 29 11:58:23 vault1 kernel:  ffff810004303ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:23 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fa63080
May 29 11:58:23 vault1 kernel:  ffff81011fc78040 000000000000aa1b ffff81011fa63288 000000011fa63080
May 29 11:58:23 vault1 kernel: Call Trace:
May 29 11:58:23 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:23 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:23 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:23 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:23 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:23 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:23 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:23 vault1 kernel: 
May 29 11:58:23 vault1 kernel: events/2      S ffff81007ebd3638     0    16      1 (L-TLB)
May 29 11:58:23 vault1 kernel:  ffff81007fde9ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:23 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fa640c0
May 29 11:58:23 vault1 kernel:  ffff81011fccf080 000000000001434a ffff81011fa642c8 000000021fa640c0
May 29 11:58:23 vault1 kernel: Call Trace:
May 29 11:58:23 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:23 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:23 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:23 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:23 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:23 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:23 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:23 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:23 vault1 kernel: 
May 29 11:58:23 vault1 kernel: events/3      S ffff810037d4ba98     0    17      1 (L-TLB)
May 29 11:58:23 vault1 kernel:  ffff8100042bfea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:23 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fa65040
May 29 11:58:23 vault1 kernel:  ffff81011fd360c0 000000000000f2ba ffff81011fa65248 000000031fa65040
May 29 11:58:23 vault1 kernel: Call Trace:
May 29 11:58:23 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:23 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:23 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:23 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:23 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:23 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:23 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:23 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:23 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:23 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:23 vault1 kernel: 
May 29 11:58:23 vault1 kernel: khelper       S ffff81007f114118     0    18      1 (L-TLB)
May 29 11:58:23 vault1 kernel:  ffff810037d39ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:23 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fa66080
May 29 11:58:23 vault1 kernel:  ffff81011f2ce080 0000000000007797 ffff81011fa66288 000000001fa66080
May 29 11:58:24 vault1 kernel: Call Trace:
May 29 11:58:24 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:24 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:24 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:24 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:24 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:24 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:24 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:24 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:24 vault1 kernel: 
May 29 11:58:24 vault1 kernel: kthread       S ffff81007f1149d8     0    19      1 (L-TLB)
May 29 11:58:24 vault1 kernel:  ffff81011fa6fea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:24 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007fdf3080
May 29 11:58:24 vault1 kernel:  ffff81011fc78040 000000000000199a ffff81007fdf3288 000000017fdf3080
May 29 11:58:24 vault1 kernel: Call Trace:
May 29 11:58:24 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:24 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:24 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:24 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:24 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:24 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:24 vault1 kernel: 
May 29 11:58:24 vault1 kernel: kblockd/0     S ffff81011f2b8958     0    59     19 (L-TLB)
May 29 11:58:24 vault1 kernel:  ffff81011fe7fea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:24 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fe24040
May 29 11:58:24 vault1 kernel:  ffffffff8058a6e0 000000000000324c ffff81011fe24248 000000001fe24040
May 29 11:58:24 vault1 kernel: Call Trace:
May 29 11:58:24 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:24 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:24 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:24 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:24 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:24 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:24 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:24 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:24 vault1 kernel: 
May 29 11:58:24 vault1 kernel: kblockd/1     S ffff81011f2b8958     0    60     19 (L-TLB)
May 29 11:58:24 vault1 kernel:  ffff81011fb81ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:24 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fe23080
May 29 11:58:24 vault1 kernel:  ffff81011fc78040 000000000000334b ffff81011fe23288 000000011fe23080
May 29 11:58:24 vault1 kernel: Call Trace:
May 29 11:58:24 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:24 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:24 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:24 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:24 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:24 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:24 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:24 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:24 vault1 kernel: 
May 29 11:58:24 vault1 kernel: kblockd/2     S ffff81007e8de9d8     0    61     19 (L-TLB)
May 29 11:58:24 vault1 kernel:  ffff81011fb83ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:24 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011fe220c0
May 29 11:58:24 vault1 kernel:  ffff81007e4c5080 000000000001120f ffff81011fe222c8 000000021fe220c0
May 29 11:58:24 vault1 kernel: Call Trace:
May 29 11:58:24 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:24 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:24 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:24 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:24 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:24 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:24 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:24 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:24 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:24 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:24 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:24 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:24 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:24 vault1 kernel: 
May 29 11:58:24 vault1 kernel: kblockd/3     S ffff81007e8de9d8     0    62     19 (L-TLB)
May 29 11:58:25 vault1 kernel:  ffff81007fde5ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:25 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff810037e3e0c0
May 29 11:58:25 vault1 kernel:  ffff81011fd360c0 0000000000007674 ffff810037e3e2c8 0000000337e3e0c0
May 29 11:58:25 vault1 kernel: Call Trace:
May 29 11:58:25 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:25 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:25 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:25 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:25 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:25 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:25 vault1 kernel: 
May 29 11:58:25 vault1 kernel: kacpid        S ffffffff8058a280     0    63     19 (L-TLB)
May 29 11:58:25 vault1 kernel:  ffff8100042d1ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:25 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff810004281040
May 29 11:58:25 vault1 kernel:  ffff81011fccf080 0000000000000ff3 ffff810004281248 0000000204281040
May 29 11:58:25 vault1 kernel: Call Trace:
May 29 11:58:25 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:25 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:25 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:25 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:25 vault1 kernel:  [<ffffffff8031ff4a>] selinux_d_instantiate+0x0/0x14
May 29 11:58:25 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:25 vault1 kernel: 
May 29 11:58:25 vault1 kernel: cqueue/0      S ffffffff8058a280     0   217     19 (L-TLB)
May 29 11:58:25 vault1 kernel:  ffff81007fdd5ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:25 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff81007fdca080
May 29 11:58:25 vault1 kernel:  ffff81007fdf3080 0000000000001336 ffff81007fdca288 000000007fdca080
May 29 11:58:25 vault1 kernel: Call Trace:
May 29 11:58:25 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:25 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:25 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:25 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:25 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:25 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:25 vault1 kernel: 
May 29 11:58:25 vault1 kernel: cqueue/1      S ffffffff8058a280     0   218     19 (L-TLB)
May 29 11:58:25 vault1 kernel:  ffff81007fdd7ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:25 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff81007fdcb0c0
May 29 11:58:25 vault1 kernel:  ffff81011fc78040 00000000000014e8 ffff81007fdcb2c8 000000017fdcb0c0
May 29 11:58:25 vault1 kernel: Call Trace:
May 29 11:58:25 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:25 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:25 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:25 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:25 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:25 vault1 kernel: 
May 29 11:58:25 vault1 kernel: cqueue/2      S ffffffff8058a280     0   219     19 (L-TLB)
May 29 11:58:25 vault1 kernel:  ffff81007fdd9ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:25 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff81007fdcd040
May 29 11:58:25 vault1 kernel:  ffff81011fccf080 00000000000012c0 ffff81007fdcd248 000000027fdcd040
May 29 11:58:25 vault1 kernel: Call Trace:
May 29 11:58:25 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:25 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:25 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:25 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:25 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:26 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:26 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:26 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:26 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:26 vault1 kernel: 
May 29 11:58:26 vault1 kernel: cqueue/3      S ffffffff8058a280     0   220     19 (L-TLB)
May 29 11:58:26 vault1 kernel:  ffff81007fdddea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:26 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007fdce080
May 29 11:58:26 vault1 kernel:  ffff81011fd360c0 0000000000001847 ffff81007fdce288 000000037fdce080
May 29 11:58:26 vault1 kernel: Call Trace:
May 29 11:58:26 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:26 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:26 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:26 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:26 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:26 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:26 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:26 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:26 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:26 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:26 vault1 kernel: 
May 29 11:58:26 vault1 kernel: ksuspend_usbd S ffffffff8058a280     0   221     19 (L-TLB)
May 29 11:58:26 vault1 kernel:  ffff81007fddfea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:26 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff81007fdd00c0
May 29 11:58:26 vault1 kernel:  ffff81011fccf080 00000000000011b5 ffff81007fdd02c8 000000027fdd00c0
May 29 11:58:26 vault1 kernel: Call Trace:
May 29 11:58:26 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:26 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:26 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:26 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:26 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:26 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:26 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:26 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:26 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:26 vault1 kernel: 
May 29 11:58:26 vault1 kernel: khubd         S ffff81011f96fa98     0   224     19 (L-TLB)
May 29 11:58:26 vault1 kernel:  ffff810004361e20 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:26 vault1 kernel:  0000000000000000 0000000000000046 0000000000000009 ffff810004342040
May 29 11:58:26 vault1 kernel:  ffff81011fc72080 00000000007498c5 ffff810004342248 0000000004342040
May 29 11:58:26 vault1 kernel: Call Trace:
May 29 11:58:26 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:26 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:26 vault1 kernel:  [<ffffffff803d6dc8>] hub_thread+0xac0/0xb3c
May 29 11:58:26 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:26 vault1 kernel:  [<ffffffff803d6308>] hub_thread+0x0/0xb3c
May 29 11:58:26 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:26 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:26 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:26 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:26 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:26 vault1 kernel: 
May 29 11:58:26 vault1 kernel: kseriod       S ffff810037d4ba98     0   226     19 (L-TLB)
May 29 11:58:26 vault1 kernel:  ffff810004365ec0 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:26 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff810004344080
May 29 11:58:26 vault1 kernel:  ffffffff8058a6e0 000000000000270d ffff810004344288 0000000004344080
May 29 11:58:26 vault1 kernel: Call Trace:
May 29 11:58:26 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:26 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:26 vault1 kernel:  [<ffffffff803eaaea>] serio_thread+0x2a5/0x2f8
May 29 11:58:26 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:26 vault1 kernel:  [<ffffffff803ea845>] serio_thread+0x0/0x2f8
May 29 11:58:26 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:26 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:26 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:26 vault1 kernel:  [<ffffffff8031ff4a>] selinux_d_instantiate+0x0/0x14
May 29 11:58:26 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:26 vault1 kernel: 
May 29 11:58:26 vault1 kernel: kswapd0       S ffff81007e836538     0   283     19 (L-TLB)
May 29 11:58:26 vault1 kernel:  ffff810037e6fe20 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:26 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff810037fe8080
May 29 11:58:26 vault1 kernel:  ffff81006b4ed040 00000000000b1784 ffff810037fe8288 0000000037fe8080
May 29 11:58:26 vault1 kernel: Call Trace:
May 29 11:58:26 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:26 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:26 vault1 kernel:  [<ffffffff802560c6>] kswapd+0xea/0x469
May 29 11:58:26 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:26 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:26 vault1 kernel:  [<ffffffff80255fdc>] kswapd+0x0/0x469
May 29 11:58:26 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:26 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:26 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:26 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:26 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:26 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:26 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:26 vault1 kernel: 
May 29 11:58:27 vault1 kernel: kswapd1       S ffff81011febc958     0   284     19 (L-TLB)
May 29 11:58:27 vault1 kernel:  ffff81007fce9e20 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:27 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff810037fe70c0
May 29 11:58:27 vault1 kernel:  ffff81007af01080 00000000000debec ffff810037fe72c8 0000000237fe70c0
May 29 11:58:27 vault1 kernel: Call Trace:
May 29 11:58:27 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:27 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:27 vault1 kernel:  [<ffffffff802560c6>] kswapd+0xea/0x469
May 29 11:58:27 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:27 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:27 vault1 kernel:  [<ffffffff80255fdc>] kswapd+0x0/0x469
May 29 11:58:27 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:27 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:27 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:27 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:27 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:27 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:27 vault1 kernel: 
May 29 11:58:27 vault1 kernel: aio/0         S ffffffff8058a280     0   285     19 (L-TLB)
May 29 11:58:27 vault1 kernel:  ffff81007fcedea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:27 vault1 kernel:  0000000000000000 0000000000000000 0000000000000003 ffff810037fe6040
May 29 11:58:27 vault1 kernel:  ffff81007fdf3080 0000000000001520 ffff810037fe6248 0000000037fe6040
May 29 11:58:27 vault1 kernel: Call Trace:
May 29 11:58:27 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:27 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:27 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:27 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:27 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:27 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:27 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:27 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:27 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:27 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:27 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:27 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:27 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:27 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:27 vault1 kernel: 
May 29 11:58:27 vault1 kernel: aio/1         S ffffffff8058a280     0   286     19 (L-TLB)
May 29 11:58:27 vault1 kernel:  ffff810037f41ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:27 vault1 kernel:  0000000000000000 0000000000000000 0000000000000002 ffff810037fe4080
May 29 11:58:27 vault1 kernel:  ffff81011fc78040 0000000000001723 ffff810037fe4288 0000000137fe4080
May 29 11:58:27 vault1 kernel: Call Trace:
May 29 11:58:27 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:27 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:27 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:27 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:27 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:27 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:27 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:27 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:27 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:27 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:27 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:27 vault1 kernel: 
May 29 11:58:27 vault1 kernel: aio/2         S ffffffff8058a280     0   287     19 (L-TLB)
May 29 11:58:27 vault1 kernel:  ffff810037f43ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:27 vault1 kernel:  0000000000000000 0000000000000000 0000000000000002 ffff810037fe30c0
May 29 11:58:27 vault1 kernel:  ffff81011fccf080 0000000000001b18 ffff810037fe32c8 0000000237fe30c0
May 29 11:58:27 vault1 kernel: Call Trace:
May 29 11:58:27 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:27 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:27 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:27 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:27 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:27 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:27 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:27 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:27 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:27 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:27 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:27 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:27 vault1 kernel: 
May 29 11:58:27 vault1 kernel: aio/3         S ffffffff8058a280     0   288     19 (L-TLB)
May 29 11:58:27 vault1 kernel:  ffff810037f45ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:27 vault1 kernel:  0000000000000000 0000000000000000 0000000000000003 ffff810037fe2040
May 29 11:58:28 vault1 kernel:  ffff81011fd360c0 0000000000001406 ffff810037fe2248 0000000337fe2040
May 29 11:58:28 vault1 kernel: Call Trace:
May 29 11:58:28 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:28 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:28 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:28 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:28 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:28 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:28 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:28 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:28 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:28 vault1 kernel: 
May 29 11:58:28 vault1 kernel: kpsmoused     S ffffffff8058a280     0   446     19 (L-TLB)
May 29 11:58:28 vault1 kernel:  ffff810037d59ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:28 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff810037f81080
May 29 11:58:28 vault1 kernel:  ffffffff8058a6e0 0000000000000d43 ffff810037f81288 0000000037f81080
May 29 11:58:28 vault1 kernel: Call Trace:
May 29 11:58:28 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:28 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:28 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:28 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:28 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:28 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:28 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:28 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:28 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:28 vault1 kernel: 
May 29 11:58:28 vault1 kernel: scsi_eh_0     S ffff810037d4b638     0   499     19 (L-TLB)
May 29 11:58:28 vault1 kernel:  ffff81007f41fe70 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:28 vault1 kernel:  0000000000000000 0000000000000046 0000000000000004 ffff810037f69040
May 29 11:58:28 vault1 kernel:  ffff81011fccf080 0000000000000c44 ffff810037f69248 0000000280263894
May 29 11:58:28 vault1 kernel: Call Trace:
May 29 11:58:28 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:28 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:28 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:28 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:28 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:28 vault1 kernel: 
May 29 11:58:28 vault1 kernel: kjournald     S ffff81007f1149d8     0   535     19 (L-TLB)
May 29 11:58:28 vault1 kernel:  ffff81007f79bec0 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:28 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff810037d50080
May 29 11:58:28 vault1 kernel:  ffff81011fc78040 0000000000000b58 ffff810037d50288 000000018029fc0f
May 29 11:58:28 vault1 kernel: Call Trace:
May 29 11:58:28 vault1 kernel:  [<ffffffff880279be>] :jbd:kjournald+0x18e/0x21d
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff880279c3>] :jbd:kjournald+0x193/0x21d
May 29 11:58:28 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff88027830>] :jbd:kjournald+0x0/0x21d
May 29 11:58:28 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:28 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:28 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:28 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:28 vault1 kernel: 
May 29 11:58:28 vault1 kernel: kauditd       S ffff810037d4a4b8     0   557     19 (L-TLB)
May 29 11:58:28 vault1 kernel:  ffff81007f3a9ec0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:28 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81007f19b040
May 29 11:58:28 vault1 kernel:  ffff81007f32f0c0 000000000000750a ffff81007f19b248 000000007f19b040
May 29 11:58:28 vault1 kernel: Call Trace:
May 29 11:58:28 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:28 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff802b2b39>] kauditd_thread+0x111/0x148
May 29 11:58:28 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:28 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:28 vault1 kernel:  [<ffffffff802b2a28>] kauditd_thread+0x0/0x148
May 29 11:58:28 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:28 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:28 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:29 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:29 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:29 vault1 kernel: 
May 29 11:58:29 vault1 kernel: udevd         S ffff81007f343638     0   586      1 (NOTLB)
May 29 11:58:29 vault1 kernel:  ffff81007fe1ba18 0000000000000046 0000000000000000 0000000000000046
May 29 11:58:29 vault1 kernel:  ffffffff802ea6a4 ffff81007fe107f8 0000000000000005 ffff81007fe100c0
May 29 11:58:29 vault1 kernel:  ffff81011fc78040 00000000000282bc ffff81007fe102c8 0000000180262123
May 29 11:58:29 vault1 kernel: Call Trace:
May 29 11:58:29 vault1 kernel:  [<ffffffff802ea6a4>] inotify_poll+0x31/0x56
May 29 11:58:29 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:29 vault1 kernel:  [<ffffffff802ea6c2>] inotify_poll+0x4f/0x56
May 29 11:58:29 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:29 vault1 kernel:  [<ffffffff80217eea>] cache_grow+0x31f/0x378
May 29 11:58:29 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:29 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:29 vault1 last message repeated 3 times
May 29 11:58:29 vault1 kernel:  [<ffffffff8023e153>] lookup_mnt+0x19/0x4c
May 29 11:58:29 vault1 kernel:  [<ffffffff8023e17e>] lookup_mnt+0x44/0x4c
May 29 11:58:29 vault1 kernel:  [<ffffffff8020d542>] dput+0x3c/0x12b
May 29 11:58:29 vault1 kernel:  [<ffffffff80219f0b>] __follow_mount+0x26/0x7b
May 29 11:58:29 vault1 kernel:  [<ffffffff8020cff9>] do_lookup+0x63/0x1ae
May 29 11:58:29 vault1 kernel:  [<ffffffff802119b8>] do_wp_page+0x5af/0x60b
May 29 11:58:29 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:29 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:29 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:29 vault1 kernel:  [<ffffffff8023bee1>] remove_wait_queue+0x10/0x2c
May 29 11:58:29 vault1 kernel:  [<ffffffff8023bee1>] remove_wait_queue+0x10/0x2c
May 29 11:58:29 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:29 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:29 vault1 kernel:  [<ffffffff80216aff>] sys_select+0xc1/0x183
May 29 11:58:29 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:29 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:29 vault1 kernel: 
May 29 11:58:29 vault1 kernel: khpsbpkt      S ffff810037d4a4b8     0  1142     19 (L-TLB)
May 29 11:58:29 vault1 kernel:  ffff81007e7a5f00 0000000000000046 ffffffff80246747 0000000000000002
May 29 11:58:29 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007fd63040
May 29 11:58:29 vault1 kernel:  ffff81007e1680c0 0000000000001b49 ffff81007fd63248 000000001f3cbd30
May 29 11:58:29 vault1 kernel: Call Trace:
May 29 11:58:29 vault1 kernel:  [<ffffffff80246747>] skb_dequeue+0x13/0x50
May 29 11:58:29 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:29 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:29 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:29 vault1 kernel:  [<ffffffff88105239>] :ieee1394:hpsbpkt_thread+0x0/0x8d
May 29 11:58:29 vault1 kernel:  [<ffffffff881052a9>] :ieee1394:hpsbpkt_thread+0x70/0x8d
May 29 11:58:29 vault1 kernel:  [<ffffffff88105239>] :ieee1394:hpsbpkt_thread+0x0/0x8d
May 29 11:58:29 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:29 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:29 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:29 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:29 vault1 kernel: 
May 29 11:58:29 vault1 kernel: knodemgrd_0   S ffff81007e4304f8     0  1204     19 (L-TLB)
May 29 11:58:29 vault1 kernel:  ffff81007e1f5e70 0000000000000046 ffff81007e883080 ffffffff80261ece
May 29 11:58:29 vault1 kernel:  0000000000000246 ffff81007e7e4378 0000000000000009 ffff81007e883080
May 29 11:58:29 vault1 kernel:  ffff810037f5d040 00000000000e6dc7 ffff81007e883288 0000000180261ece
May 29 11:58:29 vault1 kernel: Call Trace:
May 29 11:58:29 vault1 kernel:  [<ffffffff80261ece>] __mutex_unlock_slowpath+0x128/0x133
May 29 11:58:29 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:29 vault1 kernel:  [<ffffffff88109d00>] :ieee1394:nodemgr_host_thread+0x87/0xa58
May 29 11:58:29 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:29 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:29 vault1 kernel:  [<ffffffff88109c79>] :ieee1394:nodemgr_host_thread+0x0/0xa58
May 29 11:58:29 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:29 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:29 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:29 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:29 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:29 vault1 kernel: 
May 29 11:58:29 vault1 kernel: ata/0         S ffff81007ebd24b8     0  1289     19 (L-TLB)
May 29 11:58:29 vault1 kernel:  ffff81011e58fea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:29 vault1 kernel:  0000000000000000 0000000000000000 0000000000000004 ffff81011fe3d080
May 29 11:58:29 vault1 kernel:  ffff81007e917040 0000000000002176 ffff81011fe3d288 000000001fe3d080
May 29 11:58:29 vault1 kernel: Call Trace:
May 29 11:58:29 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:29 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:29 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:29 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:29 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:29 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:29 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:29 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:29 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:29 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:29 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:29 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:29 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:29 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:29 vault1 kernel: 
May 29 11:58:30 vault1 kernel: ata/1         S ffff81007f343638     0  1290     19 (L-TLB)
May 29 11:58:30 vault1 kernel:  ffff81011e505ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:30 vault1 kernel:  0000000000000000 0000000000000000 0000000000000004 ffff81011fe34080
May 29 11:58:30 vault1 kernel:  ffff81007fe100c0 00000000000020c5 ffff81011fe34288 000000011fe34080
May 29 11:58:30 vault1 kernel: Call Trace:
May 29 11:58:30 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:30 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:30 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:30 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:30 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:30 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:30 vault1 kernel: 
May 29 11:58:30 vault1 kernel: ata/2         S ffff81011fe0b1d8     0  1291     19 (L-TLB)
May 29 11:58:30 vault1 kernel:  ffff81011e69fea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:30 vault1 kernel:  0000000000000000 0000000000000000 0000000000000004 ffff81011f35c080
May 29 11:58:30 vault1 kernel:  ffff81011edcd0c0 00000000000012dc ffff81011f35c288 000000021f35c080
May 29 11:58:30 vault1 kernel: Call Trace:
May 29 11:58:30 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:30 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:30 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:30 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:30 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:30 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:30 vault1 kernel: 
May 29 11:58:30 vault1 kernel: ata/3         S ffff81011edb5b58     0  1292     19 (L-TLB)
May 29 11:58:30 vault1 kernel:  ffff81011e6abea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:30 vault1 kernel:  0000000000000000 0000000000000000 0000000000000003 ffff81011edcd0c0
May 29 11:58:30 vault1 kernel:  ffff81011f0330c0 00000000000026f9 ffff81011edcd2c8 000000031edcd0c0
May 29 11:58:30 vault1 kernel: Call Trace:
May 29 11:58:30 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:30 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:30 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:30 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:30 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:30 vault1 kernel: 
May 29 11:58:30 vault1 kernel: ata_aux       S ffff81011fe0b1d8     0  1293     19 (L-TLB)
May 29 11:58:30 vault1 kernel:  ffff81011e6d3ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:30 vault1 kernel:  0000000000000000 0000000000000000 0000000000000004 ffff81011fe3e040
May 29 11:58:30 vault1 kernel:  ffff81011eec3080 0000000000001260 ffff81011fe3e248 000000021fe3e040
May 29 11:58:30 vault1 kernel: Call Trace:
May 29 11:58:30 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:30 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:30 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:30 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:30 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:30 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:30 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:30 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:30 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:30 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:30 vault1 kernel: 
May 29 11:58:30 vault1 kernel: scsi_eh_5     S ffff81007e8df6f8     0  1315     19 (L-TLB)
May 29 11:58:30 vault1 kernel:  ffff81011ee35e70 0000000000000046 ffff81011f2e3040 ffffffff802638fc
May 29 11:58:30 vault1 kernel:  ffff81007f3a4000 0000000000000000 0000000000000005 ffff81011f2e3040
May 29 11:58:30 vault1 kernel:  ffff81011fe2c0c0 00000000009d77e9 ffff81011f2e3248 0000000000000282
May 29 11:58:31 vault1 kernel: Call Trace:
May 29 11:58:31 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:31 vault1 kernel:  [<ffffffff88060287>] :scsi_mod:__scsi_iterate_devices+0x5c/0x75
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:31 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:31 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:31 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:31 vault1 kernel: 
May 29 11:58:31 vault1 kernel: scsi_eh_6     S ffff81007f343638     0  1316     19 (L-TLB)
May 29 11:58:31 vault1 kernel:  ffff81011fecbe70 0000000000000046 ffff81011ec6d080 ffffffff802638fc
May 29 11:58:31 vault1 kernel:  ffff81007e2ec000 0000000000000000 0000000000000008 ffff81011ec6d080
May 29 11:58:31 vault1 kernel:  ffff81011fd4a040 00000000009d51e7 ffff81011ec6d288 0000000200000282
May 29 11:58:31 vault1 kernel: Call Trace:
May 29 11:58:31 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:31 vault1 kernel:  [<ffffffff88060287>] :scsi_mod:__scsi_iterate_devices+0x5c/0x75
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:31 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:31 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:31 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:31 vault1 kernel: 
May 29 11:58:31 vault1 kernel: scsi_eh_7     S ffff81007fe19ad8     0  1741     19 (L-TLB)
May 29 11:58:31 vault1 kernel:  ffff81011e8dde70 0000000000000046 ffff81011ec7f0c0 ffffffff802638fc
May 29 11:58:31 vault1 kernel:  ffff81007fd5c000 0000000000000000 0000000000000008 ffff81011ec7f0c0
May 29 11:58:31 vault1 kernel:  ffff81011fd4a040 00000000009d3031 ffff81011ec7f2c8 0000000200000282
May 29 11:58:31 vault1 kernel: Call Trace:
May 29 11:58:31 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:31 vault1 kernel:  [<ffffffff88060287>] :scsi_mod:__scsi_iterate_devices+0x5c/0x75
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:31 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:31 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:31 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:31 vault1 kernel: 
May 29 11:58:31 vault1 kernel: scsi_eh_8     S ffff81011f1a5b18     0  1742     19 (L-TLB)
May 29 11:58:31 vault1 kernel:  ffff81011e4ffe70 0000000000000046 ffff81011ff03080 ffffffff802638fc
May 29 11:58:31 vault1 kernel:  ffff81007e4ac000 0000000000000000 000000000000000a ffff81011ff03080
May 29 11:58:31 vault1 kernel:  ffff81011fd4a040 00000000009d292b ffff81011ff03288 0000000200000282
May 29 11:58:31 vault1 kernel: Call Trace:
May 29 11:58:31 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:31 vault1 kernel:  [<ffffffff88060287>] :scsi_mod:__scsi_iterate_devices+0x5c/0x75
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:31 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:31 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:31 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:31 vault1 kernel: 
May 29 11:58:31 vault1 kernel: scsi_eh_9     S ffff81007f343638     0  2015     19 (L-TLB)
May 29 11:58:31 vault1 kernel:  ffff81011f3f9e70 0000000000000046 ffff81011f030080 ffffffff802638fc
May 29 11:58:31 vault1 kernel:  ffff81007e120000 0000000000000000 000000000000000a ffff81011f030080
May 29 11:58:31 vault1 kernel:  ffff81011fd4a040 00000000009d3f30 ffff81011f030288 0000000200000282
May 29 11:58:31 vault1 kernel: Call Trace:
May 29 11:58:31 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:31 vault1 kernel:  [<ffffffff88060287>] :scsi_mod:__scsi_iterate_devices+0x5c/0x75
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:31 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:31 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:31 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:31 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:31 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:32 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:32 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:32 vault1 kernel: 
May 29 11:58:32 vault1 kernel: scsi_eh_10    S ffff810037d4ad78     0  2016     19 (L-TLB)
May 29 11:58:32 vault1 kernel:  ffff81011e7fde70 0000000000000046 ffff81011ffe00c0 ffffffff802638fc
May 29 11:58:32 vault1 kernel:  ffff81007e288000 0000000000000000 000000000000000a ffff81011ffe00c0
May 29 11:58:32 vault1 kernel:  ffff81007f22b080 00000000009c774d ffff81011ffe02c8 0000000000000282
May 29 11:58:32 vault1 kernel: Call Trace:
May 29 11:58:32 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:32 vault1 kernel:  [<ffffffff88060287>] :scsi_mod:__scsi_iterate_devices+0x5c/0x75
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:32 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:32 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:32 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:32 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:32 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:32 vault1 kernel: 
May 29 11:58:32 vault1 kernel: kmpathd/0     S ffff81011f96e918     0  2243     19 (L-TLB)
May 29 11:58:32 vault1 kernel:  ffff81007dc5dea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:32 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff81007e125040
May 29 11:58:32 vault1 kernel:  ffff81007fdf3080 0000000000000d28 ffff81007e125248 000000007e125040
May 29 11:58:32 vault1 kernel: Call Trace:
May 29 11:58:32 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:32 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:32 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:32 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:32 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:32 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:32 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:32 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:32 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:32 vault1 kernel: 
May 29 11:58:32 vault1 kernel: kmpathd/1     S ffff81007e836998     0  2244     19 (L-TLB)
May 29 11:58:32 vault1 kernel:  ffff81007dc5fea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:32 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007e962040
May 29 11:58:32 vault1 kernel:  ffff81011fc78040 0000000000001a16 ffff81007e962248 000000017e962040
May 29 11:58:32 vault1 kernel: Call Trace:
May 29 11:58:32 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:32 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:32 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:32 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:32 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:32 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:32 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:32 vault1 kernel: 
May 29 11:58:32 vault1 kernel: kmpathd/2     S ffff81007f343638     0  2245     19 (L-TLB)
May 29 11:58:32 vault1 kernel:  ffff81007dea1ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:32 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007e5ae080
May 29 11:58:32 vault1 kernel:  ffff81007fe100c0 0000000000002189 ffff81007e5ae288 000000027e5ae080
May 29 11:58:32 vault1 kernel: Call Trace:
May 29 11:58:32 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:32 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:32 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:32 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:32 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:32 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:32 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:32 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:32 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:32 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:32 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:32 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:32 vault1 kernel: 
May 29 11:58:32 vault1 kernel: kmpathd/3     S ffff81011f96e918     0  2246     19 (L-TLB)
May 29 11:58:32 vault1 kernel:  ffff81007dea3ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:32 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007f22b080
May 29 11:58:32 vault1 kernel:  ffff81011fd360c0 00000000000032a3 ffff81007f22b288 000000037f22b080
May 29 11:58:32 vault1 kernel: Call Trace:
May 29 11:58:32 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:32 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:33 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:33 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:33 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:33 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:33 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:33 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:33 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:33 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:33 vault1 kernel: 
May 29 11:58:33 vault1 kernel: kmirrord      S ffff81007e837b18     0  2261     19 (L-TLB)
May 29 11:58:33 vault1 kernel:  ffff81007dfbfea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:33 vault1 kernel:  0000000000000000 0000000000000000 0000000000000001 ffff81007e9c7040
May 29 11:58:33 vault1 kernel:  ffff81007e9970c0 0000000000000c37 ffff81007e9c7248 000000007e9c7040
May 29 11:58:33 vault1 kernel: Call Trace:
May 29 11:58:33 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:33 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:33 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:33 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:33 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:33 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:33 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:33 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:33 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:33 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:33 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:33 vault1 kernel: 
May 29 11:58:33 vault1 kernel: jfsIO         S ffff81007e8de9d8     0  2299     19 (L-TLB)
May 29 11:58:33 vault1 kernel:  ffff81007c859f00 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:33 vault1 kernel:  000000017c858000 0000000000000002 000000000000000a ffff81007e54c040
May 29 11:58:33 vault1 kernel:  ffff81011fccf080 00000000000074c3 ffff81007e54c248 0000000200000000
May 29 11:58:33 vault1 kernel: Call Trace:
May 29 11:58:33 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:33 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:33 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff88242385>] :jfs:jfsIOWait+0x0/0xa2
May 29 11:58:33 vault1 kernel:  [<ffffffff8824240a>] :jfs:jfsIOWait+0x85/0xa2
May 29 11:58:33 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:33 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:33 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:33 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:33 vault1 kernel: 
May 29 11:58:33 vault1 kernel: jfsCommit     S ffff81007e8de9d8     0  2300     19 (L-TLB)
May 29 11:58:33 vault1 kernel:  ffff81007c85beb0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:33 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007e1680c0
May 29 11:58:33 vault1 kernel:  ffff81007e4620c0 000000000000e4f1 ffff81007e1682c8 000000027e1680c0
May 29 11:58:33 vault1 kernel: Call Trace:
May 29 11:58:33 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:33 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:33 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:33 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:33 vault1 kernel:  [<ffffffff88245114>] :jfs:jfs_lazycommit+0x1d9/0x212
May 29 11:58:33 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:33 vault1 kernel:  [<ffffffff88244f3b>] :jfs:jfs_lazycommit+0x0/0x212
May 29 11:58:33 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:33 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:33 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:33 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:33 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:33 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:33 vault1 kernel: 
May 29 11:58:33 vault1 kernel: jfsCommit     S ffff81007e8de9d8     0  2301     19 (L-TLB)
May 29 11:58:33 vault1 kernel:  ffff81007c85deb0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:34 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007e4620c0
May 29 11:58:34 vault1 kernel:  ffff81007ef410c0 000000000000097b ffff81007e4622c8 000000027e4620c0
May 29 11:58:34 vault1 kernel: Call Trace:
May 29 11:58:34 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:34 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff88245114>] :jfs:jfs_lazycommit+0x1d9/0x212
May 29 11:58:34 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:34 vault1 kernel:  [<ffffffff88244f3b>] :jfs:jfs_lazycommit+0x0/0x212
May 29 11:58:34 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:34 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:34 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:34 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:34 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:34 vault1 kernel: 
May 29 11:58:34 vault1 kernel: jfsCommit     S ffff81007e8de9d8     0  2302     19 (L-TLB)
May 29 11:58:34 vault1 kernel:  ffff81007c85feb0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:34 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007e5e50c0
May 29 11:58:34 vault1 kernel:  ffff81007e0c80c0 0000000000000719 ffff81007e5e52c8 000000027e5e50c0
May 29 11:58:34 vault1 kernel: Call Trace:
May 29 11:58:34 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:34 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff88245114>] :jfs:jfs_lazycommit+0x1d9/0x212
May 29 11:58:34 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:34 vault1 kernel:  [<ffffffff88244f3b>] :jfs:jfs_lazycommit+0x0/0x212
May 29 11:58:34 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:34 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:34 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:34 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:34 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:34 vault1 kernel: 
May 29 11:58:34 vault1 kernel: jfsCommit     S ffff81007e8de9d8     0  2303     19 (L-TLB)
May 29 11:58:34 vault1 kernel:  ffff81007c861eb0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:34 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81007ef410c0
May 29 11:58:34 vault1 kernel:  ffff81007e5e50c0 000000000000071c ffff81007ef412c8 000000027ef410c0
May 29 11:58:34 vault1 kernel: Call Trace:
May 29 11:58:34 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:34 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff88245114>] :jfs:jfs_lazycommit+0x1d9/0x212
May 29 11:58:34 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:34 vault1 kernel:  [<ffffffff88244f3b>] :jfs:jfs_lazycommit+0x0/0x212
May 29 11:58:34 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:34 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:34 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:34 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:34 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:34 vault1 kernel: 
May 29 11:58:34 vault1 kernel: jfsSync       S ffff81007f343638     0  2304     19 (L-TLB)
May 29 11:58:34 vault1 kernel:  ffff81007c863ee0 0000000000000046 0000000000000000 ffff81000438c040
May 29 11:58:34 vault1 kernel:  000000000000018e 0000000000000001 0000000000000007 ffff81000438c040
May 29 11:58:34 vault1 kernel:  ffff81011fccf080 000000000000d778 ffff81000438c248 0000000200000246
May 29 11:58:34 vault1 kernel: Call Trace:
May 29 11:58:34 vault1 kernel:  [<ffffffff882448ef>] :jfs:jfs_sync+0x181/0x1ac
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff8824476e>] :jfs:jfs_sync+0x0/0x1ac
May 29 11:58:34 vault1 kernel:  [<ffffffff882448f4>] :jfs:jfs_sync+0x186/0x1ac
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff8824476e>] :jfs:jfs_sync+0x0/0x1ac
May 29 11:58:34 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:34 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:34 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:34 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:34 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:34 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:34 vault1 kernel: 
May 29 11:58:34 vault1 kernel: kjournald     S ffff81007f1149d8     0  2306     19 (L-TLB)
May 29 11:58:34 vault1 kernel:  ffff81007d54fec0 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:34 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff810037f5d040
May 29 11:58:34 vault1 kernel:  ffff81011fc78040 0000000000004c8c ffff810037f5d248 000000018029fc0f
May 29 11:58:34 vault1 kernel: Call Trace:
May 29 11:58:34 vault1 kernel:  [<ffffffff880279be>] :jbd:kjournald+0x18e/0x21d
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff880279c3>] :jbd:kjournald+0x193/0x21d
May 29 11:58:34 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:34 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:34 vault1 kernel:  [<ffffffff88027830>] :jbd:kjournald+0x0/0x21d
May 29 11:58:34 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:35 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:35 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:35 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:35 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:35 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:35 vault1 kernel: 
May 29 11:58:35 vault1 kernel: kjournald     S ffff81011f96fa98     0  2308     19 (L-TLB)
May 29 11:58:35 vault1 kernel:  ffff81007d541ec0 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:35 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff810037f60040
May 29 11:58:35 vault1 kernel:  ffff81011fc78040 000000000000287b ffff810037f60248 000000018029fc0f
May 29 11:58:35 vault1 kernel: Call Trace:
May 29 11:58:35 vault1 kernel:  [<ffffffff880279be>] :jbd:kjournald+0x18e/0x21d
May 29 11:58:35 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:35 vault1 kernel:  [<ffffffff880279c3>] :jbd:kjournald+0x193/0x21d
May 29 11:58:35 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:35 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:35 vault1 kernel:  [<ffffffff88027830>] :jbd:kjournald+0x0/0x21d
May 29 11:58:35 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:35 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:35 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:35 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:35 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:35 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:35 vault1 kernel: 
May 29 11:58:35 vault1 kernel: kjournald     D ffff81007e837b18     0  2310     19 (L-TLB)
May 29 11:58:35 vault1 kernel:  ffff81007d0efd40 0000000000000046 0000000000000000 ffff81007e9970c0
May 29 11:58:35 vault1 kernel:  ffff81011fc78040 00000000000055bc ffff81007e9972c8 000000017e9970c0
May 29 11:58:35 vault1 kernel:  ffff81011fc78040 0000000000004b2c ffffffffffffffff ffff810082c32700
May 29 11:58:35 vault1 kernel: Call Trace:
May 29 11:58:35 vault1 kernel:  [<ffffffff80258fc6>] generic_unplug_device+0x18/0x25
May 29 11:58:35 vault1 kernel:  [<ffffffff80258fc6>] generic_unplug_device+0x18/0x25
May 29 11:58:35 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:35 vault1 kernel:  [<ffffffff8021576b>] sync_buffer+0x0/0x43
May 29 11:58:35 vault1 kernel:  [<ffffffff8021576b>] sync_buffer+0x0/0x43
May 29 11:58:35 vault1 kernel:  [<ffffffff802157a9>] sync_buffer+0x3e/0x43
May 29 11:58:35 vault1 kernel:  [<ffffffff802618fb>] __wait_on_bit+0x40/0x6e
May 29 11:58:35 vault1 kernel:  [<ffffffff8021576b>] sync_buffer+0x0/0x43
May 29 11:58:35 vault1 kernel:  [<ffffffff8021576b>] sync_buffer+0x0/0x43
May 29 11:58:35 vault1 kernel:  [<ffffffff80261995>] out_of_line_wait_on_bit+0x6c/0x78
May 29 11:58:35 vault1 kernel:  [<ffffffff8029a120>] wake_bit_function+0x0/0x23
May 29 11:58:35 vault1 kernel:  [<ffffffff8023aa60>] sync_dirty_buffer+0xae/0xe2
May 29 11:58:35 vault1 kernel:  [<ffffffff88023eff>] :jbd:journal_commit_transaction+0xbc7/0x109c
May 29 11:58:35 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:35 vault1 kernel:  [<ffffffff880278ea>] :jbd:kjournald+0xba/0x21d
May 29 11:58:35 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:35 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:35 vault1 kernel:  [<ffffffff88027830>] :jbd:kjournald+0x0/0x21d
May 29 11:58:35 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:35 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:35 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:35 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:35 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:35 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:35 vault1 kernel: 
May 29 11:58:35 vault1 kernel: dhclient      S ffff81007f1156f8     0  2686      1 (NOTLB)
May 29 11:58:35 vault1 kernel:  ffff81007747da18 0000000000000046 0000000000000000 ffff81007e9fb0c0
May 29 11:58:35 vault1 kernel:  ffff81007e9fb0c0 ffffffff802638fc 0000000000000007 ffff81007e9fb0c0
May 29 11:58:35 vault1 kernel:  ffff81011fc78040 0000000000002776 ffff81007e9fb2c8 0000000137e28000
May 29 11:58:35 vault1 kernel: Call Trace:
May 29 11:58:35 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:35 vault1 kernel:  [<ffffffff80261790>] schedule_timeout+0x8a/0xad
May 29 11:58:35 vault1 kernel:  [<ffffffff802913d9>] process_timeout+0x0/0x5
May 29 11:58:35 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:35 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:35 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:35 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:35 vault1 kernel:  [<ffffffff802078c3>] kmem_cache_free+0x257/0x267
May 29 11:58:35 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:35 vault1 kernel:  [<ffffffff804435a0>] udp_recvmsg+0x1ee/0x270
May 29 11:58:35 vault1 kernel:  [<ffffffff80232600>] sock_common_recvmsg+0x30/0x45
May 29 11:58:35 vault1 kernel:  [<ffffffff80230bc6>] sock_recvmsg+0xf8/0x117
May 29 11:58:35 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:35 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:35 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:35 vault1 kernel:  [<ffffffff8040bc77>] move_addr_to_user+0x5d/0x78
May 29 11:58:35 vault1 kernel:  [<ffffffff8022c605>] sys_recvfrom+0x104/0x130
May 29 11:58:35 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:35 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:35 vault1 kernel:  [<ffffffff80216b98>] sys_select+0x15a/0x183
May 29 11:58:35 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:35 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:35 vault1 kernel: 
May 29 11:58:35 vault1 kernel: syslogd       D ffff81007e837b18     0  2963      1 (NOTLB)
May 29 11:58:35 vault1 kernel:  ffff81007869fd88 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:35 vault1 kernel:  0000000000000000 0000000000000046 0000000000000009 ffff81007e1b3080
May 29 11:58:36 vault1 kernel:  ffff81007e9970c0 0000000000014ad9 ffff81007e1b3288 000000018029fc0f
May 29 11:58:36 vault1 kernel: Call Trace:
May 29 11:58:36 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:36 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:36 vault1 kernel:  [<ffffffff88026c13>] :jbd:log_wait_commit+0xa4/0xf7
May 29 11:58:36 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:36 vault1 kernel:  [<ffffffff88021730>] :jbd:journal_stop+0x1e5/0x21a
May 29 11:58:36 vault1 kernel:  [<ffffffff802304c1>] __writeback_single_inode+0x1fa/0x338
May 29 11:58:36 vault1 kernel:  [<ffffffff802e2073>] sync_inode+0x19/0x39
May 29 11:58:36 vault1 kernel:  [<ffffffff802e2073>] sync_inode+0x19/0x39
May 29 11:58:36 vault1 kernel:  [<ffffffff802e207e>] sync_inode+0x24/0x39
May 29 11:58:36 vault1 kernel:  [<ffffffff88037332>] :ext3:ext3_sync_file+0xb2/0xc4
May 29 11:58:36 vault1 kernel:  [<ffffffff8024e527>] do_fsync+0x52/0xa4
May 29 11:58:36 vault1 kernel:  [<ffffffff802e4478>] __do_fsync+0x23/0x36
May 29 11:58:36 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:36 vault1 kernel: 
May 29 11:58:36 vault1 kernel: klogd         S ffff81007ebd3638     0  2966      1 (NOTLB)
May 29 11:58:36 vault1 kernel:  ffff810077c2fbe8 0000000000000046 0000000000000000 ffff81007e0fe080
May 29 11:58:36 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff81007e0fe080
May 29 11:58:36 vault1 kernel:  ffff81011fccf080 000000000000343a ffff81007e0fe288 0000000200000002
May 29 11:58:36 vault1 kernel: Call Trace:
May 29 11:58:36 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:36 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:36 vault1 kernel:  [<ffffffff80460f4b>] unix_wait_for_peer+0x86/0xb0
May 29 11:58:36 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:36 vault1 kernel:  [<ffffffff804614fb>] unix_dgram_sendmsg+0x3d3/0x4cd
May 29 11:58:36 vault1 kernel:  [<ffffffff8024671c>] sock_aio_write+0x110/0x128
May 29 11:58:36 vault1 kernel:  [<ffffffff80260e98>] __sched_text_start+0x928/0x960
May 29 11:58:36 vault1 kernel:  [<ffffffff80218507>] do_sync_write+0xc9/0x10c
May 29 11:58:36 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:36 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:36 vault1 kernel:  [<ffffffff80216cda>] vfs_write+0xe1/0x177
May 29 11:58:36 vault1 kernel:  [<ffffffff8020b86d>] fget_light+0x19/0x7b
May 29 11:58:36 vault1 kernel:  [<ffffffff802176bf>] sys_write+0x45/0x6e
May 29 11:58:36 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:36 vault1 kernel: 
May 29 11:58:36 vault1 kernel: irqbalance    S ffff81007fe18098     0  2977      1 (NOTLB)
May 29 11:58:36 vault1 kernel:  ffff8100774e9eb8 0000000000000046 0000000000000000 ffffffff802638fc
May 29 11:58:36 vault1 kernel:  ffff810003c2cbf8 ffff810003c2cbf0 0000000000000007 ffff810037e90040
May 29 11:58:36 vault1 kernel:  ffffffff8058a6e0 00000000001be12b ffff810037e90248 0000000000000292
May 29 11:58:36 vault1 kernel: Call Trace:
May 29 11:58:36 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:36 vault1 kernel:  [<ffffffff8023c6d0>] hrtimer_start+0xfd/0x110
May 29 11:58:36 vault1 kernel:  [<ffffffff802626ef>] do_nanosleep+0x46/0x77
May 29 11:58:36 vault1 kernel:  [<ffffffff80258b18>] hrtimer_nanosleep+0x58/0x11e
May 29 11:58:36 vault1 kernel:  [<ffffffff8029c17e>] hrtimer_wakeup+0x0/0x22
May 29 11:58:36 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:36 vault1 kernel:  [<ffffffff80252bb1>] sys_nanosleep+0x4c/0x62
May 29 11:58:36 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:36 vault1 kernel: 
May 29 11:58:36 vault1 kernel: portmap       S ffff81007fe18db8     0  2997      1 (NOTLB)
May 29 11:58:36 vault1 kernel:  ffff8100774d5b28 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:36 vault1 kernel:  0000000180248a3b 0000000000000002 000000000000000a ffff810037f6e080
May 29 11:58:36 vault1 kernel:  ffff81011fd34040 0000000000b33289 ffff810037f6e288 0000000300000000
May 29 11:58:36 vault1 kernel: Call Trace:
May 29 11:58:36 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:36 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:36 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:36 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:36 vault1 kernel:  [<ffffffff80213f07>] tcp_poll+0x1f/0x133
May 29 11:58:36 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:36 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:36 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:36 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:36 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:36 vault1 kernel:  [<ffffffff8029ff51>] debug_check_no_locks_freed+0x11d/0x129
May 29 11:58:36 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:36 vault1 kernel:  [<ffffffff8020b848>] free_hot_cold_page+0x184/0x190
May 29 11:58:36 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:36 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:36 vault1 kernel:  [<ffffffff8040b777>] sys_sendmsg+0x217/0x28a
May 29 11:58:36 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:36 vault1 kernel:  [<ffffffff8023089b>] __up_write+0x27/0xf2
May 29 11:58:36 vault1 kernel:  [<ffffffff8023089b>] __up_write+0x27/0xf2
May 29 11:58:36 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:36 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:36 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:36 vault1 kernel: 
May 29 11:58:36 vault1 kernel: rpc.statd     S ffff81007e1bb258     0  3017      1 (NOTLB)
May 29 11:58:37 vault1 kernel:  ffff810077419a18 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:37 vault1 kernel:  0000000180248a3b 0000000000000002 0000000000000001 ffff810037f5e080
May 29 11:58:37 vault1 kernel:  ffff81007e917040 0000000000002c39 ffff810037f5e288 0000000000000000
May 29 11:58:37 vault1 kernel: Call Trace:
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:37 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:37 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:37 vault1 kernel:  [<ffffffff80213f07>] tcp_poll+0x1f/0x133
May 29 11:58:37 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:37 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:37 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:37 vault1 last message repeated 2 times
May 29 11:58:37 vault1 kernel:  [<ffffffff80263584>] _read_unlock+0x17/0x20
May 29 11:58:37 vault1 kernel:  [<ffffffff8046155d>] unix_dgram_sendmsg+0x435/0x4cd
May 29 11:58:37 vault1 kernel:  [<ffffffff8020d542>] dput+0x3c/0x12b
May 29 11:58:37 vault1 kernel:  [<ffffffff802530fc>] sock_sendmsg+0xea/0x107
May 29 11:58:37 vault1 kernel:  [<ffffffff8020ed97>] link_path_walk+0xce/0xe0
May 29 11:58:37 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:37 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:37 vault1 kernel:  [<ffffffff8022d806>] mntput_no_expire+0x1c/0x96
May 29 11:58:37 vault1 kernel:  [<ffffffff8040ba92>] sys_sendto+0x128/0x151
May 29 11:58:37 vault1 kernel:  [<ffffffff80216aff>] sys_select+0xc1/0x183
May 29 11:58:37 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:37 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:37 vault1 kernel: 
May 29 11:58:37 vault1 kernel: dbus-daemon   S ffff81007f115b58     0  3035      1 (NOTLB)
May 29 11:58:37 vault1 kernel:  ffff81007773bb28 0000000000000046 0000000000000000 ffff81007f1d5080
May 29 11:58:37 vault1 kernel:  0000000000000000 ffffffff802a0de5 000000000000000a ffff81007f1d5080
May 29 11:58:37 vault1 kernel:  ffff81011fc78040 0000000000009ca4 ffff81007f1d5288 0000000100000002
May 29 11:58:37 vault1 kernel: Call Trace:
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:37 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:37 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:37 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:37 vault1 last message repeated 2 times
May 29 11:58:37 vault1 kernel:  [<ffffffff8024671c>] sock_aio_write+0x110/0x128
May 29 11:58:37 vault1 kernel:  [<ffffffff8040ae7a>] sock_aio_read+0x10c/0x124
May 29 11:58:37 vault1 kernel:  [<ffffffff8020cf53>] do_sync_read+0xc9/0x10c
May 29 11:58:37 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:37 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:37 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:37 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:37 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:37 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:37 vault1 kernel: 
May 29 11:58:37 vault1 kernel: hidd          S ffff810037d4ad78     0  3067      1 (NOTLB)
May 29 11:58:37 vault1 kernel:  ffff81007734bad8 0000000000000046 0000000000000000 ffff81007f0fb0c0
May 29 11:58:37 vault1 kernel:  0000000000000000 ffffffff802a0de5 0000000000000001 ffff81007f0fb0c0
May 29 11:58:37 vault1 kernel:  ffff81011fccf080 0000000000008764 ffff81007f0fb2c8 0000000200000002
May 29 11:58:37 vault1 kernel: Call Trace:
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:37 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:37 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:37 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:37 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:37 vault1 kernel:  [<ffffffff80263584>] _read_unlock+0x17/0x20
May 29 11:58:37 vault1 kernel:  [<ffffffff8046155d>] unix_dgram_sendmsg+0x435/0x4cd
May 29 11:58:37 vault1 kernel:  [<ffffffff8020d542>] dput+0x3c/0x12b
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff802078e8>] find_get_page+0x15/0x4b
May 29 11:58:37 vault1 kernel:  [<ffffffff802638bb>] _read_unlock_irq+0x24/0x27
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff80208c1f>] __handle_mm_fault+0x3cf/0xccf
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:37 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff8021e12c>] sigprocmask+0x28/0xc1
May 29 11:58:37 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:37 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:37 vault1 kernel:  [<ffffffff802d861f>] sys_ppoll+0xf1/0x1ff
May 29 11:58:37 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:37 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:37 vault1 kernel: 
May 29 11:58:37 vault1 kernel: acpid         S ffff81007ebd2d78     0  3079      1 (NOTLB)
May 29 11:58:37 vault1 kernel:  ffff8100775ffb28 0000000000000046 0000000000000627 ffff81007e740080
May 29 11:58:37 vault1 kernel:  0000000000000000 ffffffff802a0de5 0000000000000007 ffff81007e740080
May 29 11:58:37 vault1 kernel:  ffff81007e932080 0000000000017592 ffff81007e740288 0000000000000002
May 29 11:58:37 vault1 kernel: Call Trace:
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:37 vault1 kernel:  [<ffffffff88021755>] :jbd:journal_stop+0x20a/0x21a
May 29 11:58:37 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:37 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:37 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:37 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:37 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:37 vault1 kernel:  [<ffffffff8020e533>] current_fs_time+0x3b/0x40
May 29 11:58:37 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:37 vault1 kernel:  [<ffffffff80216881>] __generic_file_aio_write_nolock+0x378/0x3eb
May 29 11:58:38 vault1 kernel:  [<ffffffff80262123>] __mutex_lock_slowpath+0x245/0x25b
May 29 11:58:38 vault1 kernel:  [<ffffffff80261ece>] __mutex_unlock_slowpath+0x128/0x133
May 29 11:58:38 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:38 vault1 kernel:  [<ffffffff802224af>] generic_file_aio_write+0x6c/0xc1
May 29 11:58:38 vault1 kernel:  [<ffffffff88037192>] :ext3:ext3_file_write+0x16/0x94
May 29 11:58:38 vault1 kernel:  [<ffffffff80218507>] do_sync_write+0xc9/0x10c
May 29 11:58:38 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:38 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:38 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:38 vault1 kernel:  [<ffffffff8040bfa2>] sys_accept+0x19e/0x1fb
May 29 11:58:38 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:38 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:38 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:38 vault1 kernel: 
May 29 11:58:38 vault1 kernel: sshd          S ffff81007f342918     0  3092      1 (NOTLB)
May 29 11:58:38 vault1 kernel:  ffff810076dbda18 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:38 vault1 kernel:  000000018023bee1 0000000000000002 000000000000000a ffff81007eaf3080
May 29 11:58:38 vault1 kernel:  ffff81011fccf080 0000000000007534 ffff81007eaf3288 0000000200000000
May 29 11:58:38 vault1 kernel: Call Trace:
May 29 11:58:38 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:38 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:38 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:38 vault1 kernel:  [<ffffffff80213f07>] tcp_poll+0x1f/0x133
May 29 11:58:38 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:38 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:38 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:38 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:38 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:38 vault1 kernel:  [<ffffffff802133c4>] sock_def_readable+0x18/0x6c
May 29 11:58:38 vault1 kernel:  [<ffffffff802133c4>] sock_def_readable+0x18/0x6c
May 29 11:58:38 vault1 kernel:  [<ffffffff8020a6c3>] get_page_from_freelist+0x2ab/0x534
May 29 11:58:38 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:38 vault1 kernel:  [<ffffffff8020a6c3>] get_page_from_freelist+0x2ab/0x534
May 29 11:58:38 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:38 vault1 kernel:  [<ffffffff802c070d>] zone_statistics+0x3f/0x60
May 29 11:58:38 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:38 vault1 kernel:  [<ffffffff802118a0>] do_wp_page+0x497/0x60b
May 29 11:58:38 vault1 kernel:  [<ffffffff80211a03>] do_wp_page+0x5fa/0x60b
May 29 11:58:38 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:38 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:38 vault1 kernel:  [<ffffffff8020c6a9>] _atomic_dec_and_lock+0x39/0x58
May 29 11:58:38 vault1 kernel:  [<ffffffff80212fc9>] poison_obj+0x26/0x2f
May 29 11:58:38 vault1 kernel:  [<ffffffff802078c3>] kmem_cache_free+0x257/0x267
May 29 11:58:38 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:38 vault1 kernel:  [<ffffffff80216aff>] sys_select+0xc1/0x183
May 29 11:58:38 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:38 vault1 kernel:  [<ffffffff80239ba9>] generic_drop_inode+0x0/0x15c
May 29 11:58:38 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:38 vault1 kernel: 
May 29 11:58:38 vault1 kernel: rpc.idmapd    S ffff81007e8de118     0  3193      1 (NOTLB)
May 29 11:58:38 vault1 kernel:  ffff810075fabe78 0000000000000046 0000000000000000 ffff81007ee64040
May 29 11:58:38 vault1 kernel:  ffff81007ee64040 ffffffff802638fc 000000000000000a ffff81007ee64040
May 29 11:58:38 vault1 kernel:  ffffffff8058a6e0 00000000000027d9 ffff81007ee64248 0000000080733000
May 29 11:58:38 vault1 kernel: Call Trace:
May 29 11:58:38 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:38 vault1 kernel:  [<ffffffff80261790>] schedule_timeout+0x8a/0xad
May 29 11:58:38 vault1 kernel:  [<ffffffff802913d9>] process_timeout+0x0/0x5
May 29 11:58:38 vault1 kernel:  [<ffffffff802ead19>] sys_epoll_wait+0x193/0x426
May 29 11:58:38 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:38 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:38 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:38 vault1 kernel: 
May 29 11:58:38 vault1 kernel: crond         S ffff81007f114118     0  3203      1 (NOTLB)
May 29 11:58:38 vault1 kernel:  ffff810075c15eb8 0000000000000046 0000000000000000 ffffffff802638fc
May 29 11:58:38 vault1 kernel:  ffff810003c379f8 ffff810003c379f0 000000000000000a ffff81007e1b80c0
May 29 11:58:38 vault1 kernel:  ffff81011fc78040 0000000000027cfa ffff81007e1b82c8 0000000100000292
May 29 11:58:38 vault1 kernel: Call Trace:
May 29 11:58:38 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:38 vault1 kernel:  [<ffffffff8023c6d0>] hrtimer_start+0xfd/0x110
May 29 11:58:38 vault1 kernel:  [<ffffffff802626ef>] do_nanosleep+0x46/0x77
May 29 11:58:38 vault1 kernel:  [<ffffffff80258b18>] hrtimer_nanosleep+0x58/0x11e
May 29 11:58:38 vault1 kernel:  [<ffffffff8029c17e>] hrtimer_wakeup+0x0/0x22
May 29 11:58:38 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:38 vault1 kernel:  [<ffffffff80252bb1>] sys_nanosleep+0x4c/0x62
May 29 11:58:38 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:38 vault1 kernel: 
May 29 11:58:38 vault1 kernel: atd           S ffff81007fe184f8     0  3213      1 (NOTLB)
May 29 11:58:39 vault1 kernel:  ffff810075c55eb8 0000000000000046 0000000000000000 ffffffff802638fc
May 29 11:58:39 vault1 kernel:  ffff810003c379f8 ffff810003c379f0 0000000000000007 ffff810037ec00c0
May 29 11:58:39 vault1 kernel:  ffff81011fc78040 0000000000014409 ffff810037ec02c8 0000000100000292
May 29 11:58:39 vault1 kernel: Call Trace:
May 29 11:58:39 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:39 vault1 kernel:  [<ffffffff8023c6d0>] hrtimer_start+0xfd/0x110
May 29 11:58:39 vault1 kernel:  [<ffffffff802626ef>] do_nanosleep+0x46/0x77
May 29 11:58:39 vault1 kernel:  [<ffffffff80258b18>] hrtimer_nanosleep+0x58/0x11e
May 29 11:58:39 vault1 kernel:  [<ffffffff8029c17e>] hrtimer_wakeup+0x0/0x22
May 29 11:58:39 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:39 vault1 kernel:  [<ffffffff80252bb1>] sys_nanosleep+0x4c/0x62
May 29 11:58:39 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:39 vault1 kernel: 
May 29 11:58:39 vault1 kernel: hald          S ffff81007f3424b8     0  3223      1 (NOTLB)
May 29 11:58:39 vault1 kernel:  ffff810075dabb28 0000000000000046 0000000000000000 ffff81007f4a2080
May 29 11:58:39 vault1 kernel:  ffff81007f4a2080 ffffffff802638fc 000000000000000a ffff81007f4a2080
May 29 11:58:39 vault1 kernel:  ffffffff8058a6e0 000000000005abda ffff81007f4a2288 0000000080733000
May 29 11:58:39 vault1 kernel: Call Trace:
May 29 11:58:39 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:39 vault1 kernel:  [<ffffffff80261790>] schedule_timeout+0x8a/0xad
May 29 11:58:39 vault1 kernel:  [<ffffffff802913d9>] process_timeout+0x0/0x5
May 29 11:58:39 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:39 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:39 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:39 vault1 last message repeated 9 times
May 29 11:58:39 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:39 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:39 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:39 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:39 vault1 kernel: 
May 29 11:58:39 vault1 kernel: hald-runner   S ffff81011f3c9678     0  3224   3223 (NOTLB)
May 29 11:58:39 vault1 kernel:  ffff81011ecafb28 0000000000000046 0000000000000000 ffff81011f39d080
May 29 11:58:39 vault1 kernel:  0000000000000000 ffffffff802a0de5 0000000000000008 ffff81011f39d080
May 29 11:58:39 vault1 kernel:  ffff81011fc78040 00000000000006d2 ffff81011f39d288 0000000100000002
May 29 11:58:39 vault1 kernel: Call Trace:
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:39 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:39 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:39 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:39 vault1 kernel:  [<ffffffff8024671c>] sock_aio_write+0x110/0x128
May 29 11:58:39 vault1 kernel:  [<ffffffff8026212e>] __mutex_lock_slowpath+0x250/0x25b
May 29 11:58:39 vault1 kernel:  [<ffffffff8024660c>] sock_aio_write+0x0/0x128
May 29 11:58:39 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:39 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:39 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:39 vault1 kernel:  [<ffffffff802d3dfa>] do_readv_writev+0x199/0x1ae
May 29 11:58:39 vault1 kernel:  [<ffffffff80229266>] do_wait+0x9a7/0xa75
May 29 11:58:39 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:39 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:39 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:39 vault1 kernel: 
May 29 11:58:39 vault1 kernel: hald-addon-ac S ffff81007f114e38     0  3230   3224 (NOTLB)
May 29 11:58:39 vault1 kernel:  ffff810075593be8 0000000000000046 0000000000000627 ffff81007e932080
May 29 11:58:39 vault1 kernel:  0000000000000001 ffffffff802a0de5 0000000000000003 ffff81007e932080
May 29 11:58:39 vault1 kernel:  ffff81007f4a2080 0000000000002a2c ffff81007e932288 0000000000000002
May 29 11:58:39 vault1 kernel: Call Trace:
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff8023ad89>] prepare_to_wait+0x1b/0x5c
May 29 11:58:39 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:39 vault1 kernel:  [<ffffffff80249a11>] unix_stream_recvmsg+0x233/0x548
May 29 11:58:39 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff8040ae7a>] sock_aio_read+0x10c/0x124
May 29 11:58:39 vault1 kernel:  [<ffffffff8020cf53>] do_sync_read+0xc9/0x10c
May 29 11:58:39 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:39 vault1 kernel:  [<ffffffff8020e38c>] do_mmap_pgoff+0x65d/0x7c9
May 29 11:58:39 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:39 vault1 kernel:  [<ffffffff8020b5b0>] vfs_read+0xde/0x173
May 29 11:58:39 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:39 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:39 vault1 kernel: 
May 29 11:58:39 vault1 kernel: hald-addon-cp S ffff81007e8360d8     0  3231   3224 (NOTLB)
May 29 11:58:39 vault1 kernel:  ffff810075563b28 0000000000000046 0000000000000627 ffff81007e9fc080
May 29 11:58:39 vault1 kernel:  0000000000000000 ffffffff802a0de5 0000000000000003 ffff81007e9fc080
May 29 11:58:39 vault1 kernel:  ffff81007f4a2080 000000000001e385 ffff81007e9fc288 0000000000000002
May 29 11:58:39 vault1 kernel: Call Trace:
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:39 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:39 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:39 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:39 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:39 vault1 kernel:  [<ffffffff80249bf3>] unix_stream_recvmsg+0x415/0x548
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff802078e8>] find_get_page+0x15/0x4b
May 29 11:58:39 vault1 kernel:  [<ffffffff802638bb>] _read_unlock_irq+0x24/0x27
May 29 11:58:39 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:39 vault1 kernel:  [<ffffffff80208c1f>] __handle_mm_fault+0x3cf/0xccf
May 29 11:58:40 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:40 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:40 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:40 vault1 kernel:  [<ffffffff80208d64>] __handle_mm_fault+0x514/0xccf
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:40 vault1 kernel:  [<ffffffff80265bc5>] do_page_fault+0x490/0x7cf
May 29 11:58:40 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:40 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:40 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:40 vault1 kernel: 
May 29 11:58:40 vault1 kernel: hald-addon-ke S ffff81007fe19678     0  3235   3224 (NOTLB)
May 29 11:58:40 vault1 kernel:  ffff8100756adea8 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:40 vault1 kernel:  0000000000000000 0000000000000046 0000000000000004 ffff81007fe9d040
May 29 11:58:40 vault1 kernel:  ffffffff8058a6e0 00000000000b8af2 ffff81007fe9d248 000000007fe9d040
May 29 11:58:40 vault1 kernel: Call Trace:
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff803f1497>] evdev_read+0x112/0x235
May 29 11:58:40 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:40 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:40 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:40 vault1 kernel: 
May 29 11:58:40 vault1 kernel: hald-addon-ke S ffff81011ed8f638     0  3245   3224 (NOTLB)
May 29 11:58:40 vault1 kernel:  ffff810075c2bea8 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:40 vault1 kernel:  0000000000000000 0000000000000046 000000000000000a ffff81007eb3f040
May 29 11:58:40 vault1 kernel:  ffff81011fccf080 000000000000243f ffff81007eb3f248 000000027eb3f040
May 29 11:58:40 vault1 kernel: Call Trace:
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff803f1497>] evdev_read+0x112/0x235
May 29 11:58:40 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:40 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:40 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:40 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:40 vault1 kernel: 
May 29 11:58:40 vault1 kernel: hald-addon-ke S ffff81007e1ba0d8     0  3252   3224 (NOTLB)
May 29 11:58:40 vault1 kernel:  ffff810075f9dea8 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:40 vault1 kernel:  0000000000000000 0000000000000046 0000000000000001 ffff81007f2710c0
May 29 11:58:40 vault1 kernel:  ffff81011fc78040 00000000000be1fa ffff81007f2712c8 000000017f2710c0
May 29 11:58:40 vault1 kernel: Call Trace:
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff803f1497>] evdev_read+0x112/0x235
May 29 11:58:40 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:40 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:40 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:40 vault1 kernel: 
May 29 11:58:40 vault1 kernel: hald-addon-ke S ffff81007fe18958     0  3255   3224 (NOTLB)
May 29 11:58:40 vault1 kernel:  ffff810076715ea8 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:40 vault1 kernel:  0000000000000000 0000000000000046 0000000000000001 ffff810037f5f0c0
May 29 11:58:40 vault1 kernel:  ffff81011fc78040 00000000000bd9f3 ffff810037f5f2c8 0000000137f5f0c0
May 29 11:58:40 vault1 kernel: Call Trace:
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff803f1497>] evdev_read+0x112/0x235
May 29 11:58:40 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:40 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:40 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:40 vault1 kernel: 
May 29 11:58:40 vault1 kernel: hald-addon-st S ffff81007e8de9d8     0  3263   3224 (NOTLB)
May 29 11:58:40 vault1 kernel:  ffff810075027eb8 0000000000000046 0000000000000000 ffffffff802638fc
May 29 11:58:40 vault1 kernel:  ffff810003c379f8 ffff810003c379f0 0000000000000009 ffff81007e864040
May 29 11:58:40 vault1 kernel:  ffff81011fc78040 0000000000002aae ffff81007e864248 0000000100000292
May 29 11:58:40 vault1 kernel: Call Trace:
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff8023c6d0>] hrtimer_start+0xfd/0x110
May 29 11:58:40 vault1 kernel:  [<ffffffff802626ef>] do_nanosleep+0x46/0x77
May 29 11:58:40 vault1 kernel:  [<ffffffff80258b18>] hrtimer_nanosleep+0x58/0x11e
May 29 11:58:40 vault1 kernel:  [<ffffffff8029c17e>] hrtimer_wakeup+0x0/0x22
May 29 11:58:40 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:40 vault1 kernel:  [<ffffffff80252bb1>] sys_nanosleep+0x4c/0x62
May 29 11:58:40 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:40 vault1 kernel: 
May 29 11:58:40 vault1 kernel: smartd        S ffff81011febcdb8     0  3307      1 (NOTLB)
May 29 11:58:40 vault1 kernel:  ffff81011ed2deb8 0000000000000046 0000000000000000 ffffffff802638fc
May 29 11:58:40 vault1 kernel:  ffff810003c379f8 ffff810003c379f0 0000000000000007 ffff81011ee23040
May 29 11:58:40 vault1 kernel:  ffff81011fc78040 0000000000002d86 ffff81011ee23248 0000000100000292
May 29 11:58:40 vault1 kernel: Call Trace:
May 29 11:58:40 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:40 vault1 kernel:  [<ffffffff8023c6d0>] hrtimer_start+0xfd/0x110
May 29 11:58:40 vault1 kernel:  [<ffffffff802626ef>] do_nanosleep+0x46/0x77
May 29 11:58:40 vault1 kernel:  [<ffffffff80258b18>] hrtimer_nanosleep+0x58/0x11e
May 29 11:58:40 vault1 kernel:  [<ffffffff8029c17e>] hrtimer_wakeup+0x0/0x22
May 29 11:58:40 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:41 vault1 kernel:  [<ffffffff80252bb1>] sys_nanosleep+0x4c/0x62
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:41 vault1 kernel: 
May 29 11:58:41 vault1 kernel: login         S ffff81007f115298     0  3310      1 (NOTLB)
May 29 11:58:41 vault1 kernel:  ffff810075cd3ec8 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:41 vault1 kernel:  0000000000000000 0000000200000002 0000000000000009 ffff81007fd33040
May 29 11:58:41 vault1 kernel:  ffff81011fd360c0 000000000007dc88 ffff81007fd33248 0000000300000000
May 29 11:58:41 vault1 kernel: Call Trace:
May 29 11:58:41 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:41 vault1 kernel:  [<ffffffff8022920b>] do_wait+0x94c/0xa75
May 29 11:58:41 vault1 kernel:  [<ffffffff8022922e>] do_wait+0x96f/0xa75
May 29 11:58:41 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:41 vault1 kernel: 
May 29 11:58:41 vault1 kernel: login         S ffff81007e8de578     0  3311      1 (NOTLB)
May 29 11:58:41 vault1 kernel:  ffff810076361ec8 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:41 vault1 kernel:  0000000000000000 0000000200000002 0000000000000007 ffff81007fd3e0c0
May 29 11:58:41 vault1 kernel:  ffff81011fc78040 0000000000087012 ffff81007fd3e2c8 0000000100000000
May 29 11:58:41 vault1 kernel: Call Trace:
May 29 11:58:41 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:41 vault1 kernel:  [<ffffffff8022920b>] do_wait+0x94c/0xa75
May 29 11:58:41 vault1 kernel:  [<ffffffff8022922e>] do_wait+0x96f/0xa75
May 29 11:58:41 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:41 vault1 kernel: 
May 29 11:58:41 vault1 kernel: mingetty      S ffff81011f3c8958     0  3312      1 (NOTLB)
May 29 11:58:41 vault1 kernel:  ffff810075fd5dc8 0000000000000046 0000000000026a68 ffff81011fd1da10
May 29 11:58:41 vault1 kernel:  0000000000000296 ffffffff80263178 0000000000000004 ffff81007fc0e040
May 29 11:58:41 vault1 kernel:  ffff81007ea550c0 00000000000441eb ffff81007fc0e248 0000000375fd4000
May 29 11:58:41 vault1 kernel: Call Trace:
May 29 11:58:41 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:41 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:41 vault1 kernel:  [<ffffffff802638fe>] _spin_unlock_irqrestore+0x40/0x44
May 29 11:58:41 vault1 kernel:  [<ffffffff8022a7cf>] read_chan+0x384/0x609
May 29 11:58:41 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:41 vault1 kernel:  [<ffffffff80232d53>] tty_read+0x72/0xc7
May 29 11:58:41 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:41 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:41 vault1 kernel: 
May 29 11:58:41 vault1 kernel: mingetty      S ffff81011f2b9ad8     0  3313      1 (NOTLB)
May 29 11:58:41 vault1 kernel:  ffff810075f07dc8 0000000000000046 0000000000000000 ffff81007f4a37b0
May 29 11:58:41 vault1 kernel:  0000000000000627 ffff81007f4a3040 0000000000000004 ffff81007f4a3040
May 29 11:58:41 vault1 kernel:  ffff81007e6b4080 000000000002f310 ffff81007f4a3248 0000000200000046
May 29 11:58:41 vault1 kernel: Call Trace:
May 29 11:58:41 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:41 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:41 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:41 vault1 kernel:  [<ffffffff8022a7cf>] read_chan+0x384/0x609
May 29 11:58:41 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:41 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:41 vault1 kernel:  [<ffffffff80232d53>] tty_read+0x72/0xc7
May 29 11:58:41 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:41 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:41 vault1 kernel: 
May 29 11:58:41 vault1 kernel: mingetty      S ffff81011f2b8098     0  3314      1 (NOTLB)
May 29 11:58:41 vault1 kernel:  ffff810075d57dc8 0000000000000046 0000000000000000 ffff81007ea55830
May 29 11:58:41 vault1 kernel:  0000000000000627 ffff81007ea550c0 0000000000000004 ffff81007ea550c0
May 29 11:58:41 vault1 kernel:  ffff81011fd360c0 0000000000002997 ffff81007ea552c8 0000000300000046
May 29 11:58:41 vault1 kernel: Call Trace:
May 29 11:58:41 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:41 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:41 vault1 kernel:  [<ffffffff8022a7cf>] read_chan+0x384/0x609
May 29 11:58:41 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:41 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:41 vault1 kernel:  [<ffffffff80232d53>] tty_read+0x72/0xc7
May 29 11:58:41 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:41 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:41 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:41 vault1 kernel: 
May 29 11:58:41 vault1 kernel: mingetty      S ffff81011f3c8db8     0  3315      1 (NOTLB)
May 29 11:58:41 vault1 kernel:  ffff810075c95dc8 0000000000000046 0000000000000000 ffff81007e4167f0
May 29 11:58:41 vault1 kernel:  0000000000000627 ffff81007e416080 0000000000000004 ffff81007e416080
May 29 11:58:41 vault1 kernel:  ffff81007e6b4080 0000000000002b22 ffff81007e416288 0000000200000046
May 29 11:58:41 vault1 kernel: Call Trace:
May 29 11:58:41 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:42 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:42 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:42 vault1 kernel:  [<ffffffff8022a7cf>] read_chan+0x384/0x609
May 29 11:58:42 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:42 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff80232d53>] tty_read+0x72/0xc7
May 29 11:58:42 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:42 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:42 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:42 vault1 kernel: 
May 29 11:58:42 vault1 kernel: mingetty      S ffff81011edb4578     0  3316      1 (NOTLB)
May 29 11:58:42 vault1 kernel:  ffff81007e0bddc8 0000000000000046 0000000000000000 ffff81007e6b47f0
May 29 11:58:42 vault1 kernel:  0000000000000627 ffff81007e6b4080 0000000000000003 ffff81007e6b4080
May 29 11:58:42 vault1 kernel:  ffff81011fccf080 000000000001b72f ffff81007e6b4288 0000000200000046
May 29 11:58:42 vault1 kernel: Call Trace:
May 29 11:58:42 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:42 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:42 vault1 kernel:  [<ffffffff8022a7cf>] read_chan+0x384/0x609
May 29 11:58:42 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:42 vault1 kernel:  [<ffffffff80232d53>] tty_read+0x72/0xc7
May 29 11:58:42 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:42 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:42 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:42 vault1 kernel: 
May 29 11:58:42 vault1 kernel: bash          S ffff81007f114578     0  3377   3310 (NOTLB)
May 29 11:58:42 vault1 kernel:  ffff81011f889dc8 0000000000000046 0000000000000000 ffff81011f3fc830
May 29 11:58:42 vault1 kernel:  0000000000000627 ffff81011f3fc0c0 0000000000000009 ffff81011f3fc0c0
May 29 11:58:42 vault1 kernel:  ffff81011fc78040 000000000000af71 ffff81011f3fc2c8 0000000100000046
May 29 11:58:42 vault1 kernel: Call Trace:
May 29 11:58:42 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:42 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:42 vault1 kernel:  [<ffffffff8022a7cf>] read_chan+0x384/0x609
May 29 11:58:42 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:42 vault1 kernel:  [<ffffffff80232d53>] tty_read+0x72/0xc7
May 29 11:58:42 vault1 kernel:  [<ffffffff8020b59d>] vfs_read+0xcb/0x173
May 29 11:58:42 vault1 kernel:  [<ffffffff80211fc7>] sys_read+0x45/0x6e
May 29 11:58:42 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:42 vault1 kernel: 
May 29 11:58:42 vault1 kernel: scsi_eh_11    S ffff81011f2b84f8     0  3447     19 (L-TLB)
May 29 11:58:42 vault1 kernel:  ffff81011e1bbe70 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:42 vault1 kernel:  0000000000000000 0000000000000046 0000000000000008 ffff81011eeb50c0
May 29 11:58:42 vault1 kernel:  ffff81011fd360c0 0000000000000758 ffff81011eeb52c8 0000000380263894
May 29 11:58:42 vault1 kernel: Call Trace:
May 29 11:58:42 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:42 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:42 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:42 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:42 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:42 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:42 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:42 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:42 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:42 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:42 vault1 kernel: 
May 29 11:58:42 vault1 kernel: qla2xxx_11_dp S ffff81011f96fa98     0  3455     19 (L-TLB)
May 29 11:58:42 vault1 kernel:  ffff81011e775ee0 0000000000000046 0000000000000000 0000000000200200
May 29 11:58:42 vault1 kernel:  0000000100032ce3 ffffffff802913d9 000000000000000a ffff81011e452080
May 29 11:58:42 vault1 kernel:  ffff81011fc78040 0000000000000923 ffff81011e452288 0000000100000102
May 29 11:58:42 vault1 kernel: Call Trace:
May 29 11:58:42 vault1 kernel:  [<ffffffff802913d9>] process_timeout+0x0/0x5
May 29 11:58:42 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:42 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:42 vault1 kernel:  [<ffffffff880ba348>] :qla2xxx:qla2x00_do_dpc+0x39/0x439
May 29 11:58:42 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:42 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:42 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:42 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:42 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:42 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:42 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:42 vault1 kernel: 
May 29 11:58:42 vault1 kernel: scsi_wq_11    S ffff81011ed8e058     0  3456     19 (L-TLB)
May 29 11:58:42 vault1 kernel:  ffff81011e777ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:42 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011e5d5080
May 29 11:58:42 vault1 kernel:  ffff81011fd360c0 00000000000014e9 ffff81011e5d5288 000000031e5d5080
May 29 11:58:42 vault1 kernel: Call Trace:
May 29 11:58:42 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:42 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:42 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:42 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:42 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:42 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:42 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:42 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:42 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:43 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:43 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:43 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:43 vault1 kernel: 
May 29 11:58:43 vault1 kernel: fc_wq_11      S ffff81011ed8e058     0  3457     19 (L-TLB)
May 29 11:58:43 vault1 kernel:  ffff81011e779ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:43 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011fff7040
May 29 11:58:43 vault1 kernel:  ffff81011fd360c0 0000000000000e63 ffff81011fff7248 000000031fff7040
May 29 11:58:43 vault1 kernel: Call Trace:
May 29 11:58:43 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:43 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:43 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:43 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:43 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:43 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:43 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:43 vault1 kernel: 
May 29 11:58:43 vault1 kernel: fc_dl_11      S ffff81011f2b84f8     0  3458     19 (L-TLB)
May 29 11:58:43 vault1 kernel:  ffff81011e77bea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:43 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011e96a080
May 29 11:58:43 vault1 kernel:  ffff810037d460c0 00000000000022c2 ffff81011e96a288 000000011e96a080
May 29 11:58:43 vault1 kernel: Call Trace:
May 29 11:58:43 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:43 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:43 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:43 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:43 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:43 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:43 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:43 vault1 kernel: 
May 29 11:58:43 vault1 kernel: scsi_eh_12    S ffff81011ed8e058     0  3465     19 (L-TLB)
May 29 11:58:43 vault1 kernel:  ffff81011ee2be70 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:43 vault1 kernel:  0000000000000000 0000000000000046 0000000000000009 ffff81011e50e040
May 29 11:58:43 vault1 kernel:  ffff81011fd360c0 0000000000000913 ffff81011e50e248 0000000380263894
May 29 11:58:43 vault1 kernel: Call Trace:
May 29 11:58:43 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:43 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:43 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:43 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:43 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:43 vault1 kernel: 
May 29 11:58:43 vault1 kernel: qla2xxx_12_dp S ffff81007f3424b8     0  3466     19 (L-TLB)
May 29 11:58:43 vault1 kernel:  ffff81011f20bee0 0000000000000046 0000000000000000 0000000000200200
May 29 11:58:43 vault1 kernel:  00000001000341a9 ffffffff802913d9 000000000000000a ffff81011e80d0c0
May 29 11:58:43 vault1 kernel:  ffffffff8058a6e0 000000000000080f ffff81011e80d2c8 0000000000000102
May 29 11:58:43 vault1 kernel: Call Trace:
May 29 11:58:43 vault1 kernel:  [<ffffffff802913d9>] process_timeout+0x0/0x5
May 29 11:58:43 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:43 vault1 kernel:  [<ffffffff880ba348>] :qla2xxx:qla2x00_do_dpc+0x39/0x439
May 29 11:58:43 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:43 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:43 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:43 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:43 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:43 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:43 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:44 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:44 vault1 kernel: 
May 29 11:58:44 vault1 kernel: scsi_wq_12    S ffff81011ed8e058     0  3467     19 (L-TLB)
May 29 11:58:44 vault1 kernel:  ffff81011f257ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:44 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011f03b040
May 29 11:58:44 vault1 kernel:  ffff81011fd360c0 0000000000001d8d ffff81011f03b248 000000031f03b040
May 29 11:58:44 vault1 kernel: Call Trace:
May 29 11:58:44 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:44 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:44 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:44 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:44 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:44 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:44 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:44 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:44 vault1 kernel: 
May 29 11:58:44 vault1 kernel: fc_wq_12      S ffff81011ed8e058     0  3468     19 (L-TLB)
May 29 11:58:44 vault1 kernel:  ffff81011e77dea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:44 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011eeb4080
May 29 11:58:44 vault1 kernel:  ffff81011fd360c0 000000000000127d ffff81011eeb4288 000000031eeb4080
May 29 11:58:44 vault1 kernel: Call Trace:
May 29 11:58:44 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:44 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:44 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:44 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:44 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:44 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:44 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:44 vault1 kernel: 
May 29 11:58:44 vault1 kernel: fc_dl_12      S ffff81011ed8e058     0  3469     19 (L-TLB)
May 29 11:58:44 vault1 kernel:  ffff81011e7bdea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:44 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011e949040
May 29 11:58:44 vault1 kernel:  ffff81011fd360c0 0000000000001255 ffff81011e949248 000000031e949040
May 29 11:58:44 vault1 kernel: Call Trace:
May 29 11:58:44 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:44 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:44 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:44 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:44 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:44 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:44 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:44 vault1 kernel: 
May 29 11:58:44 vault1 kernel: scsi_eh_13    S ffff81011ed8e058     0  3476     19 (L-TLB)
May 29 11:58:44 vault1 kernel:  ffff81011e71be70 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:44 vault1 kernel:  0000000000000000 0000000000000046 0000000000000009 ffff81011e869080
May 29 11:58:44 vault1 kernel:  ffff81011fd360c0 00000000000008a3 ffff81011e869288 0000000380263894
May 29 11:58:44 vault1 kernel: Call Trace:
May 29 11:58:44 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:44 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:44 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:44 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:44 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:44 vault1 kernel: 
May 29 11:58:44 vault1 kernel: qla2xxx_13_dp S ffff81007e8de9d8     0  3477     19 (L-TLB)
May 29 11:58:44 vault1 kernel:  ffff81011e90fee0 0000000000000046 0000000000000000 0000000000000282
May 29 11:58:44 vault1 kernel:  ffff81011e90fe40 ffff81011e90fe40 0000000000000009 ffff81011fbcc0c0
May 29 11:58:44 vault1 kernel:  ffff81011fc78040 0000000000000b5a ffff81011fbcc2c8 0000000100000000
May 29 11:58:44 vault1 kernel: Call Trace:
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:44 vault1 kernel:  [<ffffffff880ba348>] :qla2xxx:qla2x00_do_dpc+0x39/0x439
May 29 11:58:44 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:44 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:44 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:44 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:44 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:44 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:44 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:44 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:45 vault1 kernel: 
May 29 11:58:45 vault1 kernel: scsi_wq_13    S ffff81011f2b84f8     0  3478     19 (L-TLB)
May 29 11:58:45 vault1 kernel:  ffff81011e77fea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:45 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011ed7f040
May 29 11:58:45 vault1 kernel:  ffff81011fc78040 000000000032574d ffff81011ed7f248 000000011ed7f040
May 29 11:58:45 vault1 kernel: Call Trace:
May 29 11:58:45 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:45 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:45 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:45 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:45 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:45 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:45 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:45 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:45 vault1 kernel: 
May 29 11:58:45 vault1 kernel: fc_wq_13      S ffff81011ed8e058     0  3479     19 (L-TLB)
May 29 11:58:45 vault1 kernel:  ffff81011e079ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:45 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011ec4b040
May 29 11:58:45 vault1 kernel:  ffff81011fd360c0 0000000000000d40 ffff81011ec4b248 000000031ec4b040
May 29 11:58:45 vault1 kernel: Call Trace:
May 29 11:58:45 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:45 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:45 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:45 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:45 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:45 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:45 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:45 vault1 kernel: 
May 29 11:58:45 vault1 kernel: fc_dl_13      S ffff81011ed8e058     0  3480     19 (L-TLB)
May 29 11:58:45 vault1 kernel:  ffff81011feafea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:45 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011fcb7080
May 29 11:58:45 vault1 kernel:  ffff81011fd360c0 0000000000000c43 ffff81011fcb7288 000000031fcb7080
May 29 11:58:45 vault1 kernel: Call Trace:
May 29 11:58:45 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:45 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:45 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:45 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:45 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:45 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:45 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:45 vault1 kernel: 
May 29 11:58:45 vault1 kernel: scsi_eh_14    S ffff81011ed8e058     0  3493     19 (L-TLB)
May 29 11:58:45 vault1 kernel:  ffff81011e873e70 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:45 vault1 kernel:  0000000000000000 0000000000000046 0000000000000009 ffff81011e6030c0
May 29 11:58:45 vault1 kernel:  ffff81011fd360c0 00000000000007e0 ffff81011e6032c8 0000000380263894
May 29 11:58:45 vault1 kernel: Call Trace:
May 29 11:58:45 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff88063f8e>] :scsi_mod:scsi_error_handler+0x6a/0x4dd
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:45 vault1 kernel:  [<ffffffff88063f24>] :scsi_mod:scsi_error_handler+0x0/0x4dd
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:45 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:45 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:45 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:45 vault1 kernel: 
May 29 11:58:45 vault1 kernel: qla2xxx_14_dp S ffff81007f343638     0  3501     19 (L-TLB)
May 29 11:58:45 vault1 kernel:  ffff81011e111ee0 0000000000000046 ffff810074d4c7d0 0000000000000282
May 29 11:58:45 vault1 kernel:  ffff81011e111e40 ffff81011e111e40 000000000000000a ffff81011e122080
May 29 11:58:45 vault1 kernel:  ffff81007fe100c0 0000000000000afb ffff81011e122288 0000000000000000
May 29 11:58:45 vault1 kernel: Call Trace:
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:45 vault1 kernel:  [<ffffffff880ba348>] :qla2xxx:qla2x00_do_dpc+0x39/0x439
May 29 11:58:45 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:45 vault1 kernel:  [<ffffffff880ba30f>] :qla2xxx:qla2x00_do_dpc+0x0/0x439
May 29 11:58:45 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:45 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:45 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:45 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:45 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:46 vault1 kernel: 
May 29 11:58:46 vault1 kernel: scsi_wq_14    S ffff81007ebd3638     0  3502     19 (L-TLB)
May 29 11:58:46 vault1 kernel:  ffff81011e049ea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:46 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011e0570c0
May 29 11:58:46 vault1 kernel:  ffff81007e0fe080 000000000036e7a4 ffff81011e0572c8 000000001e0570c0
May 29 11:58:46 vault1 kernel: Call Trace:
May 29 11:58:46 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:46 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:46 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:46 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:46 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:46 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:46 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:46 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:46 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:46 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:46 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:46 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:46 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:46 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:46 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:46 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:46 vault1 kernel: 
May 29 11:58:46 vault1 kernel: fc_wq_14      S ffff81011ed8e058     0  3503     19 (L-TLB)
May 29 11:58:46 vault1 kernel:  ffff81011f0b3ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:46 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011e117040
May 29 11:58:46 vault1 kernel:  ffff81011fd360c0 0000000000000dc9 ffff81011e117248 000000031e117040
May 29 11:58:46 vault1 kernel: Call Trace:
May 29 11:58:46 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:46 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:46 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:46 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:46 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:46 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:46 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:46 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:46 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:46 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:46 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:46 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:46 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:46 vault1 kernel: 
May 29 11:58:46 vault1 kernel: fc_dl_14      S ffff81011ed8e058     0  3504     19 (L-TLB)
May 29 11:58:46 vault1 kernel:  ffff81011e189ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:46 vault1 kernel:  0000000000000000 0000000000000000 0000000000000009 ffff81011f9ea080
May 29 11:58:46 vault1 kernel:  ffff81011fd360c0 0000000000000dda ffff81011f9ea288 000000031f9ea080
May 29 11:58:46 vault1 kernel: Call Trace:
May 29 11:58:46 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:46 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:46 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:46 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:46 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:46 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:46 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:46 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:46 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:46 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:46 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:46 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:46 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:46 vault1 kernel: 
May 29 11:58:46 vault1 kernel: rpc.rquotad   S ffff81011febdad8     0  3740      1 (NOTLB)
May 29 11:58:46 vault1 kernel:  ffff81011dd5fb28 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:46 vault1 kernel:  0000000180248a3b 0000000000000002 0000000000000001 ffff81011ddca080
May 29 11:58:46 vault1 kernel:  ffffffff8058a6e0 000000000002fcdc ffff81011ddca288 0000000000000000
May 29 11:58:46 vault1 kernel: Call Trace:
May 29 11:58:46 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:46 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:46 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:46 vault1 kernel:  [<ffffffff80213f07>] tcp_poll+0x1f/0x133
May 29 11:58:46 vault1 kernel:  [<ffffffff8022ff1d>] do_sys_poll+0x276/0x35f
May 29 11:58:46 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:46 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:46 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:46 vault1 kernel:  [<ffffffff8020a6c3>] get_page_from_freelist+0x2ab/0x534
May 29 11:58:46 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:46 vault1 kernel:  [<ffffffff8020a6c3>] get_page_from_freelist+0x2ab/0x534
May 29 11:58:46 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:46 vault1 kernel:  [<ffffffff802078e8>] find_get_page+0x15/0x4b
May 29 11:58:46 vault1 kernel:  [<ffffffff802638bb>] _read_unlock_irq+0x24/0x27
May 29 11:58:46 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:46 vault1 kernel:  [<ffffffff80208c1f>] __handle_mm_fault+0x3cf/0xccf
May 29 11:58:46 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:46 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:46 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:46 vault1 kernel:  [<ffffffff80208d64>] __handle_mm_fault+0x514/0xccf
May 29 11:58:46 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:46 vault1 kernel:  [<ffffffff80265bc5>] do_page_fault+0x490/0x7cf
May 29 11:58:46 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:47 vault1 kernel:  [<ffffffff8021e472>] sys_close+0x2b/0xd1
May 29 11:58:47 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:47 vault1 kernel:  [<ffffffff8024b1fc>] sys_poll+0x32/0x3b
May 29 11:58:47 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:47 vault1 kernel: 
May 29 11:58:47 vault1 kernel: lockd         S ffff81007fe18db8     0  3743      1 (L-TLB)
May 29 11:58:47 vault1 kernel:  ffff81007620de10 0000000000000046 0000000000000000 ffff81007ffe3830
May 29 11:58:47 vault1 kernel:  0000000000000627 ffff81007ffe30c0 0000000000000001 ffff81007ffe30c0
May 29 11:58:47 vault1 kernel:  ffff81011fccf080 0000000000003c35 ffff81007ffe32c8 0000000200000046
May 29 11:58:47 vault1 kernel: Call Trace:
May 29 11:58:47 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:47 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:47 vault1 kernel:  [<ffffffff882e824e>] :sunrpc:svc_recv+0x2b5/0x44f
May 29 11:58:47 vault1 kernel:  [<ffffffff882e8257>] :sunrpc:svc_recv+0x2be/0x44f
May 29 11:58:47 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:47 vault1 kernel:  [<ffffffff88315556>] :lockd:lockd+0x139/0x263
May 29 11:58:47 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:47 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:47 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:47 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:47 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:47 vault1 kernel:  [<ffffffff8831541d>] :lockd:lockd+0x0/0x263
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:47 vault1 kernel: 
May 29 11:58:47 vault1 kernel: rpciod/0      S ffff81011f96e4b8     0  3744     19 (L-TLB)
May 29 11:58:47 vault1 kernel:  ffff81011d85dea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:47 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011e7ae0c0
May 29 11:58:47 vault1 kernel:  ffffffff8058a6e0 0000000000001725 ffff81011e7ae2c8 000000001e7ae0c0
May 29 11:58:47 vault1 kernel: Call Trace:
May 29 11:58:47 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:47 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:47 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:47 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:47 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:47 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:47 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:47 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:47 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:47 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:47 vault1 kernel: 
May 29 11:58:47 vault1 kernel: rpciod/1      S ffff81007e836df8     0  3745     19 (L-TLB)
May 29 11:58:47 vault1 kernel:  ffff81011e8ebea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:47 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011dd85040
May 29 11:58:47 vault1 kernel:  ffff81011eca90c0 0000000000001573 ffff81011dd85248 000000011dd85040
May 29 11:58:47 vault1 kernel: Call Trace:
May 29 11:58:47 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:47 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:47 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:47 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:47 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:47 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:47 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:47 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:47 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:47 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:47 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:47 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:47 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:47 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:47 vault1 kernel: 
May 29 11:58:47 vault1 kernel: rpciod/2      S ffff81007e836df8     0  3746     19 (L-TLB)
May 29 11:58:47 vault1 kernel:  ffff81011e2ebea0 0000000000000046 ffffffff80248a3b 0000000000000002
May 29 11:58:47 vault1 kernel:  0000000000000000 0000000000000000 0000000000000005 ffff81011dd83080
May 29 11:58:47 vault1 kernel:  ffff81007ffe30c0 00000000000013c6 ffff81011dd83288 000000021dd83080
May 29 11:58:47 vault1 kernel: Call Trace:
May 29 11:58:47 vault1 kernel:  [<ffffffff80248a3b>] add_wait_queue+0x13/0x34
May 29 11:58:47 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:47 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:47 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:47 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:47 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:47 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:47 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:47 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:47 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:47 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:47 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:47 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:47 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:48 vault1 kernel: 
May 29 11:58:48 vault1 kernel: rpciod/3      S ffff81011ed8e058     0  3747     19 (L-TLB)
May 29 11:58:48 vault1 kernel:  ffff81011d86fea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:48 vault1 kernel:  0000000000000000 0000000000000000 0000000000000005 ffff81011d8d10c0
May 29 11:58:48 vault1 kernel:  ffff81011fd360c0 000000000000117b ffff81011d8d12c8 000000031d8d10c0
May 29 11:58:48 vault1 kernel: Call Trace:
May 29 11:58:48 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:48 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:48 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:48 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:48 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:48 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:48 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:48 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:48 vault1 kernel:  [<ffffffff80276ee4>] physflat_send_IPI_mask+0x0/0x82
May 29 11:58:48 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:48 vault1 kernel: 
May 29 11:58:48 vault1 kernel: nfsd4         S ffff81007f3424b8     0  3748     19 (L-TLB)
May 29 11:58:48 vault1 kernel:  ffff81011e229ea0 0000000000000046 0000000000000000 0000000000000002
May 29 11:58:48 vault1 kernel:  0000000000000000 0000000000000000 000000000000000a ffff81011d8d0040
May 29 11:58:48 vault1 kernel:  ffffffff8058a6e0 00000000000018ad ffff81011d8d0248 000000001d8d0040
May 29 11:58:48 vault1 kernel: Call Trace:
May 29 11:58:48 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:48 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:48 vault1 kernel:  [<ffffffff80248f5b>] worker_thread+0x0/0x150
May 29 11:58:48 vault1 kernel:  [<ffffffff80249045>] worker_thread+0xea/0x150
May 29 11:58:48 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:48 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:48 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:48 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:48 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:48 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:48 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:48 vault1 kernel: 
May 29 11:58:48 vault1 kernel: nfsd          D ffff81007e8de9d8     0  3749      1 (L-TLB)
May 29 11:58:48 vault1 kernel:  ffff810075cf3a60 0000000000000046 0000000000000540 ffff810074f460c0
May 29 11:58:48 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff810074f460c0
May 29 11:58:48 vault1 kernel:  ffff81007e0c80c0 000000000003c1a3 ffff810074f462c8 0000000274f46830
May 29 11:58:48 vault1 kernel: Call Trace:
May 29 11:58:48 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:48 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:48 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:48 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:48 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:48 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:48 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:48 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:48 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:48 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:48 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:48 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:48 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:48 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:48 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:48 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:48 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:48 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:48 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:48 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:48 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:48 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:48 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:48 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:48 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:48 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:48 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:48 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:48 vault1 kernel: 
May 29 11:58:48 vault1 kernel: nfsd          D ffff81007e8de118     0  3750      1 (L-TLB)
May 29 11:58:48 vault1 kernel:  ffff8100765fba60 0000000000000046 0000000000000000 ffff81007ea050c0
May 29 11:58:48 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff81007ea050c0
May 29 11:58:48 vault1 kernel:  ffffffff8058a6e0 000000000004b18a ffff81007ea052c8 000000007ea05830
May 29 11:58:48 vault1 kernel: Call Trace:
May 29 11:58:48 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:48 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:48 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:48 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:48 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:48 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:48 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:48 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:48 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:48 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:48 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:49 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:49 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:49 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:49 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:49 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:49 vault1 kernel:  [<ffffffff882ec9af>] :sunrpc:sunrpc_cache_lookup+0x30/0x131
May 29 11:58:49 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:49 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:49 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:49 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:49 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:49 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:49 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:49 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:49 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:49 vault1 kernel: 
May 29 11:58:49 vault1 kernel: nfsd          D ffff81007e8de9d8     0  3751      1 (L-TLB)
May 29 11:58:49 vault1 kernel:  ffff81007618fa60 0000000000000046 0000000000000000 ffff81007e9fd040
May 29 11:58:49 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff81007e9fd040
May 29 11:58:49 vault1 kernel:  ffff81011fccf080 000000000005db1b ffff81007e9fd248 000000027e9fd7b0
May 29 11:58:49 vault1 kernel: Call Trace:
May 29 11:58:49 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:49 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:49 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:49 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:49 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:49 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:49 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:49 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:49 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:49 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:49 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:49 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:49 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:49 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:49 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:49 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:49 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:49 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:49 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:49 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:49 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:49 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:49 vault1 kernel: 
May 29 11:58:49 vault1 kernel: nfsd          D ffff81007e8de118     0  3752      1 (L-TLB)
May 29 11:58:49 vault1 kernel:  ffff81007699fa60 0000000000000046 0000000000000540 ffff81007e4c5080
May 29 11:58:49 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff81007e4c5080
May 29 11:58:49 vault1 kernel:  ffff81007e1b9040 000000000001b7e6 ffff81007e4c5288 000000007e4c57f0
May 29 11:58:49 vault1 kernel: Call Trace:
May 29 11:58:49 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:49 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:49 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:49 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:49 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:49 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:49 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:49 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:49 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:49 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:49 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:49 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:49 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:49 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:49 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:49 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:49 vault1 kernel:  [<ffffffff882ec9af>] :sunrpc:sunrpc_cache_lookup+0x30/0x131
May 29 11:58:49 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:49 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:49 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:49 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:49 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:50 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:50 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:50 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:50 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:50 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:50 vault1 kernel: 
May 29 11:58:50 vault1 kernel: nfsd          D ffff81007e8de118     0  3753      1 (L-TLB)
May 29 11:58:50 vault1 kernel:  ffff81007663ba60 0000000000000046 0000000000000000 ffff81007e1b9040
May 29 11:58:50 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff81007e1b9040
May 29 11:58:50 vault1 kernel:  ffffffff8058a6e0 00000000000396b7 ffff81007e1b9248 000000007e1b97b0
May 29 11:58:50 vault1 kernel: Call Trace:
May 29 11:58:50 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:50 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:50 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:50 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:50 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:50 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:50 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:50 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:50 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:50 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:50 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:50 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:50 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:50 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:50 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:50 vault1 kernel:  [<ffffffff882ec9af>] :sunrpc:sunrpc_cache_lookup+0x30/0x131
May 29 11:58:50 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:50 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:50 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:50 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:50 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:50 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:50 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:50 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:50 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:50 vault1 kernel: 
May 29 11:58:50 vault1 kernel: nfsd          D ffff81007e8de9d8     0  3754      1 (L-TLB)
May 29 11:58:50 vault1 kernel:  ffff810076203a60 0000000000000046 0000000000000540 ffff81007e0c80c0
May 29 11:58:50 vault1 kernel:  0000000000000001 ffffffff802a0de5 0000000000000009 ffff81007e0c80c0
May 29 11:58:50 vault1 kernel:  ffff81007e9fd040 0000000000051705 ffff81007e0c82c8 000000027e0c8830
May 29 11:58:50 vault1 kernel: Call Trace:
May 29 11:58:50 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:50 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:50 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:50 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:50 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:50 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:50 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:50 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:50 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:50 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:50 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:50 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:50 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:50 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:50 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:50 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:50 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:50 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:50 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:50 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:50 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:50 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:50 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:50 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:50 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:50 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:50 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:50 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:50 vault1 kernel: 
May 29 11:58:50 vault1 kernel: nfsd          D ffff81007e8de9d8     0  3755      1 (L-TLB)
May 29 11:58:50 vault1 kernel:  ffff810071643a60 0000000000000046 0000000000000540 ffff81007fc350c0
May 29 11:58:50 vault1 kernel:  0000000000000001 ffffffff802a0de5 000000000000000a ffff81007fc350c0
May 29 11:58:51 vault1 kernel:  ffff81011fd34040 000000000001ead4 ffff81007fc352c8 000000037fc35830
May 29 11:58:51 vault1 kernel: Call Trace:
May 29 11:58:51 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:51 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:51 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:51 vault1 kernel:  [<ffffffff80262019>] __mutex_lock_slowpath+0x13b/0x25b
May 29 11:58:51 vault1 kernel:  [<ffffffff80262021>] __mutex_lock_slowpath+0x143/0x25b
May 29 11:58:51 vault1 kernel:  [<ffffffff8024e63b>] d_find_alias+0x3a/0x42
May 29 11:58:51 vault1 kernel:  [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:51 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:51 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:51 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:51 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:51 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:51 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:51 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:51 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:51 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:51 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:51 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:51 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:51 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:51 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:51 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:51 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:51 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:51 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:51 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:51 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:51 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:51 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:51 vault1 kernel: 
May 29 11:58:51 vault1 kernel: nfsd          D ffff81007e8de9d8     0  3756      1 (L-TLB)
May 29 11:58:51 vault1 kernel:  ffff8100761f3620 0000000000000046 0000000000000002 0000000000000000
May 29 11:58:51 vault1 kernel:  0000000000000000 0000000000000046 0000000000000009 ffff81007ea200c0
May 29 11:58:51 vault1 kernel:  ffff81007e0c80c0 000000000000c278 ffff81007ea202c8 000000037ea208a0
May 29 11:58:51 vault1 kernel: Call Trace:
May 29 11:58:51 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:51 vault1 kernel:  [<ffffffff802616cf>] io_schedule+0x3f/0x67
May 29 11:58:51 vault1 kernel:  [<ffffffff882456d9>] :jfs:txBeginAnon+0x85/0x13c
May 29 11:58:51 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:51 vault1 kernel:  [<ffffffff8823f2f2>] :jfs:extAlloc+0x3d/0x423
May 29 11:58:51 vault1 kernel:  [<ffffffff8823f786>] :jfs:extHint+0xae/0xfc
May 29 11:58:51 vault1 kernel:  [<ffffffff8822c65c>] :jfs:jfs_get_block+0x167/0x237
May 29 11:58:51 vault1 kernel:  [<ffffffff802e5c6c>] nobh_prepare_write+0xd3/0x458
May 29 11:58:51 vault1 kernel:  [<ffffffff8822c4f5>] :jfs:jfs_get_block+0x0/0x237
May 29 11:58:51 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:51 vault1 kernel:  [<ffffffff8020c722>] add_to_page_cache+0x2d/0x8c
May 29 11:58:51 vault1 kernel:  [<ffffffff80263540>] _write_unlock_irq+0x24/0x27
May 29 11:58:51 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:51 vault1 kernel:  [<ffffffff80263540>] _write_unlock_irq+0x24/0x27
May 29 11:58:51 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:51 vault1 kernel:  [<ffffffff80263540>] _write_unlock_irq+0x24/0x27
May 29 11:58:51 vault1 kernel:  [<ffffffff80210354>] generic_file_buffered_write+0x27b/0x77b
May 29 11:58:51 vault1 kernel:  [<ffffffff802606f4>] __sched_text_start+0x184/0x960
May 29 11:58:51 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:51 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:51 vault1 kernel:  [<ffffffff8020e533>] current_fs_time+0x3b/0x40
May 29 11:58:51 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:51 vault1 kernel:  [<ffffffff80216881>] __generic_file_aio_write_nolock+0x378/0x3eb
May 29 11:58:51 vault1 kernel:  [<ffffffff80262123>] __mutex_lock_slowpath+0x245/0x25b
May 29 11:58:51 vault1 kernel:  [<ffffffff8026212e>] __mutex_lock_slowpath+0x250/0x25b
May 29 11:58:51 vault1 kernel:  [<ffffffff802224a4>] generic_file_aio_write+0x61/0xc1
May 29 11:58:51 vault1 kernel:  [<ffffffff80222443>] generic_file_aio_write+0x0/0xc1
May 29 11:58:51 vault1 kernel:  [<ffffffff802d38c7>] do_sync_readv_writev+0xc0/0x107
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:51 vault1 kernel:  [<ffffffff8029a0f2>] autoremove_wake_function+0x0/0x2e
May 29 11:58:51 vault1 kernel:  [<ffffffff8020c870>] cache_alloc_debugcheck_after+0xef/0x139
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3776>] rw_copy_check_uvector+0x4b/0xdc
May 29 11:58:51 vault1 kernel:  [<ffffffff802cf576>] __kmalloc+0x131/0x13d
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3797>] rw_copy_check_uvector+0x6c/0xdc
May 29 11:58:51 vault1 kernel:  [<ffffffff802d3d38>] do_readv_writev+0xd7/0x1ae
May 29 11:58:51 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:51 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:51 vault1 kernel:  [<ffffffff8022400d>] file_move+0x1d/0x49
May 29 11:58:51 vault1 kernel:  [<ffffffff8832fc8d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
May 29 11:58:51 vault1 kernel:  [<ffffffff8021f168>] __dentry_open+0x104/0x1b0
May 29 11:58:51 vault1 kernel:  [<ffffffff88330305>] :nfsd:nfsd_open+0x13c/0x16f
May 29 11:58:51 vault1 kernel:  [<ffffffff8833053b>] :nfsd:nfsd_write+0xc5/0xe2
May 29 11:58:51 vault1 kernel:  [<ffffffff88337611>] :nfsd:nfsd3_proc_write+0xfb/0x11a
May 29 11:58:51 vault1 kernel:  [<ffffffff8832c244>] :nfsd:nfsd_dispatch+0xdd/0x19e
May 29 11:58:51 vault1 kernel:  [<ffffffff882e5353>] :sunrpc:svc_process+0x3ea/0x6f3
May 29 11:58:51 vault1 kernel:  [<ffffffff8832c7fe>] :nfsd:nfsd+0x194/0x2b2
May 29 11:58:51 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:51 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:51 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:51 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:51 vault1 kernel:  [<ffffffff8832c66a>] :nfsd:nfsd+0x0/0x2b2
May 29 11:58:51 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:51 vault1 kernel: 
May 29 11:58:51 vault1 kernel: rpc.mountd    S ffff81007e8dee38     0  3759      1 (NOTLB)
May 29 11:58:51 vault1 kernel:  ffff8100766c5a18 0000000000000046 0000000000000000 0000000000000000
May 29 11:58:51 vault1 kernel:  0000000180248a3b 0000000000000002 0000000000000009 ffff81007e618040
May 29 11:58:51 vault1 kernel:  ffff81011fc78040 00000000000120f1 ffff81007e618248 0000000100000000
May 29 11:58:51 vault1 kernel: Call Trace:
May 29 11:58:51 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:52 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:52 vault1 kernel:  [<ffffffff80213f07>] tcp_poll+0x1f/0x133
May 29 11:58:52 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:52 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:52 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:52 vault1 last message repeated 4 times
May 29 11:58:52 vault1 kernel:  [<ffffffff8020b406>] kfree+0x1a8/0x274
May 29 11:58:52 vault1 kernel:  [<ffffffff8020b4c4>] kfree+0x266/0x274
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff8020b406>] kfree+0x1a8/0x274
May 29 11:58:52 vault1 kernel:  [<ffffffff8020b4c4>] kfree+0x266/0x274
May 29 11:58:52 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:52 vault1 kernel:  [<ffffffff8020b4c4>] kfree+0x266/0x274
May 29 11:58:52 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:52 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff882ec363>] :sunrpc:cache_write+0x45/0xc0
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:52 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:52 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:52 vault1 kernel:  [<ffffffff80216aff>] sys_select+0xc1/0x183
May 29 11:58:52 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:52 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:52 vault1 kernel: 
May 29 11:58:52 vault1 kernel: bash          S ffff81011fff8998     0  4891   3311 (NOTLB)
May 29 11:58:52 vault1 kernel:  ffff8100339c3ec8 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:52 vault1 kernel:  0000000000000000 0000000200000002 0000000000000009 ffff81004a1760c0
May 29 11:58:52 vault1 kernel:  ffff81011fccf080 00000000000a29d2 ffff81004a1762c8 0000000200000000
May 29 11:58:52 vault1 kernel: Call Trace:
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff8022920b>] do_wait+0x94c/0xa75
May 29 11:58:52 vault1 kernel:  [<ffffffff8022922e>] do_wait+0x96f/0xa75
May 29 11:58:52 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:52 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:52 vault1 kernel: 
May 29 11:58:52 vault1 kernel: ssh           S ffff81007f343a98     0  4918   4891 (NOTLB)
May 29 11:58:52 vault1 kernel:  ffff810116ffba18 0000000000000046 0000000000000000 0000000000000046
May 29 11:58:52 vault1 kernel:  ffffffff8022edfd 0000000000000046 000000000000000a ffff810091f5d0c0
May 29 11:58:52 vault1 kernel:  ffff81011fd360c0 0000000000073aab ffff810091f5d2c8 0000000391f5d0c0
May 29 11:58:52 vault1 kernel: Call Trace:
May 29 11:58:52 vault1 kernel:  [<ffffffff8022edfd>] __wake_up+0x22/0x4e
May 29 11:58:52 vault1 kernel:  [<ffffffff8023a80a>] tty_ldisc_deref+0x62/0x75
May 29 11:58:52 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:52 vault1 kernel:  [<ffffffff80226c98>] tty_poll+0x5f/0x6d
May 29 11:58:52 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:52 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:52 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:52 vault1 last message repeated 4 times
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff802174d3>] release_console_sem+0x44/0x1eb
May 29 11:58:52 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:52 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:52 vault1 kernel:  [<ffffffff802638fc>] _spin_unlock_irqrestore+0x3e/0x44
May 29 11:58:52 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:52 vault1 kernel:  [<ffffffff8022edfd>] __wake_up+0x22/0x4e
May 29 11:58:52 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:52 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:52 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:52 vault1 kernel:  [<ffffffff80216aff>] sys_select+0xc1/0x183
May 29 11:58:52 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:52 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:52 vault1 kernel: 
May 29 11:58:52 vault1 kernel: sshd          S ffff81007f1149d8     0  6871   3092 (NOTLB)
May 29 11:58:52 vault1 kernel:  ffff81011e20da18 0000000000000046 0000000000000000 0000000000000046
May 29 11:58:52 vault1 kernel:  ffffffff8022edfd 0000000000000046 000000000000000a ffff81010bea70c0
May 29 11:58:52 vault1 kernel:  ffff81011fc78040 0000000000012ee2 ffff81010bea72c8 000000010bea70c0
May 29 11:58:52 vault1 kernel: Call Trace:
May 29 11:58:52 vault1 kernel:  [<ffffffff8022edfd>] __wake_up+0x22/0x4e
May 29 11:58:52 vault1 kernel:  [<ffffffff8023a80a>] tty_ldisc_deref+0x62/0x75
May 29 11:58:52 vault1 kernel:  [<ffffffff80261724>] schedule_timeout+0x1e/0xad
May 29 11:58:52 vault1 kernel:  [<ffffffff80226c98>] tty_poll+0x5f/0x6d
May 29 11:58:52 vault1 kernel:  [<ffffffff80211e12>] do_select+0x3fe/0x462
May 29 11:58:52 vault1 kernel:  [<ffffffff8021f267>] __pollwait+0x0/0xe1
May 29 11:58:52 vault1 kernel:  [<ffffffff80287a44>] default_wake_function+0x0/0xe
May 29 11:58:53 vault1 last message repeated 3 times
May 29 11:58:53 vault1 kernel:  [<ffffffff802313cd>] release_sock+0x2f/0xd6
May 29 11:58:53 vault1 kernel:  [<ffffffff8028de66>] local_bh_enable_ip+0xe4/0xea
May 29 11:58:53 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:53 vault1 kernel:  [<ffffffff80227651>] tcp_sendmsg+0x9ab/0xab5
May 29 11:58:53 vault1 kernel:  [<ffffffff80227651>] tcp_sendmsg+0x9ab/0xab5
May 29 11:58:53 vault1 kernel:  [<ffffffff8024671c>] sock_aio_write+0x110/0x128
May 29 11:58:53 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:53 vault1 kernel:  [<ffffffff802d81fe>] core_sys_select+0x1bb/0x264
May 29 11:58:53 vault1 kernel:  [<ffffffff80218507>] do_sync_write+0xc9/0x10c
May 29 11:58:53 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:53 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:53 vault1 kernel:  [<ffffffff8020cc19>] dnotify_parent+0x1f/0x6d
May 29 11:58:53 vault1 kernel:  [<ffffffff80216aff>] sys_select+0xc1/0x183
May 29 11:58:53 vault1 kernel:  [<ffffffff80263178>] trace_hardirqs_on_thunk+0x35/0x37
May 29 11:58:53 vault1 kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83
May 29 11:58:53 vault1 kernel: 
May 29 11:58:53 vault1 kernel: pdflush       D ffff81007e8de9d8     0  8692     19 (L-TLB)
May 29 11:58:53 vault1 kernel:  ffff81005aba3a20 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:53 vault1 kernel:  0000000137d30000 0000000000000002 000000000000000a ffff81004687d0c0
May 29 11:58:53 vault1 kernel:  ffff81011fd360c0 0000000000003dcf ffff81004687d2c8 0000000300000001
May 29 11:58:53 vault1 kernel: Call Trace:
May 29 11:58:53 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:53 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:53 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:53 vault1 kernel:  [<ffffffff80262fa6>] __down_write_nested+0x7e/0x96
May 29 11:58:53 vault1 kernel:  [<ffffffff8822c53a>] :jfs:jfs_get_block+0x45/0x237
May 29 11:58:53 vault1 kernel:  [<ffffffff8022307f>] __up_read+0x19/0x7f
May 29 11:58:53 vault1 kernel:  [<ffffffff802e9478>] __mpage_writepage+0x1f5/0x55d
May 29 11:58:53 vault1 kernel:  [<ffffffff8822c4f5>] :jfs:jfs_get_block+0x0/0x237
May 29 11:58:53 vault1 kernel:  [<ffffffff802638bb>] _read_unlock_irq+0x24/0x27
May 29 11:58:53 vault1 kernel:  [<ffffffff802c0835>] dec_zone_page_state+0x33/0x3a
May 29 11:58:53 vault1 kernel:  [<ffffffff8029fc0f>] mark_held_locks+0x4a/0x6c
May 29 11:58:53 vault1 kernel:  [<ffffffff802c0835>] dec_zone_page_state+0x33/0x3a
May 29 11:58:53 vault1 kernel:  [<ffffffff8029fe09>] trace_hardirqs_on+0x124/0x14f
May 29 11:58:53 vault1 kernel:  [<ffffffff8021d493>] mpage_writepages+0x228/0x375
May 29 11:58:53 vault1 kernel:  [<ffffffff8822c0bb>] :jfs:jfs_writepage+0x0/0xf
May 29 11:58:53 vault1 kernel:  [<ffffffff8822c4f5>] :jfs:jfs_get_block+0x0/0x237
May 29 11:58:53 vault1 kernel:  [<ffffffff802593b8>] do_writepages+0x23/0x30
May 29 11:58:53 vault1 kernel:  [<ffffffff80230487>] __writeback_single_inode+0x1c0/0x338
May 29 11:58:53 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:53 vault1 kernel:  [<ffffffff80263584>] _read_unlock+0x17/0x20
May 29 11:58:53 vault1 kernel:  [<ffffffff80221c26>] sync_sb_inodes+0x1a6/0x267
May 29 11:58:53 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:53 vault1 kernel:  [<ffffffff8024f304>] writeback_inodes+0x95/0xee
May 29 11:58:53 vault1 kernel:  [<ffffffff802be735>] wb_kupdate+0x9e/0x112
May 29 11:58:53 vault1 kernel:  [<ffffffff80254d52>] pdflush+0x0/0x1e7
May 29 11:58:53 vault1 kernel:  [<ffffffff80254d52>] pdflush+0x0/0x1e7
May 29 11:58:53 vault1 kernel:  [<ffffffff80254e8e>] pdflush+0x13c/0x1e7
May 29 11:58:53 vault1 kernel:  [<ffffffff802be697>] wb_kupdate+0x0/0x112
May 29 11:58:53 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:53 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:53 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:53 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:53 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:53 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:53 vault1 kernel: 
May 29 11:58:53 vault1 kernel: pdflush       S ffff81007e8de9d8     0 10661     19 (L-TLB)
May 29 11:58:53 vault1 kernel:  ffff81007e775ed0 0000000000000046 0000000000000000 ffffffff802a0de5
May 29 11:58:53 vault1 kernel:  0000000180598080 0000000000000002 000000000000000a ffff810055df5040
May 29 11:58:53 vault1 kernel:  ffff81011fccf080 0000000000003d7f ffff810055df5248 0000000200000000
May 29 11:58:53 vault1 kernel: Call Trace:
May 29 11:58:53 vault1 kernel:  [<ffffffff802a0de5>] __lock_acquire+0xb4a/0xbdf
May 29 11:58:53 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:53 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:53 vault1 kernel:  [<ffffffff80299f53>] keventd_create_kthread+0x0/0x6d
May 29 11:58:53 vault1 kernel:  [<ffffffff80254d52>] pdflush+0x0/0x1e7
May 29 11:58:53 vault1 kernel:  [<ffffffff80254e21>] pdflush+0xcf/0x1e7
May 29 11:58:53 vault1 kernel:  [<ffffffff8023312e>] kthread+0xd0/0xff
May 29 11:58:53 vault1 kernel:  [<ffffffff8025cfa8>] child_rip+0xa/0x12
May 29 11:58:53 vault1 kernel:  [<ffffffff80263894>] _spin_unlock_irq+0x24/0x27
May 29 11:58:53 vault1 kernel:  [<ffffffff8025c6bc>] restore_args+0x0/0x30
May 29 11:58:53 vault1 kernel:  [<ffffffff8023305e>] kthread+0x0/0xff
May 29 11:58:53 vault1 kernel:  [<ffffffff8025cf9e>] child_rip+0x0/0x12
May 29 11:58:53 vault1 kernel: 
May 29 11:58:53 vault1 kernel: 
May 29 11:58:53 vault1 kernel: Showing all locks held in the system:
May 29 11:58:53 vault1 kernel: 1 lock held by syslogd/2963:
May 29 11:58:53 vault1 kernel:  #0:  (&inode->i_mutex){--..}, at: [<ffffffff8024e516>] do_fsync+0x41/0xa4
May 29 11:58:53 vault1 kernel: 1 lock held by mingetty/3312:
May 29 11:58:53 vault1 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<ffffffff8022a64c>] read_chan+0x201/0x609
May 29 11:58:53 vault1 kernel: 1 lock held by mingetty/3313:
May 29 11:58:53 vault1 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<ffffffff8022a64c>] read_chan+0x201/0x609
May 29 11:58:53 vault1 kernel: 1 lock held by mingetty/3314:
May 29 11:58:53 vault1 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<ffffffff8022a64c>] read_chan+0x201/0x609
May 29 11:58:53 vault1 kernel: 1 lock held by mingetty/3315:
May 29 11:58:53 vault1 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<ffffffff8022a64c>] read_chan+0x201/0x609
May 29 11:58:53 vault1 kernel: 1 lock held by mingetty/3316:
May 29 11:58:53 vault1 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<ffffffff8022a64c>] read_chan+0x201/0x609
May 29 11:58:53 vault1 kernel: 1 lock held by bash/3377:
May 29 11:58:53 vault1 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<ffffffff8022a64c>] read_chan+0x201/0x609
May 29 11:58:53 vault1 kernel: 2 locks held by nfsd/3749:
May 29 11:58:53 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 2 locks held by nfsd/3750:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 2 locks held by nfsd/3751:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 2 locks held by nfsd/3752:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 2 locks held by nfsd/3753:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 2 locks held by nfsd/3754:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 2 locks held by nfsd/3755:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel: 3 locks held by nfsd/3756:
May 29 11:58:54 vault1 kernel:  #0:  (hash_sem){----}, at: [<ffffffff8832c7e7>] nfsd+0x17d/0x2b2 [nfsd]
May 29 11:58:54 vault1 kernel:  #1:  (&inode->i_mutex){--..}, at: [<ffffffff8022248f>] generic_file_aio_write+0x4c/0xc1
May 29 11:58:54 vault1 kernel:  #2:  (&jfs_ip->rdwrlock#2){----}, at: [<ffffffff8822c53a>] jfs_get_block+0x45/0x237 [jfs]
May 29 11:58:54 vault1 kernel: 2 locks held by bash/6873:
May 29 11:58:54 vault1 kernel:  #0:  (sysrq_key_table_lock){....}, at: [<ffffffff80395b2a>] __handle_sysrq+0x22/0x128
May 29 11:58:54 vault1 kernel:  #1:  (tasklist_lock){..-?}, at: [<ffffffff8029ebd4>] debug_show_all_locks+0x3e/0x152
May 29 11:58:54 vault1 kernel: 2 locks held by pdflush/8692:
May 29 11:58:54 vault1 kernel:  #0:  (&type->s_umount_key#20){----}, at: [<ffffffff8024f2e2>] writeback_inodes+0x73/0xee
May 29 11:58:54 vault1 kernel:  #1:  (&jfs_ip->rdwrlock#2){----}, at: [<ffffffff8822c53a>] jfs_get_block+0x45/0x237 [jfs]
May 29 11:58:54 vault1 kernel: 
May 29 11:58:54 vault1 kernel: =============================================
May 29 11:58:54 vault1 kernel: 

--------------030401080608010707040408--
