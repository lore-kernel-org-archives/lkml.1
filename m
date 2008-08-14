Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbYHNSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbYHNSbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYHNSbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:31:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34752 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbYHNSa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:30:59 -0400
Date: Thu, 14 Aug 2008 19:31:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: oops in proc_sys_compare
Message-ID: <Pine.LNX.4.64.0808141908290.15191@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this oops below, after several hours of swap-heavy kernel builds
in tmpfs, on 2.6.27-rc1-mm1 a couple of weeks ago.  Tried to reproduce
it without success, then got a very similar trace (not saved) from
2.6.27-rc3 itself doing the same test yesterday: again oopsing in
proc_sys_compare on address -16, looks like it's trying for
PROC_I(dentry->d_inode)->sysctl but d_inode is NULL.

I looked to see what's been going on in fs/proc recently, and your
[PATCH] sanitize proc_sysctl 9043476f726802f4b00c96d0c4f418dde48d1304
does sound like it might be implicated.  I've only seen this on
PowerPC G5, similar tests on x86_32 and _64 haven't shown it:
maybe a memory barrier needed somewhere?

Hugh

Unable to handle kernel paging request for data at address 0xfffffffffffffff0
Faulting instruction address: 0xc000000000121ec4
Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT SMP NR_CPUS=4 PowerMac
Modules linked in:
NIP: c000000000121ec4 LR: c000000000121eb4 CTR: 0000000000000000
REGS: c000000002af33f0 TRAP: 0300   Not tainted  (2.6.27-rc1-mm1)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24222482  XER: 00000000
DAR: fffffffffffffff0, DSISR: 0000000040000000
TASK = c000000002d22500[26561] 'sh' THREAD: c000000002af0000 CPU: 3
GPR00: 0000000000000078 c000000002af3670 c0000000005cf520 0000000000000000 
GPR04: c0000000021ba01b 000000000000000b c000000015e63596 c0000000021ba011 
GPR08: 0001f59632fdb346 0000000000000000 000000000001ffff 0000000000000000 
GPR12: 0000000020222424 c0000000005ec800 0000000000000000 0000000000000000 
GPR16: 00000000200be41c 0000000000000000 c000000002af38d0 c000000002af38b0 
GPR20: c000000002af38c0 c000000002af3bf8 0000000000000101 0000000000000024 
GPR24: c0000000021ba011 0000000032fdb346 000000000000000b c000000002af38c0 
GPR28: c000000015e634f8 c000000015e634e0 c000000000562498 c000000015e63510 
NIP [c000000000121ec4] .proc_sys_compare+0x48/0x7c
LR [c000000000121eb4] .proc_sys_compare+0x38/0x7c
Call Trace:
[c000000002af3670] [c000000000522620] root_table_header+0x0/0x58 (unreliable)
[c000000002af36f0] [c0000000000dabdc] .__d_lookup+0xf4/0x1f0
[c000000002af37a0] [c0000000000d0978] .do_lookup+0x38/0x128
[c000000002af3840] [c0000000000d1438] .__link_path_walk+0x9d0/0xf30
[c000000002af3950] [c0000000000d19f0] .path_walk+0x58/0xc4
[c000000002af3a00] [c0000000000d1b94] .do_path_lookup+0x138/0x17c
[c000000002af3ab0] [c0000000000d1cc8] .__path_lookup_intent_open+0x78/0xdc
[c000000002af3b60] [c0000000000d2960] .do_filp_open+0xcc/0x764
[c000000002af3d00] [c0000000000c5454] .do_sys_open+0x80/0x14c
[c000000002af3db0] [c000000000108378] .compat_sys_open+0x24/0x38
[c000000002af3e30] [c0000000000076ac] syscall_exit+0x0/0x40
Instruction dump:
60000000 80a40004 80090004 7f802800 409e003c e8890008 e87f0008 4bf0aa45 
60000000 2fa30000 409e0024 e93fffe0 <e869fff0> 4bf2f84d 60000000 7c630034 
---[ end trace ac14ee183d55eec5 ]---
