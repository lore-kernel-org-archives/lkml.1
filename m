Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZDNRT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZDNRT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZDNRTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:19:45 -0400
Received: from mail.vyatta.com ([76.74.103.46]:55210 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbZDNRTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:19:43 -0400
Date: Tue, 14 Apr 2009 10:19:36 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Patrick McHardy <kaber@trash.net>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com,
       jeff.chua.linux@gmail.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU
Message-ID: <20090414101936.1d70879c@nehalam>
In-Reply-To: <49E4B0A5.70404@cosmosbay.com>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
	<18913.53699.544083.320542@cargo.ozlabs.ibm.com>
	<20090412173108.GO6822@linux.vnet.ibm.com>
	<20090412.181330.23529546.davem@davemloft.net>
	<20090413040413.GQ6822@linux.vnet.ibm.com>
	<20090413095309.631cf395@nehalam>
	<49E48136.5060700@trash.net>
	<49E49C65.8060808@cosmosbay.com>
	<20090414074554.7fa73e2f@nehalam>
	<49E4B0A5.70404@cosmosbay.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 17:49:57 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Stephen Hemminger a écrit :
> > On Tue, 14 Apr 2009 16:23:33 +0200
> > Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> >> Patrick McHardy a écrit :
> >>> Stephen Hemminger wrote:
> >>>> This is an alternative version of ip/ip6/arp tables locking using
> >>>> per-cpu locks.  This avoids the overhead of synchronize_net() during
> >>>> update but still removes the expensive rwlock in earlier versions.
> >>>>
> >>>> The idea for this came from an earlier version done by Eric Duzamet.
> >>>> Locking is done per-cpu, the fast path locks on the current cpu
> >>>> and updates counters.  The slow case involves acquiring the locks on
> >>>> all cpu's.
> >>>>
> >>>> The mutex that was added for 2.6.30 in xt_table is unnecessary since
> >>>> there already is a mutex for xt[af].mutex that is held.
> >>>>
> >>>> Tested basic functionality (add/remove/list), but don't have test cases
> >>>> for stress, ip6tables or arptables.
> >>> Thanks Stephen, I'll do some testing with ip6tables.
> >> Here is the patch I cooked on top of Stephen one to get proper locking.
> > 
> > I see no demonstrated problem with locking in my version.
> 
> Yes, I did not crash any machine around there, should we wait for a bug report ? :)
> 
> > The reader/writer race is already handled. On replace the race of
> > 
> > CPU 0                          CPU 1
> >                            lock (iptables(1))
> >                            refer to oldinfo
> > swap in new info
> > foreach CPU
> >    lock iptables(i)
> >    (spin)                  unlock(iptables(1))
> >    read oldinfo
> >    unlock
> > ...
> > 
> > The point is my locking works, you just seem to feel more comfortable with
> > a global "stop all CPU's" solution.
> 
> Oh right, I missed that xt_replace_table() was *followed* by a get_counters()
> call, but I am pretty sure something is needed in xt_replace_table().
> 
> A memory barrier at least (smp_wmb())
> 
> As soon as we do "table->private = newinfo;", other cpus might fetch incorrect
> values for newinfo->fields.
> 
> In the past, we had a write_lock_bh()/write_unlock_bh() pair that was
> doing this for us.
> Then we had rcu_assign_pointer() that also had this memory barrier implied.
> 
> Even if vmalloc() calls we do before calling xt_replace_table() probably
> already force barriers, add one for reference, just in case we change callers
> logic to call kmalloc() instead of vmalloc() or whatever...
>

You are right, doing something with barrier would be safer there.
How about using xchg?

@@ -682,26 +668,19 @@ xt_replace_table(struct xt_table *table,
 	      struct xt_table_info *newinfo,
 	      int *error)
 {
-	struct xt_table_info *oldinfo, *private;
+	struct xt_table_info *private;
 
 	/* Do the substitution. */
-	mutex_lock(&table->lock);
 	private = table->private;
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		duprintf("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		mutex_unlock(&table->lock);
 		*error = -EAGAIN;
 		return NULL;
 	}
-	oldinfo = private;
-	rcu_assign_pointer(table->private, newinfo);
-	newinfo->initial_entries = oldinfo->initial_entries;
-	mutex_unlock(&table->lock);
-
-	synchronize_net();
-	return oldinfo;
+	newinfo->initial_entries = private->initial_entries;
+	return xchg(&table->private, newinfo);
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
 
P.s: we all missed the ordering bug in the RCU version??

