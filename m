Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYARJBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYARJBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYARJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:01:41 -0500
Received: from ozlabs.org ([203.10.76.45]:39231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYARJBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:01:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18320.27372.202771.764301@cargo.ozlabs.ibm.com>
Date: Fri, 18 Jan 2008 20:01:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel oops will running kernbench
In-Reply-To: <20080118004416.6a757169.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<479064F0.7040305@linux.vnet.ibm.com>
	<20080118004416.6a757169.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Fri, 18 Jan 2008 14:06:00 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi Andrew,
> > 
> > Following oops was seen while running kernbench on one of test machine
> > (power4+ box). I tried reproducing the oops but was unsuccessful. 
> > I will try to reproduce the oops with debug info compiled.
> > 
> > 
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > SMP NR_CPUS=32 NUMA pSeries
> > Modules linked in:
> > NIP: 0000000000004570 LR: 000000000fc42dc0 CTR: 0000000000000000
> > REGS: c00000077b6bf8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
> > MSR: 8000000000001000 <ME>  CR: 28022422  XER: 00000000
> > DAR: c00000077b6bfce0, DSISR: 000000000a000000
> > TASK = c000000773164c40[19588] 'as' THREAD: c00000077b6bc000 CPU: 1
> > GPR00: 0000000000004000 c00000077b6bfb40 0000000000007346 000000000000d032 
> > GPR04: 000000000000043a 0000000000000000 000000000000000c 0000000000000004 
> > GPR08: 000000000fd278c8 0000000048022424 c00000077b6bfe30 0000998be2321500 
> > GPR12: 8000000000001030 c0000000005f6280 0000000010030000 0000000010030000 
> > GPR16: 0000000010030000 0000000010050000 000000001006aac0 0000000010053cd0 
> > GPR20: 0000000000000000 0000000000000fe0 0000000010050000 0000000010050000 
> > GPR24: 0000000000000ff8 0000000000000fe8 0000000000000062 000000000fd27490 
> > GPR28: 000000000fd274c8 0000000010099420 000000000fd25ff4 000000001009a400 
> > NIP [0000000000004570] 0x4570
> > LR [000000000fc42dc0] 0xfc42dc0
> > Call Trace:
> > [c00000077b6bfb40] [c00000077b292000] 0xc00000077b292000 (unreliable)
> > Instruction dump:
> > 48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
> > 48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 
> > 
> 
> odd.  Where did the stack trace go?

It's there, it's just really really short (one line).  The link
register is in userspace and the stack pointer looks to be right at
the top of a kernel stack area.

The trap was a data access exception which is very odd given that the
machine is in real mode (MMU off) with the pc at 0x4570.  Actually it
looks like the machine probably got a data access exception somewhere
(probably in userspace, probably a page fault or similar) and then got
another exception before it had finished saving the state from the
first exception.

Kamalesh, do you still have the vmlinux?  If so could you disassemble
the area from say 0x4500 to 0x4600, and find out what is the closest
symbol before 0xc000000000004570 from System.map, and show us those?

Paul.
