Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbYBHJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbYBHJEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759891AbYBHJEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:04:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbYBHJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:04:27 -0500
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
	architecture
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080207202329.GA21949@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local>
	 <20080207125824.GB7111@infradead.org>
	 <20080207130117.GA18750@uranus.ravnborg.org>
	 <200802071609.36960.openembedded@haerwu.biz>
	 <20080207160557.GB28435@flint.arm.linux.org.uk>
	 <20080207202329.GA21949@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 09:04:13 +0000
Message-Id: <1202461453.5469.217.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 21:23 +0100, Sam Ravnborg wrote:
> Both situations are trivially fixable by introducing
> HAVE_IDE and HAVE_MTD.
> See attached patch.

HAVE_MTD is wrong. The actual problem we're trying to solve is that when
the architecture lacks alignment fixups, certain patterns of write
access to 16-bit or 32-bit NOR flash arrays are broken. So it's not
'MTD' which should be conditional -- but only certain configurations of
NOR flash, which could perhaps be prevented by disallowing any of the
MTD_MAP_BANK_WIDTH_* options other than MTD_MAP_BANK_WIDTH_1 from being
set.

And it's not just an ARM-specific problem; a number of our MMU-less
architectures also lack alignment traps now. It _used_ to be the case
that platforms without alignment fixups were simply considered to be
broken -- if the hardware didn't support unaligned access, either
natively or through traps, it just wasn't supported by Linux. But since
that isn't really the case any more, perhaps we should seek a better
option than just disabling certain functionality (or _not_ disabling it,
in the case of the network stack, and just kind of praying that it works
even though we don't really think it does).

We could add get_unaligned() in certain places in the code, but that
isn't ideal for the majority of architectures. What we really want, I
suppose, is get_something_which_may_be_but_probably_is_not_unaligned().

With a better name.

-- 
dwmw2

