Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZEZQr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZEZQr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZEZQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:47:51 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38183 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZEZQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:47:51 -0400
Date: Wed, 27 May 2009 01:47:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/2] mtd/maps: uclinux: support Blackfin systems
Message-ID: <20090526164735.GA24261@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
	linux-mtd@lists.infradead.org
References: <1243331191-11445-1-git-send-email-vapier@gentoo.org> <1243331191-11445-2-git-send-email-vapier@gentoo.org> <20090526113122.GB16835@linux-sh.org> <8bd0f97a0905260942m4b574d75oc4f38ee3d8849395@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0905260942m4b574d75oc4f38ee3d8849395@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 12:42:48PM -0400, Mike Frysinger wrote:
> On Tue, May 26, 2009 at 07:31, Paul Mundt wrote:
> > On Tue, May 26, 2009 at 05:46:31AM -0400, Mike Frysinger wrote:
> >> diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
> >> index 57699c2..dcb552f 100644
> >> --- a/drivers/mtd/maps/uclinux.c
> >> +++ b/drivers/mtd/maps/uclinux.c
> >> @@ -55,8 +55,13 @@ static int __init uclinux_mtd_init(void)
> >> ??{
> >> ?? ?? ?? struct mtd_info *mtd;
> >> ?? ?? ?? struct map_info *mapp;
> >> +#ifdef CONFIG_BLACKFIN
> >> + ?? ?? extern unsigned long memory_mtd_start;
> >> + ?? ?? unsigned long addr = (unsigned long) memory_mtd_start;
> >> +#else
> >> ?? ?? ?? extern char _ebss;
> >> ?? ?? ?? unsigned long addr = (unsigned long) &_ebss;
> >> +#endif
> >>
> >> ?? ?? ?? mapp = &uclinux_ram_map;
> >> ?? ?? ?? mapp->phys = addr;
> >
> > NAK.
> >
> > I know there's no accounting for taste, but it would be nice to at least
> > see some minimal amount of effort going in to fixing these things
> > sanely rather than just lazily shoving ifdefs in wherever possible.
> >
> > In this case you should just kill all of that crap off, and have the
> > platforms that use this set uclinux_ram_map up themselves, it's already
> > a global. Of course you can use _ebss as a default value for
> > uclinux_ram_map.phys and just override it in your platform.
> 
> i would agree if it were a board-specific issue, but it's an arch
> issue, so pushing it to the boards level is wrong.  i can however
> replace the addr with a global weak and add a symbol into the Blackfin
> arch code to override it.
> 
I obviously meant architectures setting up the address, not the board
code, as this has nothing at all to do with boards. There are already
plenty of cases in setup_arch() for filling in uclinux mtd data, one more
isn't going to make a difference.

I don't see anything wrong with keeping uclinux_ram_map as a global
however, particularly since platforms that need to special case the
mapping can easily do this under the existing ifdef. Adding weak symbols
for something like this just seems silly.
