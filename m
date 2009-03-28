Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZC1Ns2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZC1Ns2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZC1NsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:48:20 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41870 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZC1NsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AkXTg8fvfKpv+3lAwteUK3jOVd/DIbl6OuFLv/CZ6W5UR0mi9QTPRePemgTLDbA6pb
         6Rop0KAg+sa0ci1wpDRLh2hy7TY6Q0iIs9Z48lMb/qdTHOzoadJ0brs8JTHg/+Hxr+Pc
         mYdNJ0lg8yRCOnF1fbOAQg4L8mGcltRmknw78=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Possible IRQ lock inversion from 2.6.29-Linus-03321-gbe0ea69 (2.6.29-git)
Date: Sat, 28 Mar 2009 14:36:09 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Li Zefan <lizf@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
References: <49CC5F15.4020404@lwfinger.net> <200903271354.45480.bzolnier@gmail.com> <20090327120623.3056c795@bike.lwn.net>
In-Reply-To: <20090327120623.3056c795@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281436.20086.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Jonathan Corbet wrote:
> On Fri, 27 Mar 2009 13:54:35 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > I remember looking a bit more closely into the issue and not seeing
> > the problem with the locking (though I could have missed something):
> > 
> > file->f_lock is never taken in hard-irq or soft-irq context and in
> > the only place where file->f_lock is taken with fasync_lock hold we're
> > protected against IRQs by write_lock_irq().
> 
> I do think that the warning is spurious at this time.
> 
> > [ Despite not being a problem now I think that changing spin_[un]lock()
> >   to *_irq() variants for file->f_lock could be (given that it really
> >   fixes the warning) more viable long-term solution than adding special
> >   lockdep handling (well, it could be that one day file->f_lock is used
> >   in soft-irq context and then the irq lock inversion issue will become
> >   a real one) and shouldn't incurr performance penalty since we hold it
> >   only for a very brief time. ]
> 
> We could do that.  When I made the change I'd verified that there were
> no users in IRQ context, and I couldn't really see why there should
> be.  I'd rather avoid adding all those IRQ disables if I can avoid it.
> 
> How about, instead, just reversing the order of lock acquisition in
> fasync_helper()?  That would increase the hold time for f_lock, but I
> have a hard time seeing that being a real problem.  I'm running with
> the following now; all seems well.  I'll send it up in a bit if nobody
> gripes.

This is even better and works just fine here.

Thanks,
Bart
