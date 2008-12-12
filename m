Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbYLLCui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbYLLCui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbYLLCuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:50:23 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:39439 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757632AbYLLCuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:50:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bo69thLT4vbHK5+Z11De/LQNV88JDQBe092cYyhs12zqHE0SeRX7RlrcWxC/dCWwm16k/lFg3F3leqChy7Pzcg7qrfaiSSvVc85ydBWLjsXrn2kF5i6Iaf6s/8/x9a6zjWZ5jl+xjWFlpq6KTPZdBEsV5PZXT7YCLFqzvWCYiXY=  ;
X-YMail-OSG: 1xeNlRUVM1lvxKYcCaMZJVX7a8sSyRr2HWS8BFYcaFz3CXePlZcp.q6jAyf2hhu9zRGUgjondkKfqg6Ic4ieUiZ4ql9rUNRIKFMIUJ3Bd9yeBCitpNWEC0kMafwYNP4SUyQa9FVp3_ePMQ3M4_6D2Kf07xHwME8PYdDV8qEOzodvuYO2uMaE6DNWYNmH
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU
Date: Fri, 12 Dec 2008 12:50:11 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <494196DD.5070600@cosmosbay.com> <200707241113.46834.nickpiggin@yahoo.com.au>
In-Reply-To: <200707241113.46834.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121350.13291.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 11:13, Nick Piggin wrote:
> On Friday 12 December 2008 09:40, Eric Dumazet wrote:
> > From: Christoph Lameter <cl@linux-foundation.org>
> >
> > [PATCH] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU
> >
> > Currently we schedule RCU frees for each file we free separately. That
> > has several drawbacks against the earlier file handling (in 2.6.5 f.e.),
> > which did not require RCU callbacks:
> >
> > 1. Excessive number of RCU callbacks can be generated causing long RCU
> >   queues that in turn cause long latencies. We hit SLUB page allocation
> >   more often than necessary.
> >
> > 2. The cache hot object is not preserved between free and realloc. A
> > close followed by another open is very fast with the RCUless approach
> > because the last freed object is returned by the slab allocator that is
> > still cache hot. RCU free means that the object is not immediately
> > available again. The new object is cache cold and therefore open/close
> > performance tests show a significant degradation with the RCU
> >   implementation.
> >
> > One solution to this problem is to move the RCU freeing into the Slab
> > allocator by specifying SLAB_DESTROY_BY_RCU as an option at slab creation
> > time. The slab allocator will do RCU frees only when it is necessary
> > to dispose of slabs of objects (rare). So with that approach we can cut
> > out the RCU overhead significantly.
> >
> > However, the slab allocator may return the object for another use even
> > before the RCU period has expired under SLAB_DESTROY_BY_RCU. This means
> > there is the (unlikely) possibility that the object is going to be
> > switched under us in sections protected by rcu_read_lock() and
> > rcu_read_unlock(). So we need to verify that we have acquired the correct
> > object after establishing a stable object reference (incrementing the
> > refcounter does that).
> >
> >
> > Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  Documentation/filesystems/files.txt |   21 ++++++++++++++--
> >  fs/file_table.c                     |   33 ++++++++++++++++++--------
> >  include/linux/fs.h                  |    5 ---
> >  3 files changed, 42 insertions(+), 17 deletions(-)
> >
> > diff --git a/Documentation/filesystems/files.txt
> > b/Documentation/filesystems/files.txt index ac2facc..6916baa 100644
> > --- a/Documentation/filesystems/files.txt
> > +++ b/Documentation/filesystems/files.txt
> > @@ -78,13 +78,28 @@ the fdtable structure -
> >     that look-up may race with the last put() operation on the
> >     file structure. This is avoided using atomic_long_inc_not_zero()
> >     on ->f_count :
> > +   As file structures are allocated with SLAB_DESTROY_BY_RCU,
> > +   they can also be freed before a RCU grace period, and reused,
> > +   but still as a struct file.
> > +   It is necessary to check again after getting
> > +   a stable reference (ie after atomic_long_inc_not_zero()),
> > +   that fcheck_files(files, fd) points to the same file.
> >
> >  	rcu_read_lock();
> >  	file = fcheck_files(files, fd);
> >  	if (file) {
> > -		if (atomic_long_inc_not_zero(&file->f_count))
> > +		if (atomic_long_inc_not_zero(&file->f_count)) {
> >  			*fput_needed = 1;
> > -		else
> > +			/*
> > +			 * Now we have a stable reference to an object.
> > +			 * Check if other threads freed file and reallocated it.
> > +			 */
> > +			if (file != fcheck_files(files, fd)) {
> > +				*fput_needed = 0;
> > +				put_filp(file);
> > +				file = NULL;
> > +			}
> > +		} else
> >  		/* Didn't get the reference, someone's freed */
> >  			file = NULL;
> >  	}
> > @@ -95,6 +110,8 @@ the fdtable structure -
> >     atomic_long_inc_not_zero() detects if refcounts is already zero or
> >     goes to zero during increment. If it does, we fail
> >     fget()/fget_light().
> > +   The second call to fcheck_files(files, fd) checks that this filp
> > +   was not freed, then reused by an other thread.
> >
> >  6. Since both fdtable and file structures can be looked up
> >     lock-free, they must be installed using rcu_assign_pointer()
> > diff --git a/fs/file_table.c b/fs/file_table.c
> > index a46e880..3e9259d 100644
> > --- a/fs/file_table.c
> > +++ b/fs/file_table.c
> > @@ -37,17 +37,11 @@ static struct kmem_cache *filp_cachep __read_mostly;
> >
> >  static struct percpu_counter nr_files __cacheline_aligned_in_smp;
> >
> > -static inline void file_free_rcu(struct rcu_head *head)
> > -{
> > -	struct file *f =  container_of(head, struct file, f_u.fu_rcuhead);
> > -	kmem_cache_free(filp_cachep, f);
> > -}
> > -
> >  static inline void file_free(struct file *f)
> >  {
> >  	percpu_counter_dec(&nr_files);
> >  	file_check_state(f);
> > -	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
> > +	kmem_cache_free(filp_cachep, f);
> >  }
> >
> >  /*
> > @@ -306,6 +300,14 @@ struct file *fget(unsigned int fd)
> >  			rcu_read_unlock();
> >  			return NULL;
> >  		}
> > +		/*
> > +		 * Now we have a stable reference to an object.
> > +		 * Check if other threads freed file and re-allocated it.
> > +		 */
> > +		if (unlikely(file != fcheck_files(files, fd))) {
> > +			put_filp(file);
> > +			file = NULL;
> > +		}
>
> This is a non-trivial change, because that put_filp may drop the last
> reference to the file. So now we have the case where we free the file
> from a context in which it had never been allocated.
>
> From a quick glance though the callchains, I can't seen an obvious
> problem. But it needs to have documentation in put_filp, or at least
> a mention in the changelog, and also cc'ed to the security lists.
>
> Also, it adds code and cost to the get/put path in return for
> improvement in the free path. get/put is the more common path, but
> it is a small loss for a big improvement. So it might be worth it. But
> it is not justified by your microbenchmark. Do we have a more useful
> case that it helps?

Sorry, my clock screwed up and I didn't notice :(
