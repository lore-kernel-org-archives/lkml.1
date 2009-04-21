Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZDUFqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZDUFqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZDUFpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:45:49 -0400
Received: from mail.vyatta.com ([76.74.103.46]:57209 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZDUFps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:45:48 -0400
Date: Mon, 20 Apr 2009 22:45:40 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com, mingo@elte.hu,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
Message-ID: <20090420224540.30d7b0ed@nehalam>
In-Reply-To: <49ED5813.1000803@cn.fujitsu.com>
References: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
	<49E72E83.50702@trash.net>
	<20090416.153354.170676392.davem@davemloft.net>
	<20090416234955.GL6924@linux.vnet.ibm.com>
	<20090417012812.GA25534@linux.vnet.ibm.com>
	<20090418094001.GA2369@ioremap.net>
	<20090418141455.GA7082@linux.vnet.ibm.com>
	<20090420103414.1b4c490f@nehalam>
	<49ECBE0A.7010303@cosmosbay.com>
	<18924.59347.375292.102385@cargo.ozlabs.ibm.com>
	<20090420215827.GK6822@linux.vnet.ibm.com>
	<18924.64032.103954.171918@cargo.ozlabs.ibm.com>
	<20090420160121.268a8226@nehalam>
	<49ED406F.2040401@cn.fujitsu.com>
	<49ED4407.8010200@cosmosbay.com>
	<49ED5813.1000803@cn.fujitsu.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 13:22:27 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Eric Dumazet wrote:
> > Lai Jiangshan a écrit :
> >> Stephen Hemminger wrote:
> >>> +/**
> >>> + * xt_table_info_rdlock_bh - recursive read lock for xt table info
> >>> + *
> >>> + * Table processing calls this to hold off any changes to table
> >>> + * (on current CPU). Always leaves with bottom half disabled.
> >>> + * If called recursively, then assumes bh/preempt already disabled.
> >>> + */
> >>> +void xt_info_rdlock_bh(void)
> >>> +{
> >>> +	struct xt_info_lock *lock;
> >>> +
> >>> +	preempt_disable();
> >>> +	lock = &__get_cpu_var(xt_info_locks);
> >>> +	if (likely(++lock->depth == 0))
> >> Maybe I missed something. I think softirq may be still enabled here.
> >> So what happen when xt_info_rdlock_bh() called recursively here?
> > 
> > well, first time its called, you are right softirqs are enabled until
> > the point we call spin_lock_bh(), right after this line :
> 
> xt_info_rdlock_bh() called recursively here will enter the
> critical region without &__get_cpu_var(xt_info_locks)->lock.

NO spin_lock_bh always does a preempt_disable

  xt_info_rdlock_bh            (depth = -1)
+1         preempt_disable
           spin_lock_bh
+1             preempt_disable
-1         preempt_enable_no_resched
---
+1

Second call preempt_count=1   (depth = 0)
       xt_info_rdlock_bh
+1         preempt_disable
-1         preempt_enable_no_resched
---

Result is preempt_count=1 (depth = 1)


Now lets do unlocks
       xt_info_rdunlock_bh  preempt_count=1 depth=1
          does nothing
   xt_info_rdunlock_bh      preempt_count=1 depth = 0
-1      spin_unlock_bh

Resulting preempt_count=0  depth = -1

Same as starting point.

> Because xt_info_rdlock_bh() called recursively here sees
> lock->depth >= 0, and "++lock->depth == 0" is false.
> 
> > 
> > 
> >>> +		spin_lock_bh(&lock->lock);
> >>> +	preempt_enable_no_resched();
> > 
> > After this line, both softirqs and preempt are disabled.

No. spin_lock_bh on first pass does this.

> > Future calls to this function temporarly raise preemptcount and decrease it.
> > (Null effect)
> > 
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(xt_info_rdlock_bh);
> >>> +
> >> Is this OK for you:
> >>
> >> void xt_info_rdlock_bh(void)
> >> {
> >> 	struct xt_info_lock *lock;
> >>
> >> 	local_bh_disable();
> > 
> > well, Stephen was trying to not change preempt count for the 2nd, 3rd, 4th?... invocation of this function.
> > This is how I understood the code.
> > 
> >> 	lock = &__get_cpu_var(xt_info_locks);
> >> 	if (likely(++lock->depth == 0))
> >> 		spin_lock(&lock->lock);
> >> }
> >>
> 
> Sorry for it.
> Is this OK:
> 
> void xt_info_rdlock_bh(void)
> {
> 	struct xt_info_lock *lock;
> 
> 	local_bh_disable();
> 	lock = &__get_cpu_var(xt_info_locks);
> 	if (likely(++lock->depth == 0))
> 		spin_lock(&lock->lock);
> 	else
> 		local_bh_enable();
> }

Unnecessary.

> I did not think things carefully enough, and I do know
> nothing about ip/ip6/arp.
> 
> Lai
