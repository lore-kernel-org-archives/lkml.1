Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbXGJFJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbXGJFJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 01:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXGJFJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 01:09:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:22832 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXGJFJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 01:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=P+ZohsP/y+vod9NIdA29NWYoaE2ibBIbpru6ZSXZFWyRI37RrvqL91H+acLUHZaZjnZ5XR2EPFkZqVWcpjdx064Tp7+iOXGYsm6zyqVs68NGitfmswTTWNuYowxXcO8gb8gLLAO1lni+xhddzzt1/pHA86h/fG+2hcPxFRMq1LM=
Message-ID: <46931495.4050605@gmail.com>
Date: Tue, 10 Jul 2007 14:09:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Stern wrote:
> You remember the problem we faced with "suicidal" sysfs attributes and 
> the device_schedule_callback() routine that fixes it?

Sure.

> Well, it turns out that this approach may confict with suspend/resume
> processing.  In brief, it's not a good idea to unregister devices while
> a suspend is in progress, but on the other hand it's not a good idea to
> block keventd waiting until the suspend is over.

Is it because keventd isn't frozen during suspend?  I'm afraid we might
be trying to solve the problem at the wrong layer.  Device
addition/removal should be _locked out_ during suspend/resume.
Depending on executing thread being frozen is more subtle and fragile
and freezing might go away altogether.

IMHO, what's needed is a giant rwlock protecting the whole device
addition/removal while suspend is in progress (addition/removal during
resume should be safe as long as we put the new devices on the already
processed list).  The lock can probably replace dpm_sem and dpm_list_sem.

It's probably necessary to use trylock from addition/removal to avoid
deadlock.  Drivers which support hotplugging need to rescan/revalidate
the bus during resume anyway so failing addition/removal during suspend
shouldn't be a problem.

> I haven't paid much attention to your sysfs updates.  Is it still true
> that calls to show/store methods are mutually exclusive with attribute
> unregistration?  Assuming the answer is Yes, would it be possible to
> bypass that mutual exclusion in certain explicit cases?  Here's what I
> have in mind:
> 
> 	The user writes to an attribute file.
> 
> 	The sysfs core calls the attribute's store method.
> 
> 	The method tells the sysfs core to pretend that the call
> 	temporarily doesn't exist, or has completed, or something
> 	like that.
> 
> 	The method safely unregisters the attribute file, with no
> 	mutual exclusion problems and no deadlock.  Of course, the
> 	unregistration will still block until all _other_ method
> 	calls for this attribute are complete.
> 
> 	The method tells the sysfs core to stop pretending and
> 	go back to its normal state.
> 
> 	The method returns, and the sysfs core takes whatever actions
> 	are needed to fully release the attribute file.
> 
> The idea is that there could be a way to allow unregistration while a 
> method is still running, if the method specifically requests it.  If we 
> could do this then device_schedule_callback() would be unnecessary.

Regardless of the suspend problem, I like the above idea.  Actually, I
was thinking about doing exactly that for suicidal nodes when I first
found out the problem.  All that's needed is an owner field which allows
the owning thread to reenter (what was the name for this type of mutex?
 BSD folks like it).  It's probably better to put some restrictions to
allow only the specific case tho.

I like it because it shifts complexity from the drivers into driver
core.  IOW, the driver model is kinder to drivers that way - the driver
writer doesn't have to care whether something is suicidal or not - and I
think that's the way we should be headed although we're not good at it yet.

Thanks.

-- 
tejun
