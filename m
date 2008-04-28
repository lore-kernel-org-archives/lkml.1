Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbYD1HxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbYD1HxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764112AbYD1Hw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:52:57 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:2976 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765632AbYD1Hw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:52:56 -0400
Date: Mon, 28 Apr 2008 09:52:53 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428075253.GB4507@osiris.boeblingen.de.ibm.com>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com> <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com> <20080428002853.1693e7fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428002853.1693e7fd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 12:28:53AM -0700, Andrew Morton wrote:
> On Mon, 28 Apr 2008 09:09:46 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Sun, Apr 27, 2008 at 06:39:26PM -0700, Andrew Morton wrote:
> > > On Sun, 27 Apr 2008 23:12:24 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > Index: linux-2.6/kernel/cpuset.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/kernel/cpuset.c
> > > > +++ linux-2.6/kernel/cpuset.c
> > > > @@ -684,7 +684,9 @@ restart:
> > > >  rebuild:
> > > >  	/* Have scheduler rebuild sched domains */
> > > >  	get_online_cpus();
> > > > +	mutex_lock(&sched_domains_mutex);
> > > >  	partition_sched_domains(ndoms, doms, dattr);
> > > > +	mutex_unlock(&sched_domains_mutex);
> > > >  	put_online_cpus();
> > > >  
> > > 
> > > It seems a bit fragile to take this lock in the caller without even adding
> > > a comment at the callee site which documents the new locking rule.
> > > 
> > > It would be more robust to take the lock within partition_sched_domains().
> > > 
> > > partition_sched_domains() already covers itself with lock_doms_cur().  Can
> > > we take that in arch_reinit_sched_domains() rather than adding the new lock?
> > 
> > I think you meant taking it in partition_sched_domains?
> 
> What I meant was: rather than adding the new sched_domains_mutex, can we
> instead call lock_doms_cur() from arch_reinit_sched_domains() and
> sched_init_smp()?  Borrow the existing lock?
> 
> Whether that makes sense depends upon what lock_doms_cur() semantically
> *means*.  As that appears to be somewhat of a secret, we get to decide ;)

Oh, I didn't realize that lock_doms_cur() was only used in one function.
So that should work. Will try.
