Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbXFVIEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbXFVIEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXFVID5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:03:57 -0400
Received: from www.osadl.org ([213.239.205.134]:58812 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751142AbXFVIDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:03:54 -0400
Subject: Re: [PATCH -rt] Preemption problem in kernel RT Patch
From: Thomas Gleixner <tglx@linutronix.de>
To: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       David Miller <davem@davemloft.net>
In-Reply-To: <77B279EC7347F341A6AE891AA6AD68E9314247@ranchero.sycamorenet.com>
References: <77B279EC7347F341A6AE891AA6AD68E9314247@ranchero.sycamorenet.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:03:51 +0200
Message-Id: <1182499431.20203.62.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

please fix your mail client to do proper line wraps at column 78.

On Thu, 2007-06-21 at 15:39 -0400, Beauchemin, Mark wrote:
> Hi,
> 	I've found a preemption problem in kernel/rtmutex.c:649.  The BUG_ON
> listed in the patch below makes sure a preemption event hasn't
> occurred since the thread last checked the owner of the lock.  If it
> did happen and the current task is now the owner, it asserts with
> BUG_ON.  With the RT-PATCH applied, however, interrupts are not
> disabled and preemption is possible.  The following patch removes the
> BUG_ON as it is an incorrect check in the rt kernel. I've checked the
> rtmutex code and it appears to handle this case just fine..

Nice, but nevertheless wrong theory.

This check is part of the RT-Patch and it _is_ entirely correct: 
Something tries to do a spin_lock() on a lock, which the same task has
already locked before. That's what the BUG_ON is catching.

There is nothing which can make a task magically the owner of a lock,
whether preemption is enabled or not.

> Call Trace:                                                                                                           
> [D010BB40] [C01C7BA8] rt_spin_lock_slowlock+0x44/0x1f8 (unreliable)                                                   
> [D010BB90] [C0153464] dev_queue_xmit+0x298/0x2a0         Tunnel2                                                      
> [D010BBB0] [C0176398] ip_output+0x288/0x2dc                                                                           
> [D010BBE0] [C01AC078] ipip_tunnel_xmit+0x508/0x698                                                                    
> [D010BC60] [C0150DF4] dev_hard_start_xmit+0x1b4/0x2a4                                                                 
> [D010BC80] [C0153430] dev_queue_xmit+0x264/0x2a0         Tunnel4                                                      
> [D010BCA0] [C0176398] ip_output+0x288/0x2dc                                                                           
> [D010BCD0] [C01AC078] ipip_tunnel_xmit+0x508/0x698                                                                    
> [D010BD50] [C0150DF4] dev_hard_start_xmit+0x1b4/0x2a4                                                                 
> [D010BD70] [C0153430] dev_queue_xmit+0x264/0x2a0         Tunnel2                                                      
> [D010BD90] [C0176398] ip_output+0x288/0x2dc                                                                           
> [D010BDC0] [C017685C] ip_queue_xmit+0x1ac/0x4e4                                                                       
> [D010BE30] [C018762C] tcp_transmit_skb+0x390/0x810                                                                    
> [D010BE70] [C018882C] tcp_retransmit_skb+0x160/0x638                                                                  
> [D010BEA0] [C018BA5C] tcp_write_timer+0x274/0x6c0                                                                     
> [D010BED0] [C0024314] run_timer_softirq+0x2d0/0xedc                                                                   
> [D010BF80] [C001F1C4] ksoftirqd+0xf8/0x1b0                                                                            
> [D010BFC0] [C0031588] kthread+0xc0/0xfc                                                                               
> [D010BFF0] [C000471C] kernel_thread+0x44/0x60                                                                         

Looks like the tunnel code is doing a nasty recursive thing. 

Dave, any idea ?

Mark, can you please turn on CONFIG_PROVE_LOCKING. This should produce
more detailed information about the problem.

	tglx


