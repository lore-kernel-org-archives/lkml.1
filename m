Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbYFPWB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbYFPWB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYFPWBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:01:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYFPWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:01:48 -0400
Subject: Re: [PATCH] ip2: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
In-Reply-To: <4856DDAA.1080707@garzik.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	 <20080616115950.41bc65aa@lxorguk.ukuu.org.uk>	<4856C6C8.6060506@garzik.org>
	 <4856C795.2050007@garzik.org>	<20080616205820.1fe298d7@lxorguk.ukuu.org.uk>
	 <4856CB61.6030202@garzik.org> <20080616212111.406f9c96@lxorguk.ukuu.org.uk>
	 <4856DDAA.1080707@garzik.org>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 23:01:39 +0100
Message-Id: <1213653699.26255.862.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 17:39 -0400, Jeff Garzik wrote:
> Alan Cox wrote:
> >> Extracting the firmware:  good
> >>
> >> Scattering a /single/ driver across multiple directories in the kernel 
> >> tree:  bad
> > 
> > I'd equally argue that putting all the firmware in one place is more
> > logical than smearing it around the tree.
> 
> Logical for whom?  Drivers have always been self-contained... until now.
> 
> This separation certainly does not make things _easier_ for users, our 
> reason for existence.  This separation certainly does not make it easier 
> to drop in a driver with a firmware, i.e. not easier on driver 
> developers.  It is one more PITA detail when copying a driver from one 
> kernel to another, or shipping the driver out of tree.

When you're doing either of those things, you should be letting
request_firmware() do its job. You shouldn't _need_ to build that
firmware into your static kernel image.

And if you _do_ want to build arbitrary firmware into your kernel image,
you can do that with ease -- with the CONFIG_BUILTIN_FIRMWARE option you
can include _whatever_ files you like.

> There are good reasons why the Makefile rules, Kconfig rules, C source 
> code and headers for a driver all live together...  moving the firmware 
> elsewhere is strangely, given that a driver simply /does not work/ 
> without the firmware.

We already cope with having separate directories for include/, and with
having some stuff split between arch/ and generic locations. In fact,
not only do we 'cope', but we _prefer_ it that way. It's logical. And
that's for kernel code which really does get modified in lock-step.

We almost _never_ change firmware and driver in lock-step as we do other
code. Maybe we'd like to -- but since the firmware is usually an opaque
blob, we don't have that luxury. So it really isn't that much of an
issue to have the firmware in the firmware/ directory where we've been
putting it.

When you have a new firmware blob and you want to update it, it really
is no harder this way than it was before. In fact, in most cases I've
converted so far, it should be easier. That's certainly the intention.

> I like the goal, but see little effort in the area of "make this 
> transition painless for users."

Actually this choice was made with that as the primary motivation. It
makes it easy for 'make firmware_install' to do the right thing, and
that should be the primary interface for the user. It also makes it
simple to build a 'shadow' git tree, like the kernel-headers tree, which
contains _only_ the firmware -- and also to build a GPL-only kernel
source tarball which _omits_ it, for whose who want such a thing (like
Fedora does).

If you look at my original patches, you'll see that I did _start_ by
putting firmware blobs in the source tree next to the drivers, using hex
arrays in C code with DECLARE_BUILTIN_FIRMWARE(). I revised that
approach when I saw it was better to put them in firmware/ and implement
'make firmware_install' instead. And I stand by that decision.

-- 
dwmw2

