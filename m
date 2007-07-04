Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbXGDOi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbXGDOi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760420AbXGDOiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:38:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3980 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760047AbXGDOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:38:51 -0400
Date: Wed, 4 Jul 2007 10:38:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703224215.GA30081@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707041030540.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> On Tue, Jul 03, 2007 at 06:21:42PM -0400, Alan Stern wrote:
> > On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > > We're used to the idea of applications blocking when a resource they're 
> > > using goes away - NFS has done it forever. 
> > 
> > You persist in evading my point.  I'm not worried about applications;  
> > I'm worried about drivers.
> > 
> > Let me put it explicitly: You're writing a driver.  You're working on
> > the read, write, or probe method.  You add code to check if a system
> > sleep is underway.  Suppose the answer is Yes -- what does your driver
> > do next?
> 
> Leave the process blocked and defer any i/o until after resume. Why does 
> it need to be any more complicated than that?

(1) The driver will undoubtedly hold some mutex or semaphore at the 
time it checks whether a system sleep is underway.  You will have to 
drop it before blocking and then reacquire it afterward.

(2) The driver may have been called by some other routine which holds a 
mutex needed for resuming the device.  In this case the driver _can't_ 
drop the mutex and so the resume will deadlock.


Okay, I agree that (1) can be handled without too much effort.  But 
doing it adds an extra test to _every_ driver's I/O pathway.  Freezing 
userspace does not incur all this additional overhead.

(2) shouldn't arise during normal read and write operations, but it
certainly _will_ arise during probe.

Alan Stern

