Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752626AbYLRJ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYLRJ3U (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYLRJ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:29:04 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51471 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbYLRJ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:29:02 -0500
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20081202132828.5c84b815.akpm@linux-foundation.org>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
	 <20081202132828.5c84b815.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 18 Dec 2008 09:28:46 +0000
Message-Id: <1229592526.12846.10.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 09:28:47.0508 (UTC) FILETIME=[07733540:01C960F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 13:28 -0800, Andrew Morton wrote:
> On Sat, 29 Nov 2008 10:43:12 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > +	INIT_LIST_HEAD(&object->object_list);
> > +	INIT_LIST_HEAD(&object->gray_list);
> > +	INIT_HLIST_HEAD(&object->area_list);
> > +	spin_lock_init(&object->lock);
> > +	atomic_set(&object->use_count, 1);
> > +	object->flags = OBJECT_ALLOCATED;
> > +	object->pointer = ptr;
> > +	object->size = size;
> > +	object->ref_count = ref_count;
> > +	object->count = -1;				/* black color initially */
> > +	object->jiffies = jiffies;
> > +	if (in_irq()) {
> > +		object->pid = 0;
> > +		strncpy(object->comm, "hardirq", TASK_COMM_LEN);
> > +	} else if (in_softirq()) {
> > +		object->pid = 0;
> > +		strncpy(object->comm, "softirq", TASK_COMM_LEN);
> > +	} else {
> > +		object->pid = current->pid;
> > +		strncpy(object->comm, current->comm, TASK_COMM_LEN);
> 
> Access to current->comm is a teeny but racy.  Use get_task_comm() here.

This seems to cause some problems. First of all, the IRQs aren't
necessarily disabled and get_task_comm() acquires current->alloc_lock
without disabling the IRQs (I could add local_irq_save/restore around
it). The alloc_lock comment in task_struct also states that the lock
protects the (de)allocation of some members which may imply that the
lock could be held when kmemleak is called.

The other issue which I couldn't completely figure out is a lockdep
warning caused by calling get_task_comm() in kmemleak:

Starting the hotplug events dispatcher: udevd                                   
======================================================                          
[ INFO: soft-safe -> soft-unsafe lock order detected ]                          
2.6.28-rc8-00074-g1134084-dirty #158                                            
------------------------------------------------------                          
udevd/350 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:                         
 (&p->alloc_lock){--..}, at: [<c008a000>] get_task_comm+0x20/0x40               
                                                                                
and this task is already holding:                                               
 (nl_table_lock){..-?}, at: [<c01c3628>] netlink_table_grab+0x18/0xd0           
which would create a new lock dependency:                                       
 (nl_table_lock){..-?} -> (&p->alloc_lock){--..}                                
                                                                                
but this new dependency connects a soft-irq-safe lock:                          
 (nl_table_lock){..-?}                                                          
... which became soft-irq-safe at:                                              
  [<c0055770>] __lock_acquire+0x51c/0x14b0                                      
  [<c0056768>] lock_acquire+0x64/0x78                                           
  [<c0229690>] _read_lock+0x34/0x44                                             
  [<c01c474c>] netlink_broadcast+0xbc/0x3bc                                     
  [<c01c52f4>] nlmsg_notify+0x6c/0x98                                           
  [<c01bde40>] rtnl_notify+0x44/0x4c                                            
  [<c01ba0f0>] __neigh_notify+0x98/0xcc                                         
  [<c01bb35c>] neigh_update_notify+0x2c/0x30                                    
  [<c01bbad8>] neigh_update+0x350/0x36c                                         
  [<c01ee5ec>] arp_process+0x624/0x6b0                                          
  [<c01ee764>] arp_rcv+0xd8/0xec                                                
  [<c01b34b4>] netif_receive_skb+0x278/0x2bc                                    
  [<c01b3580>] process_backlog+0x88/0x120                                       
  [<c01b1b78>] net_rx_action+0x6c/0x19c                                         
  [<c0039f34>] __do_softirq+0x74/0x124                                          
  [<c003a03c>] irq_exit+0x58/0x60                                               
  [<c0020068>] __exception_text_start+0x68/0x84                                 
  [<c0020a1c>] __irq_svc+0x3c/0x80                                              
  [<c0022360>] cpu_idle+0x38/0x54                                               
  [<c0223a30>] rest_init+0x58/0x6c                                              
  [<c000892c>] start_kernel+0x234/0x27c                                         
  [<70008034>] 0x70008034                                                       
  [<ffffffff>] 0xffffffff                                                       
                                                                                
to a soft-irq-unsafe lock:                                                      
 (&p->alloc_lock){--..}                                                         
... which became soft-irq-unsafe at:                                            
...  [<c0055800>] __lock_acquire+0x5ac/0x14b0                                   
  [<c0056768>] lock_acquire+0x64/0x78                                           
  [<c02292e0>] _spin_lock+0x3c/0x4c                                             
  [<c0089944>] set_task_comm+0x20/0x3c                                          
  [<c0049774>] kthreadd+0x2c/0x174                                              
  [<c0037db0>] do_exit+0x0/0x6ec                                                
  [<ffffffff>] 0xffffffff                                                       

[ ... removed some other info ... ]

stack backtrace:                                                                
[<c0226594>] (dump_stack+0x0/0x14) from [<c00551f0>] (check_usage+0x34c/0x3b0)  
[<c0054ea4>] (check_usage+0x0/0x3b0) from [<c00560ac>] (__lock_acquire+0xe58/0x1
4b0)                                                                            
[<c0055254>] (__lock_acquire+0x0/0x14b0) from [<c0056768>] (lock_acquire+0x64/0x
78)                                                                             
[<c0056704>] (lock_acquire+0x0/0x78) from [<c02292e0>] (_spin_lock+0x3c/0x4c)   
 r7:df4cebd8 r6:df4cebd8 r5:df41328c r4:df41328c                                
[<c02292a4>] (_spin_lock+0x0/0x4c) from [<c008a000>] (get_task_comm+0x20/0x40)  
 r4:df413000                                                                    
[<c0089fe0>] (get_task_comm+0x0/0x40) from [<c00828a8>] (kmemleak_alloc+0x134/0x
2b0)                                                                            
 r7:df4cebd8 r6:df4ceb28 r5:df41c000 r4:40000093                                
[<c0082774>] (kmemleak_alloc+0x0/0x2b0) from [<c0080fc0>] (__kmalloc_node+0xac/0
xb8)                                                                            
[<c0080f14>] (__kmalloc_node+0x0/0xb8) from [<c006f88c>] (__krealloc+0x4c/0x74) 
 r7:00000020 r6:00000004 r5:00000000 r4:00000000                                
[<c006f840>] (__krealloc+0x0/0x74) from [<c006f8dc>] (krealloc+0x28/0x48)       
 r7:df41df00 r6:00000020 r5:00000000 r4:00000004                                
[<c006f8b4>] (krealloc+0x0/0x48) from [<c01c37a4>] (netlink_realloc_groups+0x68/
0xb0)                                                                           
 r5:df4b5270 r4:00000004                                                        
[<c01c373c>] (netlink_realloc_groups+0x0/0xb0) from [<c01c4320>] (netlink_bind+0
x6c/0x148)                                                                      
 r7:df41df00 r6:df4b5270 r5:bef07cc4 r4:df4b5000                                
[<c01c42b4>] (netlink_bind+0x0/0x148) from [<c01a61a0>] (sys_bind+0x6c/0x90)    
 r7:df41df00 r6:0000000c r5:bef07cc4 r4:df4b5000                                
[<c01a6134>] (sys_bind+0x0/0x90) from [<c0020dc0>] (ret_fast_syscall+0x0/0x2c)  
 r7:0000011a r6:bef07cc4 r5:00000004 r4:000204f4                                

Thanks.

-- 
Catalin

