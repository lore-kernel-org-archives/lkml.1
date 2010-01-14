Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336Ab0ANRCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab0ANRCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329Ab0ANRCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:02:15 -0500
Received: from waste.org ([173.11.57.241]:54455 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322Ab0ANRCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:02:14 -0500
Subject: Re: [PATCH] pagemap: early return on unmapped areas
From: Matt Mackall <mpm@selenic.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20100114085230.GA12078@localhost>
References: <20100110020955.GB25323@basil.fritz.box>
	 <20100113141648.42eff724.akpm@linux-foundation.org>
	 <1263421562.29868.5000.camel@calx>
	 <20100113143055.7bea30c5.akpm@linux-foundation.org>
	 <1263423916.29868.5009.camel@calx>
	 <20100113151502.fa425247.akpm@linux-foundation.org>
	 <20100114055319.GA17671@localhost>
	 <20100113221013.b1beecb4.akpm@linux-foundation.org>
	 <20100114080600.GA4739@localhost> <20100114083048.GC12241@basil.fritz.box>
	 <20100114085230.GA12078@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 11:02:11 -0600
Message-ID: <1263488531.29868.5151.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 16:52 +0800, Wu Fengguang wrote:
> On Thu, Jan 14, 2010 at 04:30:48PM +0800, Andi Kleen wrote:
> > > ---
> > > pagemap: early return on unmapped areas
> > 
> > Yes seems like a reasonable idea.
> 
> Thanks!
> 
> I just changed the ">" to ">=", because it happen to make a difference
> for cp/cat, which does 4k sized read:
> 
>         4k read buffer = 4k/8 pages = 512 pages = NR_PMD_PAGES
> 
> So the change to ">=" makes cp exit immediately (4k buffer matches
> exactly one PMD hole).
> 
> before
>         dd if=/proc/$$/pagemap of=/dev/null bs=4k
>         512+0 records in
>         512+0 records out
>         2097152 bytes (2.1 MB) copied, 0.0225796 s, 92.9 MB/s
> 
> after
>         dd if=/proc/$$/pagemap of=/dev/null bs=4k
>         0+0 records in
>         0+0 records out
>         0 bytes (0 B) copied, 2.8029e-05 s, 0.0 kB/s

Have you guys lost your minds?

I regularly used the exact standard tool you just broke above to test
pagemap when I was developing it. There's no doubt that this patch (or
any similarly misguided ones) WILL regress existing naive or not
intended to be portable 32-bit users. And if I was some poor future
bastard trying to write a program against pagemap with your patch, odds
of getting a concussion banging my head against the wall trying to
figure out its highly non-file-like behavior would be quite high. 

Why are we even still on this. There's no regression. LTP + pagemap +
64-bit has always behaved thus. Nor are large virtual files new. And
LTP's n00b assumption that it can just read all of any file in /proc has
always been wrong. LTP had the exact same problem on 64-bit /proc/kcore
(how long has that existed?) and finally fixed it in 2005.

-- 
http://selenic.com : development and support for Mercurial and Linux


