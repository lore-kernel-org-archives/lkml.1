Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYBXRxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYBXRxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYBXRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:53:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60415 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbYBXRxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:53:04 -0500
Date: Sun, 24 Feb 2008 18:53:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [Fixed PATCH] hpt366: fix section mismatch warnings
Message-ID: <20080224175315.GA10712@uranus.ravnborg.org>
References: <20080222194651.GA7154@uranus.ravnborg.org> <20080223212222.GA16568@uranus.ravnborg.org> <200802241533.51671.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802241533.51671.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 03:33:51PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 23 February 2008, Sam Ravnborg wrote:
> > hpt366: fix section mismatch warnings
> > 
> > Fix following warnings:
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a38): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a40): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370a
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a48): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a50): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372n
> > 
> > Replace a static array with a small switch resulting in
> > more readable code.
> > Mark the pci table __devinitconst.
> > 
> > A lot of variables are const but annotated __devinitdata.
> > Annotating them __devinitconst would cause a section type
> > conflict error when build for 64 bit powerpc.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > ---
> 
> thanks, applied
> 
> > The first patch I posted caused a section type conflict when
> > build for 64 bit powerpc. The actual cause of this is know and unavoidable
> > when we start to declare variables const.
> > The patch attached is much simpler as the transition from __devinitdata
> > to __devinitconst turned out to be bogus.
> 
> Weird, I thought that the main purpose of __devinitconst was to replace
> const + __devinitdata?

The problem we face is that gcc in some cases mark the
destination section READ-ONLY and in other cases not.
So if we annotate two variables to go into the same
section and gcc only annotate one of them READ-ONLY them
we will have a section type conflict.

gcc is not consistent across architectures what to mark
READ-ONLY and not. And what we saw here was a combination
where on x86 the destinatin section were marked equal
(READ-ONLY or not READ-ONLY) but on powerpc were marked
different. One was marked READ-ONLY the other was not.

So when playing with const it is improtant to try out with
a 64 bit gcc for powerpc to see if it causes any section
type conflict. Note: 32 bit gcc does not have this
issue.

	Sam

