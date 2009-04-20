Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZDTUnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZDTUnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZDTUm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:42:58 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34170 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbZDTUm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:42:57 -0400
Date: Mon, 20 Apr 2009 13:42:49 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v10)
Message-ID: <20090420134249.43ab1f6f@nehalam>
In-Reply-To: <49ECBE0A.7010303@cosmosbay.com>
References: <20090415170111.6e1ca264@nehalam>
	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
	<49E72E83.50702@trash.net>
	<20090416.153354.170676392.davem@davemloft.net>
	<20090416234955.GL6924@linux.vnet.ibm.com>
	<20090417012812.GA25534@linux.vnet.ibm.com>
	<20090418094001.GA2369@ioremap.net>
	<20090418141455.GA7082@linux.vnet.ibm.com>
	<20090420103414.1b4c490f@nehalam>
	<49ECBE0A.7010303@cosmosbay.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 20:25:14 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Stephen Hemminger a écrit :
> > This version of x_tables (ip/ip6/arp) locking uses a per-cpu
> > recursive lock that can be nested. It is sort of like existing kernel_lock,
> > rwlock_t and even old 2.4 brlock.
> > 
> > "Reader" is ip/arp/ip6 tables rule processing which runs per-cpu.
> > It needs to ensure that the rules are not being changed while packet
> > is being processed.
> > 
> > "Writer" is used in two cases: first is replacing rules in which case
> > all packets in flight have to be processed before rules are swapped,
> > then counters are read from the old (stale) info. Second case is where
> > counters need to be read on the fly, in this case all CPU's are blocked
> > from further rule processing until values are aggregated.
> > 
> > The idea for this came from an earlier version done by Eric Dumazet.
> > Locking is done per-cpu, the fast path locks on the current cpu
> > and updates counters.  This reduces the contention of a
> > single reader lock (in 2.6.29) without the delay of synchronize_net()
> > (in 2.6.30-rc2). 
> > 
> > The mutex that was added for 2.6.30 in xt_table is unnecessary since
> > there already is a mutex for xt[af].mutex that is held.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com
> > 
> > ---
> > Changes from earlier patches.
> >   - function name changes
> >   - disable bottom half in info_rdlock
> 
> OK, but we still have a problem on machines with >= 250 cpus,
> because calling 250 times spin_lock() is going to overflow preempt_count,
> as each spin_lock() increases preempt_count by one.
> 
> PREEMPT_MASK: 0x000000ff
> 
> add_preempt_count() should warn us about this overflow if CONFIG_DEBUG_PREEMPT is set

Wouldn't 256 or higher CPU system be faster without preempt?  If there are that many
CPU's, it is faster to do the work on other cpu and avoid the overhead of a hotly
updated preempt count.
