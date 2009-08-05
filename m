Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbZHEHUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbZHEHUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbZHEHUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:20:53 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33079 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933684AbZHEHUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:20:52 -0400
Message-ID: <4A793284.8000401@gmail.com>
Date: Wed, 05 Aug 2009 09:19:32 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Pirko <jpirko@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20090804.125742.32009006.davem@davemloft.net> <20090805070205.GA8741@elte.hu> <20090805071411.GA9217@elte.hu>
In-Reply-To: <20090805071411.GA9217@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 05 Aug 2009 09:19:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> FYI, -tip testing found that these bits trigger a missing lockdep 
>> annotation warning:
> 
> it's apparently using an zero-initialized spinlock. This is a 
> side-effect of:
> 
>         dev_unicast_init(dev);
> 
> in alloc_netdev_mq() making use of dev->addr_list_lock.
> 
> Wouldnt the patch below be the right fix? The device has just been 
> allocated freshly, it's not accessible anywhere yet so no locking is 
> needed at all - in fact it's wrong to lock it here (the lock isnt 
> initialized yet).
> 
> This bug was apparently introduced via:
> 
> | commit a6ac65db2329e7685299666f5f7b6093c7b0f3a0
> | Author: Jiri Pirko <jpirko@redhat.com>
> | Date:   Thu Jul 30 01:06:12 2009 +0000
> |
> |     net: restore the original spinlock to protect unicast list
> 
> it needlessly added new locking and apparently nobody ran this patch 
> with lockdep.
> 
> 	Ingo
> 
> Index: linux2/net/core/dev.c
> ===================================================================
> --- linux2.orig/net/core/dev.c
> +++ linux2/net/core/dev.c
> @@ -4007,9 +4007,7 @@ static void dev_unicast_flush(struct net
>  
>  static void dev_unicast_init(struct net_device *dev)
>  {
> -	netif_addr_lock_bh(dev);
>  	__hw_addr_init(&dev->uc);
> -	netif_addr_unlock_bh(dev);
>  }
>  
>  


Indeed, this function is static and thus only called from alloc_netdev_mq()

