Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYHRSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYHRSmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYHRSmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:42:03 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33073 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbYHRSmB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:42:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAHhdqUhMRKxB/2dsb2JhbACBYrQFgVg
Date: Mon, 18 Aug 2008 14:41:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eran Liberty <liberty@extricom.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, rostedt@goodmis.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Message-ID: <20080818184158.GA1798@Krystal>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <48A9BEA3.10906@extricom.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:40:23 up 74 days, 23:20,  6 users,  load average: 0.83, 0.86,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eran Liberty (liberty@extricom.com) wrote:
> Steven Rostedt wrote:
>> Eran Liberty wrote:
>>> After compiling a kernel with ftrace I started to experience all sorts of 
>>> crashes.
>>
>> Just to make sure...
>>
>> ftrace enables markers too, and RCU has tracing with the markers. This may 
>> not be the problem, but I just want to eliminate as many variables as 
>> possible.
>> Could you disable ftrace, but keep the markers on too.  Also, could you 
>> enable ftrace again and turn on the FTRACE_STARTUP_TEST.
>
> for the fun of it I took out all my propriety modules; so now its a non 
> tainted kernel.
>
> Here is the matrix:
>
> !FTRACE x !MARKERS => stable
> !FTRACE x MARKERS => stable
> FTRACE x !MARKERS => n/a (FTRACE forces MARKERS)
> FTRACE x MARKERS => unstable
> FTRACE x FTRACE_STARTUP_TEST x MARKERS => unstable + tests passed
>
> Testing tracer sched_switch: PASSED
> Testing tracer ftrace: PASSED
> Testing dynamic ftrace: PASSED
>
> Oops: Exception in kernel mode, sig: 11 [#1]
> Exsw1600
> Modules linked in:
> NIP: c00bbb20 LR: c00bbb20 CTR: 00000000
> REGS: dd5b1c50 TRAP: 0700   Not tainted  (2.6.27-rc2)
> MSR: 00029000 <EE,ME>  CR: 24082282  XER: 20000000
> TASK = ddcce060[1707] 'find' THREAD: dd5b0000
> GPR00: 00000000 dd5b1d00 ddcce060 dd801180 dd5b1d68 dd5b1d58 dd80125b 
> 100234ec
> GPR08: c0800000 00019330 0000ffff dd5b1d20 24000288 100ad874 100936f8 
> 1008a1d0
> GPR16: 10083f80 dd5b1e2c dd5b1d68 fffffff4 c0380000 dd5b1d60 dd5b1d58 
> dd802084
> GPR24: dc3d7700 dd802018 dd5b1d68 c0380000 dd801180 dd5b1d68 00000000 
> dd5b1d00
> NIP [c00bbb20] d_lookup+0x40/0x90
> LR [c00bbb20] d_lookup+0x40/0x90
> Call Trace:
> [dd5b1d00] [dd5b1d58] 0xdd5b1d58 (unreliable)

Can you check if, at some point during the system execution (starting
from boot), 0xdd5b1d58 is an address where a module is loaded ? (the
module can be later unloaded, what I wonder is if this address would
appear to have had a loaded+unloaded module).

Actually, could you try to compile your kernel without "MODULE_UNLOAD" ?

Mathieu

> [dd5b1d20] [c00aebc4] do_lookup+0xe8/0x220
> [dd5b1d50] [c00b0a80] __link_path_walk+0x5a4/0xd54
> [dd5b1dc0] [c00b1288] path_walk+0x58/0xe0
> [dd5b1df0] [c00b13f8] do_path_lookup+0x78/0x13c
> [dd5b1e20] [c00b20f4] user_path_at+0x64/0xac
> [dd5b1e90] [c00a9028] vfs_lstat_fd+0x34/0x74
> [dd5b1ec0] [c00a90fc] vfs_lstat+0x30/0x48
> [dd5b1ed0] [c00a9144] sys_lstat64+0x30/0x5c
> [dd5b1f40] [c0010554] ret_from_syscall+0x0/0x3c
> Instruction dump:
> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db32a0
> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b32a0
> ---[ end trace 1eb8fd7adac2bb65 ]---
>
> Liberty
>
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
