Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYFSNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYFSNxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbYFSNxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:53:01 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52440 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbYFSNxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:53:00 -0400
Date: Thu, 19 Jun 2008 15:53:26 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>, josht@linux.vnet.ibm.com,
       nsnix@comcast.net, tony@bakeyournoodle.com, linuxppc-dev@ozlabs.org
Subject: Re: [OOPS] RT kernel on PowerPC
Message-ID: <20080619155326.0234be60@bull.net>
In-Reply-To: <20080619124634.GA7409@linux.vnet.ibm.com>
References: <20080619124634.GA7409@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Chirag

On Thu, 19 Jun 2008 18:16:34 +0530 Chirag Jog <chirag@linux.vnet.ibm.com> wrote:

> Hi,
>     I was trying out the realtime linux kernel 2.6.25.4-rt3 on a powerpc box.
>     The kernel booted fine.
>     On running the matrix_mult testcase from the real-time testsuite
>     in ltp (ltp/testcases/realtime/func), I get the following Oops.
>     After the which machine just freezes.

  I do get the same thing on a JS22 blade, and you will find that some other
tests are hanging or oopsing. For example the sbrk_mutex testcase suffers from
missed hrtimer wakeups. I also get loads of:

  BUG: using smp_processor_id() in preemptible [00000000] code

all triggered from the sys_munmap -> ... -> free_pgtables code path.

  Currently I'm trying to debug some networking problems where the whole
stack gets stuck under heavy receive load.

  As you can see, -rt is far from stable on the Power architecture. Sorry for
not having an answer for you but I just wanted to show some of the
obstacles laying ahead.

  Sebastien.

>     I tried setting the panic_on_oops but that didn't help strangely.
>     Also, attached is the config file
> 
> Oops: Kernel access of bad area, sig: 11 [#1]
> PREEMPT SMP NR_CPUS=64 NUMA pSeries
> Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ehea inet_lro iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_multipath dm_mod parport_pc lp parport sg sr_mod ibmvscsic scsi_transport_srp sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
> NIP: c000000000050fa0 LR: c000000000053db4 CTR: c00000000005ab98
> REGS: c00000009224fe50 TRAP: 0300   Not tainted  (2.6.25.4-rt3)
> MSR: 8000000000001032 <ME,IR,DR>  CR: 28000088  XER: 00000000
> DAR: c0000180004fc4b0, DSISR: 0000000040000000
> TASK = c000000092200ad0[59] 'events/3' THREAD: c000000092250000 CPU: 3
> GPR00: c0000000004fc480 c0000000922500d0 c0000000005bca00 c000000092200ad0 
> GPR04: 0000000000000002 0000000000000038 0000000000000000 000000000000000f 
> GPR08: 0000000000000001 c0000180004fc480 0f0f0f0f0f0f0f0f c0000000004d9a00 
> GPR12: 8000000000009032 c0000000004fca80 0000000000000000 c000000000413910 
> GPR16: 4000000000c00000 c000000000412108 0000000000000000 0000000000284000 
> GPR20: c0000000004cb9b0 00000000010cb9b0 0000000000000000 0000001fdaa40b13 
> GPR24: 0000000000000000 000000000000001f c0000000922501d0 0000000000000000 
> GPR28: 0000000000000001 c000000092200ad0 c00000000056a680 c000000090b18ad0 
> NIP [c000000000050fa0] .__resched_task+0x38/0xfc
> LR [c000000000053db4] .try_to_wake_up+0x168/0x200
> Call Trace:
> Instruction dump:
> fbc1fff0 fbe1fff8 ebc2af70 7c7d1b78 f8010010 f821ff71 e81e8008 e97e8000 
> e9230008 81290010 79294da4 7d290214 <e8090030> 7c0b002e 7c000074 7800d182 
> 
> Disassembling the __resched_task,
> 
> Dump of assembler code for function __resched_task:
> 0xc000000000050f68 <__resched_task+0>:  mflr    r0
> 0xc000000000050f6c <__resched_task+4>:  std     r29,-24(r1)
> 0xc000000000050f70 <__resched_task+8>:  std     r30,-16(r1)
> 0xc000000000050f74 <__resched_task+12>: std     r31,-8(r1)
> 0xc000000000050f78 <__resched_task+16>: ld      r30,-20624(r2)
> 0xc000000000050f7c <__resched_task+20>: mr      r29,r3
> 0xc000000000050f80 <__resched_task+24>: std     r0,16(r1)
> 0xc000000000050f84 <__resched_task+28>: stdu    r1,-144(r1)
> 0xc000000000050f88 <__resched_task+32>: ld      r0,-32760(r30)
> 0xc000000000050f8c <__resched_task+36>: ld      r11,-32768(r30)
> 0xc000000000050f90 <__resched_task+40>: ld      r9,8(r3)
> 0xc000000000050f94 <__resched_task+44>: lwz     r9,16(r9)
> 0xc000000000050f98 <__resched_task+48>: rldicr  r9,r9,9,54
> 0xc000000000050f9c <__resched_task+52>: add     r9,r9,r0
> 0xc000000000050fa0 <__resched_task+56>: ld      r0,48(r9) <----
> offending instruction 
> 0xc000000000050fa4 <__resched_task+60>: lwzx    r0,r11,r0
>         
> 
> 
> 
> 
> -- 
> Cheers,
> Chirag Jog
> 
