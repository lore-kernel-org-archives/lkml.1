Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbXDZTYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbXDZTYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbXDZTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:24:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51308 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbXDZTYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:24:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Thu, 26 Apr 2007 21:28:30 +0200
User-Agent: KMail/1.9.5
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Dumitru Ciobarcianu" <Dumitru.Ciobarcianu@ines.ro>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Christian Hesse" <mail@earthworm.de>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Con Kolivas" <kernel@kolivas.org>,
       "suspend2-devel@lists.suspend2.net" 
	<suspend2-devel@lists.suspend2.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>
References: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi>
In-Reply-To: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262128.31547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 18:10, Pekka Enberg wrote:
> 
> On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > In principle, we could add suspend2 as an alternative (in analogy with the I/O
> > schedulers, for example), but I think for this purpose it should be reviewed
> > properly.
> 
> Yeah, this makes sense.
> 
> On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > There also is a real problem with how it uses the LRU pages.  It _seems_ to
> > work, but at least to me it seems to be potentially dangerous.
> 
> I am new to suspend2 so can you please explain what exactly is dangerous
> about it?

After freezing tasks, it first saves the contents of the LRU pages, freezes
devices and then uses the LRU pages for storing the suspend image (if more
memory is needed, it's allocated, but that's irrelevant here).  Now, we have no
warranty that the LRU pages are not updated after we've saved their contents
(first potential problem here).

After the image has been created, we have to unfreeze devices and save the
image.  Now, we have no warranty that no one will be writing to the LRU pages
that we have used to store the image, for whatever reasons known to him, so the
image can potentially get corrupted while it's being saved.

In principle, device drivers can do this and there are some kernel threads that
also can do this (we don't freeze them, because they're needed for the image
saving).

The design is conceptually really really complicated and it makes strong
assumptions about the behavior of different subsystems.  While these
assumptions _may_ be satisfied right now, we'd have to ensure the satisfaction
of them in the future if suspend2 were merged.

Greetings,
Rafael
