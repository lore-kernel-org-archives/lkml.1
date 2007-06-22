Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXFVQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXFVQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758181AbXFVQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:25:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXFVQZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:25:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
Date: Fri, 22 Jun 2007 18:10:55 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <1182494169.3228.11.camel@dhcp193.mvista.com> <1182494960.20203.34.camel@chaos>
In-Reply-To: <1182494960.20203.34.camel@chaos>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706221810.56298.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/HhStcGzf43027w11Fz99UoN2sZGNGON+4eqN
 aDeChmALcTjFNRgyCeHkaQVkVz1mv/adfxa9X76EgOTNc5O/Zm
 Y2UMcsmXHrlgHU+Uaoe7Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, Thomas Gleixner wrote:
> > > Index: linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
> > > ===================================================================
> > > --- linux-2.6.21-rt9.orig/drivers/char/drm/drm_irq.c
> > > +++ linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
> > > @@ -461,7 +461,7 @@ void drm_locked_tasklet(drm_device_t *de
> > >     static DECLARE_TASKLET(drm_tasklet, drm_locked_tasklet_func, 0);
> > >  
> > >     if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ) ||
> > > -       test_bit(TASKLET_STATE_SCHED, &drm_tasklet.state))
> > > +       tasklet_is_scheduled(&drm_tasklet))
> > >             return;
> > >  
> > >     spin_lock_irqsave(&dev->tasklet_lock, irqflags);
> > > 
> > 
> > 
> > No sense in having a patch just for this, may as well merge this with
> > patch 3 ..
> 
> Wrong. patch 3 adds the API and this one makes use of it. Stevens split
> makes perfectly sense.

Wouldn't the easy solution be to get rid of drm_locked_tasklet
entirely and convert i915_vblank_tasklet(), the only user, to use
a work queue right away?

The drm_locked_tasklet() function seems to have multiple bugs anyway,
so getting rid of it can only help, and it avoids exporting a new
tasklet_is_scheduled() interface.

	Arnd <><
