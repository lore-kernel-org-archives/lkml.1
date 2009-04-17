Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZDQANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZDQANZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZDQANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:13:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50696 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbZDQANG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:13:06 -0400
Date: Thu, 16 Apr 2009 17:13:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu recursive spinlock  (v6)
Message-ID: <20090417001304.GA21657@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam> <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam> <49E6BBA9.2030701@cosmosbay.com> <49E7384B.5020707@trash.net> <20090416144748.GB6924@linux.vnet.ibm.com> <49E75876.10509@cosmosbay.com> <20090416175850.GH6924@linux.vnet.ibm.com> <49E77BF6.1080206@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49E77BF6.1080206@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 08:41:58PM +0200, Eric Dumazet wrote:
> 
> 
> Paul E. McKenney a écrit :
> > 
> > But if some other CPU holds the lock, this code would fail to wait for
> > that other CPU to release the lock, right?  It also might corrupt the
> > rl->count field due to two CPUs accessing it concurrently non-atomically.
> 
> If another cpu holds the lock, this cpu will spin on its own lock.
> 
> Remember other cpus dont touch rl->count. This is a private field, only touched
> by the cpu on its own per_cpu data. There is no possible 'corruption'

Ah!!!  I must confess that I didn't make it that far into the code...

> So the owner of the per_cpu data does :
> 
> /*
>  * disable preemption, get rl = &__get_cpu_var(arp_tables_lock);
>  * then :
>  */
> lock_time :
> if (++rl->count == 0)
> 	spin_lock(&rl->lock);
> 
> unlock_time:
> if (likely(--rl->count == 0))
> 	spin_unlock(&rl->lock);
> 
> 
> while other cpus only do :
> 
> spin_lock(&rl->lock);
> /* work on data */
> spin_unlock(&rl->lock);
> 
> So they cannot corrupt 'count' stuff.

OK, that does function.  Hurts my head, though.  ;-)

> > I suggest the following, preferably in a function or macro or something:
> > 
> > 	cur_cpu = smp_processor_id();
> > 	if (likely(rl->owner != cur_cpu) {
> > 		spin_lock(&rl->lock);
> > 		rl->owner = smp_processor_id();
> > 		rl->count = 1;
> > 	} else {
> > 		rl->count++;
> > 	}
> > 
> > And the inverse for unlock.
> > 
> > Or am I missing something subtle?
> 
> Apparently Linus missed it too, and reacted badly to my mail.
> I dont know why we discuss of this stuff on lkml either...

Encapsulating them so that they appear in the same place might (or might
not) have gotten the fact that you were not doing a recursive lock
through my head.  Even so, the name "rec_lock" might have overwhelmed
the code structure in my mind.  ;-)

> I stop working on this subject and consider drinking dome hard stuf and
> watching tv :)

That -is- extreme!  ;-)

							Thanx, Paul

> See you
> 
