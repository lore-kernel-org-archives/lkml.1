Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXIMHE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXIMHE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXIMHEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:04:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:16805 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXIMHEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H5ThkJsU4uNjUJXyFMEggjqd8KCrJ6ZHcV82LAxQ0MaxgCulKTFnxfaqNjMDP0hjmdjmO8YjcYHIKg0PqrOQI3qyRTPxxc5yEyeJhhukNkn88247Nhv4vReJXXPGXZE9yRw8+5lE7FLrOLHQsmQ1wDakqBbcGe7EOyf8YCv6+3g=
Message-ID: <2bd9ebfa0709130004h79db9a3p5331b5063fb53add@mail.gmail.com>
Date: Thu, 13 Sep 2007 12:34:46 +0530
From: TEJ <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: strange interaction of struct sock between PF_INET and PF_UNIX stack
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello LKML


I am testing a customized TCP/IP offloaded stack code. Its working
fine with basic data transmission in between two peers. After 6-7
packet transmission it suddnely  give me null pointer dereference bug.
The null pointer bug comes at unix datagram sockets. I don't
understand the interaction of TCP/IP sock object with the unix
datagram socket. the bug details has been attached

1. this is the first bug

<1>[  637.540746] BUG: unable to handle kernel NULL pointer
dereference at virtual address 00000004
<1>[  637.549320]  printing eip:
<4>[  637.552047] c126cd6e
<1>[  637.552049] *pde = 00000000
<0>[  637.554869] Oops: 0002 [#1]
<0>[  637.557687] SMP DEBUG_PAGEALLOC
<4>[  637.560972] Modules linked in: dcxgb3 upcxgb3 locxgb3 uhci_hcd
intel_agp agpgart
<0>[  637.568675] CPU:    0
<4>[  637.568676] EIP:    0060:[<c126cd6e>]    Not tainted VLI
<4>[  637.568677] EFLAGS: 00010006   (2.6.18-debug #3)
<0>[  637.581026] EIP is at skb_dequeue+0x2e/0x60
<0>[  637.585228] eax: 00000000   ebx: f7b1c734   ecx: c1fcf530   edx: 00000286
[0]more>
<0>[  637.592042] esi: f595dd80   edi: f7b1c740   ebp: f6791d1c   esp: f6791d10
<0>[  637.598849] ds: 007b   es: 007b   ss: 0068
<0>[  637.602974] Process syslogd (pid: 3710, ti=f6790000
task=c1fcf530 task.ti=f6790000)
<0>[  637.610479] Stack: 000003fe f7b1c680 f6791dbc f6791d54 c127033c
f7b1c734 f7b1c734 7fffffff
<0>[  637.619233]        00000000 f7b1c8ac f6791f20 f6791dbc f6791d54
c12e9199 000003fe f6791f20
<0>[  637.627990]        f6791dbc f6791da0 c12ca1ab f7b1c680 00000000
00000000 f6791d90 00000001
<0>[  637.636745] Call Trace:
<4>[  637.639447]  [<c1004831>] show_stack_log_lvl+0xb1/0xe0
<4>[  637.644655]  [<c1004a65>] show_registers+0x1b5/0x240
<4>[  637.649682]  [<c1004c2e>] die+0x13e/0x390
<4>[  637.653755]  [<c12ec0bc>] do_page_fault+0x32c/0x670
<4>[  637.658698]  [<c1004341>] error_code+0x39/0x40
<4>[  637.663205]  [<c127033c>] skb_recv_datagram+0x13c/0x210
<4>[  637.668490]  [<c12ca1ab>] unix_dgram_recvmsg+0x7b/0x240
<4>[  637.673777]  [<c1267485>] sock_recvmsg+0xe5/0x110
<4>[  637.678543]  [<c1268e97>] sys_recvfrom+0x97/0x100
<4>[  637.683311]  [<c1268f36>] sys_recv+0x36/0x40
<4>[  637.687645]  [<c1269373>] sys_socketcall+0x163/0x260
<4>[  637.692673]  [<c1003793>] syscall_call+0x7/0xb
<0>[  637.697180] Code: 83 ec 0c 89 1c 24 8b 5d 08 89 7c 24 08 89 74
24 04 8d 7b 0c 89 f8 e8 b2 dd 07 00 8b 33 39 f3 89 c2 7
<0>[  637.718832] EIP: [<c126cd6e>] skb_dequeue+0x2e/0x60 SS:ESP 0068:f6791d10
<4>[  637.725643]
[0]kdb>

dcxgb3: driver code
upcxgb3 and locxgb3: TCP/IP stack code.


2. the second bug

after a delay of 10-15 second a softlock up bug raises.

<0>[  637.718832] EIP: [<c126cd6e>] skb_dequeue+0x2e/0x60 SS:ESP 0068:f6791d10
<4>[  637.725643]  <0>BUG: spinlock lockup on CPU#1, klogd/3746, f7b1c740
<4>[  899.151233]  [<c10048ab>] show_trace+0x1b/0x20
<4>[  899.155936]  [<c1004ff6>] dump_stack+0x26/0x30
<4>[  899.160643]  [<c114b160>] _raw_spin_lock+0x110/0x150
<4>[  899.165872]  [<c12eab60>] _spin_lock_irqsave+0x50/0x60
<4>[  899.171289]  [<c126cc51>] skb_queue_tail+0x21/0x50
<4>[  899.176357]  [<c12c8f5c>] unix_dgram_sendmsg+0x42c/0x510
<4>[  899.181938]  [<c1267074>] do_sock_write+0xb4/0xc0
<4>[  899.186920]  [<c1267807>] sock_aio_write+0x67/0x70
<4>[  899.191974]  [<c1067ea9>] do_sync_write+0xb9/0xf0
<4>[  899.196936]  [<c10689c0>] vfs_write+0x190/0x1a0
<4>[  899.201731]  [<c1069107>] sys_write+0x47/0x70
<4>[  899.206367]  [<c1003793>] syscall_call+0x7/0xb


and i am sure these two bugs are inter-related..
System Details:
Linux helvella 2.6.18-debug #3 SMP Fri Aug 10 14:08:20 IST 2007 i686 GNU/Linux


any suggestion why this interaction is happening.
or what i am doing wrong?

thank you
