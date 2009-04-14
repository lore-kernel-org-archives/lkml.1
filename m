Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZDNRWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZDNRWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZDNRW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:22:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59302 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZDNRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:22:25 -0400
Date: Tue, 14 Apr 2009 18:11:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, jmorris@namei.org,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
In-Reply-To: <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
 <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk>
 <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
 <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk>
 <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009, Tetsuo Handa wrote:
> Paul E. McKenney wrote:
> > Is this reproducible?
> Not always, but it is reproducible.
> 
> Al Viro wrote:
> > I'd really love to see results of repeated alt-sysrq-p/alt-sysrq-l, just
> > to see where was it actually spinning.
> Below is sysrq message.
> Maybe something related to khelper's current->mm == NULL warning problem.

Maybe, up to a point, and I'll post separately on those warnings.

> Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1-200904130930.txt .
> 
> [   47.412519] SysRq : Show Regs
> [   47.413986] 
> [   47.414584] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   47.415804] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   47.415804] EIP is at __get_user_4+0x11/0x17
> [   47.415804] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   47.415804] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   47.415804]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   47.415804] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   47.415804] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   47.415804] DR6: ffff0ff0 DR7: 00000400
> [   47.415804] Call Trace:
> [   47.415804]  [<c0225f4e>] ? count+0x3e/0xb0
> [   47.415804]  [<c0228581>] do_execve+0x621/0x890
> [   47.415804]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   47.415804]  [<c010237e>] sys_execve+0x5e/0xb0
> [   47.415804]  [<c0103d19>] syscall_call+0x7/0xb
> [   47.415804]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   47.415804]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   47.415804]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   47.415804]  [<c0104707>] ? kernel_thread_helper+0x7/0x10

I'm now thinking that this really is hitting in count(), despite
the ? on that in the backtrace, and is entirely unrelated to the
recent check_unsafe_exec() changes.  Stuck in a loop scanning the
the kernelspace exec args without an mm.

But my compiler on your config gives quite different function
sizes: please would you post to the list or send me privately
the output of "objdump -trd fs/exec.o", so we can check that.

Thanks,
Hugh
