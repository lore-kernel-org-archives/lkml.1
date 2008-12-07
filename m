Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYLGRou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYLGRou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYLGRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:44:38 -0500
Received: from kandzendo.ru ([195.178.208.66]:58526 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYLGRoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:44:37 -0500
Date: Sun, 7 Dec 2008 20:44:35 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207174435.GB1687@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk> <20081207163151.GA31838@ioremap.net> <20081207170108.39dfd93f@lxorguk.ukuu.org.uk> <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com> <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 05:28:55PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > /dev/console is a logical mapping to a device which may well be
> > > different, loaded after PCI is initialised and dependant on PCI.
> > 
> > So wrong. If no driver is associated, like early, in that case, we
> > must return -ENODEV, instead of calling modprobe in a loop. It's a
> > built-in device, and it's easy to fix.
> 
> You've clearly no idea how initrd even works have you ? If it just
> returned -ENODEV you wouldn't be able to open the console and you
> wouldn't trigger the loading of the module to get the console running. So
> you've now completely buggered the boot process.
> 
> The correct sequence is
> 
> 	Open device
> 		Kernel issues hotplug message
> 			Hotplug script loads drivers to policy
> 
> 
> The problem case you have due to initrd bugs is
> 
> 	Open device
> 		Kernel issues hotplug message
> 			Hotplug script opens same device (BUG)

Everyone understands that, what you do not want to get, is that this
case can be handled by the kernel so that there would be no recursion.
And instead of thinking how to fix it, you just try to shut it up.

There may be another case, when the same happens inside the kernel, i.e.
module being loaded requires console and the same happens again. Similar
problem exists for network console, when there is no underlying device
yet, but it is handled.

Fortunately console is the most common example (maybe even the only
one), so this case can be fixed easily. Moreover, because of subtle
tty ordering, when everything is in kernel, it still may be triggered,
as was shown previously.

And while having dumb console device sounds awful for you, it is a
bulletprof solution even for non-expected userspace behaviout. And so
far the only objection was that it may break something, which you
believe may happen not even being tested.

Alan, let's make some progress on this fingerpointing. If Herbert's
patch fixes the crypto loading problem, it will find its way upstream
for the current tree, and in the merge window Kay's patch may be applied
and widely tested. Thoughts?

-- 
	Evgeniy Polyakov
