Return-Path: <linux-kernel-owner+w=401wt.eu-S934756AbYBUVQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbYBUVQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762875AbYBUVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:16:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYBUVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:16:17 -0500
Date: Thu, 21 Feb 2008 21:16:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
Message-ID: <20080221211610.GA27894@ZenIV.linux.org.uk>
References: <1203503909.17534.14.camel@johannes.berg> <20080220195913.GE21139@uranus.ravnborg.org> <1203597776.20331.5.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203597776.20331.5.camel@johannes.berg>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 01:42:56PM +0100, Johannes Berg wrote:
> >> [patch doing CHECKFLAGS += -D__CHECK_ENDIAN__ in the
> >> net/mac80211/Makefile]
> 
> > I would prefer it to be kernel wide enabled.
> > Tried a defconfig build.
> 
> Hm. I tend to think there was a reason for this, since this is actually
> explicitly disabled by include/linux/types.h:
> 
> #ifdef __CHECKER__
> #define __bitwise__ __attribute__((bitwise))
> #else 
> #define __bitwise__
> #endif
> 
> #ifdef __CHECK_ENDIAN__
> #define __bitwise __bitwise__
> #else
> #define __bitwise
> #endif
> 
> The commit that introduced __CHECK_ENDIAN__ was
> af4ca457eaf2d6682059c18463eb106e2ce58198 ("gfp_t: infrastructure") but
> it doesn't say anything about the rationale for it.
> 
> > When I enabled __CHECK_ENDIAN I got:
> > 8 files with > 100 warnings
> > 14 files with 10 to 99 warnings.
> > 
> > So nothing that should scare a kernel hacker...
> > 
> > warnings without: 1686
> > warnings with: 2788
> > 
> > OK - thats a lot, but then fixing 8 files will significantly
> > reduce this.
> 
> I recently ran sparse on my config and was surprised by the number of
> warnings. Then again, something in mmzone.h or so generated billions of
> them...
> 
> In any case, I would love to have __CHECK_ENDIAN__ enabled by default at
> least on the wireless code (just caught another bug with it...)

So build with make C=2 -D__CHECK_ENDIAN__ net/ieee80211/, etc. - it's not
that such a script would be tricky...

I've been shooting the endianness crap down for quite a while (see e.g.
drivers/net/* patches in 2.6.24 and 2.6.24-rc1; there's more in queue)
and it's getting better, but not enough to enable it unconditionally.

Note that it's not quite a janitor-level stuff; blind "fixing" of warnings
in that area is very likely to result in hidden bugs - you need serious
RTFS + RTFDatasheet + ask maintainer + trawl list archives for bug reports
in quite a few cases.
