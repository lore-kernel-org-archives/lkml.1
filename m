Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYK0Jke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYK0Jke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYK0Jj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:39:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYK0Jjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:39:52 -0500
Subject: Re: [PATCH 4/6] fs: Introduce a per_cpu nr_inodes
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, travis <travis@sgi.com>
In-Reply-To: <1227778377.4454.1299.camel@twins>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com>
	 <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com>
	 <20081121.010508.40225532.davem@davemloft.net>
	 <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>
	 <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com>
	 <20081121153453.GA23713@elte.hu>  <492DDC91.3020503@cosmosbay.com>
	 <1227778377.4454.1299.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Nov 2008 10:39:31 +0100
Message-Id: <1227778771.4454.1311.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 10:33 +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-27 at 00:32 +0100, Eric Dumazet wrote:
> > Avoids cache line ping pongs between cpus and prepare next patch,
> > because updates of nr_inodes metric dont need inode_lock anymore.
> > 
> > (socket8 bench result : 25s to 20.5s)
> > 
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > ---
> 
> > @@ -96,9 +96,40 @@ static DEFINE_MUTEX(iprune_mutex);
> >   * Statistics gathering..
> >   */
> >  struct inodes_stat_t inodes_stat;
> > +static DEFINE_PER_CPU(int, nr_inodes);
> >  
> >  static struct kmem_cache * inode_cachep __read_mostly;
> >  
> > +int get_nr_inodes(void)
> > +{
> > +	int cpu;
> > +	int counter = 0;
> > +
> > +	for_each_possible_cpu(cpu)
> > +	    counter += per_cpu(nr_inodes, cpu);
> > +	if (counter < 0)
> > +		counter = 0;
> > +	return counter;
> > +}
> 
> It would be good to get a cpu hotplug handler here and move to
> for_each_online_cpu(). People are wanting distro's to be build with
> NR_CPUS=4096.

Also, this trade-off between global vs per_cpu only works if
get_nr_inodes() is called significantly less than nr_inodes is changed.

With it being called from writeback that might not be true for all
workloads. One thing you can do about it is use the regular per-cpu
counter stuff, which allows you to do an approximation of the global
number (it also does all the hotplug stuff for you already).


