Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYKNTeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYKNTeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYKNTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:34:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbYKNTeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:34:25 -0500
Date: Fri, 14 Nov 2008 14:34:11 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rml@tech9.net,
       Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
In-Reply-To: <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
 <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Nov 2008, Alan Cox wrote:

> > * driver unload --- check the count of outstanding requests and call 
> > yield() repeatedly until it goes to zero, then unload.
> 
> Use a wakeup when the request count hits zero
> 
> > * reduced size of data structures (and reduced cache footprint for the hot 
> > path that actually processes requests)
> 
> The CPU will predict the non-wakeup path if that is normal. You can even
> make the wakeup use something like
> 
> 	if (exiting & count == 0)
> 
> to get the prediction righ
> 
> > The downside of yield is slower unloading of the driver by few tens of 
> > miliseconds, but the user doesn't really care about fractions of a second 
> > when unloading drivers.
> 
> And more power usage, plus extremely rude behaviour when virtualising.

How these unlikely cases can be rude?

If I have a race condition that gets triggered just for one user in the 
world when repeatedly loading & unloading a driver for an hour, and I use 
yield() to solve it, what's wrong with it? A wait queue increases cache 
footprint for every user. (even if I use preallocated hashed wait queue, 
it still eats a cacheline to access it and find out that it's empty)

Mikulas

> There are cases you have to use cpu_relax/spins or yield simply because
> the hardware doesn't feel like providing interrupts when you need them,
> but for the general case its best to use proper sleeping.
> 
> Remember also you can use a single wait queue for an entire driver for
> obscure happenings like unloads.
> 
> Alan
> 
