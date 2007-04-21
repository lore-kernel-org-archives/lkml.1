Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXDUTXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXDUTXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXDUTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:23:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbXDUTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:23:12 -0400
Date: Sat, 21 Apr 2007 12:21:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 04/10] lib: percpu_counter_mod64
Message-Id: <20070421122139.f5259c82.akpm@linux-foundation.org>
In-Reply-To: <1177153346.2934.36.camel@lappy>
References: <20070420155154.898600123@chello.nl>
	<20070420155502.787144532@chello.nl>
	<20070421025517.d9f9bc14.akpm@linux-foundation.org>
	<1177153346.2934.36.camel@lappy>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 13:02:26 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > +	cpu = get_cpu();
> > > +	pcount = per_cpu_ptr(fbc->counters, cpu);
> > > +	count = *pcount + amount;
> > > +	if (count >= FBC_BATCH || count <= -FBC_BATCH) {
> > > +		spin_lock(&fbc->lock);
> > > +		fbc->count += count;
> > > +		*pcount = 0;
> > > +		spin_unlock(&fbc->lock);
> > > +	} else {
> > > +		*pcount = count;
> > > +	}
> > > +	put_cpu();
> > > +}
> > > +EXPORT_SYMBOL(percpu_counter_mod64);
> > 
> > Bloaty.  Surely we won't be needing this on 32-bit kernels?  Even monster
> > PAE has only 64,000,000 pages and won't be using deltas of more than 4
> > gigapages?
> > 
> > <Does even 64-bit need to handle 4 gigapages in a single hit?  /me suspects
> > another changelog bug>
> 
> Yeah, /me chastises himself for that...
> 
> This is because percpu_counter is s64 instead of the native long; I need
> to halve the counter at some point (bdi_writeout_norm) and do that by
> subtracting half the current value.

ah, the mysterious bdi_writeout_norm().

I don't think it's possible to precisely halve a percpu_counter - there has
to be some error involved.  I guess that's acceptable within the
inscrutable bdi_writeout_norm().

otoh, there's a chance that the attempt to halve the counter will take the
counter negative, due to races.  Does the elusive bdi_writeout_norm()
handle that?  If not, it should.  If it does, then there should be comments
around the places where this is being handled, because it is subtle, and unobvious,
and others might break it by accident.

> If percpu_counter_mod is limited to s32 this might not always work
> (although in practice it might just fit).
