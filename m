Return-Path: <linux-kernel-owner+w=401wt.eu-S1763301AbXE1Sfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763301AbXE1Sfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbXE1Sfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:35:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56138 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919AbXE1Sfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:35:30 -0400
Date: Mon, 28 May 2007 20:36:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ARM: Section mismatch warnings
Message-ID: <20070528183629.GA30821@uranus.ravnborg.org>
References: <20070528163253.GA29174@uranus.ravnborg.org> <20070528170430.GB5737@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528170430.GB5737@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x1748):
>  Section mismatch: reference to .init.text:sa1110_mb_disable
>  (between 'neponset_init' and 'neponset_resume')
> 
> This one looks quite bogus.  sa1110_mb_disable() is marked __init, and
> it's called from neponset_init() which is also marked __init.

Created a neponset.i file - output:

static int neponset_init(void)
{
 platform_driver_register(&neponset_device_driver);

So we loose the __init marker during preprocessing.
Which is due the the buggy part of my path that adds __devinit.

There was a reason I noted the devinit markers should be reviewed carefully -
this one seems wrong.


> 
> > o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x17ac):
>  Section mismatch: reference to .init.data:devices
>  (between 'neponset_init' and 'neponset_resume')
> 
> No reference to 'devices' (marked __initdata) in neponset_resume but there
> is in neponset_init(), which is the only reference to it, and it is marked
> __init.  Another false positive?
It is between the symbols so the rference will never be in the latter function.
In this case it is due to my wrong __devinit marking (again).

> 
> > o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2410/built-in.o(.text+0x80):
>  Section mismatch: reference to .init.data:s3c2410_dma_order
>  (between 's3c2410_dma_add' and 's3c2410_pm_add')
> 
> Don't know enough about s3c stuff, but this one looks like a false positive
> as well - it's registering a sysdev driver at boot time, and the class
> and sysdev is only ever also registered at boot time and never unregistered.
> Adding __init to s3c2410_dma_add would probably be the right thing to do
> but will move the problem to be a reference to s3c2410_dma_add from
> s3c2410_dma_driver instead.
> 
> Once that's done, might need an annotation of some sort?  Not sure.
modpost allows references to .init.text from variables named *_driver - so that
would work out.
And it is not a 'false positive' in the sense that there is indeed a
reference from a .text section to a .init.text section - so the calling
function ougth to be marked __init.


So conclusion is that most of these were caused by a wrong marking from my side.
But at least I had requested special attention to that part in my patch
submission because I knew I was not sure.

I did not see any wrong-doings by modpost.

	Sam
