Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZBFRCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZBFRCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBFRCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:02:13 -0500
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:40506 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751633AbZBFRCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:02:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=i2nb4UcV9aB03Oy6McthjgXBpi6iusGPPKJIkIxoluA7w0JKZv8A27rt4CEuejGFXWAmZXrm4rWYTMDqBo0F+QmDIa0RTbx/Tv5wbhUeTmvLghc6BMcbuSlguP3GcnaL;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
Date: Fri, 6 Feb 2009 08:49:44 -0800
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <1233898836.4612.116.camel@pasglop> <Pine.LNX.4.64.0902061248010.14011@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902061248010.14011@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902060849.45851.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 4:56 am Hugh Dickins wrote:
> On Fri, 6 Feb 2009, Benjamin Herrenschmidt wrote:
> > On Thu, 2009-02-05 at 14:33 -0800, Jesse Barnes wrote:
> > > One option there would be to provide the file but just use anonymous
> > > memory to back it.  X will happily think it's messing with legacy VGA
> > > memory, but it shouldn't matter that it's not actually affecting hw.
> >
> > What about this (untested) patch ?
> >
> > powerpc/pci: mmap anonymous memory when legacy_mem doesn't exist
> >
> > The new legacy_mem file in sysfs is causing problems with X on machines
> > that don't support legacy memory access. The way I initially implemented
> > it, we would fail with -ENXIO when trying to mmap it, thus exposing to
> > X that we do support the API but there is no legacy memory.
> >
> > Unfortunately, X poor error handling is causing it to fail to start when
> > it gets this error.
> >
> > This implements a workaround hack that instead maps anonymous memory
> > instead (using shmem if VM_SHARED is set, just like /dev/zero does).
> >
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
>
> Beautiful idea, works very nicely for me.
> Put a dummy in the baby's mouth to stop it crying.
>
> I still don't understand the point of this legacy_mem file at all,
> and why X should want to mmap it, if it works so well when it's
> thus divorced from reality.  But I won't worry my pretty little
> head over it any further - please don't waste your time trying
> to explain it to me!

Hugh, did you get a chance to try my X patch (w/o Ben's patch applied)?  If it 
also works, we should apply it to X too, if only to make porting to future 
platforms a little easier.

Since you probably don't want to know, you can skip this paragraph as it 
describes the motivation behind the legacy_mem file. :)  The motivation for 
it was to support machines with multihead video card configurations, but 
which could also support multiple legacy port I/O and memory spaces (e.g. on 
a per PCI domain basis).  It allows X to run option ROMs on multiple devices 
simultaneously, and can also help with hardware that can't route legacy space 
from a given host bus to arbitrary system addresses.  When we put this in 
initially, Ben knew there were some platforms where legacy memory simply 
wasn't available, but we figured that shouldn't be a problem, since X didn't 
really *need* that space to function (most ROMs just put splash screens 
there).  Unfortunately in the interim, X made the lack of an mmap'able 
legacy_mem file into a fatal error.

In the past, doing Linux bringup on a platform with a complex I/O topology 
(sparc, ia64, alpha, etc.) usually meant doing X bring up as well, often by 
adding new interfaces or hacks to X.  With the legacy_mem and io files, 
there's a chance that X won't have to be modified at bring up time, so in 
that sense the APIs are a step forward.  However that also means your 
platform has to support the APIs in a way consistent with how X uses them, as 
you discovered. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
