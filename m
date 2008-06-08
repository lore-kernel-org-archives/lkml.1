Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYFHUhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYFHUhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYFHUgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:36:54 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:60378 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbYFHUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:36:53 -0400
Date: Sun, 8 Jun 2008 22:36:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Speed up "make headers_*"
In-Reply-To: <1212931024.32207.546.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0806082235240.25145@anakin>
References: <20080608094730.GA30098@uranus.ravnborg.org>
 <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
 <20080608104122.GA10545@uranus.ravnborg.org> <1212922141.32207.495.camel@pmac.infradead.org>
 <20080608111707.GB10545@uranus.ravnborg.org> <1212931024.32207.546.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-255220043-1212957410=:25145"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-255220043-1212957410=:25145
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 8 Jun 2008, David Woodhouse wrote:
> On Sun, 2008-06-08 at 13:17 +0200, Sam Ravnborg wrote:
> > #if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> 
> That's just scary, and broken for m68k where in userspace neither
> CONFIG_M68K nor __KERNEL__ will be defined, so the unwanted ac_ahz
> member will actually show up and break the binary compatibility.
> 
> Assuming we _don't_ want the ac_ahz member to be included on m68k, this
> should fix it (is __mc68000__ the right thing to use?)...
> 
> diff --git a/include/linux/acct.h b/include/linux/acct.h
> index e8cae54..228473b 100644
> --- a/include/linux/acct.h
> +++ b/include/linux/acct.h
> @@ -58,8 +58,7 @@ struct acct
>  	comp_t		ac_minflt;		/* Minor Pagefaults */
>  	comp_t		ac_majflt;		/* Major Pagefaults */
>  	comp_t		ac_swaps;		/* Number of Swaps */
> -/* m68k had no padding here. */
> -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> +#ifndef __mc68000__ /* m68k had no padding here. */
>  	__u16		ac_ahz;			/* AHZ */
>  #endif
>  	__u32		ac_exitcode;		/* Exitcode */
> 

JFYI, this was introduced by (from the `full-history-linux' tree):

commit 83245ea9c7212315e2f265f60e966534ba97a08a
Author: Tim Schmielau <tim@physik3.uni-rostock.de>
Date:   Thu Jun 17 18:01:23 2004 -0700

    [PATCH] BSD accounting format rework
    
    BSD accounting format rework:
    
    Use all explicit and implicit padding in struct acct to
    
     - correctly report 32 bit uid/gid,
     - correctly report jobs (e.g., daemons) running longer than 497 days,
     - increase the precision of ac_etime from 2^-13 to 2^-20
       (i.e., from ~6 hours to ~1 min. after a year)
     - store the current AHZ value.
     - allow cross-platform processing of the accounting file
       (limited for m68k which has a different size struct acct).
     - introduce versioning for smooth transition to incompatible formats in
       the future. Currently the following version numbers are defined:
         0: old format (until 2.6.7) with 16 bit uid/gid
         1: extended variant (binary compatible to v0 on M68K)
         2: extended variant (binary compatible to v0 on everything except M68K)
         3: a new binary incompatible format (64 bytes)
         4: new binary incompatible format (128 bytes).
            layout of its first 64 bytes is the same as for v3.
         5: marks second half of new binary incompatible format (128 bytes)
            (layout is not yet defined)
    
    All this is accomplished without breaking binary compatibility.  32 bit
    uid/gid support is compatible with the patch previously floating around and
    used e.g.  by Red Hat.
    
    This patch also introduces a config option for a new, binary incompatible
    "version 3" format that
    
     - is uniform across and properly aligned on all platforms
     - stores pid and ppid
     - uses AHZ==100 on all platforms (allows to report longer times)
    
    Much of the compatibility glue goes away when v1/v2 support is removed from
    the kernel.  Such a patch is at
    
      http://www.physik3.uni-rostock.de/tim/kernel/2.7/acct-cleanup-04.patch
    
    and might be applied in the 2.7 timeframe.
    
    The new v3 format is source compatible with current GNU acct tools (6.3.5).
    However, current GNU acct tools can be compiled for only one format.  As the
    is no way to pass the kernel configuration to userspace, with my patch it wi
    still only support the old v2 format.  Only if v1/v2 support is removed from
    the kernel, recompiling GNU acct tools will yield v3 support.
    
    A preliminary take at the corresponding work on cross-platform userspace too
    (GNU acct package) is at
    
      http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/
    
    This version of the package is able to read any of the v0/v2/v3 formats,
    regardless of byte-order (untested), even within the same file.
    Cross-platform compatibility with m68k (v1 format) is not yet implemented, b
    native use on m68k should work (untested).  pid and ppid are currently only
    shown by the dump-acct utility.
    
    Thanks to Arthur Corliss, Albert Cahalan and Ragnar Kjørstad for their
    comments, and to Albert Cahalan for the u64->IEEE float conversion code.
    
    Signed-off-by: Tim Schmielau <tim@physik3.uni-rostock.de>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-255220043-1212957410=:25145--
