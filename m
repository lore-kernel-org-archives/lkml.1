Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbXGDPi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbXGDPi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbXGDPit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:38:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4744 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757833AbXGDPis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:38:48 -0400
Date: Wed, 4 Jul 2007 11:38:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <18059.34264.421573.246262@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707041126290.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Paul Mackerras wrote:

> Rafael J. Wysocki writes:
> 
> > They are mostly related to kernel threads, that we've already agreed no to
> > freeze (except for the ones that want that, but they will be responsible for
> > getting everything right).  The initial patches for that are in -mm and more
> > will come.
> 
> Serious question: which kernel threads would actually want to be
> frozen?

khubd and ksuspend_usbd.

> Threads that do no I/O at all don't care about suspend/resume and
> don't need to be frozen in any case.  Threads that issue I/O requests
> in order to service incoming I/O requests can't be frozen because of
> the possibility of deadlock.  Which leaves threads that do I/O just
> for the fun of it. :)
> 
> What am I missing?

Those two threads will try to resume USB devices in response to wakeup
requests.  Such requests arrive during a suspend or resume transition
more often than one would expect.

If the resume attempt occurs before the host controller has been 
suspended, it will abort the system suspend.  If it occurs after the 
host controller is suspended (and before the controller resumes) it 
will fail and try to unregister the USB device -- something else we 
don't like happening while the sytem is only partially up (not to 
mention the annoyance caused by the unregistration of a perfectly 
functional device).

Alan Stern

