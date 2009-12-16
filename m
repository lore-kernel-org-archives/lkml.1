Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZLPAue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZLPAue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZLPAud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:50:33 -0500
Received: from tex.lwn.net ([70.33.254.29]:53535 "EHLO tex.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbZLPAuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:50:32 -0500
Date: Tue, 15 Dec 2009 17:50:29 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
Message-ID: <20091215175029.1062f139@bike.lwn.net>
In-Reply-To: <1260923885.6521.41.camel@keith-laptop>
References: <1260907788.6521.10.camel@keith-laptop>
	<20091215164950.1fd41caf@bike.lwn.net>
	<1260923885.6521.41.camel@keith-laptop>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.19.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 16:38:05 -0800
Keith Mannthey <kmannth@us.ibm.com> wrote:

> > Do you need to create a new directory for a single .c file?
> 
> Perhaps not. I have a single .h and a single .c file. 
> Do you think I should move them right into misc (with maybe a better
> name the rtl.h)? 

That's what I would do, but this is a detail.

> > For a driver which is intended to help reduce latencies, a 10ms delay with
> > a spinlock held seems a little harsh.  It seems like maybe you could drop
> > the lock and use msleep()?
> 
> Irony is that doing this special write actually triggers an SMI. 
> 
> Well I really don't want any other possible action to happen until after
> the command finishes.  I can definitely shorten the amount of time of
> the mdelay but I don't want any possible way to start another write
> until the command finishes.  

Why not protect it with a mutex and use msleep()?  I see no reason why you
need a spinlock there.

> > > +			if (count++ > 10000) {
> > 
> > ...that's 100 seconds total - a *long* time...
> 
> The is a "possible" error condition that I have given a large window
> too. More than happy to shorten it up to say a small human amount of
> time maybe 2 seconds?

Whatever makes sense for the hardware.  Certainly there comes a point where
you can conclude it's not going to get back to you.  If you get rid of the
busy wait, you can delay a lot longer here without creating trouble.

> > Again, you should use ioread32() here.
> 
> I should never directly access the ioremap region? 

No, you really shouldn't.  Probably, on any machine where this driver is
relevant you get away with it just fine, but it's not the way to write
portable code.

jon
