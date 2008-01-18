Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYARJfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYARJfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYARJfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:35:06 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39208 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189AbYARJfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:35:02 -0500
Message-ID: <479072BC.3080908@linux.vnet.ibm.com>
Date: Fri, 18 Jan 2008 15:04:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel oops will running kernbench
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <479064F0.7040305@linux.vnet.ibm.com> <20080118004416.6a757169.akpm@linux-foundation.org> <18320.27372.202771.764301@cargo.ozlabs.ibm.com>
In-Reply-To: <18320.27372.202771.764301@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Andrew Morton writes:
> 
>> On Fri, 18 Jan 2008 14:06:00 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>> Hi Andrew,
>>>
>>> Following oops was seen while running kernbench on one of test machine
>>> (power4+ box). I tried reproducing the oops but was unsuccessful. 
>>> I will try to reproduce the oops with debug info compiled.
>>>
>>>
>>> Oops: Kernel access of bad area, sig: 11 [#1]
>>> SMP NR_CPUS=32 NUMA pSeries
>>> Modules linked in:
>>> NIP: 0000000000004570 LR: 000000000fc42dc0 CTR: 0000000000000000
>>> REGS: c00000077b6bf8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
>>> MSR: 8000000000001000 <ME>  CR: 28022422  XER: 00000000
>>> DAR: c00000077b6bfce0, DSISR: 000000000a000000
>>> TASK = c000000773164c40[19588] 'as' THREAD: c00000077b6bc000 CPU: 1
>>> GPR00: 0000000000004000 c00000077b6bfb40 0000000000007346 000000000000d032 
>>> GPR04: 000000000000043a 0000000000000000 000000000000000c 0000000000000004 
>>> GPR08: 000000000fd278c8 0000000048022424 c00000077b6bfe30 0000998be2321500 
>>> GPR12: 8000000000001030 c0000000005f6280 0000000010030000 0000000010030000 
>>> GPR16: 0000000010030000 0000000010050000 000000001006aac0 0000000010053cd0 
>>> GPR20: 0000000000000000 0000000000000fe0 0000000010050000 0000000010050000 
>>> GPR24: 0000000000000ff8 0000000000000fe8 0000000000000062 000000000fd27490 
>>> GPR28: 000000000fd274c8 0000000010099420 000000000fd25ff4 000000001009a400 
>>> NIP [0000000000004570] 0x4570
>>> LR [000000000fc42dc0] 0xfc42dc0
>>> Call Trace:
>>> [c00000077b6bfb40] [c00000077b292000] 0xc00000077b292000 (unreliable)
>>> Instruction dump:
>>> 48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
>>> 48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 
>>>
>> odd.  Where did the stack trace go?

Only this much was captured in the serial console.
> 
> It's there, it's just really really short (one line).  The link
> register is in userspace and the stack pointer looks to be right at
> the top of a kernel stack area.
> 
> The trap was a data access exception which is very odd given that the
> machine is in real mode (MMU off) with the pc at 0x4570.  Actually it
> looks like the machine probably got a data access exception somewhere
> (probably in userspace, probably a page fault or similar) and then got
> another exception before it had finished saving the state from the
> first exception.
> 
> Kamalesh, do you still have the vmlinux?  If so could you disassemble
> the area from say 0x4500 to 0x4600, and find out what is the closest
> symbol before 0xc000000000004570 from System.map, and show us those?
> 
> Paul.
> --
I tried reproducing the problem and was successful with following trace
in which the pc is at 0x4570 as the above one

 Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: 0000000000004570 LR: 000000000ff0288c CTR: 000000000ff013e0
REGS: c00000077e61f8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
MSR: 8000000000001000 <ME>  CR: 28000422  XER: 00000000
DAR: c00000077e61fce0, DSISR: 000000000a000000
TASK = c00000077207f880[23480] 'cc1' THREAD: c00000077e61c000 CPU: 3
GPR00: 0000000000004000 c00000077e61fb40 0000000000000088 000000000000d032 
GPR04: 0000000000000088 000000000000030c 00000000fefefeff 000000007f7f7f7f 
GPR08: 0000000000008000 0000000044000428 c00000077e61fe30 0000998be2321500 
GPR12: 8000000000001030 c0000000005f6680 0000000010030000 0000000010030000 
GPR16: 00000000105b0000 00000000105b0000 0000000010440000 00000000105b0000 
GPR20: 00000000105b0000 00000000105b0000 00000000105b0000 00000000105b0000 
GPR24: 00000000105b0000 00000000105b0000 00000000105b0000 00000000ffa11b24 
GPR28: 0000000000000000 00000000ffffffff 000000000ffebff4 000000000ffec408 
NIP [0000000000004570] 0x4570
LR [000000000ff0288c] 0xff0288c
Call Trace:
[c00000077e61fb40] [c00000077e61fcf0] 0xc00000077e61fcf0 (unreliable)
[c00000077e61fbd0] [0000000010440000] 0x10440000
Instruction dump:
48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 

The disassembled vmlinux from 0x4500 to 0x4600 

c000000000004500:       f9 4d 01 68     std     r10,360(r13)
c000000000004504:       48 02 89 f9     bl      c00000000002cefc <.slb_allocate_realmode>
c000000000004508:       e9 4d 01 68     ld      r10,360(r13)
c00000000000450c:       e8 6d 01 60     ld      r3,352(r13)
c000000000004510:       81 2d 01 5c     lwz     r9,348(r13)
c000000000004514:       7d 48 03 a6     mtlr    r10
c000000000004518:       71 8a 00 02     andi.   r10,r12,2
c00000000000451c:       41 82 00 28     beq-    c000000000004544 <unrecov_slb>
c000000000004520:       7d 38 01 20     mtocrf  128,r9  
c000000000004524:       7d 30 11 20     mtocrf  1,r9
c000000000004528:       e9 2d 01 20     ld      r9,288(r13)
c00000000000452c:       e9 4d 01 28     ld      r10,296(r13)
c000000000004530:       e9 6d 01 30     ld      r11,304(r13)
c000000000004534:       e9 8d 01 38     ld      r12,312(r13)
c000000000004538:       e9 ad 01 40     ld      r13,320(r13)
c00000000000453c:       4c 00 00 24     rfid    
c000000000004540:       48 00 00 00     b       c000000000004540 <.slb_miss_realmode+0x48>

c000000000004544 <unrecov_slb>:
c000000000004544:       71 8a 40 00     andi.   r10,r12,16384
c000000000004548:       7c 2a 0b 78     mr      r10,r1  
c00000000000454c:       38 21 fd 10     addi    r1,r1,-752
c000000000004550:       41 82 00 08     beq-    c000000000004558 <unrecov_slb+0x14>
c000000000004554:       e8 2d 01 a8     ld      r1,424(r13)
c000000000004558:       2c a1 00 00     cmpdi   cr1,r1,0
c00000000000455c:       40 84 00 08     bge-    cr1,c000000000004564 <unrecov_slb+0x20>
c000000000004560:       48 00 00 10     b       c000000000004570 <unrecov_slb+0x2c>
c000000000004564:       38 20 41 00     li      r1,16640
c000000000004568:       b0 2d 01 c8     sth     r1,456(r13)
c00000000000456c:       4b ff fb 18     b       c000000000004084 <bad_stack>
c000000000004570:       f9 21 01 a0     std     r9,416(r1) 
c000000000004574:       f9 61 01 70     std     r11,368(r1)
c000000000004578:       f9 81 01 78     std     r12,376(r1)
c00000000000457c:       f9 41 00 00     std     r10,0(r1)
c000000000004580:       f8 01 00 70     std     r0,112(r1)
c000000000004584:       f9 41 00 78     std     r10,120(r1)
c000000000004588:       41 82 00 24     beq-    c0000000000045ac <unrecov_slb+0x68>
c00000000000458c:       7d 35 4a a6     mfspr   r9,309  
c000000000004590:       7d 2c 42 e6     mftb    r9
c000000000004594:       e9 4d 01 e0     ld      r10,480(r13)
c000000000004598:       f9 2d 01 e0     std     r9,480(r13)
c00000000000459c:       7d 4a 48 50     subf    r10,r10,r9
c0000000000045a0:       e9 2d 01 d0     ld      r9,464(r13)
c0000000000045a4:       7d 29 52 14     add     r9,r9,r10
c0000000000045a8:       f9 2d 01 d0     std     r9,464(r13)
c0000000000045ac:       f8 41 00 80     std     r2,128(r1)
c0000000000045b0:       f8 61 00 88     std     r3,136(r1)
c0000000000045b4:       f8 81 00 90     std     r4,144(r1)
c0000000000045b8:       f8 a1 00 98     std     r5,152(r1)
c0000000000045bc:       f8 c1 00 a0     std     r6,160(r1)
c0000000000045c0:       f8 e1 00 a8     std     r7,168(r1)
c0000000000045c4:       f9 01 00 b0     std     r8,176(r1)
c0000000000045c8:       e9 2d 01 20     ld      r9,288(r13)
c0000000000045cc:       e9 4d 01 28     ld      r10,296(r13)
c0000000000045d0:       f9 21 00 b8     std     r9,184(r1)
c0000000000045d4:       f9 41 00 c0     std     r10,192(r1)
c0000000000045d8:       e9 2d 01 30     ld      r9,304(r13)
c0000000000045dc:       e9 4d 01 38     ld      r10,312(r13)
c0000000000045e0:       e9 6d 01 40     ld      r11,320(r13)
c0000000000045e4:       f9 21 00 c8     std     r9,200(r1)
c0000000000045e8:       f9 41 00 d0     std     r10,208(r1)
c0000000000045ec:       f9 61 00 d8     std     r11,216(r1)
c0000000000045f0:       e8 4d 00 10     ld      r2,16(r13)
c0000000000045f4:       7d 28 02 a6     mflr    r9
c0000000000045f8:       f9 21 01 90     std     r9,400(r1)
c0000000000045fc:       7d 49 02 a6     mfctr   r10
c000000000004600:       f9 41 01 88     std     r10,392(r1)

The closet symbol form the system.map file

c000000000004280 T data_access_common
c000000000004400 T instruction_access_common
c0000000000044f8 T .slb_miss_realmode
c000000000004544 t unrecov_slb
c000000000004680 T hardware_interrupt_common

Let me know if you need more information.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
