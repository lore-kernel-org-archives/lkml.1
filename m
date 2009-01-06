Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZAFRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZAFRfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZAFRfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:35:42 -0500
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:50004 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbZAFRfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:35:40 -0500
Date: Tue, 6 Jan 2009 20:35:39 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Lock-up on PPC64
In-Reply-To: <1231243373.14860.24.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0901062032550.2972@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
 <1230165163.7292.32.camel@pasglop> <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
 <1231158516.8367.3.camel@localhost> <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
 <1231243373.14860.24.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Benjamin Herrenschmidt wrote:

> On Mon, 2009-01-05 at 19:34 +0300, malc wrote:
>> Before this change (atleast) mono_handle_native_sigsegv was executed
>> (before machine locks-up hard) after the change this code path is
>> never touched.
>>
>> The fact that machine locks up hard and not even magic sysrq works
>> is what deserves a better look.
>
> Indeed. It's possible that the normally not hit error case is triggering
> a different bug. Definitely worth looking at.
>
> I didn't have a chance so far, I'm a bit swamped at the moment, but keep
> pining me please :-)
>

As you wish :) I've written some ad-hoc stuff in the failing path which 
manually triggers sysrq and then sends the klogctl output via network
and here it is:

<6>SysRq : Show State
<6>  task                        PC stack   pid father
<4>init          S 000000000ff23a7c     0     1      0
<4>Call Trace:
<4>[c000000000d87370] [c000000000d87410] 0xc000000000d87410 (unreliable)
<4>[c000000000d87540] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000d875d0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000d876c0] [c0000000005a3d58] .schedule_timeout+0xa8/0xe8
<4>[c000000000d87790] [c0000000000ed4f4] .do_select+0x410/0x4b0
<4>[c000000000d87b10] [c0000000001182bc] .compat_core_sys_select+0x18c/0x25c
<4>[c000000000d87d00] [c000000000119e60] .compat_sys_select+0xb0/0x190
<4>[c000000000d87dc0] [c000000000014e3c] .ppc32_select+0x14/0x28
<4>[c000000000d87e30] [c000000000008534] syscall_exit+0x0/0x40
<4>kthreadd      S 0000000000000000     0     2      0
<4>Call Trace:
<4>[c000000000d8bbb0] [c000000000d8bc50] 0xc000000000d8bc50 (unreliable)
<4>[c000000000d8bd80] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000d8be10] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000d8bf00] [c0000000000852bc] .kthreadd+0x98/0x1bc
<4>[c000000000d8bf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>migration/0   S 0000000000000000     0     3      2
<4>Call Trace:
<4>[c000000007fc7ad0] [c000000007fc7b70] 0xc000000007fc7b70 (unreliable)
<4>[c000000007fc7ca0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000007fc7d30] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000007fc7e20] [c000000000067148] .migration_thread+0x228/0x3fc
<4>[c000000007fc7f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000007fc7f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ksoftirqd/0   S 0000000000000000     0     4      2
<4>Call Trace:
<4>[c000000007fcbb30] [c000000007fcbbd0] 0xc000000007fcbbd0 (unreliable)
<4>[c000000007fcbd00] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000007fcbd90] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000007fcbe80] [c000000000071dd8] .ksoftirqd+0x48/0xd4
<4>[c000000007fcbf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000007fcbf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>watchdog/0    S 0000000000000000     0     5      2
<4>Call Trace:
<4>[c000000007fcfb20] [c000000007fcfbe0] 0xc000000007fcfbe0 (unreliable)
<4>[c000000007fcfcf0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000007fcfd80] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000007fcfe70] [c0000000000a1540] .watchdog+0x48/0x70
<4>[c000000007fcff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000007fcff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>migration/1   S 0000000000000000     0     6      2
<4>Call Trace:
<4>[c000000007fdbad0] [c000000007fdbb70] 0xc000000007fdbb70 (unreliable)
<4>[c000000007fdbca0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000007fdbd30] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000007fdbe20] [c000000000067148] .migration_thread+0x228/0x3fc
<4>[c000000007fdbf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000007fdbf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ksoftirqd/1   S 0000000000000000     0     7      2
<4>Call Trace:
<4>[c0000000010ebb30] [c0000000010ebbd0] 0xc0000000010ebbd0 (unreliable)
<4>[c0000000010ebd00] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0000000010ebd90] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0000000010ebe80] [c000000000071dd8] .ksoftirqd+0x48/0xd4
<4>[c0000000010ebf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0000000010ebf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>watchdog/1    S 0000000000000000     0     8      2
<4>Call Trace:
<4>[c0000000010efb20] [c0000000010efbe0] 0xc0000000010efbe0 (unreliable)
<4>[c0000000010efcf0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0000000010efd80] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0000000010efe70] [c0000000000a1540] .watchdog+0x48/0x70
<4>[c0000000010eff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0000000010eff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>events/0      S 0000000000000000     0     9      2
<4>Call Trace:
<4>[c0000000010fbaf0] [c0000000010fbb90] 0xc0000000010fbb90 (unreliable)
<4>[c0000000010fbcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0000000010fbd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0000000010fbe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0000000010fbf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0000000010fbf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>events/1      S 0000000000000000     0    10      2
<4>Call Trace:
<4>[c0000000010ffaf0] [c0000000010ffb90] 0xc0000000010ffb90 (unreliable)
<4>[c0000000010ffcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0000000010ffd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0000000010ffe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0000000010fff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0000000010fff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>khelper       S 0000000000000000     0    11      2
<4>Call Trace:
<4>[c000000000be3af0] [c000000000be3b90] 0xc000000000be3b90 (unreliable)
<4>[c000000000be3cc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000be3d50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000be3e40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c000000000be3f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000be3f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>kblockd/0     S 0000000000000000     0    95      2
<4>Call Trace:
<4>[c0006c005ee2baf0] [c0006c005ee2bb90] 0xc0006c005ee2bb90 (unreliable)
<4>[c0006c005ee2bcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005ee2bd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005ee2be40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0006c005ee2bf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005ee2bf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>kblockd/1     S 0000000000000000     0    96      2
<4>Call Trace:
<4>[c0006c005ee2faf0] [c0006c005ee2fb90] 0xc0006c005ee2fb90 (unreliable)
<4>[c0006c005ee2fcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005ee2fd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005ee2fe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0006c005ee2ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005ee2ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ata/0         S 0000000000000000     0   104      2
<4>Call Trace:
<4>[c000000007f93af0] [c000000007f93b90] 0xc000000007f93b90 (unreliable)
<4>[c000000007f93cc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000007f93d50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000007f93e40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c000000007f93f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000007f93f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ata/1         S 0000000000000000     0   105      2
<4>Call Trace:
<4>[c000000007f8baf0] [c000000007f8bb90] 0xc000000007f8bb90 (unreliable)
<4>[c000000007f8bcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000007f8bd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000007f8be40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c000000007f8bf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000007f8bf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ata_aux       S 0000000000000000     0   106      2
<4>Call Trace:
<4>[c0006c005ee5faf0] [c0006c005ee5fb90] 0xc0006c005ee5fb90 (unreliable)
<4>[c0006c005ee5fcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005ee5fd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005ee5fe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0006c005ee5ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005ee5ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>khubd         S 0000000000000000     0   111      2
<4>Call Trace:
<4>[c0006c005ee7ba70] [c0006c005ee7bb10] 0xc0006c005ee7bb10 (unreliable)
<4>[c0006c005ee7bc40] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005ee7bcd0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005ee7bdc0] [c000000000476ef0] .hub_thread+0xc1c/0xcec
<4>[c0006c005ee7bf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005ee7bf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>kseriod       S 0000000000000000     0   114      2
<4>Call Trace:
<4>[c0006c005ee87af0] [c0006c005ee87b90] 0xc0006c005ee87b90 (unreliable)
<4>[c0006c005ee87cc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005ee87d50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005ee87e40] [c00000000049da90] .serio_thread+0x33c/0x394
<4>[c0006c005ee87f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005ee87f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ps3avd        S 0000000000000000     0   145      2
<4>Call Trace:
<4>[c000000000dafaf0] [c000000000dafb90] 0xc000000000dafb90 (unreliable)
<4>[c000000000dafcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000dafd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000dafe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c000000000daff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000daff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>pdflush       S 0000000000000000     0   161      2
<4>Call Trace:
<4>[c00000000108fae0] [c00000000108fb80] 0xc00000000108fb80 (unreliable)
<4>[c00000000108fcb0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c00000000108fd40] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c00000000108fe30] [c0000000000aebcc] .pdflush+0x124/0x2b8
<4>[c00000000108ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c00000000108ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>pdflush       S 0000000000000000     0   162      2
<4>Call Trace:
<4>[c0006c005e963ae0] [c0006c005e963b80] 0xc0006c005e963b80 (unreliable)
<4>[c0006c005e963cb0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005e963d40] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005e963e30] [c0000000000aebcc] .pdflush+0x124/0x2b8
<4>[c0006c005e963f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005e963f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>kswapd0       S 0000000000000000     0   163      2
<4>Call Trace:
<4>[c0006c005e967a50] [c0006c005e967af0] 0xc0006c005e967af0 (unreliable)
<4>[c0006c005e967c20] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005e967cb0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005e967da0] [c0000000000b3638] .kswapd+0x10c/0x4b0
<4>[c0006c005e967f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005e967f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>aio/0         S 0000000000000000     0   164      2
<4>Call Trace:
<4>[c0006c005e96baf0] [c0006c005e96bb90] 0xc0006c005e96bb90 (unreliable)
<4>[c0006c005e96bcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005e96bd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005e96be40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0006c005e96bf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005e96bf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>aio/1         S 0000000000000000     0   165      2
<4>Call Trace:
<4>[c0006c005e96faf0] [c0006c005e96fb90] 0xc0006c005e96fb90 (unreliable)
<4>[c0006c005e96fcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005e96fd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005e96fe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0006c005e96ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005e96ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>ps3fb         S 0000000000000000     0   173      2
<4>Call Trace:
<4>[c000000000dfbb30] [c000000000dfbbd0] 0xc000000000dfbbd0 (unreliable)
<4>[c000000000dfbd00] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000dfbd90] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000dfbe80] [c00000000026e228] .ps3fbd+0x44/0x70
<4>[c000000000dfbf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000dfbf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>khvcd         S 0000000000000000     0   757      2
<4>Call Trace:
<4>[c000000000ee3b20] [c000000000ee3bc0] 0xc000000000ee3bc0 (unreliable)
<4>[c000000000ee3cf0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000ee3d80] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000ee3e70] [c00000000028faa8] .khvcd+0x100/0x170
<4>[c000000000ee3f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000ee3f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>khvcsd        S 0000000000000000     0   832      2
<4>Call Trace:
<4>[c000000000eb7af0] [c000000000eb7b90] 0xc000000000eb7b90 (unreliable)
<4>[c000000000eb7cc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000eb7d50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000eb7e40] [c0000000002914e4] .khvcsd+0x260/0x2b0
<4>[c000000000eb7f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000eb7f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>scsi_eh_0     S 0000000000000000     0   916      2
<4>Call Trace:
<4>[c000000000fd7ad0] [c000000000fd7b70] 0xc000000000fd7b70 (unreliable)
<4>[c000000000fd7ca0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000fd7d30] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000fd7e20] [c0000000002f8dc0] .scsi_error_handler+0x5c/0x374
<4>[c000000000fd7f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000fd7f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>rpciod/0      S 0000000000000000     0  1001      2
<4>Call Trace:
<4>[c0006c005ea8faf0] [c0006c005ea8fb90] 0xc0006c005ea8fb90 (unreliable)
<4>[c0006c005ea8fcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005ea8fd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005ea8fe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c0006c005ea8ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005ea8ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>rpciod/1      S 0000000000000000     0  1002      2
<4>Call Trace:
<4>[c000000000dabaf0] [c000000000dabb90] 0xc000000000dabb90 (unreliable)
<4>[c000000000dabcc0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c000000000dabd50] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c000000000dabe40] [c000000000080ea8] .worker_thread+0xa0/0xf0
<4>[c000000000dabf00] [c000000000085574] .kthread+0x78/0xc4
<4>[c000000000dabf90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>kjournald     S 0000000000000000     0  1009      2
<4>Call Trace:
<4>[c0006c005b8bfad0] [c0006c005b8bfb70] 0xc0006c005b8bfb70 (unreliable)
<4>[c0006c005b8bfca0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005b8bfd30] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005b8bfe20] [c00000000015ffc8] .kjournald+0x1d0/0x29c
<4>[c0006c005b8bff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005b8bff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>kauditd       S 0000000000000000     0  1041      2
<4>Call Trace:
<4>[c0006c005a00fae0] [c0006c005a00fb80] 0xc0006c005a00fb80 (unreliable)
<4>[c0006c005a00fcb0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005a00fd40] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005a00fe30] [c00000000009adc0] .kauditd_thread+0x14c/0x1a4
<4>[c0006c005a00ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005a00ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>udevd         S 000000001feb2a7c     0  1075      1
<4>Call Trace:
<4>[c0006c005eed7370] [c0006c005eed7410] 0xc0006c005eed7410 (unreliable)
<4>[c0006c005eed7540] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005eed75d0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005eed76c0] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c005eed7790] [c0000000000ed4f4] .do_select+0x410/0x4b0
<4>[c0006c005eed7b10] [c0000000001182bc] .compat_core_sys_select+0x18c/0x25c
<4>[c0006c005eed7d00] [c000000000119e80] .compat_sys_select+0xd0/0x190
<4>[c0006c005eed7dc0] [c000000000014e3c] .ppc32_select+0x14/0x28
<4>[c0006c005eed7e30] [c000000000008534] syscall_exit+0x0/0x40
<4>kjournald     S 0000000000000000     0  2644      2
<4>Call Trace:
<4>[c0006c005902fad0] [c0006c005902fb70] 0xc0006c005902fb70 (unreliable)
<4>[c0006c005902fca0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005902fd30] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005902fe20] [c00000000015ffc8] .kjournald+0x1d0/0x29c
<4>[c0006c005902ff00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c005902ff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>spusched      S 0000000000000000     0  2650      2
<4>Call Trace:
<4>[c0006c00590d3b10] [c0006c00590d3bb0] 0xc0006c00590d3bb0 (unreliable)
<4>[c0006c00590d3ce0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00590d3d70] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00590d3e60] [d00000000016a99c] .spusched_thread+0x40/0x10c [spufs]
<4>[c0006c00590d3f00] [c000000000085574] .kthread+0x78/0xc4
<4>[c0006c00590d3f90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>syslogd       S 000000001ff68be0     0  3030      1
<4>Call Trace:
<4>[c0006c005928b410] [c0006c005928b4b0] 0xc0006c005928b4b0 (unreliable)
<4>[c0006c005928b5e0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005928b670] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005928b760] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c005928b830] [c0000000004e8d04] .skb_recv_datagram+0x1e4/0x2b8
<4>[c0006c005928b910] [c000000000568470] .unix_dgram_recvmsg+0x88/0x2a8
<4>[c0006c005928ba00] [c0000000004dd968] .sock_recvmsg+0xd0/0x110
<4>[c0006c005928bc00] [c0000000004dee94] .sys_recvfrom+0xec/0x170
<4>[c0006c005928bd90] [c0000000004fea4c] .compat_sys_socketcall+0x178/0x214
<4>[c0006c005928be30] [c000000000008534] syscall_exit+0x0/0x40
<4>klogd         R  running task        0  3033      1
<4>irqbalance    S 000000001ff25918     0  3050      1
<4>Call Trace:
<4>[c0006c005931f970] [c0006c005931fa10] 0xc0006c005931fa10 (unreliable)
<4>[c0006c005931fb40] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005931fbd0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005931fcc0] [c0000000005a3d58] .schedule_timeout+0xa8/0xe8
<4>[c0006c005931fd90] [c000000000096bb8] .compat_sys_nanosleep+0x90/0x128
<4>[c0006c005931fe30] [c000000000008534] syscall_exit+0x0/0x40
<4>portmap       S 000000001ff194e0     0  3073      1
<4>Call Trace:
<4>[c0006c0059407550] [c0006c00594075f0] 0xc0006c00594075f0 (unreliable)
<4>[c0006c0059407720] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00594077b0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00594078a0] [c0000000005a3d58] .schedule_timeout+0xa8/0xe8
<4>[c0006c0059407970] [c0000000000ecf38] .do_sys_poll+0x2c8/0x410
<4>[c0006c0059407d90] [c0000000000ed0cc] .sys_poll+0x4c/0x64
<4>[c0006c0059407e30] [c000000000008534] syscall_exit+0x0/0x40
<4>rpc.idmapd    S 000000001feab6b4     0  3102      1
<4>Call Trace:
<4>[c0006c00595e7910] [c0006c00595e79b0] 0xc0006c00595e79b0 (unreliable)
<4>[c0006c00595e7ae0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00595e7b70] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00595e7c60] [c0000000005a3d58] .schedule_timeout+0xa8/0xe8
<4>[c0006c00595e7d30] [c0000000001157a4] .sys_epoll_wait+0x188/0x530
<4>[c0006c00595e7e30] [c000000000008534] syscall_exit+0x0/0x40
<4>lockd         S 0000000000000000     0  3141      2
<4>Call Trace:
<4>[c0006c00593ef9b0] [c0006c00593efa50] 0xc0006c00593efa50 (unreliable)
<4>[c0006c00593efb80] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00593efc10] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00593efd00] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c00593efdd0] [c000000000583c80] .svc_recv+0x314/0x534
<4>[c0006c00593efec0] [c0000000001c67f0] .lockd+0x14c/0x2a8
<4>[c0006c00593eff90] [c000000000024d00] .kernel_thread+0x4c/0x68
<4>sshd          S 000000001fa2ba7c     0  3193      1
<4>Call Trace:
<4>[c0006c005992f370] [c0006c005992f410] 0xc0006c005992f410 (unreliable)
<4>[c0006c005992f540] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005992f5d0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005992f6c0] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c005992f790] [c0000000000ed4f4] .do_select+0x410/0x4b0
<4>[c0006c005992fb10] [c0000000001182bc] .compat_core_sys_select+0x18c/0x25c
<4>[c0006c005992fd00] [c000000000119e80] .compat_sys_select+0xd0/0x190
<4>[c0006c005992fdc0] [c000000000014e3c] .ppc32_select+0x14/0x28
<4>[c0006c005992fe30] [c000000000008534] syscall_exit+0x0/0x40
<4>mingetty      S 000000000ff1a6d4     0  3216      1
<4>Call Trace:
<4>[c0006c00597ef700] [c0006c00597ef7a0] 0xc0006c00597ef7a0 (unreliable)
<4>[c0006c00597ef8d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00597ef960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00597efa50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c00597efb20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c00597efc30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c00597efcf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c00597efd90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c00597efe30] [c000000000008534] syscall_exit+0x0/0x40
<4>mingetty      S 000000000ff1a6d4     0  3218      1
<4>Call Trace:
<4>[c0006c00591df700] [c0006c00591df7a0] 0xc0006c00591df7a0 (unreliable)
<4>[c0006c00591df8d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00591df960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00591dfa50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c00591dfb20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c00591dfc30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c00591dfcf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c00591dfd90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c00591dfe30] [c000000000008534] syscall_exit+0x0/0x40
<4>mingetty      S 000000000ff1a6d4     0  3219      1
<4>Call Trace:
<4>[c0006c005981b700] [c0006c005981b7a0] 0xc0006c005981b7a0 (unreliable)
<4>[c0006c005981b8d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005981b960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005981ba50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c005981bb20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c005981bc30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c005981bcf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c005981bd90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c005981be30] [c000000000008534] syscall_exit+0x0/0x40
<4>mingetty      S 000000000ff1a6d4     0  3221      1
<4>Call Trace:
<4>[c0006c00598af700] [c0006c00598af7a0] 0xc0006c00598af7a0 (unreliable)
<4>[c0006c00598af8d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00598af960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00598afa50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c00598afb20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c00598afc30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c00598afcf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c00598afd90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c00598afe30] [c000000000008534] syscall_exit+0x0/0x40
<4>mingetty      S 000000000ff1a6d4     0  3222      1
<4>Call Trace:
<4>[c0006c005985b700] [c0006c005985b7a0] 0xc0006c005985b7a0 (unreliable)
<4>[c0006c005985b8d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c005985b960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c005985ba50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c005985bb20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c005985bc30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c005985bcf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c005985bd90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c005985be30] [c000000000008534] syscall_exit+0x0/0x40
<4>mingetty      S 000000000ff1a6d4     0  3224      1
<4>Call Trace:
<4>[c0006c00597e3700] [c0006c00597e37a0] 0xc0006c00597e37a0 (unreliable)
<4>[c0006c00597e38d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00597e3960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00597e3a50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c00597e3b20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c00597e3c30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c00597e3cf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c00597e3d90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c00597e3e30] [c000000000008534] syscall_exit+0x0/0x40
<4>sshd          S 000000001fa226d4     0  3279   3193
<4>Call Trace:
<4>[c0006c0059a034e0] [c0006c0059a03580] 0xc0006c0059a03580 (unreliable)
<4>[c0006c0059a036b0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c0059a03740] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c0059a03830] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c0059a03900] [c000000000567abc] .unix_stream_recvmsg+0x2a4/0x650
<4>[c0006c0059a03a40] [c0000000004dcdc8] .sock_aio_read+0x104/0x12c
<4>[c0006c0059a03b50] [c0000000000db480] .do_sync_read+0xc4/0x124
<4>[c0006c0059a03cf0] [c0000000000dbd14] .vfs_read+0xf4/0x1a4
<4>[c0006c0059a03d90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c0059a03e30] [c000000000008534] syscall_exit+0x0/0x40
<4>sshd          R  running task        0  3281   3279
<4>bash          S 000000000ff1a6d4     0  3282   3281
<4>Call Trace:
<4>[c0006c00599e3700] [c0006c00599e37a0] 0xc0006c00599e37a0 (unreliable)
<4>[c0006c00599e38d0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c00599e3960] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c00599e3a50] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c00599e3b20] [c00000000027afe0] .read_chan+0x3bc/0x770
<4>[c0006c00599e3c30] [c000000000276bb4] .tty_read+0xc0/0x14c
<4>[c0006c00599e3cf0] [c0000000000dbcf8] .vfs_read+0xd8/0x1a4
<4>[c0006c00599e3d90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c00599e3e30] [c000000000008534] syscall_exit+0x0/0x40
<4>sshd          S 000000001fa226d4     0  3323   3193
<4>Call Trace:
<4>[c0006c0059f834e0] [c0006c0059f83580] 0xc0006c0059f83580 (unreliable)
<4>[c0006c0059f836b0] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c0059f83740] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c0059f83830] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c0059f83900] [c000000000567abc] .unix_stream_recvmsg+0x2a4/0x650
<4>[c0006c0059f83a40] [c0000000004dcdc8] .sock_aio_read+0x104/0x12c
<4>[c0006c0059f83b50] [c0000000000db480] .do_sync_read+0xc4/0x124
<4>[c0006c0059f83cf0] [c0000000000dbd14] .vfs_read+0xf4/0x1a4
<4>[c0006c0059f83d90] [c0000000000dc3f4] .sys_read+0x4c/0x8c
<4>[c0006c0059f83e30] [c000000000008534] syscall_exit+0x0/0x40
<4>sshd          S 000000001fa2ba7c     0  3325   3323
<4>Call Trace:
<4>[c0006c0059f93370] [c0006c0059f93410] 0xc0006c0059f93410 (unreliable)
<4>[c0006c0059f93540] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c0059f935d0] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c0059f936c0] [c0000000005a3cec] .schedule_timeout+0x3c/0xe8
<4>[c0006c0059f93790] [c0000000000ed4f4] .do_select+0x410/0x4b0
<4>[c0006c0059f93b10] [c0000000001182bc] .compat_core_sys_select+0x18c/0x25c
<4>[c0006c0059f93d00] [c000000000119e80] .compat_sys_select+0xd0/0x190
<4>[c0006c0059f93dc0] [c000000000014e3c] .ppc32_select+0x14/0x28
<4>[c0006c0059f93e30] [c000000000008534] syscall_exit+0x0/0x40
<4>bash          S 000000000fee9118     0  3326   3325
<4>Call Trace:
<4>[c0006c0059f73930] [c0006c0059f739d0] 0xc0006c0059f739d0 (unreliable)
<4>[c0006c0059f73b00] [c00000000000e8d8] .__switch_to+0x110/0x144
<4>[c0006c0059f73b90] [c0000000005a2e68] .schedule+0x5a8/0x728
<4>[c0006c0059f73c80] [c00000000006efb8] .do_wait+0xe4c/0x1070
<4>[c0006c0059f73dc0] [c000000000014548] .compat_sys_waitpid+0x18/0x2c
<4>[c0006c0059f73e30] [c000000000008534] syscall_exit+0x0/0x40
<4>dlog          R  running task        0  3363   3326
<4>Sched Debug Version: v0.05-v20, 2.6.23-9.ydl6.1 #1
<4>now at 90061762394 nsecs
<4>
<4>cpu#0
<4>  .nr_running                    : 3
<4>  .load                          : 5169
<4>  .ls.delta_fair                 : 41806983440
<4>  .ls.delta_exec                 : 89976330074
<4>  .nr_switches                   : 31519
<4>  .nr_load_updates               : 22494
<4>  .nr_uninterruptible            : 197
<4>  .jiffies                       : 4294914790
<4>  .next_balance                  : 4294914815
<4>  .curr->pid                     : 3050
<4>  .clock                         : 89976330074
<4>  .idle_clock                    : 0
<4>  .prev_clock_raw                : 89976330336
<4>  .clock_warps                   : 0
<4>  .clock_overflows               : 16260
<4>  .clock_deep_idle_events        : 0
<4>  .clock_max_delta               : 4000000
<4>  .cpu_load[0]                   : 1024
<4>  .cpu_load[1]                   : 1024
<4>  .cpu_load[2]                   : 1024
<4>  .cpu_load[3]                   : 1024
<4>  .cpu_load[4]                   : 1024
<4>
<4>cfs_rq
<4>  .fair_clock                    : 9850601511
<4>  .exec_clock                    : 17038500532
<4>  .wait_runtime                  : 0
<4>  .wait_runtime_overruns         : 0
<4>  .wait_runtime_underruns        : 0
<4>  .sleeper_bonus                 : 1535299
<4>  .wait_runtime_rq_sum           : 59697736
<4>
<4>runnable tasks:
<4>            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
<4>------------------------------------------------------------------------------------------------------------------------------------------------------------------
<4>           ps3fb   173      9837477513     -13123998      40000000      5311   115               0               0               0               0               0
<4>R     irqbalance  3050      9810447679     -40153832      39849424         6   120               0               0               0               0               0
<4>            sshd  3281      9870579167      19977656     -20151688       280   120               0               0               0               0               0
<4>
<4>cpu#1
<4>  .nr_running                    : 3
<4>  .load                          : 5169
<4>  .ls.delta_fair                 : 42447067418
<4>  .ls.delta_exec                 : 90004018170
<4>  .nr_switches                   : 18967
<4>  .nr_load_updates               : 22503
<4>  .nr_uninterruptible            : -197
<4>  .jiffies                       : 4294914790
<4>  .next_balance                  : 4294914822
<4>  .curr->pid                     : 3363
<4>  .clock                         : 90016005724
<4>  .idle_clock                    : 0
<4>  .prev_clock_raw                : 90116240256
<4>  .clock_warps                   : 0
<4>  .clock_overflows               : 16229
<4>  .clock_deep_idle_events        : 0
<4>  .clock_max_delta               : 4000000
<4>  .cpu_load[0]                   : 5169
<4>  .cpu_load[1]                   : 4973
<4>  .cpu_load[2]                   : 4179
<4>  .cpu_load[3]                   : 3335
<4>  .cpu_load[4]                   : 2896
<4>
<4>cfs_rq
<4>  .fair_clock                    : 7132545922
<4>  .exec_clock                    : 14197356548
<4>  .wait_runtime                  : 0
<4>  .wait_runtime_overruns         : 0
<4>  .wait_runtime_underruns        : 0
<4>  .sleeper_bonus                 : 3144905
<4>  .wait_runtime_rq_sum           : 38151694
<4>
<4>runnable tasks:
<4>            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
<4>------------------------------------------------------------------------------------------------------------------------------------------------------------------
<4>        events/1    10      7115462305     -18668451      40000000       582   115               0               0               0               0               0
<4>           klogd  3033      6698428379    -435702377      38151694       433   120               0               0               0               0               0
<4>R           dlog  3363      7174130756      40000000     -40000000         9   120               0               0               0               0               0
<4>

-- 
mailto:av1474@comtv.ru
