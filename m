Return-Path: <linux-kernel-owner+w=401wt.eu-S966419AbXIKGm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419AbXIKGm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933345AbXIKGju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:39:50 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:41378 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933104AbXIKGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:39:48 -0400
X-Trace: 605051038-mk-filter-4.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJbV5UZRAUxC/2dsb2JhbACBXQ
Subject: Re: [PATCH 1/2] Maple Bus support for SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070911042716.GA18367@linux-sh.org>
References: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com>
	 <20070911042716.GA18367@linux-sh.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 07:39:26 +0100
Message-Id: <1189492766.6129.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 13:27 +0900, Paul Mundt wrote:
> (Adding GregKH to the CC, he needs to Ack this before I can merge it).
> 

> > diff --git a/drivers/sh/maple/maplebus.c b/drivers/sh/maple/maplebus.c
> > new file mode 100644
> > index 0000000..4662463
> > --- /dev/null
> > +++ b/drivers/sh/maple/maplebus.c
> > @@ -0,0 +1,747 @@
> > +/* maplebus.c
> > + * Core maple bus functionality
> > + * Original 2.4 code used here copyright
> > + * YAEGASHI Takeshi, Paul Mundt, M. R. Brown and others
> > + * Porting to 2.6 Copyright Adrian McMenamin, 2007
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> I don't believe the 'or any later version' thing was intended by any of
> the original authors, this should probably be dropped. The original file
> lacked explicit terms, so the default behaviour there is to fall back to
> what the top-level COPYING says, which has the 'or any later version'
> garbage removed.

On 30th of August you wrote this in an email to the linuxsh list:

"Both Marcus and I intended all of our code to be v2 only, so that
should probably be statically defined here. However, I believe
Yaegashi-san wrote a lot of this initial version, and I'm sure there
were others that hacked on it as well. So we may simply have to leave it
as GPLv2 with the unfortunate + any later version garbage."

I think you were right the first time.



> 
> > +static DEFINE_MUTEX(maple_list_lock);
> > +
> > +DEFINE_MUTEX(maple_dma_lock);
> > +EXPORT_SYMBOL_GPL(maple_dma_lock);
> > +
> It would be better to have accessors for this rather than exporting the
> mutex globally.


Actually the mutex is accessed in the aica code so it, or any wrappers
need to be exported
> 


> 
> > +/* use init call to ensure bus is registered ahead of devices */
> > +fs_initcall(maple_bus_init);
> 
> Please use subsys_initcall() or something like that, this isn't a file
> system. The comment is also pointless, it's obvious what the initcall is
> for if you use the proper one.
> 

Except performance of the driver is very poor when I use subsys_initcall
- detecting devices on a phase-of-the-noon related basis. Not an issue
when I use the later call.


> > index 0000000..8a37c7e
> > --- /dev/null
> > +++ b/include/linux/maple.h
> > @@ -0,0 +1,126 @@
> > +/**
> > + * maple.h


> 
> > +void maple_setup_port_rescan(struct maple_device *mdev);
> > +
> > +void maplebus_init_hardware(void);
> > +
> Why would these ever be accessible to drivers?
> 
You are right about the rescan - a relic of an earlier iteration but the
maplebus_init_hardware is used to control the DMA in the aica code
