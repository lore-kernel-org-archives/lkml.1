Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXDUPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXDUPai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXDUPai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:30:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2294 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750827AbXDUPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:30:37 -0400
Date: Sat, 21 Apr 2007 11:30:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <d120d5000704200935s6aacf367ncc229f5bb95b1e12@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704211119430.26258-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Dmitry Torokhov wrote:

> On 4/19/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > Among the worst offenders are character devices.  None of the subsystem
> > providers offering char device registration performs immediate detach --
> > they are a lot like sysfs used to be.  (In fact, they probably _can't_
> > provide it since read() or write() calls can block indefinitely in the
> > lower-level driver; the subsystem may have no way to force them to
> > fail-fast.)
> 
> 
> That shoudl be doable - the read/write routines should check if device
> is still alive and return immideately when device is dead. When
> disconnecting device just wake up all readers and writers and they
> should eventually fall off.

Read and write don't matter so much; they can be handled easily enough in
the driver.  The real problem is the race between open() and unregister().  
We rely on the low-level drivers to make them mutually exclusive, but it
really should be done by the subsystem.  More precisely, the subsystem
should guarantee that all outstanding calls to open() have completed
before unregister() returns.

> Hmm, I guess am starting to think that using refcounting everywhere is
> not a good idea. We are trying to have "immediate disconnect" behavior
> and refcounting is an antithesis of it. Refcounting works well when it
> is contained - register grabs reference; unregister puts it back; but
> there is no passing references down between the layers. When device is
> being removed it needs to signal downstream that it is gone and should
> not be accessed anymore. And we need to do that anyway because if
> device is really gone but its users ignore it they will get endless
> stream of errors when trying to access it.

"Should not be accessed" is correct, but there's nothing wrong in 
principle with acquiring a lock in the device structure, provided the 
driver does nothing else.  And provided that the driver pins the subsystem 
module, so the device's release() routine will be called _before_ the 
subsystem can be unloaded.

Alan Stern

