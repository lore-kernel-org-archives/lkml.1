Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbXGJI2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbXGJI2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbXGJI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:28:46 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:17630 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXGJI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:28:45 -0400
Date: Tue, 10 Jul 2007 10:28:57 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
Message-ID: <20070710102857.15a57337@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46931495.4050605@gmail.com>
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
	<46931495.4050605@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 14:09:41 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> > I haven't paid much attention to your sysfs updates.  Is it still true
> > that calls to show/store methods are mutually exclusive with attribute
> > unregistration?  Assuming the answer is Yes, would it be possible to
> > bypass that mutual exclusion in certain explicit cases?  Here's what I
> > have in mind:
> > 
> > 	The user writes to an attribute file.
> > 
> > 	The sysfs core calls the attribute's store method.
> > 
> > 	The method tells the sysfs core to pretend that the call
> > 	temporarily doesn't exist, or has completed, or something
> > 	like that.
> > 
> > 	The method safely unregisters the attribute file, with no
> > 	mutual exclusion problems and no deadlock.  Of course, the
> > 	unregistration will still block until all _other_ method
> > 	calls for this attribute are complete.
> > 
> > 	The method tells the sysfs core to stop pretending and
> > 	go back to its normal state.
> > 
> > 	The method returns, and the sysfs core takes whatever actions
> > 	are needed to fully release the attribute file.
> > 
> > The idea is that there could be a way to allow unregistration while a 
> > method is still running, if the method specifically requests it.  If we 
> > could do this then device_schedule_callback() would be unnecessary.
> 
> Regardless of the suspend problem, I like the above idea.  Actually, I
> was thinking about doing exactly that for suicidal nodes when I first
> found out the problem.  All that's needed is an owner field which allows
> the owning thread to reenter (what was the name for this type of mutex?
>  BSD folks like it).  It's probably better to put some restrictions to
> allow only the specific case tho.
> 
> I like it because it shifts complexity from the drivers into driver
> core.  IOW, the driver model is kinder to drivers that way - the driver
> writer doesn't have to care whether something is suicidal or not - and I
> think that's the way we should be headed although we're not good at it yet.

It might be that I misunderstand the idea, but doesn't the device
driver writer need to consider whether the attribute is suicidal as
well? (If it is the method that needs to call the sysfs core.)

A general immediate disconnect of the buffers (which will be handled in
a second pass) would be great, but doesn't sound easy.
