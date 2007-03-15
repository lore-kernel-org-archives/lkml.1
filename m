Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXCOTlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXCOTlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933208AbXCOTli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:41:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:40693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbXCOTlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=W3TdUOL3EfUD7pTjVTsOJKy0+imTTg5WNavd9TIzy1QR9UfvNI2/zt/qb/KcbFih2U3lRvWdNlNNltOYoSNIA1levGWJcjpezTaRnumlaqSpKyXhhS5YkEw3OyN+TjOFeUt1fsCG8xdLNZPGrGUiakeAuKdMmufXrFMgz1kFouI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 10/13] BLK_DEV_IDE_CELLEB dependency fix
Date: Thu, 15 Mar 2007 20:48:42 +0100
User-Agent: KMail/1.9.6
Cc: Akira Iguchi <akira2.iguchi@toshiba.co.jp>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk> <200703150608.l2F68JY2026403@toshiba.co.jp> <20070315084645.GR4095@ftp.linux.org.uk>
In-Reply-To: <20070315084645.GR4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152048.42972.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 15 March 2007, Al Viro wrote:
> On Thu, Mar 15, 2007 at 03:10:20PM +0900, Akira Iguchi wrote:
> > Al wrote:
> > >
> > >Eh...  You still need dependency on IDE=y; otherwise you'll get configs
> > >with IDE=m, BLK_DEV_IDE_CELLEB=y and those won't link.  BLK_DEV_IDEDMA_PCI
> > >is selectable just fine with IDE=m.
> > >
> > >It's the same problem as with ps3 fb.
> > >
> > 
> > I'm sorry I missed this case.
> > Using some configurations, I found BLK_DEV_IDE=y was better.
> > (I failed to link when IDE=y and BLK_DEV_IDE=m.)
> 
> Umm...  Point taken.  After looking at the entire thing... well.
> 
> a) BLK_DEV_IDE_PMAC has bogus dependency on IDE=y.  If anything, that
> should've been BLK_DEV_IDE=y; however, it *does* build with ide modular -
> it doesn't generate a separate module and its initialization is called
> explicitly from ide one.  AFAICS, we can simply drop that dependency.

agreed

> b) BLK_DEV_IDE_PMAC does *not* build without BLK_DEV_IDEDMA_PMAC.  Quoting
> benh, "I don't see any reason to keep that dma thingy optional anyway".

ditto

> c) BLK_DEV_MPC8xx_IDE depends on BLK_DEV_IDE=y *and* IDE=y.  The latter is
> obviously redundant.  The former...  No idea, 8xx is currently b0rken in

ditto

> ARCH=powerpc and I can't be arsed to wade through arch/ppc bitrot.  As it
> is, driver definitely wants ARCH=ppc stuff (__res, for one thing).
> 
> Now, BLK_DEV_IDE_CELLEB looks interesting.  The nature of breakage is not
> the same as usual (non-modular driver depends on stuff that might be built
> modular); what's going on here is funnier.  If you get ide-core modular,
> you'll have BLK_DEV_IDE_CELLEB code *linked* *into* ide-core.ko.  Unlike
> the rest of its ilk, however, it doesn't have its init called directly from
> ide init.  It uses module_init(), which happens to work when it goes into
> the kernel image (ide-core.o has several initcalls, not a problem), but breaks
> when it goes into a modular ide-core.ko; there multiple module_init() are
> fatal.
> 
> So AFAICS the minimal fix for that sucker is dependency on BLK_DEV_IDE=y;
> however, I really wonder if
> 	* it needs to be linked into ide-core (as opposed to being a normal
> module of its own)

AFAICS there are no legacy device ordering issues with scc_pata so it doesn't
need to be linked into ide-core but I'll leave the definitive answer to Akira

> 	* alternatively, its init should be called explicitly.
> 
> Comments?

Care to provide patch for non-scc_pata issues that you've discovered? :-)

Thanks,
Bart
