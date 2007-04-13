Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXDMUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXDMUiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030202AbXDMUiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:38:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030196AbXDMUiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:38:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net, Pavel Machek <pavel@ucw.cz>
Subject: [RFD] swsusp problem: Drivers allocate much memory during suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
Date: Fri, 13 Apr 2007 22:41:52 +0200
User-Agent: KMail/1.9.5
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
References: <460B6E4B.3060004@gmail.com> <200704131400.12021.rjw@sisk.pl> <1176466896.7112.159.camel@nigel.suspend2.net>
In-Reply-To: <1176466896.7112.159.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704132241.52725.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 April 2007 14:21, Nigel Cunningham wrote:
> Hi.
> 
> On Fri, 2007-04-13 at 14:00 +0200, Rafael J. Wysocki wrote:
> > > 
> > > Shrinking memory...  Pages needed: 128103 normal, 0 highmem
> > > Pages needed: 125226 normal, 0 highmem
> > > Pages needed: -5757 normal, 0 highmem
> > > Pages needed: -5757 normal, 0 highmem
> > > Pages needed: -5757 normal, 0 highmem
> > > Pages needed: -5757
> > > Pages needed: 127953 normal, 0 highmem
> > > Pages needed: 125076 normal, 0 highmem
> > > Pages needed: -6043 normal, 0 highmem
> > > Pages needed: -6043 normal, 0 highmem
> > > Pages needed: -6043 normal, 0 highmem
> > > Pages needed: -6043
> > > done (200 pages freed)
> > > Freed 800 kbytes in 0.16 seconds (5.00 MB/s)
> > > Suspending console(s)
> > > ...
> > > CPU1 is down
> > > swsusp: critical section:
> > > swsusp: Need to copy 131358 pages
> > > swsusp: Normal pages needed: 131358
> > > swsusp: Normal pages needed: 131358 + 1024 + 22, available pages: 130607
> > 
> > Well, it looks like someone allocated about 6000 pages after we had freed
> > enough memory for suspending.
> 
> We have a tunable allowance in Suspend2 for this, because fglrx
> allocates a lot of pages in its suspend routine if DRI is enabled. I
> think some other drivers do too, but fglrx is the main one I know.

I wasn't aware of that, thanks for the information.

I think this means we'll probably need to add a tunable, similar to image_size,
that will allow the users to specify how much spare memory they want to reserve
for suspending (instead of the constant PAGES_FOR_IO).  IMO we can call it
'spare_memory'.

Still, this doesn't look like a real solution, because it would require the
users affected by this problem to experiment with suspending in order to
figure out how much spare memory they will need.

IMO to really fix the problem, we should let the drivers that need much memory
for suspending allocate it _before_ the memory shrinker is called.  For this
purpose we can use notifiers that will be called before we start the shrinking
of memory.  Namely, if a driver needs to allocate substantial amount of memory
for suspending, it can register a notifier that will be called before we try to
shrink memory.  Then, the memory needed by the driver may be allocated in
this notifier (of course, in that case it will also have to be called if the
shrinking of memory fails, so that the memory allocated by the driver for
suspending can be freed) and used in the driver's .suspend() routine.

Comments welcome.

Greetings,
Rafael
