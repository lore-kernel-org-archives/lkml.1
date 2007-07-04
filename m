Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXGDPEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXGDPEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbXGDPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:04:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4318 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753816AbXGDPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:04:33 -0400
Date: Wed, 4 Jul 2007 11:04:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <18059.7151.841436.329553@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707041057230.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Paul Mackerras wrote:

> Alan Stern writes:
> 
> > > Most drivers suspended their hardware in the second call.  If they are
> > > in the middle of a conversation with their device that *has* to be
> > > completed, they can do that by polling.
> > 
> > Ugh.  That will cause problems when you try to integrate runtime 
> > suspend.  In fact this whole approach is unsuitable for runtime PM and 
> > it obscures the similarities between runtime PM and STR.
> 
> Yes there are similarities, but it would be a big mistake to say that
> a requirement for STR is that all drivers do runtime PM.

That's not what I'm saying.  What I'm saying is that it would be a big 
mistake to force all drivers which implement runtime PM to do it using 
a separate code path from system PM.

> The main attraction of the late-suspend call is that it really does,
> reliably, guarantee that the driver's I/O request methods won't get
> called between the late-suspend call and the early-resume call.

For some drivers (like USB), carrying out an actual suspend requires a
delay.  Right now we implement those delays using wait_event(),
wait_for_completion(), and so on.  Would you have us check at runtime
whether or not a system suspend is underway and in each case use a
busy-loop instead if it is?

What happens if, in order to carry out the late-suspend, a driver needs
to acquire a mutex which happens to be held by some other task?  That
other task won't be able to run and release the mutex, so you will
deadlock.

Alan Stern

