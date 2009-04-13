Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZDMSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZDMSL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZDMSLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:11:15 -0400
Received: from mail.vyatta.com ([76.74.103.46]:52064 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZDMSLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:11:14 -0400
Date: Mon, 13 Apr 2009 11:11:06 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       paulus@samba.org, mingo@elte.hu, torvalds@linux-foundation.org,
       laijs@cn.fujitsu.com, jeff.chua.linux@gmail.com, jengelh@medozas.de,
       kaber@trash.net, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU
Message-ID: <20090413111106.718888ca@nehalam>
In-Reply-To: <49E37908.2080903@cosmosbay.com>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
	<18913.53699.544083.320542@cargo.ozlabs.ibm.com>
	<20090412173108.GO6822@linux.vnet.ibm.com>
	<20090412.181330.23529546.davem@davemloft.net>
	<20090413040413.GQ6822@linux.vnet.ibm.com>
	<20090413095309.631cf395@nehalam>
	<49E37908.2080903@cosmosbay.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 19:40:24 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Stephen Hemminger a écrit :
> > This is an alternative version of ip/ip6/arp tables locking using
> > per-cpu locks.  This avoids the overhead of synchronize_net() during
> > update but still removes the expensive rwlock in earlier versions.
> > 
> > The idea for this came from an earlier version done by Eric Duzamet.
> > Locking is done per-cpu, the fast path locks on the current cpu
> > and updates counters.  The slow case involves acquiring the locks on
> > all cpu's.
> > 
> > The mutex that was added for 2.6.30 in xt_table is unnecessary since
> > there already is a mutex for xt[af].mutex that is held.
> > 
> > Tested basic functionality (add/remove/list), but don't have test cases
> > for stress, ip6tables or arptables.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> Patch seems good to me, but apparently xt_replace_table()
> misses the "acquiring the locks on all cpus" you mentioned in ChangeLog ?

It happens in get_counters already.

> I am still off-computers until tomorrow so cannot provide a patch for this, sorry.
> 
> Some form of
> 
> local_bh_disable();
> for_each_possible_cpu(cpu)
> 	spin_lock(&per_cpu(ip_tables_lock, cpu));
> 
> oldinfo = private;
> /* do the substitution */
> table->private = newinfo;
> newinfo->initial_entries = oldinfo->initial_entries;
> 
> for_each_possible_cpu(cpu)
> 	spin_unlock(&per_cpu(ip_tables_lock, cpu));
> local_bh_enable();
> 
> 
> But I wonder if this could hit a limit of max spinlocks held by this cpu, say on a 4096 cpu machine ?
> 
> 
> 
