Return-Path: <linux-kernel-owner+w=401wt.eu-S966891AbXG3T0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966891AbXG3T0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936942AbXG3TZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:25:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936279AbXG3TZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:25:32 -0400
Date: Mon, 30 Jul 2007 12:23:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Satyam Sharma <satyam@infradead.org>,
       Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP
 driver
Message-Id: <20070730122339.bbc541e5.akpm@linux-foundation.org>
In-Reply-To: <200707301909.38602.mb@bu3sch.de>
References: <20070729212909.GC3432@traven>
	<200707300006.42397.mb@bu3sch.de>
	<alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
	<200707301909.38602.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 19:09:38 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Monday 30 July 2007, Satyam Sharma wrote:
> > 
> > On Mon, 30 Jul 2007, Michael Buesch wrote:
> > 
> > > On Sunday 29 July 2007 23:34, Matthias Kaehlcke wrote:
> > > > The Host AP driver uses a semaphore as mutex. Use the mutex API
> > > > instead of the (binary) semaphore.
> > > > 
> > > > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> > 
> > [ Something seems to have gone wrong with your diff / patch / script.
> >   There was no diff header here, which should have been. ]
> > 
> > > > -	res = down_interruptible(&local->rid_bap_sem);
> > > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > > >  	if (res)
> > > >  		return res;
> > > >  
> > > > @@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
> > > >  	/* RID len in words and +1 for rec.rid */
> > > >  	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
> > > >  
> > > > -	res = down_interruptible(&local->rid_bap_sem);
> > > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > > >  	if (res)
> > > >  		return res;
> > > >  
> > > 
> > > Is res returned to userspace? If yes, that's not right.
> > 
> > Yup, that's not right.
> > 
> > > On a interrupted mutex allocation you should return
> > > -ERESTARTSYS to userspace.
> > 
> > Nope, userspace must not see ERESTARTSYS (I /think/ this is the third
> > time I'm participating in this exact same discussion :-)
> > 
> > If the return would be caught by a previous in-kernel caller in the
> > call chain, ERESTARTSYS is okay and it could try to restart the
> > operation. However, if the return goes unfiltered directly to
> > userspace, EINTR is the correct choice.
> 
> Last time I submitted a patch which returned EINTR to userspace,
> people came and said it was wrong. It was said that we must
> return ERESTARTSYS to the libc and the libc will convert that
> into either EINTR or automatically restart it immediately.
> (You can set that in the sigaction stuff).
> 
> So either the one who told me that last time was wrong, or you. :)
> 
> Andrew? I think you were involved in this discussion I mentioned.
> (It was about the HW-RNG chardev, but that doesn't matter here).

who, me?  signals?  Danger.

yes, I think ERESTARTSYS is correct.  That gets converted to -EINTR by the
arch's signal handling code (not by glibc) just before we return to
userspace.

