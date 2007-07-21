Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbXGUTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbXGUTWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761100AbXGUTWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:22:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761202AbXGUTWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:22:12 -0400
Date: Sat, 21 Jul 2007 12:21:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix theoretical ccids_{read,write}_lock() race
Message-Id: <20070721122149.62c73ba5.akpm@linux-foundation.org>
In-Reply-To: <20070721191104.GA83@tv-sign.ru>
References: <20070721115712.GA871@tv-sign.ru>
	<20070721123159.GB1769@elte.hu>
	<20070721141814.GA1013@tv-sign.ru>
	<20070721150206.GA1083@tv-sign.ru>
	<20070721120235.7505338a.akpm@linux-foundation.org>
	<20070721191104.GA83@tv-sign.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 23:11:04 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 07/21, Andrew Morton wrote:
> >
> > On Sat, 21 Jul 2007 19:02:06 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > 
> > > Make sure that spin_unlock_wait() is properly ordered wrt atomic_inc().
> > > 
> > > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> > > 
> > > --- t/net/dccp/ccid.c~ccid	2006-12-18 18:17:31.000000000 +0300
> > > +++ t/net/dccp/ccid.c	2007-07-21 18:29:21.000000000 +0400
> > > @@ -40,6 +40,7 @@ static inline void ccids_write_unlock(vo
> > >  static inline void ccids_read_lock(void)
> > >  {
> > >  	atomic_inc(&ccids_lockct);
> > > +	smp_mb__after_atomic_inc();
> > >  	spin_unlock_wait(&ccids_lock);
> > >  }
> > >  
> > 
> > Why not just use standard rwlocks in there?
> > 
> > (This is probably an FAQ, but it should be).
> 
> Perhaps because read_lock() doesn't allow to sleep?
> 

down_read() does.

afaict the code doesn't sleep while holding that lock anwyay.
