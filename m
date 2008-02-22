Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbYBVTCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbYBVTCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbYBVTBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:01:53 -0500
Received: from gw.goop.org ([64.81.55.164]:43243 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbYBVTBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:01:52 -0500
Message-ID: <47BF1B8F.5090701@goop.org>
Date: Fri, 22 Feb 2008 10:59:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Xen-devel] [PATCH] let XEN depend on PAE
References: <47BEAB48.7050900@nets.rwth-aachen.de> <47BEFA4C.6030400@goop.org> <47BEFE55.7020703@nets.rwth-aachen.de>
In-Reply-To: <47BEFE55.7020703@nets.rwth-aachen.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:
> This is with 2.6.24.2, but latest-git looks the same:
> I also tried with 2.6.23 which crashes instantly, without any output of the guest.
>   

I'm not too surprised.  Non-PAE Xen is a bit of a rarity, and it only 
gets tested rarely.  Chris Wright did spend some time on it a while ago, 
but I don't know that its had any real attention since.  I've been 
making sure non-PAE compiles, but I've been lax about testing it.

This is the first usermode exec, I guess?  The backtrace is a bit odd; 
I've never seen a problem in move_page_tables before.

Does "xm dmesg" tell you what Xen is complaining about?  You may need to 
compile with debug=y in Config.mk.

> [    0.599806] 1 multicall(s) failed: cpu 0
> [    0.599816]   call  1/2: op=26 arg=[c1051860] result=0
> [    0.599825]   call  2/2: op=14 arg=[bf9c7000] result=-22
> [    0.599841] ------------[ cut here ]------------
> [    0.599851] kernel BUG at arch/x86/xen/multicalls.c:103!
> [    0.599861] invalid opcode: 0000 [#1] SMP
> [    0.599871] Modules linked in:
> [    0.599879]
> [    0.599885] Pid: 1, comm: init Not tainted (2.6.24.2 #6)
> [    0.599895] EIP: 0061:[<c0101b7c>] EFLAGS: 00010202 CPU: 0
> [    0.599910] EIP is at xen_mc_flush+0x19c/0x1b0
> [    0.599919] EAX: 00000000 EBX: c10510a0 ECX: c1051060 EDX: c1051060
> [    0.599930] ESI: 00000002 EDI: 00000001 EBP: c2417c10 ESP: c2417be4
> [    0.599940]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
> [    0.599951] Process init (pid: 1, ti=c2417000 task=c2416ab0 task.ti=c2417000)
> [    0.599960] Stack: c0443c98 00000002 00000002 0000000e bf9c7000 ffffffea c1051060 00000200
> [    0.599984]        00000067 c193fffc bf9c7000 c2417c18 c0101112 c2417c5c c0166dfc c193ce40
> [    0.600006]        c193e5c0 c0000000 c193e5c0 00001000 c0000000 c193ce40 c198e71c c10331cc
> [    0.600029] Call Trace:
> [    0.600036]  [<c0107a6a>] show_trace_log_lvl+0x1a/0x30
> [    0.600050]  [<c0107b29>] show_stack_log_lvl+0xa9/0xd0
> [    0.600062]  [<c0107c1a>] show_registers+0xca/0x1e0
> [    0.600074]  [<c0107e4a>] die+0x11a/0x250
> [    0.600085]  [<c0108003>] do_trap+0x83/0xb0
> [    0.600096]  [<c0108318>] do_invalid_op+0x88/0xa0
> [    0.600108]  [<c03e89d2>] error_code+0x72/0x80
> [    0.600121]  [<c0101112>] xen_leave_lazy+0x12/0x20
> [    0.600134]  [<c0166dfc>] move_page_tables+0x27c/0x300
> [    0.600149]  [<c0174762>] setup_arg_pages+0x162/0x2a0
> [    0.600162]  [<c019cad3>] load_elf_binary+0x3d3/0x1bd0
> [    0.600175]  [<c0173f92>] search_binary_handler+0x92/0x200
> [    0.600190]  [<c019b1ef>] load_script+0x1bf/0x200
> [    0.600202]  [<c0173f92>] search_binary_handler+0x92/0x200
> [    0.600215]  [<c0175bab>] do_execve+0x15b/0x180
> [    0.600227]  [<c0104a2e>] sys_execve+0x2e/0x80
> [    0.600241]  [<c0106342>] syscall_call+0x7/0xb
> [    0.600253]  =======================
> [    0.600259] Code: 24 08 89 44 24 0c 89 74 24 04 c7 04 24 98 3c 44 c0 e8 c9 36 02 00 8b 45 ec 83 c3 20 8b 90 00 0b 00 00 39 d6 72 c0 e9 04 ff ff ff <0f> 0b eb fe 0f 0b eb fe 8d b6 00 00 00 00 8d bf 00 00 00 00 55
> [    0.600370] EIP: [<c0101b7c>] xen_mc_flush+0x19c/0x1b0 SS:ESP e021:c2417be4
> [    0.600393] ---[ end trace a686db401f06e173 ]---
> [    0.600403] Kernel panic - not syncing: Attempted to kill init!
>
> full dmesg, config here:
> http://lists.xensource.com/archives/html/xen-devel/2008-02/msg00716.html
>
> Best regards,
> Arnd Hannemann
>
>   

    J
