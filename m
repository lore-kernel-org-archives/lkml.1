Return-Path: <linux-kernel-owner+w=401wt.eu-S1763394AbYDVVFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763394AbYDVVFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbYDVVF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:05:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009AbYDVVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:05:26 -0400
Date: Tue, 22 Apr 2008 13:58:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, herbert@gondor.apana.org.au,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: device_pm_add (was: Re: 2.6.25-git2: BUG: unable to handle kernel
 paging request at ffffffffffffffff)
In-Reply-To: <200804222234.19936.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0804221350110.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com> <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <200804222234.19936.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
> 
> There is a bug in device_add() that IMO can be fixed this way:

Ok, looks fine. Greg?

> Index: linux-2.6/drivers/base/core.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/core.c
> +++ linux-2.6/drivers/base/core.c
> @@ -820,11 +820,11 @@ int device_add(struct device *dev)
>  	error = bus_add_device(dev);
>  	if (error)
>  		goto BusError;
> +	bus_attach_device(dev);
>  	error = device_pm_add(dev);
>  	if (error)
>  		goto PMError;
>  	kobject_uevent(&dev->kobj, KOBJ_ADD);
> -	bus_attach_device(dev);
>  	if (parent)
>  		klist_add_tail(&dev->knode_parent, &parent->klist_children);
>  
> The problem is that bus_remove_device() assumes bus_attach_device() to have
> run, AFAICS.

As to the other issue:

> > So I would suggest reverting that commit, or at least just making it a 
> > warning (while still registering the device).
> 
> Are drivers supposed to register children of suspended devices?  That doesn't
> make much sense IMO ...

Well, that's why I think the warning itself makes sense - and then we can 
decide whether it makes sense for that particular case or not. Clearly it 
happens (since it triggered), now we need to figure out _why_ it happened. 

But I don't think debugging messages should change behaviour.

		Linus
