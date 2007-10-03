Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXJCPlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXJCPlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbXJCPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:41:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbXJCPlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:41:08 -0400
Date: Wed, 3 Oct 2007 17:40:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003154046.GA17256@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 3 Oct 2007, Ingo Molnar wrote:
> > 
> > hm, i just triggered the procfs crash below with -rc9 on a testbox.
> 
> You have a terminally buggy piece of shit compiler.

hm, it's 4.0.2. Not the latest & greatest but i've been using it for 2 
years and this would be the first time it miscompiles a 32-bit kernel 
out of tens of thousands of successful kernel bootups.

>  - and as a result you get an exception on the *next* page:
> 
> 	BUG: unable to handle kernel paging request at virtual address f2a40000

Hm, are you sure? This is a CONFIG_DEBUG_PAGEALLOC=y kernel, so even a 
slight overrun of a non-NIL terminated string (as suspected by Al) could 
run into a non-mapped kernel page. (which would indicate not a compiler 
bug but use-after free)

i just found another config under which i get similar crashes, config 
attached. One common theme is CONFIG_DEBUG_FS and DEBUG_PAGEALLOC - and 
CONFIG_MAC80211_DEBUGFS is not enabled in this one so it's off the hook 
i think. (the crashes are attached below)

(my serial log on this box goes back about 6 months, and that alone 
shows more than 3500 successful kernel bootups on that particular 
testsystem, each kernel built by this compiler - and there's another 
testsystem that i use even more frequently. Despite that, a compiler bug 
is still possible of course.)

	Ingo

--------------->
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa8'
kobject vcsa8: cleaning up
BUG: unable to handle kernel paging request at virtual address f6207000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 0000000036207000
Oops: 0000 [#1]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    1
EIP:    0060:[<c016ecf1>]    Not tainted VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f6206ffe   ebx: c2de0f50   ecx: 0000002b   edx: f6206ffe
esi: f6206007   edi: c2dddfb0   ebp: f6503f18   esp: f6503f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process awk (pid: 1160, ti=f6503000 task=f73a8390 task.ti=f6503000)
Stack: 00000ff9 f6e5cf70 f6206ffe c2dddf80 f6e5cf70 c2dddfb0 f6503f30 c016ce40 
       c05d71b5 f6730f38 f6e5cf70 c2dddfb0 f6503f70 c016f05d 00000400 08098f18 
       f6730f38 f6e5cf90 00000000 0806bc2e 00000003 08094320 f6503fb0 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6503f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#2]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002c   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f6367f18   esp: f6367f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process MAKEDEV (pid: 1170, ti=f6367000 task=f776e390 task.ti=f6367000)
Stack: 00000ff9 f650ef70 f63d0ffe c2dddf80 f650ef70 c2dddfb0 f6367f30 c016ce40 
       c05d71b5 f6473f38 f650ef70 c2dddfb0 f6367f70 c016f05d 00000400 b7f13000 
       f6473f38 f650ef90 00000000 f65eb580 000b7f13 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6367f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#3]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002c   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f6358f18   esp: f6358f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process MAKEDEV (pid: 1174, ti=f6358000 task=f73ae390 task.ti=f6358000)
Stack: 00000ff9 f650ef70 f63d0ffe c2dddf80 f650ef70 c2dddfb0 f6358f30 c016ce40 
       c05d71b5 f6274f38 f650ef70 c2dddfb0 f6358f70 c016f05d 00000400 b7f02000 
       f6274f38 f650ef90 00000000 f65eb7b0 000b7f02 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6358f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#4]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002a   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f6080f18   esp: f6080f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevd (pid: 1176, ti=f6080000 task=f7346390 task.ti=f6080000)
Stack: 00000ff9 f650ef70 f63d0ffe c2dddf80 f650ef70 c2dddfb0 f6080f30 c016ce40 
       c05d71b5 f67b3f38 f650ef70 c2dddfb0 f6080f70 c016f05d 00000400 b7f89000 
       f67b3f38 f650ef90 00000000 f6bb5120 000b7f89 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6080f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#5]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002b   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f597ef18   esp: f597ef00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevsend (pid: 1264, ti=f597e000 task=f778e390 task.ti=f597e000)
Stack: 00000ff9 f650ef70 f63d0ffe c2dddf80 f650ef70 c2dddfb0 f597ef30 c016ce40 
       c05d71b5 f67c5f38 f650ef70 c2dddfb0 f597ef70 c016f05d 00000400 b7f12000 
       f67c5f38 f650ef90 00000000 f6073510 000b7f12 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f597ef00
BUG: unable to handle kernel paging request at virtual address f6207000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 0000000036207000
Oops: 0000 [#6]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    1
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f6206ffe   ebx: c2de0f50   ecx: 0000002b   edx: f6206ffe
esi: f6206007   edi: c2dddfb0   ebp: f5929f18   esp: f5929f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevsend (pid: 1265, ti=f5929000 task=f77af390 task.ti=f5929000)
Stack: 00000ff9 f6e5cf70 f6206ffe c2dddf80 f6e5cf70 c2dddfb0 f5929f30 c016ce40 
       c05d71b5 f6352f38 f6e5cf70 c2dddfb0 f5929f70 c016f05d 00000400 b7f31000 
       f6352f38 f6e5cf90 00000000 f66c9740 000b7f31 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f5929f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#7]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002b   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f6a98f18   esp: f6a98f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevsend (pid: 1266, ti=f6a98000 task=f7397390 task.ti=f6a98000)
Stack: 00000ff9 f650ef70 f63d0ffe c2dddf80 f650ef70 c2dddfb0 f6a98f30 c016ce40 
       c05d71b5 f7359f38 f650ef70 c2dddfb0 f6a98f70 c016f05d 00000400 b7f8a000 
       f7359f38 f650ef90 00000000 f6376dd0 000b7f8a 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6a98f00
BUG: unable to handle kernel paging request at virtual address f6207000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 0000000036207000
Oops: 0000 [#8]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    1
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f6206ffe   ebx: c2de0f50   ecx: 0000002b   edx: f6206ffe
esi: f6206007   edi: c2dddfb0   ebp: f60c0f18   esp: f60c0f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevsend (pid: 1267, ti=f60c0000 task=f6372390 task.ti=f60c0000)
Stack: 00000ff9 f6e5cf70 f6206ffe c2dddf80 f6e5cf70 c2dddfb0 f60c0f30 c016ce40 
       c05d71b5 f6145f38 f6e5cf70 c2dddfb0 f60c0f70 c016f05d 00000400 b7fd2000 
       f6145f38 f6e5cf90 00000000 f6aa4890 000b7fd2 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f60c0f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#9]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002a   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f64c1f18   esp: f64c1f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevstart (pid: 1269, ti=f64c1000 task=f6742390 task.ti=f64c1000)
Stack: 00000ff9 f650ef70 f63d0ffe c2dddf80 f650ef70 c2dddfb0 f64c1f30 c016ce40 
       c05d71b5 f6b22f38 f650ef70 c2dddfb0 f64c1f70 c016f05d 00000400 b7f47000 
       f6b22f38 f650ef90 00000000 f667ecf0 000b7f47 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f64c1f00
fill_kobj_path: path = '/class/input/input0'
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#10]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 00000057   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f588cf18   esp: f588cf00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ls (pid: 1289, ti=f588c000 task=f7346390 task.ti=f588c000)
Stack: 00000ff9 f59bef70 f63d0ffe c2dddf80 f59bef70 c2dddfb0 f588cf30 c016ce40 
       c05d71b5 f6f26f38 f59bef70 c2dddfb0 f588cf70 c016f05d 00000400 b7f48000 
       f6f26f38 f59bef90 00000000 f6376580 000b7f48 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f588cf00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#11]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 00000023   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f55e6f18   esp: f55e6f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process lvm.static (pid: 1329, ti=f55e6000 task=f7769390 task.ti=f55e6000)
Stack: 00000ff9 f59bef70 f63d0ffe c2dddf80 f59bef70 c2dddfb0 f55e6f30 c016ce40 
       c05d71b5 f6592f38 f59bef70 c2dddfb0 f55e6f70 c016f05d 00000400 b7f77000 
       f6592f38 f59bef90 00000000 f66c9900 000b7f77 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c01028e2>] syscall_call+0x7/0xb
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f55e6f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#12]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002b   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f56e0f18   esp: f56e0f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process fsck.ext3 (pid: 1331, ti=f56e0000 task=f7769390 task.ti=f56e0000)
Stack: 00000ff9 f59bef70 f63d0ffe c2dddf80 f59bef70 c2dddfb0 f56e0f30 c016ce40 
       c05d71b5 f67f3f38 f59bef70 c2dddfb0 f56e0f70 c016f05d 00000400 b7dba000 
       f67f3f38 f59bef90 00000000 f60ce510 000b7dba 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c01028e2>] syscall_call+0x7/0xb
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f56e0f00
BUG: unable to handle kernel paging request at virtual address f63d1000
 printing eip:
c016ecf1
*pdpt = 0000000000003001
*pde = 0000000000ac1067
*pte = 00000000363d1000
Oops: 0000 [#13]
SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c016ecf1>]    Tainted: G      D VLI
EFLAGS: 00010297   (2.6.23-rc9 #20)
EIP is at seq_path+0x60/0xca
eax: f63d0ffe   ebx: c2de0f50   ecx: 00000026   edx: f63d0ffe
esi: f63d0007   edi: c2dddfb0   ebp: f5703f18   esp: f5703f00
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process sulogin (pid: 1335, ti=f5703000 task=f7397390 task.ti=f5703000)
Stack: 00000ff9 f59bef70 f63d0ffe c2dddf80 f59bef70 c2dddfb0 f5703f30 c016ce40 
       c05d71b5 f6058f38 f59bef70 c2dddfb0 f5703f70 c016f05d 00000400 b7fcf000 
       f6058f38 f59bef90 00000000 f60ce660 000b7fcf 00000073 00000000 00000000 
Call Trace:
 [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
 [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
 [<c0104083>] show_registers+0x1af/0x281
 [<c0104338>] die+0x11a/0x1e8
 [<c01138d1>] do_page_fault+0x632/0x715
 [<c04e7372>] error_code+0x72/0x80
 [<c016ce40>] show_vfsmnt+0x43/0x120
 [<c016f05d>] seq_read+0xf1/0x269
 [<c0159783>] vfs_read+0x90/0x10e
 [<c0159f9e>] sys_read+0x3f/0x63
 [<c0102876>] sysenter_past_esp+0x5f/0x89
 =======================
Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 
EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f5703f00

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config-crash2

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc9
# Wed Oct  3 17:07:53 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CPUSETS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
CONFIG_M486=y
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=m
# CONFIG_X86_MCE_P4THERMAL is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=m
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_IRQBALANCE=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
# CONFIG_PM is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
CONFIG_HIBERNATION_SMP_POSSIBLE=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
# CONFIG_HOTPLUG_PCI_PCIE_POLL_EVENT_MODE is not set
# CONFIG_PCIEAER is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_K8_NB=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=m
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=m
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=m
# CONFIG_IP_VS_NQ is not set

#
# IPVS application helper
#
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK_ENABLED is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_NF_ARPTABLES=y
# CONFIG_IP_NF_ARPFILTER is not set
CONFIG_IP_NF_ARP_MANGLE=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_RR is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_CLS_POLICE=y
# CONFIG_NET_CLS_IND is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_L2CAP is not set
# CONFIG_BT_SCO is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=m
CONFIG_NET_9P=m
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
# CONFIG_PNPACPI is not set
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=m
CONFIG_SATA_SIL24=y
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=m
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=y
CONFIG_PATA_CYPRESS=m
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_LEGACY=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_QDI=y
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=m
CONFIG_PATA_WINBOND_VLB=m
CONFIG_PATA_PLATFORM=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set

#
# Fusion MPT device support
#
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=m
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m

#
# Subsystem Options
#
CONFIG_IEEE1394_VERBOSEDEBUG=y

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_IFB is not set
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=m
CONFIG_EL2=m
CONFIG_ELPLUS=y
CONFIG_EL16=m
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=m
CONFIG_LANCE=m
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
CONFIG_DEPCA=y
CONFIG_HP100=y
CONFIG_NET_ISA=y
CONFIG_E2100=y
CONFIG_EWRK3=m
CONFIG_EEXPRESS=m
# CONFIG_EEXPRESS_PRO is not set
CONFIG_HPLAN_PLUS=y
CONFIG_HPLAN=m
CONFIG_LP486E=m
# CONFIG_ETH16I is not set
CONFIG_NE2000=m
# CONFIG_ZNET is not set
CONFIG_SEEQ8005=y
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
CONFIG_APRICOT=m
CONFIG_B44=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
# CONFIG_CS89x0 is not set
# CONFIG_DGRS is not set
CONFIG_EEPRO100=y
CONFIG_E100=y
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=m
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_SIS900 is not set
CONFIG_EPIC100=m
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=m
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_RHINE_NAPI=y
CONFIG_SC92031=y
# CONFIG_NET_POCKET is not set
# CONFIG_NETDEV_1000 is not set
CONFIG_E1000=y
# CONFIG_NETDEV_10000 is not set
CONFIG_MLX4_CORE=m
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
CONFIG_WAN=y
CONFIG_HOSTESS_SV11=m
# CONFIG_COSA is not set
CONFIG_LANMEDIA=y
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=y
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=m
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300=y
CONFIG_PC300_MLPPP=y

#
# Cyclades-PC300 MLPPP support is disabled.
#

#
# Refer to the file README.mlppp, provided by PC300 package.
#
CONFIG_PC300TOO=y
CONFIG_N2=m
CONFIG_C101=m
CONFIG_FARSYNC=y
# CONFIG_DSCC4 is not set
# CONFIG_DLCI is not set
# CONFIG_LAPBETHER is not set
CONFIG_X25_ASY=m
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
CONFIG_NET_FC=y
CONFIG_SHAPER=m
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=m
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1ISA is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
# CONFIG_ISDN_DIVAS_BRIPCI is not set
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_TIPAR=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=m
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=m
# CONFIG_WDT_501_PCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y
CONFIG_AGP=m
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=m
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_ATMEL=y
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_I810 is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
CONFIG_I2C_SIMTEC=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
CONFIG_SENSORS_DS1374=m
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
CONFIG_SENSORS_PCA9539=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y

#
# SPI support
#
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_LM70_LLP=m

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=m
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=m

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=y
# CONFIG_DVB_CORE_ATTACH is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_IMSTT=y
CONFIG_FB_HECUBA=m
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
# CONFIG_FB_INTEL_I2C is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=y
# CONFIG_FB_TRIDENT_ACCEL is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_SM501=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
# CONFIG_LOGO is not set

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
# CONFIG_SND is not set

#
# Open Sound System
#
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_TRIDENT is not set
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
CONFIG_HID_FF=y
# CONFIG_HID_PID is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_PANTHERLORD_FF=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_ZEROPLUS_FF=y
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_DPCM=y
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_AIRPRIME=m
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_WHITEHEAT=m
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP2101=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_NAVMAN=m
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_DEBUG is not set
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=m
# CONFIG_USB_AUERSWALD is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=y

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_INFINIBAND_ISER is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_MAX6902=m

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
CONFIG_UIO=m
CONFIG_UIO_CIF=m

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=y
# CONFIG_EXT4DEV_FS_XATTR is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_SECURITY=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_NOLOCK is not set
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_MINIX_FS=y
CONFIG_ROMFS_FS=m
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set

#
# Network File Systems
#
CONFIG_NFS_FS=m
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_TCP is not set
CONFIG_LOCKD=m
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_BIND34 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
CONFIG_CODA_FS_OLD_API=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set
CONFIG_INSTRUMENTATION=y
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_KOBJECT=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
CONFIG_FRAME_POINTER=y
CONFIG_FORCED_INLINING=y
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
# CONFIG_DOUBLEFAULT is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ABLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

--OgqxwSJOaUobr8KG--
