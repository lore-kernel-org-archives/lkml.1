Return-Path: <linux-kernel-owner+w=401wt.eu-S939541AbXG3T7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939541AbXG3T7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937338AbXG3T70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:59:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47551 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933415AbXG3T7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:59:24 -0400
Date: Tue, 31 Jul 2007 01:41:28 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michael Buesch <mb@bu3sch.de>,
       Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP
 driver
In-Reply-To: <20070730122339.bbc541e5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707310133230.17287@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <200707300006.42397.mb@bu3sch.de>
 <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
 <200707301909.38602.mb@bu3sch.de>
 <20070730122339.bbc541e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Andrew Morton wrote:

> On Mon, 30 Jul 2007 19:09:38 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Monday 30 July 2007, Satyam Sharma wrote:
> > > 
> > > On Mon, 30 Jul 2007, Michael Buesch wrote:
> > > 
> > > > On Sunday 29 July 2007 23:34, Matthias Kaehlcke wrote:
> > > > >  
> > > > > @@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
> > > > >  	/* RID len in words and +1 for rec.rid */
> > > > >  	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
> > > > >  
> > > > > -	res = down_interruptible(&local->rid_bap_sem);
> > > > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > > > >  	if (res)
> > > > >  		return res;
> > > > >  
> > > > 
> > > > Is res returned to userspace? If yes, that's not right.
> > > 
> > > Yup, that's not right.
> > > 
> > > > On a interrupted mutex allocation you should return
> > > > -ERESTARTSYS to userspace.
> > > 
> > > Nope, userspace must not see ERESTARTSYS (I /think/ this is the third
> > > time I'm participating in this exact same discussion :-)
> > > 
> > > If the return would be caught by a previous in-kernel caller in the
> > > call chain, ERESTARTSYS is okay and it could try to restart the
> > > operation. However, if the return goes unfiltered directly to
> > > userspace, EINTR is the correct choice.
> > 
> > Last time I submitted a patch which returned EINTR to userspace,
> > people came and said it was wrong. It was said that we must
> > return ERESTARTSYS to the libc and the libc will convert that
> > into either EINTR or automatically restart it immediately.
> > (You can set that in the sigaction stuff).
> > 
> > So either the one who told me that last time was wrong, or you. :)
> > 
> > Andrew? I think you were involved in this discussion I mentioned.
> > (It was about the HW-RNG chardev, but that doesn't matter here).
> 
> who, me?  signals?  Danger.
> 
> yes, I think ERESTARTSYS is correct.  That gets converted to -EINTR by the
> arch's signal handling code (not by glibc) just before we return to
> userspace.

Hmm? But the question is whether which of EINTR or ERESTARTSYS is correct
to be returned to userspace (so, EINTR).

But now that you pointed to the automagic ERESTARTSYS-to-EINTR conversion
in the arch/ code, I think there's no problem returning ERESTARTSYS from
syscalls in generic kernel code when interrupted by a signal either (if
all arch's do that conversion).

Probably makes sense to change down_interruptible() and
mutex_lock_interruptible() to return ERESTARTSYS (and not EINTR) in
that case. wait_event_interruptible() is already ERESTARTSYS, I see ...


Satyam
