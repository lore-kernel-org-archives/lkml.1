Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYGYOhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYGYOhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYGYOhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:37:47 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62027 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYGYOhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:37:46 -0400
Message-ID: <4889E538.5010007@lwfinger.net>
Date: Fri, 25 Jul 2008 09:37:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Kernel BUG in 2.6.26-git series
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current git pulls from Linus's tree, I get a kernel BUG if 
CONFIG_SCHED_SMT is defined. It does not always appear, but when it does, it is 
late in the bootup sequence. Perhaps there is a timing issue. This is an x86_64 
system on an HP dv2815nr notebook with and AMD Turion X2 CPU. My distro is 
openSUSE 11.0.

kernel: BUG: unable to handle kernel NULL pointer dereference at 000000000000002
kernel: IP: [<ffffffff80231aec>] sched_mc_power_savings_store+0x13/0x41
kernel: PGD 0
kernel: Oops: 0000 [1] SMP
kernel: CPU 0
kernel: Modules linked in: iptable_filter ip_tables x_tables snd_pcm_oss
snd_mixer_oss snd_seq snd_
seq_device af_packet nfs rfkill_input lockd nfs_acl sunrpc cpufreq_conservative
cpufreq_userspace cpufreq_powersave powernow
_k8 fuse loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill snd_hda_intel mac80211
k8temp cfg80211 led_class input_polldev bat
tery sr_mod snd_pcm button ac joydev hwmon snd_timer serio_raw cdrom forcedeth
ssb snd soundcore snd_page_alloc sg sd_mod oh
ci_hcd ehci_hcd usbcore edd fan thermal processor ext3 mbcache jbd pata_amd ahci
libata scsi_mod dock
kernel: Pid: 3686, comm: sched-powersave Not tainted 2.6.26-Linus-06879-gfb2e405 #71
kernel: RIP: 0010:[<ffffffff80231aec>]  [<ffffffff80231aec>]
sched_mc_power_savings_store+0x13/0x41
kernel: RSP: 0018:ffff8800b8793ea8  EFLAGS: 00010292
kernel: RAX: ffffffff80231ad9 RBX: 0000000000000002 RCX: ffffffffffffffea
kernel: RDX: 0000000000000002 RSI: ffff8800b9aed000 RDI: ffffffff805508d0
kernel: RBP: ffff8800b8793eb8 R08: ffff8800b9aed000 R09: 0000000000000000
kernel: R10: ffffffff8027c836 R11: ffffffff80231ad9 R12: ffff8800bb6dc4b0
kernel: R13: 00000000ffffffed R14: ffffffff80550940 R15: ffffffff80550240
kernel: FS:  00007f9c3dc546f0(0000) GS:ffffffff8057ea00(0000) knlGS:00000000f69426d0
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000000002 CR3: 00000000b9fe6000 CR4: 00000000000006e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process sched-powersave (pid: 3686, threadinfo ffff8800b8792000, task
ffff8800b876c9c0)
kernel: Stack:  0000000000000000 0000000000000002 ffff8800b8ab4980 ffffffff802dbb84
kernel:  ffff880037a15458 ffff8800b8793f50 ffff8800b8ab49a0 ffff8800b8fb3a80
kernel:  0000000000000002 ffff8800b8793f50 00007f9c3dc7c000 00007f9c3df40be0
kernel: Call Trace:
kernel:  [<ffffffff802dbb84>] sysfs_write_file+0xd5/0x10c
kernel:  [<ffffffff8029922b>] ? vfs_write+0xad/0x123
kernel:  [<ffffffff8029935d>] ? sys_write+0x45/0x6e
kernel:  [<ffffffff8020be9b>] ? system_call_fastpath+0x16/0x1b
kernel:
kernel:
kernel: Code: 27 5c 00 00 31 d2 31 f6 31 ff e8 21 fd ff ff e8 c0 5b 00 00 31 c0
c9 c3 55 48 89 e5 53 48 89 cb 48 c7 c1 ea ff ff ff 48 83 ec 08 <8a> 12 8d 42 d0
3c 01 77 1d 31 c0 80 fa 31 0f 94 c0 89 05 11 19
kernel: RIP  [<ffffffff80231aec>] sched_mc_power_savings_store+0x13/0x41
kernel:  RSP <ffff8800b8793ea8>
kernel: CR2: 0000000000000002

======================================================================

The specific problem is that the buffer pointer in the call to 
sched_mc_power_savings_store() is NULL. Due to the intermittent nature of the 
trigger, I have not been able bisect this problem; however, the only recent 
change in this code was with:

commit 4a0b2b4dbe1335b8b9886ba3dc85a145d5d938ed
Author: Andi Kleen <andi@firstfloor.org>
Date:   Tue Jul 1 18:48:41 2008 +0200

     sysdev: Pass the attribute to the low level sysdev show/store function


If I forgot any essential details, please let me know.

Larry
