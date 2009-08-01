Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbZHAJ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbZHAJ6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 05:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZHAJ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 05:58:45 -0400
Received: from bu3sch.de ([62.75.166.246]:42105 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZHAJ6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 05:58:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: dm-devel@redhat.com
Subject: NULL data pointer dereference in kcryptd
Date: Sat, 1 Aug 2009 11:58:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908011158.12718.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following oops happened while doing an mke2fs -j on a luks mapping.
I think (I'm not entirely sure) that it was triggered by running the "sync" command
simultaneously to the mke2fs. Both sync and mke2fs are stuck in D state after the oops.

root     10916  0.4  0.0   1888   460 ?        D<   22:39   0:03 /bin/sync
root     11038  0.4  0.0   1888   460 ?        D<   22:39   0:02 /bin/sync
(Not sure why two. Maybe I poked it twice. I don't remember.)

root     10375  7.3  0.0      0     0 ?        D    22:25   1:54 [mke2fs]
(Why are there brackets around mke2fs anyway?)

root       353  0.0  0.0      0     0 ?        S<   18:25   0:00 [crypto/0]
root       354  0.0  0.0      0     0 ?        S<   18:25   0:00 [crypto/1]
root       355  0.0  0.0      0     0 ?        S<   18:25   0:00 [crypto/2]
root       356  0.0  0.0      0     0 ?        S<   18:25   0:00 [crypto/3]
root     10321  0.0  0.0      0     0 ?        S<   22:24   0:00 [kcryptd_io]

Kernel is 2.6.30 on PowerPC 64bit SMP.

[15577.988487] Unable to handle kernel paging request for data at address 0x00000000
[15577.988494] Faulting instruction address: 0xc0000000000b8034
[15577.988499] Oops: Kernel access of bad area, sig: 11 [#1]
[15577.988501] PREEMPT SMP NR_CPUS=4 NUMA PowerMac
[15577.988506] Modules linked in: ppdev lp af_packet sbp2 ieee1394 loop b43 mac80211 cfg80211 ssb 8250_pci 8250 serial_core parport_pc parport uninorth_agp agpgart evdev
[15577.988530] NIP: c0000000000b8034 LR: c000000000139bdc CTR: c000000000533290
[15577.988534] REGS: c0000001f022f8e0 TRAP: 0300   Not tainted  (2.6.30)
[15577.988536] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 28004044  XER: 000fffff
[15577.988546] DAR: 0000000000000000, DSISR: 0000000040000000
[15577.988549] TASK = c00000020fe74380[10322] 'kcryptd' THREAD: c0000001f022c000 CPU: 3
[15577.988552] GPR00: 00000000ffffffaf c0000001f022fb60 c000000000a4e928 0000000000011200 
[15577.988559] GPR04: 000002037053b000 c0000002150b9e40 0000000000000000 c0000001e8ec8ef0 
[15577.988565] GPR08: 0000000000000000 0000000000000000 c0000001bfacabf8 0000000000000000 
[15577.988571] GPR12: 0000000028000044 c000000000a7f880 c000000000831ae0 c0000000009270a8 
[15577.988577] GPR16: c000000000926d68 0000000000000000 f0000000046e6b58 0000000070e007b1 
[15577.988583] GPR20: 00000000fffffdef 0000000000000200 c0000001bfacabe0 f0000000046e6b58 
[15577.988590] GPR24: 0000000000000001 c0000001f022fbd0 c0000001f022fbe8 c000000203bd9ed1 
[15577.988596] GPR28: c000000203bd9ea1 0000000000011210 c0000000009ac658 0000000000000000 
[15577.988608] NIP [c0000000000b8034] .mempool_alloc+0x74/0x1a0
[15577.988614] LR [c000000000139bdc] .bio_alloc_bioset+0x4c/0x130
[15577.988616] Call Trace:
[15577.988619] [c0000001f022fb60] [c0000001f022fbf0] 0xc0000001f022fbf0 (unreliable)
[15577.988625] [c0000001f022fc40] [c000000000139bdc] .bio_alloc_bioset+0x4c/0x130
[15577.988632] [c0000001f022fcf0] [c0000000005334a0] .kcryptd_crypt+0x210/0x520
[15577.988637] [c0000001f022fde0] [c000000000068018] .worker_thread+0x248/0x3e0
[15577.988642] [c0000001f022ff00] [c00000000006e1e4] .kthread+0x84/0xe0
[15577.988648] [c0000001f022ff90] [c000000000021830] .kernel_thread+0x54/0x70
[15577.988651] Instruction dump:
[15577.988654] 789d0020 7c7c1b78 780083e4 57a906f6 3b7c0030 6000ffaf 2e090000 7fa30038 
[15577.988663] 3b410088 3b210070 e93c0020 e89c0018 <e8090000> f8410028 7c0903a6 e9690010 
[15577.988674] ---[ end trace 13c61a64a39c7194 ]---

-- 
Greetings, Michael.
