Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbXH3RXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbXH3RXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932294AbXH3RW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:22:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60987 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbXH3RW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:22:57 -0400
Date: Thu, 30 Aug 2007 23:05:51 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Robert Hancock <hancockr@shaw.ca>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, bugme-daemon@bugzilla.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mattilinnanvuori@yahoo.com
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
 should not be reachable by the outside of the module until module_init
 finishes
In-Reply-To: <46D61E7C.20304@shaw.ca>
Message-ID: <alpine.LFD.0.999.0708302246120.28360@enigma.security.iitk.ac.in>
References: <fa.fGbKfAxvHbZD1OUm5bpknraMlkQ@ifi.uio.no>
 <fa.+esfGGdgETnuZiuGXcL9U8IpoNM@ifi.uio.no> <46D61E7C.20304@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Aug 2007, Robert Hancock wrote:

> Andrew Morton wrote:
> > On Wed, 29 Aug 2007 11:33:06 -0700 (PDT) bugme-daemon@bugzilla.kernel.org
> > wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=8957
> > > 
> > >            Summary: Exported functions and variables should not be
> > > reachable
> > >                     by the outside of the module until module_init
> > > finishes
> > >            Product: Other
> > >            Version: 2.5
> > >      KernelVersion: 2.6.23-rc4
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > > >>             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: Modules
> > >         AssignedTo: other_modules@kernel-bugs.osdl.org
> > >         ReportedBy: mattilinnanvuori@yahoo.com
> > > 
> > > 
> > > Problem Description: a module's exported functions can be called before
> > > before
> > > they are properly initialized by the module_init function.
> > > 
> > > Steps to reproduce: write a module that exports functions that require
> > > initialization by the module_init function to work correctly.
> > > 
> > > E.g. spin lock variables are no longer allowed to be initialized by C
> > > initializers of the module but only by spin_lock_init that can be called
> > > by the
> > > module_init function. If an exported function calls spin_lock before it is
> > > initialized, it deadlocks.

Hmm, can you post some sample code / sample module to reproduce this?

I don't think exported symbols can be resolved till our module finishes
loading + initializing. There's a whole lot of dancing in the libusual
module precisely to cope with this behaviour.


> > ooh, nice bug ;)
> 
> Under what circumstances is this actually happening? What are these functions
> that are being called?
> 
> Normally things are set up such that this isn't a problem, i.e. if module A
> depends on module B, module A can't load until module B is finished loading.

See drivers/usb/storage/libusual.c -- pretty unusual goings on there :-)

It needs to request_module() another module (that will reference our
exported symbols). To cope with the fact that our exported modules
_cannot_ be resolved till we finish loading, it uses semaphore-used-as-
completion-handler kludge to let another "probe" kthread know when our
module_init() function is done, so that it can proceed to request_module()
the other module.

Interestingly, the kthread that request_module()s the other module is
spawned from the struct usb_driver ->probe() function (not an exported
function) and the claim there is that (1) usb_driver ->probe() can be
called out without the module_init() of libusual having finished, and,
(2) the newly requested module's loading will fail because it cannot
resolve libusual's exported symbols till we have finished module_init().


Satyam
