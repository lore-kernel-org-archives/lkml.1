Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbXHWMEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbXHWMEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbXHWMD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:03:56 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1270 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbXHWMD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:03:56 -0400
Date: Thu, 23 Aug 2007 13:03:18 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070823120318.GA7506@shadowen.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6FB2.1010801@csn.ul.ie> <20070822111029.46db0ab7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822111029.46db0ab7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:10:29AM -0700, Andrew Morton wrote:
[...]
> >   CC      arch/x86_64/kernel/asm-offsets.s
> > arch/x86_64/kernel/asm-offsets.c:1: error: -mpreferred-stack-boundary=3
> > is not between 4 and 12
> > make[1]: *** [arch/x86_64/kernel/asm-offsets.s] Error 1
[...]
> x86_64-mm-less-stack-alignment.patch has
> 
> cflags-y += $(call cc-option,-mpreferred-stack-boundary=3)
> 
> So we _should_ have detected that gcc didn't like =3, so it
> should not have been used.
> 
> I am suspecting a kbuild glitch: asm-offsets.c tends to be handled
> in special ways (ie: it's usually the thing which blows up first)
> so perhaps it is somehow avoiding the above does-gcc-support-this test.
> 
> Suitable cc's added ;)

It seems that this is a problem caused by the way we check for
compiler options in x86_64.  Each compiler flag is checked for
individually and if available added to cflags-y, later that is
added to CFLAGS.  However, this means that each flag is checked
in total isolation.  On x86_64 (on this compiler at least) the
-mpreferred-stack-boundary and -m{32,64} flags are actually mutually
dependant, the alignment constraints vary based on the word size.
This leads to the compile failure:

    # gcc -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
    # echo $?
    0
    # gcc -m64 -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
    /dev/null:1: error: -mpreferred-stack-boundary=3 is not between 4 and 12
    # echo $?
    1

In the main Makefile we always add each flag directly to CFLAGS
which means we check them all in combination, perhaps this is
prudent here also?  Either way I suspect that changing the -m64
check to add itself directly to CFLAGS will fix this us.

-apw
