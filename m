Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXDCTXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXDCTXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXDCTXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:23:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54810 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXDCTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:23:51 -0400
Date: Tue, 3 Apr 2007 21:23:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH] make csum_partial obj-y
Message-ID: <20070403192349.GA24243@one.firstfloor.org>
References: <20070403112604.129610b1.randy.dunlap@oracle.com> <p731wj1z0or.fsf@bingen.suse.de> <4612A66D.5090009@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4612A66D.5090009@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 12:09:33PM -0700, Randy Dunlap wrote:
> Andi Kleen wrote:
> >Randy Dunlap <randy.dunlap@oracle.com> writes:
> >
> >>From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >>Fixes kernel bugzilla #8242:
> >>
> >>Move csum_partial() from lib-y to obj-$(CONFIG_CSUM_PARTIAL)
> >>so that modules can use it.
> >>
> >>CONFIG_BLK_DEV_MD (md/raid driver) needs csum_partial(),
> >>even when CONFIG_NET=n and BLK_DEV_MD=m, so build it as an
> >>object to force it being built and available.
> >>
> >>REISERFS with XATTR=y also needs csum_partial(), so that
> >>is enforced here.
> >
> >They are all broken because csum_partial gives different values
> >on different architectures.   You're just extending that to
> >possibly more subsystems.
> 
> So the ones that can be localized (BLK_DEV_MD and REISERFS)
> should have their own versions?

They would need some compat code to still be able to read
old versions and a new format that is portable.

Currently it means you likely have architecture specific MD
and reiserfs data structures on disk which is broken.

BTW It might be better to just switch to a stronger checksum.
The TCP checksum is quite weak and we already have CRC functions.

> How does the networking code work across multiple architectures?

It folds the csum_partial output together with a pseudo header
into the final checksum. Just skipping the folding step is broken
because the presentation before that is architecture specific.
e.g. some hold it in 32bit and others in 64bit.

-Andi
