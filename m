Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYLGLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYLGLpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYLGLpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:45:22 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:39634 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYLGLpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:45:21 -0500
Date: Sun, 7 Dec 2008 14:45:19 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207114519.GA23247@ioremap.net>
References: <20081205212428.GB8075@ioremap.net> <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com> <20081206160927.GA498@ioremap.net> <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com> <20081206165634.GA2516@ioremap.net> <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com> <1228591926.3808.6.camel@nga> <20081206202620.GA9470@ioremap.net> <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com> <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 11:23:35AM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > This modprobe process does try to log an error, accesses /dev/console,
> > which is not initialized in the kernel at that time, and the kernel
> > module loader tries the load a module to support dev_t 5:1, which
> > again runs modprobe, and ...
> 
> So we have a buggy modprobe... 

Which nevertheless should not break boot process...

> > Setting CONFIG_CRYPTO_MANAGER=y makes it disapper. The patch I sent
> > seems to fix it.
> > 
> > The bug is handled here: http://bugzilla.kernel.org/show_bug.cgi?id=12153
> 
> We cannot go re-ordering random chunks of kernel init with unpredictable
> effects including possibly making other stuff less reliable (because you
> set up the console device before the console driver is loaded on a PCI
> bus device). And we certainly can't do it this close to a release.

Alan, really, do you believe that relying on userspace to be always
correct is the way to go? Requrement for the userspace to always have
enough buffer available when doing some reading is essetually the same.
We want userspace to be non-recursive, but if this does not happen, we
should not hung. Detect recursion, do not allow more than 1-2-3
simultaneous modprobes, whatever, but do not say, that kernel behaves
that bad just because userspace is allowed to do that.

And what's the argument of being close to a release? Do you propose to
hide the head into the sand and point a finger to anyone else saying its
not a kernel's problem? If prerelease has a bug, it should be fixed, and
not hidden under the cover.

What about storing a small stack of recently requested device ids, and
if new request is about to ask one from that stack, return error? I can
cook up the patch tomorrow.

-- 
	Evgeniy Polyakov
