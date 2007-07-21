Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbXGUUGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbXGUUGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761513AbXGUUGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:06:07 -0400
Received: from mail.screens.ru ([213.234.233.54]:53865 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761632AbXGUUGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:06:06 -0400
Date: Sun, 22 Jul 2007 00:06:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix theoretical ccids_{read,write}_lock() race
Message-ID: <20070721200627.GA107@tv-sign.ru>
References: <20070721115712.GA871@tv-sign.ru> <20070721123159.GB1769@elte.hu> <20070721141814.GA1013@tv-sign.ru> <20070721150206.GA1083@tv-sign.ru> <20070721120235.7505338a.akpm@linux-foundation.org> <20070721191104.GA83@tv-sign.ru> <20070721122149.62c73ba5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721122149.62c73ba5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Andrew Morton wrote:
>
> On Sat, 21 Jul 2007 23:11:04 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > On 07/21, Andrew Morton wrote:
> > >
> > > On Sat, 21 Jul 2007 19:02:06 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > > 
> > > > Make sure that spin_unlock_wait() is properly ordered wrt atomic_inc().
> > > > 
> > > > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> > > > 
> > > > --- t/net/dccp/ccid.c~ccid	2006-12-18 18:17:31.000000000 +0300
> > > > +++ t/net/dccp/ccid.c	2007-07-21 18:29:21.000000000 +0400
> > > > @@ -40,6 +40,7 @@ static inline void ccids_write_unlock(vo
> > > >  static inline void ccids_read_lock(void)
> > > >  {
> > > >  	atomic_inc(&ccids_lockct);
> > > > +	smp_mb__after_atomic_inc();
> > > >  	spin_unlock_wait(&ccids_lock);
> > > >  }
> > > >  
> > > 
> > > Why not just use standard rwlocks in there?
> > > 
> > > (This is probably an FAQ, but it should be).
> > 
> > Perhaps because read_lock() doesn't allow to sleep?
> > 
> 
> down_read() does.
> 
> afaict the code doesn't sleep while holding that lock anwyay.

Ah yes, it doesn't call kmem_cache_alloc() under ccids_read_lock().

So, really, why not read_lock/write_lock ?

Oleg.

