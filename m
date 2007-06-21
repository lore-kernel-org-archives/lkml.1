Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXFUTw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXFUTw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXFUTwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:52:49 -0400
Received: from users.sycamorenet.com ([12.146.0.130]:59634 "EHLO
	edsel.sycamorenet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752420AbXFUTws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:52:48 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 15:52:48 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: [PATCH -rt] Preemption problem in kernel RT Patch
Date: Thu, 21 Jun 2007 15:39:12 -0400
Message-ID: <77B279EC7347F341A6AE891AA6AD68E9314247@ranchero.sycamorenet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -rt] Preemption problem in kernel RT Patch
Thread-Index: Ace0O9jPz3fQszyXRQu70ER+a27Wqw==
From: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
To: <linux-kernel@vger.kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>
X-OriginalArrivalTime: 21 Jun 2007 19:39:13.0836 (UTC) FILETIME=[D8E5D6C0:01C7B43B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	I've found a preemption problem in kernel/rtmutex.c:649.  The BUG_ON listed in the patch below makes sure a preemption event hasn't occurred since the thread last checked the owner of the lock.  If it did happen and the current task is now the owner, it asserts with BUG_ON.  With the RT-PATCH applied, however, interrupts are not disabled and preemption is possible.  The following patch removes the BUG_ON as it is an incorrect check in the rt kernel. I've checked the rtmutex code and it appears to handle this case just fine..

	Thanks,

		Mark Beauchemin

Here's the patch:

--- linux-2.6.21.3-rt9/kernel/rtmutex.c 2007-06-01 15:21:12.000000000 -0400
+++ linux-2.6.21.3-rt9_new/kernel/rtmutex.c     2007-06-20 12:15:44.000000000 -0400
@@ -646,7 +646,7 @@
          return;
        }
 
-       BUG_ON(rt_mutex_owner(lock) == current);
+/*     BUG_ON(rt_mutex_owner(lock) == current); */
 
        /*
         * Here we save whatever state the task was in originally,



Here's the bug assertion:


: ------------[ cut here ]------------                                                                                
Kernel BUG at c01c7bc4 [verbose debug info unavailable]                                                               
Oops: Exception in kernel mode, sig: 5 [#1]                                                                           
PREEMPT                                                                                                               
NIP: C01C7BC4 LR: C01C7BA8 CTR: C01531CCJun  1 23:06:51 BC122 kern.warn kernel: REGS: d010ba90 TRAP: 0700   Tainted: P
                                                                                                                      
MSR: 00021000 <ME>  CR: 24002082  XER: 00000000                                                                       
TASK = d0100920[5] 'softirq-timer/0' THREAD: d010a000                                                                 
GPR00: 00000001 D010BB40 D0100920 00000000 00000030 00000002 C0260000 00029000                                        
GPR08: D0100920 00000000 D2C07970 D0100920 9F472D4B 00121868 C0220000 00000000                                        
GPR16: 00000000 000F422C 29000000 0000003B 9ACA0000 C026562C D010A028 00004000                                        
GPR24: D191F898 00000000 D2C1CAC8 D2C1CB60 D2C07960 CEA752C0 D010A000 00029000                                        
NIP [C01C7BC4] rt_spin_lock_slowlock+0x60/0x1f8                                                                       
LR [C01C7BA8] rt_spin_lock_slowlock+0x44/0x1f8                                                                        
Call Trace:                                                                                                           
[D010BB40] [C01C7BA8] rt_spin_lock_slowlock+0x44/0x1f8 (unreliable)                                                   
[D010BB90] [C0153464] dev_queue_xmit+0x298/0x2a0         Tunnel2                                                      
[D010BBB0] [C0176398] ip_output+0x288/0x2dc                                                                           
[D010BBE0] [C01AC078] ipip_tunnel_xmit+0x508/0x698                                                                    
[D010BC60] [C0150DF4] dev_hard_start_xmit+0x1b4/0x2a4                                                                 
[D010BC80] [C0153430] dev_queue_xmit+0x264/0x2a0         Tunnel4                                                      
[D010BCA0] [C0176398] ip_output+0x288/0x2dc                                                                           
[D010BCD0] [C01AC078] ipip_tunnel_xmit+0x508/0x698                                                                    
[D010BD50] [C0150DF4] dev_hard_start_xmit+0x1b4/0x2a4                                                                 
[D010BD70] [C0153430] dev_queue_xmit+0x264/0x2a0         Tunnel2                                                      
[D010BD90] [C0176398] ip_output+0x288/0x2dc                                                                           
[D010BDC0] [C017685C] ip_queue_xmit+0x1ac/0x4e4                                                                       
[D010BE30] [C018762C] tcp_transmit_skb+0x390/0x810                                                                    
[D010BE70] [C018882C] tcp_retransmit_skb+0x160/0x638                                                                  
[D010BEA0] [C018BA5C] tcp_write_timer+0x274/0x6c0                                                                     
[D010BED0] [C0024314] run_timer_softirq+0x2d0/0xedc                                                                   
[D010BF80] [C001F1C4] ksoftirqd+0xf8/0x1b0                                                                            
[D010BFC0] [C0031588] kthread+0xc0/0xfc                                                                               
[D010BFF0] [C000471C] kernel_thread+0x44/0x60                                                                         
Instruction dump:                                                                                                     
913e000c 80030004 2f800000 419e0188 4be73599 2f830000 409e0144 801c0010                                               
5400003a 7c001278 7c000034 5400d97e <0f000000> 39200004 7f401028 7d20112d                                             
note: softirq-timer/0[5] exited with preempt_count 1                                                                  




