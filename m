Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXJXQTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXJXQTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbXJXQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:19:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:10473 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbXJXQTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Z7TkwOyxwX1IoChPdebCMUkwmduxjXQIXzLtPA3zIHXvcaTw6AaMiShmwxK1nASrxhXxJbaCOj9O/O66kIAlo7cCgigFrLuP2T2q+RbgqGVB4oJAXjCD9JfN0EBuDkXqv1Nmv3EX1Ja0tGf9kBnSmRkkFR8dttGcXsUBECmYXpE=
Message-ID: <2c0942db0710240919x26f0803arae3776cac7add8fa@mail.gmail.com>
Date: Wed, 24 Oct 2007 09:19:13 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "John Sigler" <linux.kernel@free.fr>
Subject: Re: How to debug complete kernel lock-ups
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <471F0DB4.1080709@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471E1D3A.8000705@free.fr> <471F0DB4.1080709@free.fr>
X-Google-Sender-Auth: 8509a3f7a2bfacb8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, John Sigler <linux.kernel@free.fr> wrote:
> > I have an x86 system with two PCI slots, in which I inserted two
> > specialized output cards (Dektec DTA-105).
> >
> > http://www.dektec.com/Products/DTA-105/
> > (They provide an open source driver.)
> >
> > My problem is: when I write to the 4 ports (each card has 2 ports) "at
> > the same time" (not really "at the same time" because I have a
> > uni-processor system, so "within a short time frame" is more accurate)
> > the system *completely* locks up.
> >
> > The manufacturer told me they had seen the problem in their lab. I'm
> > just trying to provide some helpful debug output to speed up the process
> > of fixing the problem :-)
[...]
> > Suppose the PCI bus "crashes" (whatever that means) or locks up.
> > Would that make the system completely unresponsive? The I/O does have to
> > get to/from the south bridge, through the PCI bus AFAIU. I can imagine
> > that a locked PCI bus would be slightly problematic.
> >
> > Does this mean I need some kind of PCI bus analyzer (i.e. hardware) at
> > this point? Is there anything more I can try?

You need visibility into the actual place where the issue is
happening, and by your description it's the two cards fighting each
other on the PCI bus. (I'm assuming that the problem doesn't occur
when there's only one card.)

I've worked on a platform where only a few things went through the PCI
bus, and via the firmware's debugger (completely outside the kernel),
I was able to do the setup of the PCI chip and mappings, and then
pound on the hardware directly to exhibit a lockup of the bus. That
provided pretty strong proof that it wasn't some other unrelated issue
in the kernel causing us grief.

At that point, it was pretty clear that was it, as there was no kernel
running, and the CPU was still responsive. Renting a logic analyzer
was the next step.

> How do driver writers deal with complete kernel hangs?

Lots of sleeps in between each and every write to the hardware, with
regular output. Of course, if it's a timing issue (which is what it
sounds like), you're screwed.

Other than that, I look at the hardware guys and say "Your turn," and
walk out of the room to get a cup of coffee.

Ray
