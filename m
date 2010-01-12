Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506Ab0ALAiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0ALAiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277Ab0ALAiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:38:23 -0500
Received: from gw1.transmode.se ([213.115.205.20]:53366 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0ALAiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:38:22 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 19:38:22 EST
In-Reply-To: <20100112105805.50e39a77.sfr@canb.auug.org.au>
References: <20100112105805.50e39a77.sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
X-KeepSent: B3421B84:8617A839-C12576A9:0002357B;
 type=4; name=$KeepSent
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Linus <torvalds@linux-foundation.org>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFB3421B84.8617A839-ONC12576A9.0002357B-C12576A9.0002AB6A@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 12 Jan 2010 01:29:09 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-01-12 01:32:10
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote on 12/01/2010 00:58:05:
>
> Hi all,
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>
> cc1: error: include/linux/autoconf.h: No such file or directory
>
> (while building the boot wrappers - lots more of the same)
>
> Caused by commit ac4c2a3bbe5db5fc570b1d0ee1e474db7cb22585 ("zlib:
> optimize inffast when copying direct from output").  autoconf.h moved
> from include/linux to include/generated in commit
> 264a26838056fc2d759f58bec2e720e01fcb1bdb ("kbuild: move autoconf.h to
> include/generated") which was in linux-next since 14 Dec 2009 and in
> Linus' tree since 18 Dec 2009.
>
> I added the following patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 12 Jan 2010 10:23:43 +1100
> Subject: [PATCH] powerpc: fix boot Makefile for autoconf.h moving
>
> autoconf.h moved from include/linux to include/generated
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/boot/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
> index 826a30a..fb32a8e 100644
> --- a/arch/powerpc/boot/Makefile
> +++ b/arch/powerpc/boot/Makefile
> @@ -34,7 +34,7 @@ BOOTCFLAGS   += -fno-stack-protector
>  endif
>
>  BOOTCFLAGS   += -I$(obj) -I$(srctree)/$(obj)
> -BOOTCFLAGS   += -include include/linux/autoconf.h -Iarch/powerpc/include
> +BOOTCFLAGS   += -include include/generated/autoconf.h -Iarch/powerpc/include
>  BOOTCFLAGS   += -Iinclude
>
>  DTS_FLAGS   ?= -p 1024
> --
> 1.6.6
>
> However, this then produced these errors:
>
> arch/powerpc/boot/inffast.c:7:27: error: asm/unaligned.h: No such file or directory
> arch/powerpc/boot/inffast.c:8:27: error: asm/byteorder.h: No such file or directory
> arch/powerpc/boot/inffast.c: In function 'inflate_fast':
> arch/powerpc/boot/inffast.c:263: warning: implicit declaration of function
> 'get_unaligned'
> arch/powerpc/boot/inffast.c:277:2: error: #error __BIG_ENDIAN nor
> __LITTLE_ENDIAN is defined
>
> So I just reverted the original commit (after removing my fix above).
>
> This latter build problem is probably only noticed if you build with a
> separate object directory (i.e. with O=.. on the make command).  The
> previous PowerPC maintainer tells me that defining __KERNEL__ in the
> BOOTFLAGS is wrong and should have been noticed.

I guess that the above problem will fixed by adding $(srctree):
BOOTCFLAGS   += -include include/generated/autoconf.h -I$(srctree)/arch/powerpc/include
BOOTCFLAGS   += -I$(srctree)/include

But what to do with the __KERNEL__ define. If it isn't allowed I
don't know what to do.

  Jocke

