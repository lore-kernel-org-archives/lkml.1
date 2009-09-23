Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZIWW6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZIWW6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZIWW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:58:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37763 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZIWW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:58:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=itot8aX1IpiXXFD8a3trfocmISzhUJYWZAtMbJnKvJzk6/eYp13a5mizDl5N8lntI
	wusLyUryEAExYhHaq2ixQ==
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 15:58:47 -0700
Message-ID: <88cc3e770909231558u5109aca1u1409ba6877a6c8f@mail.gmail.com>
Subject: jbd/kjournald oops on 2.6.30.1
From: Abhijit Karmarkar <awk@google.com>
To: ext3-users@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting the following Oops on 2.6.30.1 kernel. The bad part is,
it happens rarely (twice in last 1.5 months) and the system is pretty
lightly loaded when this happens (no heavy file/disk io).

Any insights or patches that I can try? (i searched lkml and ext3
lists but could not find any similar oops/reports).


== Oops ===================
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff80373520>] __journal_remove_journal_head+0x10/0x120
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/class/scsi_host/host0/proc_name
CPU 0
Pid: 3834, comm: kjournald Not tainted 2.6.30.1_test #1
RIP: 0010:[<ffffffff80373520>]  [<ffffffff80373520>]
__journal_remove_journal_head+0x10/0x120
RSP: 0018:ffff880c7ee11d80  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000034
RDX: 0000000000000002 RSI: ffff8804ee82aa20 RDI: ffff8804ee82aa20
RBP: ffff880c7ee11d90 R08: 0400000000000000 R09: 0000000000000000
R10: ffffffff803706af R11: 0000000000000000 R12: ffff8808659bc198
R13: 0000000000000001 R14: ffff880bd435a980 R15: ffff880c7959d000
FS:  0000000000000000(0000) GS:ffff88006d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald (pid: 3834, threadinfo ffff880c7ee10000, task
ffff880c794900c0)
Stack:
ffff8804ee82aa20 ffff8808659bc198 ffff880c7ee11db0 ffffffff80374fd4
ffff880c7ee11db0 ffff8804ee82aa20 ffff880c7ee11e90 ffffffff8037073d
ffff880c7959d3a8 ffff880c7ee11e48 ffff880c7959d028 ffff880c7959d338
Call Trace:
[<ffffffff80374fd4>] journal_remove_journal_head+0x24/0x50
[<ffffffff8037073d>] journal_commit_transaction+0x41d/0x1150
[<ffffffff8024f8cc>] ? try_to_del_timer_sync+0x5c/0x70
[<ffffffff8037498f>] kjournald+0xff/0x270
[<ffffffff8025c370>] ? autoremove_wake_function+0x0/0x40
[<ffffffff80374890>] ? kjournald+0x0/0x270
[<ffffffff8025bf63>] kthread+0x63/0x90
[<ffffffff8020cffa>] child_rip+0xa/0x20
[<ffffffff8025bf00>] ? kthread+0x0/0x90
[<ffffffff8020cff0>] ? child_rip+0x0/0x20
Code: 1f 44 00 00 48 89 f8 48 8b 3d 7d 0d ca 00 48 89 c6 e8 85 35 f5
ff c9 c3 0f 1f 00 55 48 89 e5 41 54 53 0f 1f 44 00 00 48 8b 5f 40 <8b>
4b 08 85 c9 0f 88 f2 00 00 00 f0 ff 47 60 8b 53 08 85 d2 75
RIP  [<ffffffff80373520>] __journal_remove_journal_head+0x10/0x120
RSP <ffff880c7ee11d80>
CR2: 0000000000000008
---[ end trace 2a47799c65258934 ]---



Looking at the disassembly of journal_remove_head():
==============
0xffffffff8037b760 <__journal_remove_journal_head+0>:   push   %rbp
0xffffffff8037b761 <__journal_remove_journal_head+1>:   mov    %rsp,%rbp
0xffffffff8037b764 <__journal_remove_journal_head+4>:   push   %r12
0xffffffff8037b766 <__journal_remove_journal_head+6>:   push   %rbx
0xffffffff8037b767 <__journal_remove_journal_head+7>:   callq
0xffffffff8020bcc0 <mcount>
0xffffffff8037b76c <__journal_remove_journal_head+12>:  mov    0x40(%rdi),%rbx
0xffffffff8037b770 <__journal_remove_journal_head+16>:  mov
0x8(%rbx),%r8d     <====== Oops
0xffffffff8037b774 <__journal_remove_journal_head+20>:  test   %r8d,%r8d
0xffffffff8037b777 <__journal_remove_journal_head+23>:  js
0xffffffff8037b86d <__journal_remove_journal_head+269>
0xffffffff8037b77d <__journal_remove_journal_head+29>:  lock incl 0x60(%rdi)
0xffffffff8037b781 <__journal_remove_journal_head+33>:  mov    0x8(%rbx),%esi
0xffffffff8037b784 <__journal_remove_journal_head+36>:  test   %esi,%esi
0xffffffff8037b786 <__journal_remove_journal_head+38>:  jne
0xffffffff8037b78f <__journal_remove_journal_head+47>
0xffffffff8037b788 <__journal_remove_journal_head+40>:  cmpq   $0x0,0x28(%rbx)
0xffffffff8037b78d <__journal_remove_journal_head+45>:  je
0xffffffff8037b794 <__journal_remove_journal_head+52>
.......
.......
==============


The oops seems be due to NULL journal head while evaluating J_ASSERT_JH() macro:
==============
static void __journal_remove_journal_head(struct buffer_head *bh)
{
       struct journal_head *jh = bh2jh(bh);
       J_ASSERT_JH(jh, jh->b_jcount >= 0);  <=== jh is NULL
       get_bh(bh);
       if (jh->b_jcount == 0) {
               if (jh->b_transaction == NULL &&
....
=============

Not sure why would that happen (corruption?).


Few system details:
================
- 64-bit, 2 quad-core (total 8 cores) Xeon, 48GB RAM
- Stock 2.6.30.1 kernel, *no* modules
- ext3 file-system (data=ordered mode) used over encrypted (dmcrypt) disks.
- underlying storage: h/w RAID.
- ext*/jbd config values:

CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
===================

Let me know if you need any more details. Reproducing this (or finding
a good test to trigger this) is proving to be difficult :-( It sorta
oops once in a while ;-)


thanks
abhijit

ps: please Cc: me the replies. I am not subscribed to either of the
lists -- thanks!
