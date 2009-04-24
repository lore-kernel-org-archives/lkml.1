Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZDXQTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZDXQTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZDXQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:18:48 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50643 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZDXQSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:18:46 -0400
Date: Fri, 24 Apr 2009 09:18:39 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH]  netfilter: use per-CPU recursive lock {XIV}
Message-ID: <20090424091839.6e13ebec@nehalam>
In-Reply-To: <49F146FF.5050200@cosmosbay.com>
References: <20090418094001.GA2369@ioremap.net>
	<20090418141455.GA7082@linux.vnet.ibm.com>
	<20090420103414.1b4c490f@nehalam>
	<49ECBE0A.7010303@cosmosbay.com>
	<18924.59347.375292.102385@cargo.ozlabs.ibm.com>
	<20090420215827.GK6822@linux.vnet.ibm.com>
	<18924.64032.103954.171918@cargo.ozlabs.ibm.com>
	<20090420160121.268a8226@nehalam>
	<alpine.LFD.2.00.0904210831560.2199@localhost.localdomain>
	<20090421111541.228e977a@nehalam>
	<20090421193924.GA24404@elte.hu>
	<20090421143927.52d7d89d@nehalam>
	<alpine.LFD.2.00.0904220821240.3101@localhost.localdomain>
	<20090423210938.1501507b@nehalam>
	<49F146FF.5050200@cosmosbay.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 06:58:39 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Stephen Hemminger a écrit :
> > In days of old in 2.6.29, netfilter did locketh using a 
> > lock of the reader kind when doing its table business, and do
> > a writer when with pen in hand like a overworked accountant
> > did replace the tables. This sucketh and caused the single
> > lock to fly back and forth like a poor errant boy.
> > 
> > But then netfilter was blessed with RCU and the performance
> > was divine, but alas there were those that suffered for
> > trying to replace their many rules one at a time.
> > 
> > So now RCU must be vanquished from the scene, and better
> > chastity belts be placed upon this valuable asset most dear.
> > The locks that were but one are now replaced by one per suitor.
> > 
> > The repair was made after much discussion involving
> > Eric the wise, and Linus the foul. With flowers springing
> > up amid the thorns some peace has finally prevailed and
> > all is soothed. This patch and purple prose was penned by
> > in honor of "Talk like Shakespeare" day.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> 
> Philip Davis of the university’s School of English said :
> 
>   "Shakespeare surprises the brain and catches it off guard in
>   a manner that produces a sudden burst of activity - a sense 
>   of drama created out of the simplest of things."
> 
> http://www.physorg.com/news85664210.html
> 
> > 
> > ---
> > What hath changed over the last two setting suns:
> >   * more words, mostly correct...
> > 
> >   * no need to locketh for writeh on current cpu tis 
> >     always so
> > 
> >   * the locking of all cpu's on replace is always done as
> >     part of the get_counters cycle, so the sychronize swip
> >     in replace tables is gone with only a comment remaing
> > 
> >  include/linux/netfilter/x_tables.h |   55 ++++++++++++++--
> >  net/ipv4/netfilter/arp_tables.c    |  125 ++++++++++--------------------------
> >  net/ipv4/netfilter/ip_tables.c     |  126 ++++++++++---------------------------
> >  net/ipv6/netfilter/ip6_tables.c    |  123 ++++++++++--------------------------
> >  net/netfilter/x_tables.c           |   55 ++++++++--------
> >  5 files changed, 188 insertions(+), 296 deletions(-)
> > 
> 
> 
> >  
> >  static int __init xt_init(void)
> >  {
> > -	int i, rv;
> > +	unsigned int i;
> > +	int rv;
> > +	static struct lock_class_key xt_lock_key[NR_CPUS];
> 
> Could we avoid this [NR_CPUS] thing ?
> 
> > +
> > +	for_each_possible_cpu(i) {
> > +		rwlock_t *lock = &per_cpu(xt_info_locks, i);
> > +
> > +		rwlock_init(lock);
> > +		lockdep_set_class(lock, xt_lock_key+i);
> > +	}
> 
> 
> Did you tried :
> 
> static DECLARE_PER_CPU(struct lock_class_key, xt_locks_key);
> 

The lock keys are really only used by lock dep, and I thought per cpu
space was more scarce on some arch.

