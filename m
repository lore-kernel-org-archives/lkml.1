Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbXFCKhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbXFCKhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 06:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXFCKha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 06:37:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080AbXFCKh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 06:37:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc3: BUG: using smp_processor_id() in preemptible, in mtrr_save_state
Date: Sun, 3 Jun 2007 12:43:26 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706031243.27435.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this on an SMP box with kernel preemption enabled, during hibernation and
restore (100% of the time):

Enabling non-boot CPUs ...
BUG: using smp_processor_id() in preemptible [00000001] code: bash/4514
caller is mtrr_save_state+0x9/0x40

Call Trace:
 [<ffffffff8039008f>] debug_smp_processor_id+0xbf/0xd0
 [<ffffffff8029b9e3>] dbg_redzone1+0x13/0x30
 [<ffffffff80215ee9>] mtrr_save_state+0x9/0x40
 [<ffffffff8021b76d>] __cpu_up+0xad/0x7c0
 [<ffffffff8025886e>] mark_held_locks+0x3e/0x80
 [<ffffffff8051afc9>] __mutex_unlock_slowpath+0xd9/0x1a0
 [<ffffffff8025944e>] __lock_acquire+0x40e/0x1040
 [<ffffffff8051b099>] mutex_unlock+0x9/0x10
 [<ffffffff8025886e>] mark_held_locks+0x3e/0x80
 [<ffffffff8051b25a>] __mutex_lock_slowpath+0x1ba/0x320
 [<ffffffff80258a4a>] trace_hardirqs_on+0xda/0x180
 [<ffffffff8051b246>] __mutex_lock_slowpath+0x1a6/0x320
 [<ffffffff80260324>] _cpu_up+0xb4/0x150
 [<ffffffff802604b2>] enable_nonboot_cpus+0x92/0xc0
 [<ffffffff80267111>] hibernation_snapshot+0xa1/0xf0
 [<ffffffff802672f4>] hibernate+0xc4/0x180
 [<ffffffff80265ba0>] state_store+0xe0/0xf0
 [<ffffffff802f0021>] subsys_attr_store+0x31/0x40
 [<ffffffff802f01d3>] sysfs_write_file+0xe3/0x140
 [<ffffffff802a24c4>] vfs_write+0xe4/0x190
 [<ffffffff802a2b90>] sys_write+0x50/0x90
 [<ffffffff80209c7e>] system_call+0x7e/0x83

where

(gdb) l *mtrr_save_state+0x9
0xffffffff80215ee9 is in mtrr_save_state (/home/rafael/src/rc/linux-2.6.22-rc3/arch/x86_64/kernel/../../i386/kernel/cpu/mtrr/main.c:737).
732     /**
733      * Save current fixed-range MTRR state of the BSP
734      */
735     void mtrr_save_state(void)
736     {
737             if (smp_processor_id() == 0)
738                     mtrr_save_fixed_ranges(NULL);
739             else
740                     smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
741     }
