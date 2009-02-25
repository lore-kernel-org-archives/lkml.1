Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZBYBdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZBYBdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbZBYBcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:32:08 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:54805 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756048AbZBYBbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:31:47 -0500
Date: Wed, 25 Feb 2009 10:31:40 +0900 (JST)
Message-Id: <20090225.103140.155095402.nemoto@toshiba-tops.co.jp>
To: s.hauer@pengutronix.de
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
 parse_mtd_partitions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090224152958.GN21900@pengutronix.de>
References: <20090224133505.GJ21900@pengutronix.de>
	<20090224.233600.27954115.anemo@mba.ocn.ne.jp>
	<20090224152958.GN21900@pengutronix.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 16:29:58 +0100, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > The physmap patch has another bug and fixes are on the way mainline:
> > 
> > http://git.infradead.org/mtd-2.6.git?a=commit;h=e480814f138cd5d78a8efe397756ba6b6518fdb6
> > 
> > But this seems not enough, as you wrote.  If multiple mtd have same
> > mtd-id, bad things can happen.  And more seriously, if I load physmap
> > driver _again_ after unload, cmdlinepart will return a freed pointer
> > on the second time.
> > 
> > Hmm, little memory leak is less serious than crash.  Now I start
> > thinking reverting the commit 176bf2e0 will be best for 2.6.29
> > release.
> 
> Even when reverting the commit the same problem still exists because the
> array then gets freed in physmap_flash_remove(). This won't hurt me
> though because I never use mtd drivers as modules.

If the commit reverted, kfree() in physmap_flash_remove never be
called due to another bug (info->nr_parts is not set properly).  But
unloading the physmap module will lead crash anyway since master mtd
device will be freed without deleting slave mtd devices if cmdlinepart
was used.

So I think either reverting the commit or applying the above fix in
mtd-2.6 git tree can fix regression from 2.6.28.  Both work well
unless unloading the physmap module after booting with mtdparts=
option.

---
Atsushi Nemoto
