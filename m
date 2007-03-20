Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbXCTNkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbXCTNkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXCTNkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:40:25 -0400
Received: from mx10.go2.pl ([193.17.41.74]:51902 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935AbXCTNkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:40:24 -0400
Date: Tue, 20 Mar 2007 14:44:46 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jan Kara <jack@suse.cz>
Cc: Folkert van Heusden <folkert@vanheusden.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: dquot.c: possible circular locking Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070320134446.GA12517@ff.dom.local>
References: <20070315191749.GS31960@vanheusden.com> <20070320111701.GB1751@ff.dom.local> <20070320112253.GC1751@ff.dom.local> <20070320113151.GA12462@ff.dom.local> <20070320121909.GB14319@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320121909.GB14319@duck.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 01:19:09PM +0100, Jan Kara wrote:
> On Tue 20-03-07 12:31:51, Jarek Poplawski wrote:
> > On Tue, Mar 20, 2007 at 12:22:53PM +0100, Jarek Poplawski wrote:
> > > On Tue, Mar 20, 2007 at 12:17:01PM +0100, Jarek Poplawski wrote:
> > > ...
> > > > IMHO lockdep found that two locks are taken in different order:
> > > > 
> > > > -> #1: 1) tty_mutex in con_console() 2) dqptr_sem (somewhere later)
> > > > -> #0: 1) dqptr_sem 2) tty_console in dquot_alloc_space() with print_warning()
> > 
> > Once more - should be:
> >  -> #1: 1) tty_mutex in con_close() 2) dqptr_sem (somewhere later)
> >  -> #0: 1) dqptr_sem 2) tty_mutex in dquot_alloc_space() with print_warning()
>   Yes, I was looking at it. Hmm, we can possibly get rid of tty_mutex being
> acquired under dqptr_sem in quota code. But looking at the path from
> con_close() there's another inversion with i_mutex which is also acquired
> along the path for sysfs. And we can hardly get rid of it in the quota code.
>   Now none of these is a real deadlock as quota should never call
> print_warning() for sysfs (it doesn't use quota) but still it's nasty. I
> suppose tty_mutex is above i_mutex because of those sysfs calls and it
> seems sysfs must be called under tty_mutex because of races with
> init_dev(). So it's not easy to get rid of that dependency either.

I wonder if this cannot be done with a workqueue (message to a buffer,
maybe after try_lock on tty_mutex) and BTW isn't there any "modern"
way to queue console messages like these?

Jarek P.
