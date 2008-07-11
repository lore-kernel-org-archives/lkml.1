Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYGKAMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYGKAMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYGKAMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:12:31 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57073 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754689AbYGKAMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:12:30 -0400
Message-ID: <4876A56C.3050707@sgi.com>
Date: Thu, 10 Jul 2008 17:12:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org> <487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org> <48764C7C.5010309@goop.org> <48767692.4080504@linux-foundation.org> <487677F0.4000404@goop.org> <4876799B.7010204@linux-foundation.org> <48767F4F.1010209@zytor.com>
In-Reply-To: <48767F4F.1010209@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
...
> -- I believe 2 MB mappings are too large, except perhaps as an option.
> 
>     -hpa

Hmm, that might be the way to go.... At boot up time determine the
size of the system in terms of cpu count and memory available and
attempt to do the right thing, with startup options to override the
internal choices... ?

(Surely a system that has a "gazillion ip tunnels" could modify it's
kernel start options... ;-)

Unfortunately, we can't use a MODULE to support different options unless
we change how the kernel starts up (would need to mount the root fs
before starting secondary cpus.)

Btw, the "zero_based_only" patch (w/o the pda folded into the percpu
area) gets to the point shown below.  Dropping NR_CPUS from 4096 to 256
clears up the error.  So except for the "stack overflow" message I got
yesterday, the result is the same.  As soon as I get a chance, I'll try
it out with gcc-4.2.0 to see if it changed the boot up problem.

Thanks,
Mike

[    0.096000] ACPI: Core revision 20080321
[    0.108889] Parsing all Control Methods:
[    0.116198] Table [DSDT](id 0001) - 364 Objects with 40 Devices 109 Methods 20 Regions
[    0.124000] Parsing all Control Methods:
[    0.128000] Table [SSDT](id 0002) - 43 Objects with 0 Devices 16 Methods 0 Regions
[    0.132000]  tbxface-0598 [02] tb_load_namespace     : ACPI Tables successfully acquired
[    0.148000] evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
[    0.200000] CPU0: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
[    0.211685] Using local APIC timer interrupts.
[    0.220000] APIC timer calibration result 20781901
[    0.224000] Detected 20.781 MHz APIC timer.
[    0.228000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[    0.228000] IP: [<0000000000000000>]
[    0.228000] PGD 0
[    0.228000] Oops: 0010 [1] SMP
[    0.228000] CPU 0
[    0.228000] Pid: 1, comm: swapper Not tainted 2.6.26-rc8-tip-ingo-test-0701-00208-g79a4d68-dirty #7
[    0.228000] RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
[    0.228000] RSP: 0000:ffff81022ed1fe18  EFLAGS: 00010286
[    0.228000] RAX: 0000000000000000 RBX: ffff81022ed1fe84 RCX: ffffffff80d0de80
[    0.228000] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffffffff80d0de80
[    0.228000] RBP: ffff81022ed1fe50 R08: ffff81022ed1fe84 R09: ffffffff80e28ae0
[    0.228000] R10: ffff81022ed1fe80 R11: ffff81022ed39188 R12: 00000000ffffffff
[    0.228000] R13: ffffffff80d0de40 R14: 0000000000000001 R15: 0000000000000003
[    0.228000] FS:  0000000000000000(0000) GS:ffffffff80de69c0(0000) knlGS:0000000000000000
[    0.228000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    0.228000] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[    0.228000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.228000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.228000] Process swapper (pid: 1, threadinfo ffff81022ed10000, task ffff81022ec93100)
[    0.228000] Stack:  ffffffff8024f34c 0000000000000000 0000000000000001 0000000000000001
[    0.228000]  00000000fffffff0 ffffffff80e8e4e0 0000000000092fd0 ffff81022ed1fe60
[    0.228000]  ffffffff8024f3cc ffff81022ed1fea0 ffffffff808ef5b8 0000000000000008
[    0.228000] Call Trace:
[    0.228000]  [<ffffffff8024f34c>] ? notifier_call_chain+0x38/0x60
[    0.228000]  [<ffffffff8024f3cc>] __raw_notifier_call_chain+0xe/0x10
[    0.228000]  [<ffffffff808ef5b8>] cpu_up+0xa8/0x138
[    0.228000]  [<ffffffff80e4d9b9>] kernel_init+0xdf/0x327
[    0.228000]  [<ffffffff8020d4b8>] child_rip+0xa/0x12
[    0.228000]  [<ffffffff8020c955>] ? restore_args+0x0/0x30
[    0.228000]  [<ffffffff80e4d8da>] ? kernel_init+0x0/0x327
[    0.228000]  [<ffffffff8020d4ae>] ? child_rip+0x0/0x12
[    0.228000]
[    0.228000]
[    0.228000] Code:  Bad RIP value.
[    0.228000] RIP  [<0000000000000000>]
[    0.228000]  RSP <ffff81022ed1fe18>
[    0.228000] CR2: 0000000000000000
[    0.232000] ---[ end trace a7919e7f17c0a725 ]---
[    0.236000] Kernel panic - not syncing: Attempted to kill init!


