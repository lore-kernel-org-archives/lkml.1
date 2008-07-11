Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYGKTHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYGKTHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbYGKTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:07:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:62440 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbYGKTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GdKOkPGpNPGCxg4tpZl/mVvymUZonBvLKNmaUTdi5ZJ8wMULv6c7DLoayMabhQdM/J
         GxzihG4sM0TzMaTpkWg7wUUAW3k+poIsYlHHKOXJ++XbYAKazRlDbB9LTQXTU7p1eye5
         Jyw+fZywwvSRCYIqVC1CDvSgXjwKhMew6PtVg=
Message-ID: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>
Date: Fri, 11 Jul 2008 21:07:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Paul Jackson" <pj@sgi.com>, "Paul Menage" <menage@google.com>
Subject: current linux-2.6.git: cpusets completely broken
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have now "config-bisected" and found that the difference between a
working and a non-working config is just this:

+CONFIG_CPUSETS=y
+CONFIG_PROC_PID_CPUSET=y

The difference between a i386 defconfig base and the non-working config is:

+CONFIG_CGROUPS=y
+CONFIG_CPUSETS=y
+CONFIG_PROC_PID_CPUSET=y

(Note that group scheduling is off and has nothing to with it!)


The result of having CPUSETS enabled as above is a 100% reproducible
BUG on the very first cpu hot-unplug:

------------[ cut here ]------------
kernel BUG at xxx/linux-2.6/kernel/sched.c:5859!
invalid opcode: 0000 [#1] SMP
Modules linked in:
Pid: 3653, comm: bash Not tainted (2.6.26-rc9-00102-ge5a5816 #3)
EIP: 0060:[<c040b6e7>] EFLAGS: 00210046 CPU: 0
EIP is at migration_call+0x29b/0x3bb
EAX: c1816558 EBX: c1816500 ECX: 01213000 EDX: c0603500
ESI: f7035f80 EDI: c1816500 EBP: 00000001 ESP: f6c17ec4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3653, ti=f6c16000 task=f6cb1c00 task.ti=f6c16000)
Stack: c1816500 c0411b05 c0106fc8 c05b10f8 ffffffff 00000000 c05b11ac c0410375
       00000001 00000007 00000007 00000001 00000000 f71f5500 c012f916 ffffffff
       00000000 c03f42fb 00000000 00000001 fffffffd 00000003 0000001f 00000001
Call Trace:
 [<c0411b05>] _etext+0x0/0xb
 [<c0106fc8>] alternatives_smp_unlock+0x42/0x4f
 [<c0410375>] notifier_call_chain+0x2a/0x47
 [<c012f916>] raw_notifier_call_chain+0x9/0xc
 [<c03f42fb>] _cpu_down+0x14c/0x1ee
 [<c03f43bd>] cpu_down+0x20/0x2c
 [<c03f53d0>] store_online+0x24/0x56
 [<c03f53ac>] store_online+0x0/0x56
 [<c0272446>] sysdev_store+0x1e/0x22
 [<c0191d18>] sysfs_write_file+0xa4/0xd8
 [<c0191c74>] sysfs_write_file+0x0/0xd8
 [<c0160fe6>] vfs_write+0x83/0xf6
 [<c0161521>] sys_write+0x3c/0x63
 [<c0103545>] sysenter_past_esp+0x6a/0x91
 =======================
Code: 18 85 c0 89 c6 75 04 8b 1b eb f0 8b 4e 24 89 f2 8b 04 24 ff 51 1c ba 00 35
 60 c0 8b 0c ad 00 d2 5b c0 83 be c0 00 00 00 00 75 04 <0f> 0b eb fe 8b 06 83 f8
 40 75 04 0f 0b eb fe 8d 1c 0a 90 ff 46
EIP: [<c040b6e7>] migration_call+0x29b/0x3bb SS:ESP 0068:f6c17ec4
BUG: NMI Watchdog detected LOCKUP on CPU0, ip c040e76e, registers:
Modules linked in:
Pid: 3653, comm: bash Not tainted (2.6.26-rc9-00102-ge5a5816 #3)
EIP: 0060:[<c040e76e>] EFLAGS: 00200097 CPU: 0
EIP is at _spin_lock+0x10/0x15
EAX: c1816500 EBX: c0603500 ECX: 63adf1df EDX: 0000e2e1
ESI: c1816500 EDI: f6c17d6c EBP: f6db5500 ESP: f6c17d50
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3653, ti=f6c16000 task=f6cb1c00 task.ti=f6c16000)
Stack: c01170bb f6db5500 c180c500 00000000 00000000 c011736c 00000001 00200092
       f7353f3c c0566ef8 00000001 00000000 c012c4ad 00000000 f7353f3c c0566ef8
       c0115e44 00000000 00000001 c0566f00 c0566f00 00000000 00000001 00200092
Call Trace:
 [<c01170bb>] task_rq_lock+0x28/0x4b
 [<c011736c>] try_to_wake_up+0x65/0xe0
 [<c012c4ad>] autoremove_wake_function+0xd/0x2d
 [<c0115e44>] __wake_up_common+0x2e/0x58
 [<c0116b8c>] __wake_up+0x29/0x39
 [<c011db2b>] wake_up_klogd+0x2b/0x2d
 [<c010476f>] die+0xb1/0x10f
 [<c0104839>] do_invalid_op+0x0/0x6b
 [<c010489b>] do_invalid_op+0x62/0x6b
 [<c040b6e7>] migration_call+0x29b/0x3bb
 [<c0410cc7>] kprobe_flush_task+0x4b/0x80
 [<c0118f1c>] hrtick_set+0x7a/0xd8
 [<c040d52b>] schedule+0x5b6/0x5e8
 [<c0117f04>] update_curr_rt+0x92/0x339
 [<c040ea1a>] error_code+0x72/0x78
 [<c01100d8>] send_IPI_mask_sequence+0x24/0x91
 [<c040b6e7>] migration_call+0x29b/0x3bb
 [<c0411b05>] _etext+0x0/0xb
 [<c0106fc8>] alternatives_smp_unlock+0x42/0x4f
 [<c0410375>] notifier_call_chain+0x2a/0x47
 [<c012f916>] raw_notifier_call_chain+0x9/0xc
 [<c03f42fb>] _cpu_down+0x14c/0x1ee
 [<c03f43bd>] cpu_down+0x20/0x2c
 [<c03f53d0>] store_online+0x24/0x56
 [<c03f53ac>] store_online+0x0/0x56
 [<c0272446>] sysdev_store+0x1e/0x22
 [<c0191d18>] sysfs_write_file+0xa4/0xd8
 [<c0191c74>] sysfs_write_file+0x0/0xd8
 [<c0160fe6>] vfs_write+0x83/0xf6
 [<c0161521>] sys_write+0x3c/0x63
 [<c0103545>] sysenter_past_esp+0x6a/0x91
 =======================
Code: 00 00 01 0f 94 c0 84 c0 b9 01 00 00 00 75 09 90 81 02 00 00 00 01 30 c9 89
 c8 c3 ba 00 01 00 00 90 66 0f c1 10 38 f2 74 06 f3 90 <8a> 10 eb f6 c3 90 81 28
 00 00 00 01 74 05 e8 4f ff ff ff c3 53

Also, this is on the latest linux-2.6.git! Since we're so close to
release, maybe cpusets should simply be marked BROKEN for now? (Unless
we can fix it, of course. The alternative is to apply Miao Xie's
workaround patch temporarily.)

I hope this helps at least a little bit.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
