Return-Path: <linux-kernel-owner+w=401wt.eu-S967536AbXG3RL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967536AbXG3RL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967137AbXG3RJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:09:56 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48589
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967112AbXG3RJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:09:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP driver
Date: Mon, 30 Jul 2007 19:09:38 +0200
User-Agent: KMail/1.9.6
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070729212909.GC3432@traven> <200707300006.42397.mb@bu3sch.de> <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301909.38602.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2007, Satyam Sharma wrote:
> 
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

Last time I submitted a patch which returned EINTR to userspace,
people came and said it was wrong. It was said that we must
return ERESTARTSYS to the libc and the libc will convert that
into either EINTR or automatically restart it immediately.
(You can set that in the sigaction stuff).

So either the one who told me that last time was wrong, or you. :)

Andrew? I think you were involved in this discussion I mentioned.
(It was about the HW-RNG chardev, but that doesn't matter here).
