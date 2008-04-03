Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYDCRAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYDCRAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYDCQ7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:59:38 -0400
Received: from oss.sgi.com ([192.48.170.157]:54375 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYDCQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:59:35 -0400
Date: Thu, 3 Apr 2008 17:02:30 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, dmitri.vorobiev@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
Message-ID: <20080403160230.GA17771@linux-mips.org>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com> <20080402112907.76e1c554.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com> <20080402190623.GA23651@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402190623.GA23651@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 09:06:23PM +0200, Sam Ravnborg wrote:

> > > i386 generates
> > > 
> > > ->NR_PAGEFLAGS $18 __NR_PAGEFLAGS       #
> > 
> > > mips generates
> > > 
> > > ->NR_PAGEFLAGS 18 __NR_PAGEFLAGS         #
> > 
> > For some reason the asm-offset.c for mips generates it differently and the 
> > sed expression in kbuild is different. So it does not match.
> 
> When the asm-offset stuff were consolidated the mips variant
> did not match the others.
> I do not recall if I ever tried this on a mips tool-chain and as
> my dev box is busted atm I cannot even test it out now.
> 
> I would be happy if we could kill the MIPS specific sed expression
> in the top-level Kbuild file.
> 
> Ralf - can you take a look at this and see if mips really generates
> different assembler syntax which warrants the different sed expression.
> 
> If mips really needs a different sed expression then we should adjust
> it so the output is similar to the other archs.

The reason for MIPS doing things a little different is that the resulting
<asm/asm-offsets.h> doesn't look like machine generated jibberish.  So
how about below patch which combines the two sed expressions.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/Kbuild b/Kbuild
index 7136de7..2bd4a3c 100644
--- a/Kbuild
+++ b/Kbuild
@@ -52,10 +52,8 @@ targets += arch/$(SRCARCH)/kernel/asm-offsets.s
 
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
-	"/^->/{s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}"
+	"/^->/{s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}; /^@@@/{s/^@@@//; s/ \#.*\$$//; p;};"
 endef
-# Override default regexp for specific architectures
-sed-$(CONFIG_MIPS) := "/^@@@/{s/^@@@//; s/ \#.*\$$//; p;}"
 
 quiet_cmd_offsets = GEN     $@
 define cmd_offsets
