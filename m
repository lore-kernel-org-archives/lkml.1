Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbXKHSTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbXKHSTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760543AbXKHSTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:19:08 -0500
Received: from havoc.gtf.org ([69.61.125.42]:52051 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759866AbXKHSTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:19:07 -0500
Date: Thu, 8 Nov 2007 13:19:05 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roppedisano@infracomspa.it, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org
Subject: Re: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
Message-ID: <20071108181905.GA4895@havoc.gtf.org>
References: <4731C86B.1040704@infracomspa.it> <20071107121355.5eaf4496.akpm@linux-foundation.org> <47333CCF.1050403@infracomspa.it> <20071108094958.5c9b1b22.akpm@linux-foundation.org> <20071108180256.GB3491@havoc.gtf.org> <20071108101341.6c4f88d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108101341.6c4f88d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 10:13:41AM -0800, Andrew Morton wrote:
> > On Thu, 8 Nov 2007 13:02:56 -0500 Jeff Garzik <jeff@garzik.org> wrote:
> > On Thu, Nov 08, 2007 at 09:49:58AM -0800, Andrew Morton wrote:
> > > > On Thu, 08 Nov 2007 17:43:59 +0100 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
> > > > Andrew Morton wrote, On 11/07/2007 09:13 PM:
> > > > >> On Wed, 07 Nov 2007 15:15:07 +0100 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
> > > > >> Hello.
> > > > >> I noticed that after suspending to ram the DVD-ROM/CDRW
> > > > >> drive in no more recognized on my laptop. Looking at dmesg
> > > > >> after suspend i found:
> > > > >>
> > > > >> [    5.313446] ata2.00: _GTF unexpected object type 0x1
> > > > >> [    5.313453] ata2.00: ACPI on devcfg failed the second time, disabling 
> > > > >> (errno=-22)
> > > > >> [    5.313457] ata2.00: revalidation failed (errno=1)
> > > > >> [    5.313459] ata2.00: disabled
> > > > >>
> > > > >>
> > > > >> Not sure when the bug was introduced or if it has been always been there
> > > > >> (but I can investigate if needed).
> > > > >>
> > > > >> More details on request.
> > > > >>
> > > > >> Following dmesg pre and after suspend.
> > > > > Yes, it would be useful if you could work ot whether this worked OK in an
> > > > > earlier kernel, thanks.
> > > > Hello Andrew.
> > > > The bug has been recently added.
> > > > 
> > > > I did a git-bisect, but the result is probably not completely useful,
> > > > because many kernel did non build with my config, and I marked them as bad.
> > > 
> > > Those build errors are bad.  Please report them.  They directly prevented
> > > you from finding the commit which caused this regression.
> > > 
> > > The only way in which we'll stop people doing crap like this is to rub
> > > their noses (and the person who committed its nose) in it.
> > > 
> > > > Anyway here's the output of git-bisect:
> > > > 
> > > > rao@infra-bb:/usr/src/linux-2.6$ git bisect bad
> > > > 99874d50481c093adfe74e796436024d88b6a48c is first bad commit
> > > > commit 99874d50481c093adfe74e796436024d88b6a48c
> > > > Author: Jens Axboe <jens.axboe@oracle.com>
> > > > Date:   Fri Oct 12 12:50:41 2007 +0200
> > > > 
> > > >     [BLOCK] Only include the compat ioctl code if CONFIG_BLOCK is set
> > > > 
> > > >     Add an extra CONFIG_BLOCK_COMPAT that we can use in the Makefile
> > > > 
> > > >     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > > 
> > > > :040000 040000 f88b7b0e496edb8fbdd4bc74abd1a742a6a1d6d9
> > > > 32ead3bd57b52a664cc8ccb662195041868d7632 M      block
> > > > 
> > > > ...
> > > > 
> > > > If needed I can do further investigation, changing the assumption of
> > > > efefc6eb38d43b8e5daef482f575d767b002004e to good and see if the bisect
> > > > points to a different commit.
> > > 
> > > Yes, it'll be some other commit.  Sorry.
> > > 
> > > It would help you (and me) if an ata developer could pay some attention.
> > > 
> > > Rafael, please track this as an ata regression.
> > 
> > We unfortunately need to bounce this ACPI people.
> > 
> > We recently turned on ACPI by default in libata, which INTRODUCES the
> > ability of the BIOS to pass random, unknown-quality ATA commands to the
> > device.
> > 
> > I highly expect some breakage related to this...  if ACPI folks
> > determine it is not an ACPI bug, then its a firmware bug and we will
> > have to avoid that firmware on that platform.
> > 
> > Set module option "noacpi" to 1, to disable ACPI and see if that fixes
> > the problem.
> > 
> > This will be a common diagnosis and workaround, FWIW...
> > 
> 
> I suspect it wold be best to disable the feature for the 2.6.24 release,
> then reenable it afterwards and keep doing this until the code is
> sufficiently stable.

Re-read my message :)

The code is stable.  Behavior _by definition_ will vary by BIOS.

This feature (a) enables suspend/resume, but (b) now sends random
unvalidated shite to the device that we hope will work.

Look at all the messages where turning on ACPI in libata _fixed_
suspend/resume (because its obviously required for many, including
laptops).

So it's not an easy "turn it off" answer, you break shitloads of
suspend/resume that way, that we just fixed.

The message "_GTF unexpected object type" indicates a broken BIOS, so
IMO we should proceed in that direction, blacklisting that platform.

	Jeff


