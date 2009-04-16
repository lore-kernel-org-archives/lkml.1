Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZDPSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZDPSml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbZDPSm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:42:27 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:40743 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbZDPSm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:42:26 -0400
Message-ID: <49E77BF6.1080206@cosmosbay.com>
Date: Thu, 16 Apr 2009 20:41:58 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu recursive spinlock  (v6)
References: <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com> <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam> <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam> <49E6BBA9.2030701@cosmosbay.com> <49E7384B.5020707@trash.net> <20090416144748.GB6924@linux.vnet.ibm.com> <49E75876.10509@cosmosbay.com> <20090416175850.GH6924@linux.vnet.ibm.com>
In-Reply-To: <20090416175850.GH6924@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 16 Apr 2009 20:41:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul E. McKenney a écrit :
> 
> But if some other CPU holds the lock, this code would fail to wait for
> that other CPU to release the lock, right?  It also might corrupt the
> rl->count field due to two CPUs accessing it concurrently non-atomically.

If another cpu holds the lock, this cpu will spin on its own lock.

Remember other cpus dont touch rl->count. This is a private field, only touched
by the cpu on its own per_cpu data. There is no possible 'corruption'


So the owner of the per_cpu data does :

/*
 * disable preemption, get rl = &__get_cpu_var(arp_tables_lock);
 * then :
 */
lock_time :
if (++rl->count == 0)
	spin_lock(&rl->lock);

unlock_time:
if (likely(--rl->count == 0))
	spin_unlock(&rl->lock);


while other cpus only do :

spin_lock(&rl->lock);
/* work on data */
spin_unlock(&rl->lock);

So they cannot corrupt 'count' stuff.

> 
> I suggest the following, preferably in a function or macro or something:
> 
> 	cur_cpu = smp_processor_id();
> 	if (likely(rl->owner != cur_cpu) {
> 		spin_lock(&rl->lock);
> 		rl->owner = smp_processor_id();
> 		rl->count = 1;
> 	} else {
> 		rl->count++;
> 	}
> 
> And the inverse for unlock.
> 
> Or am I missing something subtle?

Apparently Linus missed it too, and reacted badly to my mail.
I dont know why we discuss of this stuff on lkml either...

I stop working on this subject and consider drinking dome hard stuf and
watching tv :)

See you

