Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZCTMYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZCTMYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 08:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZCTMYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 08:24:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbZCTMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 08:24:05 -0400
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 13:23:17 +0100
Message-Id: <1237551797.24626.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 22:02 +0100, Thomas Gleixner wrote:
> Impact: workaround for distcc/icecc
> 
> Peter and I noticed that distcc and icecc based kernel compiles
> started to show random full kernel rebuilds even when nothing or just
> a .c file changed. The reason is "change of the command line" which
> caused scripts/mod/empty.o to rebuild and due to the dependencies the
> complete kernel tree. I never change the command line simply because I
> use a script for my builds.
> 
> The root cause for this problem is the check for the CFI support in
> x86 binutils. The call is generated via:
> 
>     echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -
> 
> This works fine as long as a local gcc is used or distcc/icecc use the
> local machine. When distcc/icecc offload the compile to a remote
> machine the compile fails with the following error message:
>    gcc: : No such file or directory
> 
> Now we get command lines with -DCONFIG_CFI* and without every other
> compile which causes the full rebuilds.
> 
> Digging trough the distcc/icecc code it seems that the stdin input for
> remote compiles is not handled correctly. Indeed there is some strange
> comment about this, but unfortunately no decision to compile it
> local. :(
> 
> distcc and icecc are used by many developers and we can not fix the
> versions which are out there in the wild, but we can avoid the stdin
> based call easily: echo the asm code into the temp file which is used
> for the output and use it as input file for the compiler.

Yes, this makes it mostly work again... however,

On -linus I can do:
  
# cat distmake

  #!/bin/bash

  ARCH=$1; shift

  export LD="nice -n19 ${ARCH}-linux-ld"
  export AS="distcc ${ARCH}-linux-as"
  export CC="distcc ${ARCH}-linux-gcc"

  make LD="$LD" AS="$AS" CC="$CC" -j $DISTCC_SLOTS "$@"

# distmake x86_64 bzImage

to build the tree, and then use: 

# make install

to install the resulting image. Note how the second make will use the
system gcc and not the distcc with cross arch toolchain.

This will still start a full rebuild on -tip. When I change my script to
use distmake x86_64 install, things work again after this patch.




