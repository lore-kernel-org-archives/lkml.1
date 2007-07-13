Return-Path: <linux-kernel-owner+w=401wt.eu-S936777AbXGMSTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936777AbXGMSTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbXGMSTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:19:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:56304 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759669AbXGMSTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:19:08 -0400
Date: Fri, 13 Jul 2007 11:19:07 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: linux-kernel@vger.kernel.org
Subject: POSIX timer deletion race?
Message-ID: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 13 Jul 2007 18:19:08.0253 (UTC) FILETIME=[4DA290D0:01C7C57A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[also sent to George Anzinger]

Hi,

I'm seeing a problem related to deleting posix timers.

Using a moderately patched 2.6.14 kernel, I am encountering a trio of BUGs 
involving the posix timers.  This is running on an SMP xeon (Intel MPCBL 
0030 and 0001) system with 200 threads managing a large number of timers.

The issue appears to be that itimer_delete() and sys_timer_delete() both do 
something along the lines of this:

sys_timer_delete(timer_t timer_id)
{
         ...
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
         return 0;

As such, there's a window of opportunity for something else to grab the timer 
and attempt an operation of one sort or another.  Eventually, either 
sigqueue_free() or send_sigqueue() detect that the signal queue has been 
deleted, and call BUG_ON:

kernel/signal.c:
void sigqueue_free(struct sigqueue *q)
{
         unsigned long flags;
         BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
         ...

Reading the kernel.org pristine 2.6.22, the same sequence occurs.

kernel BUG at <bad filename>:52971!
invalid operand: 0000 [#1]
SMP
LTT NESTING LEVEL : 0
Modules linked in: ipmi_watchdog ipmi_si ipmi_devintf ipmi_msghandler 
softdog b
in
fmt_misc video thermal processor fan button battery ac sctp uhci_hcd 
usbcore ip
6_
tables ip_tables ipv6
CPU:    0
EIP:    0060:[<c0138fdb>]    Not tainted VLI
EFLAGS: 00010246   (2.6.14.7-selinux1-WR1.4aq_cgl)
EIP is at sigqueue_free+0x3b/0x7d
eax: 00000000   ebx: de28f9c4   ecx: ddcd9e60   edx: 00000292
esi: de3336f8   edi: 00000000   ebp: df829f90   esp: df829f8c
ds: 007b   es: 007b   ss: 0068
Process hrtm_test (pid: 16282, threadinfo=df829000 task=dfe9d350)
Stack: 00000292 df829fa0 c013ff57 df829000 de3336f8 df829fb4 c0140802 
00000286
        000003b9 00000000 df829000 c039e3ec 000003b9 4a248ff4 5a019aa0 
00000000
        00000000 b42fc3c8 00000107 c039007b 0000007b 00000107 4a2460c0 
00000073
Call Trace:
  [<c0103fad>] show_stack+0x7a/0x90
  [<c010412b>] show_registers+0x14f/0x1c7
  [<c010516b>] die+0x11a/0x195
  [<c039ff79>] do_trap+0x1991/0x205b
  [<c0105417>] do_invalid_op+0xa3/0xad
  [<c0103cdb>] error_code+0x4f/0x54
  [<c013ff57>] release_posix_timer+0x1b/0x7b
  [<c0140802>] sys_timer_delete+0xd9/0x10f
  [<c039e3ec>] no_syscall_entry_trace+0xb/0xf
Code: 2e 83 e0 fe 89 43 0c 8b 83 90 00 00 00 f0 ff 48 0c 8b 83 90 00 00 00 
e8 6
6
df ff ff 89 da a1 e0 ea 4b c0 e8 69 56 02 00 5b 5d c3 <0f> 0b eb ce b8 00 
3e 46
  c
0 e8 61 50 26 00 8b 43 08 e8 69 50 26


The other two occur via calls to itimer_delete(), and posix_timer_event(), in 
similar fashion.  Unfortunately, I don't have test code that I can share.


Version details:
Linux thermopolis-1 
2.6.14.7-selinux1-WR1.4aq_cgl #18 SMP Thu 
Jul 12 20:03:02 PDT 2007 i686 GNU/Linux

Gnu C                  3.4.4
util-linux             2.12
mount                  2.12
module-init-tools      3.2.2
e2fsprogs              1.38
reiserfsprogs          3.6.19
xfsprogs               2.7.11
PPP                    2.4.3
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.6
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
udev                   079
Modules Loaded         ipmi_watchdog 
sd_mod ipmi_si ipmi_devintf 
ipmi_msghandler softdog binfmt_misc video 
thermal processor fan button battery ac 
usb_storage scsi_mod sctp uhci_hcd usbcore 
ip6_tables ip_tables ipv6


-------------------------------- 
Jeremy Katz, Senior Engineer, Wind River
Telephone: +1 510 749 2901
