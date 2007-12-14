Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbXLNIIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbXLNIIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXLNIIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:08:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60046 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXLNIIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:08:43 -0500
Date: Fri, 14 Dec 2007 09:10:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH REVISED] Avoid overflows in kernel/time.c
Message-ID: <20071214081033.GA17598@uranus.ravnborg.org>
References: <200712140113.lBE1DJvS000316@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712140113.lBE1DJvS000316@tazenda.hos.anvin.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 05:13:19PM -0800, H. Peter Anvin wrote:
> When the conversion factor between jiffies and milli- or microseconds
> is not a single multiply or divide, as for the case of HZ == 300, we
> currently do a multiply followed by a divide.  The intervening
> result, however, is subject to overflows, especially since the
> fraction is not simplified (for HZ == 300, we multiply by 300 and
> divide by 1000).
> 
> This is exposed to the user when passing a large timeout to poll(),
> for example.
> 
> This patch replaces the multiply-divide with a reciprocal
> multiplication on 32-bit platforms.  When the input is an unsigned
> long, there is no portable way to do this on 64-bit platforms there is
> no portable way to do this since it requires a 128-bit intermediate
> result (which gcc does support on 64-bit platforms but may generate
> libgcc calls, e.g. on 64-bit s390), but since the output is a 32-bit
> integer in the cases affected, just simplify the multiply-divide
> (*3/10 instead of *300/1000).
> 
> The reciprocal multiply used can have off-by-one errors in the upper
> half of the valid output range.  This could be avoided at the expense
> of having to deal with a potential 65-bit intermediate result.  Since
> the intent is to avoid overflow problems and most of the other time
> conversions are only semiexact, the off-by-one errors were considered
> an acceptable tradeoff.
> 
> NOTE: This patch uses a bc-based shell script to compute the
> appropriate constants.  This script should be run by hand if new HZ
> values are created, as doing it automatically introduces a dependency
> on bc, and has been shown to be unreliable in some environments.  The
> flipside, unfortunately, is that this may cause problems for "make
> randconfig" on MIPS and OMAP, which appear to allow arbitrary values
> to be entered into CONFIG_HZ.

I understood that bc is unreliable.
How about creating a small .c program that does to necessary computation
and integrate it in the build process.
It should be much cleaner than this approach.

	Sam
