Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYFRQ4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYFRQ4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYFRQ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:56:25 -0400
Received: from webmail.e-teleport.net ([213.190.83.68]:55909 "EHLO
	mail.imsnet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYFRQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:56:24 -0400
Message-ID: <48593E35.1010409@e-teleport.net>
Date: Wed, 18 Jun 2008 18:56:21 +0200
From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
 MTU change
References: <20080531184615.350bac00@infradead.org> <20080603134019.df2f51d4.akpm@linux-foundation.org> <20080603215155.GA9712@electric-eye.fr.zoreil.com> <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net>
In-Reply-To: <48584AA4.8040801@e-teleport.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Séguier Régis a écrit :
> Francois Romieu a écrit :
>> Séguier Régis <rseguier@e-teleport.net> :
>> [...]
>>  
>>> The mtu change doesn't work :
>>>
>>> Jun 16 23:22:34 apollo kernel: ------------[ cut here ]------------
>>> Jun 16 23:22:34 apollo kernel: WARNING: at 
>>> arch/x86/kernel/pci-dma.c:482 dma_free_coherent+0x3a/0x9c()
>>> Jun 16 23:22:34 apollo kernel: Pid: 1527, comm: ip Tainted: G        
>>> W 2.6.26-rc6EPIA_SN_VB7001 #3
>>> Jun 16 23:22:34 apollo kernel:  [<c0115fe5>] warn_on_slowpath+0x3b/0x5f
>>> Jun 16 23:22:34 apollo kernel:  [<c0133940>] 
>>> get_page_from_freelist+0x24a/0x36f
>>> Jun 16 23:22:34 apollo kernel:  [<c012d86b>] handle_IRQ_event+0x1a/0x3f
>>> Jun 16 23:22:34 apollo kernel:  [<c0241193>] 
>>> velocity_free_rd_ring+0xa5/0xb6
>>> Jun 16 23:22:34 apollo kernel:  [<c0144752>] kfree+0x6a/0x72
>>> Jun 16 23:22:34 apollo kernel:  [<c0241193>] 
>>> velocity_free_rd_ring+0xa5/0xb6
>>> Jun 16 23:22:34 apollo kernel:  [<c0105816>] 
>>> dma_free_coherent+0x3a/0x9c
>>> Jun 16 23:22:34 apollo kernel:  [<c02411eb>] 
>>> velocity_free_dma_rings+0x47/0x4d
>>> Jun 16 23:22:34 apollo kernel:  [<c024225b>] 
>>> velocity_change_mtu+0xf6/0x157
>>> Jun 16 23:22:34 apollo kernel:  [<c02856c4>] dev_set_mtu+0x2a/0x4f
>>> Jun 16 23:22:34 apollo kernel:  [<c0286642>] dev_ioctl+0x4ab/0x530
>>> Jun 16 23:22:34 apollo kernel:  [<c012e4cb>] 
>>> handle_fasteoi_irq+0x74/0x77
>>> Jun 16 23:22:34 apollo kernel:  [<c010479b>] do_IRQ+0x50/0x60
>>> Jun 16 23:22:34 apollo kernel:  [<c027d785>] sock_ioctl+0x0/0x177
>>>     
>>
>> Does the patch below make a difference ?
>>
>> diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
>> index 71a5133..fa303da 100644
>> --- a/drivers/net/via-velocity.c
>> +++ b/drivers/net/via-velocity.c
>> @@ -1274,7 +1274,7 @@ static void velocity_free_rd_ring(struct 
>> velocity_info *vptr)
>>                   PCI_DMA_FROMDEVICE);
>>          rd_info->skb_dma = (dma_addr_t) NULL;
>>  
>> -        dev_kfree_skb(rd_info->skb);
>> +        dev_kfree_skb_any(rd_info->skb);
>>          rd_info->skb = NULL;
>>      }
>>  
>> @@ -1336,7 +1336,7 @@ static void velocity_free_td_ring_entry(struct 
>> velocity_info *vptr,
>>                  td_info->skb_dma[i] = (dma_addr_t) NULL;
>>              }
>>          }
>> -        dev_kfree_skb(td_info->skb);
>> +        dev_kfree_skb_any(td_info->skb);
>>          td_info->skb = NULL;
>>      }
>>  }
>>   
> Idem.
>
> Jun 18 01:30:15 apollo kernel: ------------[ cut here ]------------
> Jun 18 01:30:15 apollo kernel: WARNING: at 
> arch/x86/kernel/pci-dma.c:482 dma_free_coherent+0x3a/0x9c()
> Jun 18 01:30:15 apollo kernel: Pid: 1401, comm: ip Not tainted 
> 2.6.26-rc6EPIA_SN_VB7001 #4
> Jun 18 01:30:15 apollo kernel:  [<c0115fe5>] warn_on_slowpath+0x3b/0x5f
> Jun 18 01:30:15 apollo kernel:  [<c0133b19>] 
> __alloc_pages_internal+0xb4/0x349
> Jun 18 01:30:15 apollo kernel:  [<c0112bfd>] hrtick_start_fair+0x67/0xfd
> Jun 18 01:30:15 apollo kernel:  [<c011414f>] 
> check_preempt_wakeup+0x9d/0xbb
> Jun 18 01:30:15 apollo kernel:  [<c0144752>] kfree+0x6a/0x72
> Jun 18 01:30:15 apollo kernel:  [<c0241193>] 
> velocity_free_rd_ring+0xa5/0xb6
> Jun 18 01:30:15 apollo kernel:  [<c0105816>] dma_free_coherent+0x3a/0x9c
> Jun 18 01:30:15 apollo kernel:  [<c02411eb>] 
> velocity_free_dma_rings+0x47/0x4d
> Jun 18 01:30:15 apollo kernel:  [<c024225b>] 
> velocity_change_mtu+0xf6/0x157
> Jun 18 01:30:15 apollo kernel:  [<c02856c4>] dev_set_mtu+0x2a/0x4f
> Jun 18 01:30:15 apollo kernel:  [<c0286642>] dev_ioctl+0x4ab/0x530
> Jun 18 01:30:15 apollo kernel:  [<c013964a>] __do_fault+0x256/0x28e
> Jun 18 01:30:15 apollo kernel:  [<c027d8d7>] sock_ioctl+0x152/0x177
> Jun 18 01:30:15 apollo kernel:  [<c027d785>] sock_ioctl+0x0/0x177
> Jun 18 01:30:15 apollo kernel:  [<c0150b4a>] vfs_ioctl+0x16/0x48
> Jun 18 01:30:15 apollo kernel:  [<c0150d5a>] do_vfs_ioctl+0x1de/0x1f1
> Jun 18 01:30:15 apollo kernel:  [<c0150dae>] sys_ioctl+0x41/0x5b
> Jun 18 01:30:15 apollo kernel:  [<c010291d>] sysenter_past_esp+0x6a/0x91
> Jun 18 01:30:15 apollo kernel:  =======================
> Jun 18 01:30:15 apollo kernel: ---[ end trace abc2c54f7fac91dc ]---
>
This correction seems to work.

I read somewhere pci_free_consistent (in velocity_free_dma_rings) 
couldn't be use in a spin_lock.
When I move velocity_free_rings outside the spin_lock, error desappeare 
but data transfert doesn't work after the mtu change.
When I add velocity_give_many_rx_descs all work.

I will make some more tests.


--- drivers/net/via-velocity.c  2008-06-18 20:17:18.000000000 +0200
+++ ../linux-2.6.26-rc6-mtu/drivers/net/via-velocity.c  2008-06-18 
20:28:14.000000000 +0200
@@ -1968,6 +1968,8 @@ static int velocity_change_mtu(struct ne
        if (dev->mtu != new_mtu) {
                struct velocity_info *tmp_vptr;
                unsigned long flags;
+               struct tx_info tx;
+               struct rx_info rx;

                tmp_vptr = kzalloc(sizeof(*tmp_vptr), GFP_KERNEL);
                if (!tmp_vptr) {
@@ -1989,13 +1991,16 @@ static int velocity_change_mtu(struct ne
                netif_stop_queue(dev);
                velocity_shutdown(vptr);

-               velocity_free_rings(vptr);
-
+               rx=vptr->rx;
+               tx=vptr->tx;
                vptr->rx = tmp_vptr->rx;
                vptr->tx = tmp_vptr->tx;
+               tmp_vptr->rx=rx;
+               tmp_vptr->tx=tx;

                dev->mtu = new_mtu;

+               velocity_give_many_rx_descs(vptr);
                velocity_init_registers(vptr, VELOCITY_INIT_COLD);

                mac_enable_int(vptr->mac_regs);
@@ -2003,6 +2008,7 @@ static int velocity_change_mtu(struct ne

                spin_unlock_irqrestore(&vptr->lock, flags);

+               velocity_free_rings(tmp_vptr);
 out_free_tmp_vptr_1:
                kfree(tmp_vptr);
        }


-- 
Régis
