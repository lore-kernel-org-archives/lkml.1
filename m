Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZKKNse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZKKNse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZKKNsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:48:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:53412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZKKNsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:48:32 -0500
Subject: Re: Hard lockup with timer events
From: Peter Zijlstra <peterz@infradead.org>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       tglx@linutronix.de, acme@redhat.com, rosted@goodmis.org,
       paulus@samba.org
In-Reply-To: <ye8hbtiko5k.fsf@camel23.daimi.au.dk>
References: <ye8hbtiko5k.fsf@camel23.daimi.au.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 14:48:22 +0100
Message-ID: <1257947302.4372.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 20:15 +0100, Soeren Sandmann wrote:
> Hi,
> 
> This program
> 
>         http://www.daimi.au.dk/~sandmann/lockup.c
> 
> locks up hard for me on a Pentium 4 in 32 bit mode, with the hrtimer
> patches applied (-tip for example).
> 
> What the program does is spawn a thread that just spins, and then 400
> threads that each create a performance counter of type
> PERF_COUNT_SW_CPU_CLOCK and a sample period of 1000000 and a
> sample_type of
> 
>         PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_CALLCHAIN
> 
> These threads then map the event buffer and read it continuously.
> 
> It does not apparently lock up if SAMPLE_CALLCHAIN is removed; also I
> cannot get it to lock up on Core 2 Duo in either 32 or 64 bit mode.

My dual-core opteron running a 64bit kernel is decidedly unhappy about
it too... no console, no ping, but a constant stream of softlockup msgs
might give a clue, will poke at it.

[  327.635584] hrtimer: interrupt too slow, forcing clock min delta to 51117 ns
[  391.916984] BUG: soft lockup - CPU#1 stuck for 61s! [lockup:2313]                          
[  391.916984] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sr_mod floppy cdrom pcspkr sg serio_raw button shpchp [last unloaded: scsi_wait_scan]                      
[  391.916984] irq event stamp: 211957                                                                                
[  391.916984] hardirqs last  enabled at (211956): [<ffffffff813660c0>] restore_args+0x0/0x30                         
[  391.916984] hardirqs last disabled at (211957): [<ffffffff81002bd7>] save_args+0x67/0x70                           
[  391.916984] softirqs last  enabled at (1222): [<ffffffff8104b8fc>] __do_softirq+0x21e/0x22e                        
[  391.916984] softirqs last disabled at (1303): [<ffffffff81003d7c>] call_softirq+0x1c/0x3e                          
[  391.916984] CPU 1                                                                                                  
[  391.916984] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sr_mod floppy cdrom pcspkr sg serio_raw button shpchp [last unloaded: scsi_wait_scan]                      
[  391.916984] Pid: 2313, comm: lockup Not tainted 2.6.32-rc6-tip+ #6 To Be Filled By O.E.M.                          
[  391.916984] RIP: 0010:[<ffffffff810751f4>]  [<ffffffff810751f4>] lock_release+0x1ac/0x1b9                          
[  391.916984] RSP: 0000:ffff880005e03850  EFLAGS: 00000246                                                           
[  391.916984] RAX: ffff88007ce966c0 RBX: ffff880005e03880 RCX: 0000000000000001                                      
[  391.916984] RDX: 0000004c527a1a29 RSI: ffffffff810654a1 RDI: 0000000000000001                                      
[  391.916984] RBP: ffffffff81003753 R08: ffff88007ebb36c0 R09: 03c01e08c8078259                                      
[  391.916984] R10: 0000000000000000 R11: ffff88007efe58a0 R12: ffff880005e037d0                                      
[  391.916984] R13: ffffffff815774d0 R14: ffff88007ce966c0 R15: ffffffff8136b547                                      
[  391.916984] FS:  00007f9da116d710(0000) GS:ffff880005e00000(0000) knlGS:00000000f75b26c0                           
[  391.916984] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                      
[  391.916984] CR2: 00007f9db408b000 CR3: 000000007ce46000 CR4: 00000000000006e0                                      
[  391.916984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                      
[  391.916984] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                      
[  391.916984] Process lockup (pid: 2313, threadinfo ffff88007eeac000, task ffff88007ce966c0)                         
[  391.916984] Stack:                                                                                                 
[  391.916984]  ffff88007ebb36c0 ffff88007efe5800 ffff88007f996980 0000000000000000                                   
[  391.916984] <0> ffff88007ebb36c0 ffff88007efe5880 ffff880005e038d0 ffffffff812fb3e6                                
[  391.916984] <0> ffffffff812fb16e ffff88007f9ee000 ffff88007efe58a0 ffff88007fa88740                                
[  391.916984] Call Trace:                                                                                            
[  391.916984]  <IRQ>                                                                                                 
[  391.916984]  [<ffffffff812fb3e6>] ? dev_queue_xmit+0x401/0x43a                                                     
[  391.916984]  [<ffffffff812fb16e>] ? dev_queue_xmit+0x189/0x43a                                                     
[  391.916984]  [<ffffffff8131af48>] ? ip_finish_output+0x26e/0x2b7                                                   
[  391.916984]  [<ffffffff81008eaf>] ? native_sched_clock+0x37/0x71                                                   
[  391.916984]  [<ffffffff8131b025>] ? ip_output+0x94/0x9d                                                            
[  391.916984]  [<ffffffff8131867e>] ? ip_local_out+0x65/0x67                                                         
[  391.916984]  [<ffffffff8131a891>] ? ip_queue_xmit+0x2f5/0x36e                                                      
[  391.916984]  [<ffffffff810718c2>] ? mark_held_locks+0x4d/0x6b                                                      
[  391.916984]  [<ffffffff810f0f37>] ? __kmalloc+0xc6/0x152                                                           
[  391.916984]  [<ffffffff8132bf14>] ? tcp_transmit_skb+0x63a/0x679                                                   
[  391.916984]  [<ffffffff8132c139>] ? tcp_send_ack+0x116/0x11a                                                       
[  391.916984]  [<ffffffff81329421>] ? __tcp_ack_snd_check+0x6a/0x82                                                  
[  391.916984]  [<ffffffff8132a0fd>] ? tcp_rcv_established+0x7f5/0x940                                                
[  391.916984]  [<ffffffff81330b6e>] ? tcp_v4_do_rcv+0x36/0x1dc                                                       
[  391.916984]  [<ffffffff81365640>] ? _spin_lock_nested+0x70/0x78                                                    
[  391.916984]  [<ffffffff81331147>] ? tcp_v4_rcv+0x433/0x63e                                                         
[  391.916984]  [<ffffffff8131633b>] ? ip_local_deliver+0x6c/0x1b5                                                    
[  391.916984]  [<ffffffff813163bd>] ? ip_local_deliver+0xee/0x1b5                                                    
[  391.916984]  [<ffffffff8131633b>] ? ip_local_deliver+0x6c/0x1b5                                                    
[  391.916984]  [<ffffffff81316296>] ? ip_rcv+0x5a2/0x5db                                                             
[  391.916984]  [<ffffffff812f9b8c>] ? netif_receive_skb+0x311/0x36f                                                  
[  391.916984]  [<ffffffff812f9a0c>] ? netif_receive_skb+0x191/0x36f                                                  
[  391.916984]  [<ffffffff81279488>] ? e1000_clean_rx_irq+0x372/0x438                                                 
[  391.916984]  [<ffffffff8127bfdc>] ? e1000_clean+0x317/0x49f                                                        
[  391.916984]  [<ffffffff810bf640>] ? perf_output_end+0x65/0x7e                                                      
[  391.916984]  [<ffffffff812fa425>] ? net_rx_action+0xdc/0x283                                                       
[  391.916984]  [<ffffffff812fa57f>] ? net_rx_action+0x236/0x283                                                      
[  391.916984]  [<ffffffff810654a1>] ? cpu_clock+0x2d/0x3f                                                            
[  391.916984]  [<ffffffff8104b81d>] ? __do_softirq+0x13f/0x22e                                                       
[  391.916984]  [<ffffffff81070059>] ? lock_release_holdtime+0x102/0x107                                              
[  391.916984]  [<ffffffff81003d7c>] ? call_softirq+0x1c/0x3e                                                         
[  391.916984]  [<ffffffff81005391>] ? do_softirq+0x3d/0x88                                                           
[  391.916984]  [<ffffffff8104b2fe>] ? irq_exit+0x4a/0x92                                                             
[  391.916984]  [<ffffffff8136b4aa>] ? do_IRQ+0xb2/0xc9                                                               
[  391.916984]  [<ffffffff81366013>] ? ret_from_intr+0x0/0xf                                                          
[  391.916984]  <EOI>                                                                                                 
[  391.916984] Code: e8 89 ad ff ff eb 0e 4c 89 ea 4c 89 e6 48 89 df e8 e5 fb ff ff 65 48 8b 04 25 00 b5 00 00 c7 80 84 07 00 00 00 00 00 00 41 57 9d <41> 58 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 65 48 8b 04 25 00 b5                      
[  391.916984] Call Trace:                                                                                            
[  391.916984]  <IRQ>  [<ffffffff812fb3e6>] ? dev_queue_xmit+0x401/0x43a                                              
[  391.916984]  [<ffffffff812fb16e>] ? dev_queue_xmit+0x189/0x43a                                                     
[  391.916984]  [<ffffffff8131af48>] ? ip_finish_output+0x26e/0x2b7                                                   
[  391.916984]  [<ffffffff81008eaf>] ? native_sched_clock+0x37/0x71                                                   
[  391.916984]  [<ffffffff8131b025>] ? ip_output+0x94/0x9d                                                            
[  391.916984]  [<ffffffff8131867e>] ? ip_local_out+0x65/0x67                                                         
[  391.916984]  [<ffffffff8131a891>] ? ip_queue_xmit+0x2f5/0x36e                                                      
[  391.916984]  [<ffffffff810718c2>] ? mark_held_locks+0x4d/0x6b                                                      
[  391.916984]  [<ffffffff810f0f37>] ? __kmalloc+0xc6/0x152                                                           
[  391.916984]  [<ffffffff8132bf14>] ? tcp_transmit_skb+0x63a/0x679                                                   
[  391.916984]  [<ffffffff8132c139>] ? tcp_send_ack+0x116/0x11a                                                       
[  391.916984]  [<ffffffff81329421>] ? __tcp_ack_snd_check+0x6a/0x82                                                  
[  391.916984]  [<ffffffff8132a0fd>] ? tcp_rcv_established+0x7f5/0x940                                                
[  391.916984]  [<ffffffff81330b6e>] ? tcp_v4_do_rcv+0x36/0x1dc                                                       
[  391.916984]  [<ffffffff81365640>] ? _spin_lock_nested+0x70/0x78                                                    
[  391.916984]  [<ffffffff81331147>] ? tcp_v4_rcv+0x433/0x63e                                                         
[  391.916984]  [<ffffffff8131633b>] ? ip_local_deliver+0x6c/0x1b5                                                    
[  391.916984]  [<ffffffff813163bd>] ? ip_local_deliver+0xee/0x1b5                                                    
[  391.916984]  [<ffffffff8131633b>] ? ip_local_deliver+0x6c/0x1b5                                                    
[  391.916984]  [<ffffffff81316296>] ? ip_rcv+0x5a2/0x5db                                                             
[  391.916984]  [<ffffffff812f9b8c>] ? netif_receive_skb+0x311/0x36f                                                  
[  391.916984]  [<ffffffff812f9a0c>] ? netif_receive_skb+0x191/0x36f                                                  
[  391.916984]  [<ffffffff81279488>] ? e1000_clean_rx_irq+0x372/0x438                                                 
[  391.916984]  [<ffffffff8127bfdc>] ? e1000_clean+0x317/0x49f                                                        
[  391.916984]  [<ffffffff810bf640>] ? perf_output_end+0x65/0x7e                                                      
[  391.916984]  [<ffffffff812fa425>] ? net_rx_action+0xdc/0x283                                                       
[  391.916984]  [<ffffffff812fa57f>] ? net_rx_action+0x236/0x283                                                      
[  391.916984]  [<ffffffff810654a1>] ? cpu_clock+0x2d/0x3f                                                            
[  391.916984]  [<ffffffff8104b81d>] ? __do_softirq+0x13f/0x22e                                                       
[  391.916984]  [<ffffffff81070059>] ? lock_release_holdtime+0x102/0x107                                              
[  391.916984]  [<ffffffff81003d7c>] ? call_softirq+0x1c/0x3e                                                         
[  391.916984]  [<ffffffff81005391>] ? do_softirq+0x3d/0x88                                                           
[  391.916984]  [<ffffffff8104b2fe>] ? irq_exit+0x4a/0x92                                                             
[  391.916984]  [<ffffffff8136b4aa>] ? do_IRQ+0xb2/0xc9                                                               
[  391.916984]  [<ffffffff81366013>] ? ret_from_intr+0x0/0xf                                                          
[  391.916984]  <EOI>  
[  392.990186] BUG: soft lockup - CPU#0 stuck for 61s! [distccd:1734]                                                 
[  392.990186] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sr_mod floppy cdrom pcspkr sg serio_raw button shpchp [last unloaded: scsi_wait_scan]                      
[  392.990186] irq event stamp: 970145                                                                                
[  392.990186] hardirqs last  enabled at (970144): [<ffffffff813660c0>] restore_args+0x0/0x30                         
[  392.990186] hardirqs last disabled at (970145): [<ffffffff81002bd7>] save_args+0x67/0x70                           
[  392.990186] softirqs last  enabled at (105208): [<ffffffff8104b8fc>] __do_softirq+0x21e/0x22e                      
[  392.990186] softirqs last disabled at (105334): [<ffffffff813656d5>] _spin_lock_bh+0x18/0x7b                       
[  392.990186] CPU 0                                                                                                  
[  392.990186] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput sr_mod floppy cdrom pcspkr sg serio_raw button shpchp [last unloaded: scsi_wait_scan]                      
[  392.990186] Pid: 1734, comm: distccd Not tainted 2.6.32-rc6-tip+ #6 To Be Filled By O.E.M.                         
[  392.990186] RIP: 0010:[<ffffffff811c54af>]  [<ffffffff811c54af>] delay_tsc+0x2e/0xcf                               
[  392.990186] RSP: 0018:ffff88007e18dd38  EFLAGS: 00000202                                                           
[  392.990186] RAX: 0000000000000000 RBX: ffff88007e18dd68 RCX: ffffffff81330fc9                                      
[  392.990186] RDX: ffffffff811c54c5 RSI: 0000000000000001 RDI: 0000000000000001                                      
[  392.990186] RBP: ffffffff8100374e R08: ffff88007e18a780 R09: 000000000000020f                                      
[  392.990186] R10: ffffffff815b8010 R11: 0000000000000202 R12: 000000000000027d                                      
[  392.990186] R13: 00000000001d2ec0 R14: ffff88007e18c000 R15: ffff88007e18dfd8                                      
[  392.990186] FS:  00007f9db3992710(0000) GS:ffff880005c00000(0063) knlGS:00000000f75b26c0                           
[  392.990186] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b                                                      
[  392.990186] CR2: 00007f9db4126000 CR3: 000000007e072000 CR4: 00000000000006f0                                      
[  392.990186] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                      
[  392.990186] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                      
[  392.990186] Process distccd (pid: 1734, threadinfo ffff88007e18c000, task ffff88007e18a780)                        
[  392.990186] Stack:                                                                                                 
[  392.990186]  0000000000000001 000000000ba09c7e ffff88007efb5500 0000000000000001                                   
[  392.990186] <0> ffff88007e18a780 ffff88007e18ac50 ffff88007e18dd78 ffffffff811c53af                                
[  392.990186] <0> ffff88007e18ddb8 ffffffff811c96c5 000000008eaa23f8 ffff88007efb5518                                
[  392.990186] Call Trace:                                                                                            
[  392.990186]  [<ffffffff811c53af>] ? __delay+0xf/0x11                                                               
[  392.990186]  [<ffffffff811c96c5>] ? _raw_spin_lock+0xde/0x147                                                      
[  392.990186]  [<ffffffff81365723>] ? _spin_lock_bh+0x66/0x7b                                                        
[  392.990186]  [<ffffffff812eda05>] ? lock_sock_nested+0x28/0xf0                                                     
[  392.990186]  [<ffffffff812eda05>] ? lock_sock_nested+0x28/0xf0                                                     
[  392.990186]  [<ffffffff81320f8d>] ? do_tcp_setsockopt+0x9e/0x361                                                   
[  392.990186]  [<ffffffff810f6fc5>] ? fget+0x0/0x131                                                                 
[  392.990186]  [<ffffffff8132126f>] ? compat_tcp_setsockopt+0x1f/0x21                                                
[  392.990186]  [<ffffffff812ecd48>] ? compat_sock_common_setsockopt+0x1d/0x25                                        
[  392.990186]  [<ffffffff8130a551>] ? compat_sys_setsockopt+0x1d0/0x204                                              
[  392.990186]  [<ffffffff8102b3e8>] ? sysretl_from_sys_call+0x2b/0x34                                                
[  392.990186]  [<ffffffff8130a6bf>] ? compat_sys_socketcall+0x13a/0x190                                              
[  392.990186]  [<ffffffff8102b398>] ? cstar_dispatch+0x7/0x2c                                                        
[  392.990186] Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 49 89 fc bf 01 00 00 00 e8 e7 38 1a 00 e8 83 4e 00 00 41 89 c6 0f ae f0 <66> 66 90 0f 31 89 c3 65 4c 8b 3c 25 08 b5 00 00 0f ae f0 66 66                      
[  392.990186] Call Trace:                                                                                            
[  392.990186]  [<ffffffff811c54a9>] ? delay_tsc+0x28/0xcf                                                            
[  392.990186]  [<ffffffff811c53af>] ? __delay+0xf/0x11                                                               
[  392.990186]  [<ffffffff811c96c5>] ? _raw_spin_lock+0xde/0x147                                                      
[  392.990186]  [<ffffffff81365723>] ? _spin_lock_bh+0x66/0x7b                                                        
[  392.990186]  [<ffffffff812eda05>] ? lock_sock_nested+0x28/0xf0                                                     
[  392.990186]  [<ffffffff812eda05>] ? lock_sock_nested+0x28/0xf0                                                     
[  392.990186]  [<ffffffff81320f8d>] ? do_tcp_setsockopt+0x9e/0x361                                                   
[  392.990186]  [<ffffffff810f6fc5>] ? fget+0x0/0x131                                                                 
[  392.990186]  [<ffffffff8132126f>] ? compat_tcp_setsockopt+0x1f/0x21                                                
[  392.990186]  [<ffffffff812ecd48>] ? compat_sock_common_setsockopt+0x1d/0x25                                        
[  392.990186]  [<ffffffff8130a551>] ? compat_sys_setsockopt+0x1d0/0x204                                              
[  392.990186]  [<ffffffff8102b3e8>] ? sysretl_from_sys_call+0x2b/0x34                                                
[  392.990186]  [<ffffffff8130a6bf>] ? compat_sys_socketcall+0x13a/0x190                                              
[  392.990186]  [<ffffffff8102b398>] ? cstar_dispatch+0x7/0x2c  
