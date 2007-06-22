Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXFVSYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXFVSYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXFVSYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:24:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063AbXFVSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:24:34 -0400
Date: Fri, 22 Jun 2007 19:24:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Daniel Walker <dwalker@mvista.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
Message-ID: <20070622182411.GA17658@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
	Daniel Walker <dwalker@mvista.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	"David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
	kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <1182494169.3228.11.camel@dhcp193.mvista.com> <1182494960.20203.34.camel@chaos> <200706221810.56298.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221810.56298.arnd@arndb.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 06:10:55PM +0200, Arnd Bergmann wrote:
> On Friday 22 June 2007, Thomas Gleixner wrote:
> > > > Index: linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
> > > > ===================================================================
> > > > --- linux-2.6.21-rt9.orig/drivers/char/drm/drm_irq.c
> > > > +++ linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
> > > > @@ -461,7 +461,7 @@ void drm_locked_tasklet(drm_device_t *de
> > > > ????static DECLARE_TASKLET(drm_tasklet, drm_locked_tasklet_func, 0);
> > > > ?
> > > > ????if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ) ||
> > > > -??? ? ?test_bit(TASKLET_STATE_SCHED, &drm_tasklet.state))
> > > > +??? ? ?tasklet_is_scheduled(&drm_tasklet))
> > > > ????????????return;
> > > > ?
> > > > ????spin_lock_irqsave(&dev->tasklet_lock, irqflags);
> > > > 
> > > 
> > > 
> > > No sense in having a patch just for this, may as well merge this with
> > > patch 3 ..
> > 
> > Wrong. patch 3 adds the API and this one makes use of it. Stevens split
> > makes perfectly sense.
> 
> Wouldn't the easy solution be to get rid of drm_locked_tasklet
> entirely and convert i915_vblank_tasklet(), the only user, to use
> a work queue right away?
> 
> The drm_locked_tasklet() function seems to have multiple bugs anyway,
> so getting rid of it can only help, and it avoids exporting a new
> tasklet_is_scheduled() interface.

That's exactly what I though when looking over this code.  There's
some really crappy in code in that area, and it should simply be
rewritten.
