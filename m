Return-Path: <linux-kernel-owner+w=401wt.eu-S938023AbXG3DfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938023AbXG3DfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXG3DfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:35:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54717 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbXG3DfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:35:08 -0400
Date: Mon, 30 Jul 2007 09:17:25 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Michael Buesch <mb@bu3sch.de>
cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP
 driver
In-Reply-To: <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213434.GD3432@traven>
 <200707300006.42397.mb@bu3sch.de>
 <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops ...


On Mon, 30 Jul 2007, Satyam Sharma wrote:

> On Mon, 30 Jul 2007, Michael Buesch wrote:
> 
> > On Sunday 29 July 2007 23:34, Matthias Kaehlcke wrote:
> > > The Host AP driver uses a semaphore as mutex. Use the mutex API
> > > instead of the (binary) semaphore.
> > > 
> > > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> [ Something seems to have gone wrong with your diff / patch / script.
>   There was no diff header here, which should have been. ]
> 
> > > -	res = down_interruptible(&local->rid_bap_sem);
> > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > >  	if (res)
> > >  		return res;
> > >  
> > > @@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
> > >  	/* RID len in words and +1 for rec.rid */
> > >  	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
> > >  
> > > -	res = down_interruptible(&local->rid_bap_sem);
> > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > >  	if (res)
> > >  		return res;
> > >  
> > 
> > Is res returned to userspace? If yes, that's not right.
> 
> Yup, that's not right.
> 
> > On a interrupted mutex allocation you should return
> > -ERESTARTSYS to userspace.
> 
> Nope, userspace must not see ERESTARTSYS (I /think/ this is the third
> time I'm participating in this exact same discussion :-)
> 
> If the return would be caught by a previous in-kernel caller in the
> call chain, ERESTARTSYS is okay and it could try to restart the
> operation. However, if the return goes unfiltered directly to
> userspace, EINTR is the correct choice.

Eek, and because mutex_lock_interruptible() *does* return -EINTR when
interrupted by a signal, and I noticed that hfa384x_set_rid() could be
called from an ioctl(2) codepath with no intermediate caller trying to
restart it, so the code is perfectly alright, actually.

But the patch doesn't have the diff header anyway, so Matthias would
probably have to resend in any case :-)


Satyam
