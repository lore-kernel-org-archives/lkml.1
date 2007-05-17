Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbXEQANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbXEQANZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXEQANS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:13:18 -0400
Received: from gw.goop.org ([64.81.55.164]:33675 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXEQANR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:13:17 -0400
Message-ID: <464B9E19.6050902@goop.org>
Date: Wed, 16 May 2007 17:13:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc1-mm1: strange GPF when panicing under kvm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot 2.6.22-rc1-mm1 under kvm, but forget to specify a root
filesystem, it panics as expected.  However, when panicing, it gets a
GPF in delay_tsc, and then starts recursively panicing.

I don't really understand what's going on; the instruction it's faulting
on seems to be "pause" (ie, rep;nop), which seems like it shouldn't
fault at all.  It looks like some kvm artifact to me, but I'm not sure.

Hm, given the error code, maybe it's a segment register problem.

VFS: Cannot open root device "<NULL>" or unknown-block(254,0)
Please append a correct "root=" boot option; here are the available partitions:
0300    4194304 hda driver: ide-disk
  0301    4192933 hda1
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(254,0)
general protection fault: fffa [#1]
PREEMPT SMP 
Modules linked in:
CPU:    0
EIP:    0060:[<c021dcdb>]    Not tainted VLI
EFLAGS: 00000297   (2.6.22-rc1-mm1-paravirt #1391)
EIP is at delay_tsc+0x20/0x42
eax: 00025431   ebx: 00000000   ecx: 00000000   edx: 00000002
esi: 55c34bd8   edi: 00000000   ebp: c1421e70   esp: c1421e5c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=c1420000 task=c141f4f0 task.ti=c1420000)
Stack: 001c096b 55c0f7a7 00000000 00000003 00000000 c1421e80 c021dc90 00000001 
       00000000 c1421e90 c021dcb9 00000000 00000003 c1421ec0 c01298f3 c0426f0e 
       c051bd60 c1421ec0 c012a168 c041f0a4 c1421ecc c0430656 c1421ecc c1421ef4 
Call Trace:
 [<c0109177>] show_trace_log_lvl+0x1a/0x30
 [<c010922a>] show_stack_log_lvl+0x9d/0xac
 [<c0109430>] show_registers+0x1f7/0x336
 [<c0109688>] die+0x119/0x21b
 [<c037b992>] do_general_protection+0x1bf/0x1c7
 [<c037b112>] error_code+0x72/0x78
 [<c021dc90>] __delay+0xc/0xe
 [<c021dcb9>] __const_udelay+0x27/0x29
 [<c01298f3>] panic+0xf8/0x101
 [<c04cedb8>] mount_block_root+0x221/0x236
 [<c04cee26>] mount_root+0x59/0x5f
 [<c04cef2e>] prepare_namespace+0x102/0x149
 [<c04ce676>] kernel_init+0x2bf/0x2ce
 [<c0108d4b>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
Code: e2 8d 42 01 e8 cb ff ff ff c9 c3 55 89 e5 57 56 53 83 ec 08 89 45 ec 0f 31 8d 74 26 00 b9 00 00 00 00 89 c6 89 c8 09 f0 89 45 f0 <f3> 90 0f 31 8d 74 26 00 b9 00 00 00 00 89 c6 89 c8 09 f0 2b 45 
EIP: [<c021dcdb>] delay_tsc+0x20/0x42 SS:ESP 0068:c1421e5c
general protection fault: fffa [#2]
PREEMPT SMP 
Modules linked in:
CPU:    0
EIP:    0060:[<c037ae0f>]    Not tainted VLI
EFLAGS: 00000282   (2.6.22-rc1-mm1-paravirt #1391)
EIP is at _spin_unlock_irqrestore+0x44/0x6d
eax: 00000282   ebx: c048cd80   ecx: c01096f7   edx: 00000001
esi: 00000282   edi: 00000068   ebp: c1421dbc   esp: c1421db4
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=c1420000 task=c141f4f0 task.ti=c1420000)
Stack: c1421e24 c1421e5c c1421dec c01096f7 c0420228 00000068 c1421e5c 00000001 
       c048ecd4 c1421e24 00000282 c1421e24 55c34bd8 fffffffa c1421e1c c037b992 
       fffffffa 0000000d 0000000b c011a748 00010000 c11c2000 c141f6c0 00000000 
Call Trace:
 [<c0109177>] show_trace_log_lvl+0x1a/0x30
 [<c010922a>] show_stack_log_lvl+0x9d/0xac
 [<c0109430>] show_registers+0x1f7/0x336
 [<c0109688>] die+0x119/0x21b
 [<c037b992>] do_general_protection+0x1bf/0x1c7
 [<c037b112>] error_code+0x72/0x78
 [<c01096f7>] die+0x188/0x21b
 [<c037b992>] do_general_protection+0x1bf/0x1c7
 [<c037b112>] error_code+0x72/0x78
 [<c021dc90>] __delay+0xc/0xe
 [<c021dcb9>] __const_udelay+0x27/0x29
 [<c01298f3>] panic+0xf8/0x101
 [<c04cedb8>] mount_block_root+0x221/0x236
 [<c04cee26>] mount_root+0x59/0x5f
 [<c04cef2e>] prepare_namespace+0x102/0x149
 [<c04ce676>] kernel_init+0x2bf/0x2ce
 [<c0108d4b>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
Code: 89 d8 e8 7a 4f ea ff f7 c6 00 02 00 00 75 13 89 f0 50 9d 90 8d b4 26 00 00 00 00 e8 0d 9f dc ff eb 11 e8 b0 b4 dc ff 89 f0 50 9d <90> 8d b4 26 00 00 00 00 b8 01 00 00 00 e8 c9 99 da ff 89 e0 25 
EIP: [<c037ae0f>] _spin_unlock_irqrestore+0x44/0x6d SS:ESP 0068:c1421db4
general protection fault: fffa [#3]

    J
