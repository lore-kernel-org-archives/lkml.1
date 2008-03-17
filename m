Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYCQLci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYCQLci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYCQLcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:32:31 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37171 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYCQLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:32:30 -0400
Message-ID: <47DE5665.2030802@bk.jp.nec.com>
Date: Mon, 17 Mar 2008 20:30:45 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] kill_pid_info: don't take now unneeded tasklist_lock
References: <20080304185745.GA8482@tv-sign.ru>
In-Reply-To: <20080304185745.GA8482@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2008/03/05 3:57), Oleg Nesterov wrote:
> Previously handle_stop_signal(SIGCONT) could drop ->siglock. That is why
> kill_pid_info(SIGCONT) takes tasklist_lock to make sure the target task
> can't go away after unlock. Not needed now.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Hi Oleg,

I tried your patches on vanila kernel 2.6.25-rc3 (ia64).  Then, I got
the NULL pointer dereference at task_session_nr(t) in
check_kill_permission(). That is why t->signal->__session is accessed
after t->signal was released.  It is reproducible by sending many
SIGCONT signals to exiting processes.

The trace is as follows:

Pid: 7807, CPU 9, comm:           kill_sigcont
psr : 00001210085a6010 ifs : 800000000000030a ip  : [<a0000001000ab441>]    Not 
tainted (2.6.25-rc3-debug)
ip is at check_kill_permission+0x181/0x2a0
unat: 0000000000000000 pfs : 000000000000038a rsc : 0000000000000003
rnat: 0000000000000206 bsps: 0000000000000003 pr  : 000000000056a999
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000ad510 b6  : a00000010000eb80 b7  : a00000010000eb50
f6  : 000000000000000000000 f7  : 000000000000000000000
f8  : 000000000000000000000 f9  : 000000000000000000000
f10 : 000000000000000000000 f11 : 000000000000000000000
r1  : a000000100cc6a70 r2  : 0000000000000000 r3  : e000001f43f07dc8
r8  : a000000100add08c r9  : a000000100add08c r10 : 0000000000003dc4
r11 : e000001f49d901e4 r12 : e000001f43f07da0 r13 : e000001f43f00000
r14 : 0000000000000012 r15 : 0000000000000000 r16 : a000000100add0a8
r17 : a000000100add0a8 r18 : fb00000000000000 r19 : d800000000000000
r20 : e000001f4493de48 r21 : 0000000000001df6 r22 : 0000000000000100
r23 : e000001f424c5280 r24 : 0000000000000000 r25 : e000001f424c5180
r26 : e000001f49d90b08 r27 : e000001f43f00b08 r28 : 0000000000003dc4
r29 : a000000100adcec0 r30 : a000000100a73a28 r31 : e000001f4493de40

Call Trace:
  [<a000000100014440>] show_stack+0x40/0xa0
                                 sp=e000001f43f077f0 bsp=e000001f43f01060
  [<a000000100014d50>] show_regs+0x850/0x8a0
                                 sp=e000001f43f079c0 bsp=e000001f43f01008
  [<a0000001000360b0>] die+0x1b0/0x2c0
                                 sp=e000001f43f079c0 bsp=e000001f43f00fb8
  [<a000000100036210>] die_if_kernel+0x50/0x80
                                 sp=e000001f43f079c0 bsp=e000001f43f00f88
  [<a0000001005ce7e0>] ia64_fault+0x11a0/0x12c0
                                 sp=e000001f43f079c0 bsp=e000001f43f00f30
  [<a00000010000ab00>] ia64_leave_kernel+0x0/0x270
                                 sp=e000001f43f07bd0 bsp=e000001f43f00f30
  [<a0000001000ab440>] check_kill_permission+0x180/0x2a0
                                 sp=e000001f43f07da0 bsp=e000001f43f00ee0
  [<a0000001000ad510>] group_send_sig_info+0x30/0x100
                                 sp=e000001f43f07da0 bsp=e000001f43f00ea8
  [<a0000001000ad620>] kill_pid_info+0x40/0x80
                                 sp=e000001f43f07db0 bsp=e000001f43f00e70
  [<a0000001000adb30>] sys_kill+0xd0/0x2e0
                                 sp=e000001f43f07db0 bsp=e000001f43f00df0
  [<a00000010000a960>] ia64_ret_from_syscall+0x0/0x20
                                 sp=e000001f43f07e30 bsp=e000001f43f00df0
  [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                 sp=e000001f43f08000 bsp=e000001f43f00df0

Thanks,
-Atsushi Tsuji.

