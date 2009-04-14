Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZDNQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZDNQtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZDNQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:48:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41616 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391AbZDNQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:48:40 -0400
Date: Tue, 14 Apr 2009 09:48:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Blunck <jblunck@suse.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atomic: Only take lock when the counter drops to zero
	on UP as well
Message-ID: <20090414164839.GI6753@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090411141754.45F7B16080@e179.suse.de> <20090414065239.GA20951@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414065239.GA20951@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 08:52:39AM +0200, Nick Piggin wrote:
> On Fri, Apr 10, 2009 at 06:13:57PM +0200, Jan Blunck wrote:
> > I think it is wrong to unconditionally take the lock before calling
> > atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock in
> > situation where it is known that the counter will not reach zero (e.g. holding
> > another reference to the same object) but the lock is already taken.
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> 
> Paul's worry about callers aside, I think it is probably a good idea
> to reduce ifdefs and share more code.

I am also OK with this patch.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> So for this patch,
> 
> Acked-by: Nick Piggin <npiggin@suse.de>
> 
> > ---
> >  lib/dec_and_lock.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
> > index a65c314..e73822a 100644
> > --- a/lib/dec_and_lock.c
> > +++ b/lib/dec_and_lock.c
> > @@ -19,11 +19,10 @@
> >   */
> >  int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
> >  {
> > -#ifdef CONFIG_SMP
> >  	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
> >  	if (atomic_add_unless(atomic, -1, 1))
> >  		return 0;
> > -#endif
> > +
> >  	/* Otherwise do it the slow way */
> >  	spin_lock(lock);
> >  	if (atomic_dec_and_test(atomic))
> > -- 
> > 1.6.0.2
