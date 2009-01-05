Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZAEFJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZAEFJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 00:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZAEFJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 00:09:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZAEFJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 00:09:41 -0500
Message-ID: <49619601.9010900@zytor.com>
Date: Sun, 04 Jan 2009 21:09:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <20090105030348.GA13303@uranus.ravnborg.org>
In-Reply-To: <20090105030348.GA13303@uranus.ravnborg.org>
Content-Type: multipart/mixed;
 boundary="------------000808030606080401030606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000808030606080401030606
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Sam Ravnborg wrote:
> On Sun, Jan 04, 2009 at 03:58:23PM -0800, H. Peter Anvin wrote:
>> I have pulled the x86 parts of the bzip2/lzma patchset into
>> tip:x86/setup-lzma.  I would appreciate it if you could look at it and
>> make sure it looks sane.  I have not added the ARM portions (patch 4),
>> since those should go via the ARM tree, nor the capstone patch 5, which
>> can only be added after the old code is removed from *all* remaining
>> architectures.
>>
>> Ingo: this *will* break your randconfig testing if you have machines
>> where the lzma(1) utility isn't installed!
>>
>> The shortlog looks like:
>>
>> Alain Knaff (3):
>>       bzip2/lzma: library support for gzip, bzip2 and lzma decompression
>>       bzip2/lzma: config and initramfs support for bzip2/lzma 	decompression
>>       bzip2/lzma: x86 kernel compression support
>>
>> H. Peter Anvin (3):
>>       bzip2/lzma: use a table to search for initramfs compression formats
>>       bzip2/lzma: handle failures from bzip2 and lzma correctly
>>       bzip2/lzma: make config machinery an arch configurable
> 
> Can you post this last patch.
> 
> Thanks,
> 	Sam

Here it is.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------000808030606080401030606
Content-Type: text/x-patch;
 name="0006-bzip2-lzma-make-config-machinery-an-arch-configurab.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0006-bzip2-lzma-make-config-machinery-an-arch-configurab.pat";
 filename*1="ch"

>From 2e9f3bddcbc711bb14d86c6f068a779bf3710247 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Sun, 4 Jan 2009 15:41:25 -0800
Subject: [PATCH] bzip2/lzma: make config machinery an arch configurable

Impact: Bug fix (we should not show this menu on irrelevant architectures)

Make the config machinery to drive the gzip/bzip2/lzma selection
dependent on the architecture advertising HAVE_KERNEL_* so that we
don't display this for architectures where it doesn't matter.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |    3 +++
 init/Kconfig     |   52 +++++++++++++++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 862adb9..7b66c34 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -39,6 +39,9 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_BZIP2
+	select HAVE_KERNEL_LZMA
 
 config ARCH_DEFCONFIG
 	string
diff --git a/init/Kconfig b/init/Kconfig
index df84625..f9633c0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -101,10 +101,20 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config HAVE_KERNEL_GZIP
+	bool
+
+config HAVE_KERNEL_BZIP2
+	bool
+
+config HAVE_KERNEL_LZMA
+	bool
+
 choice
-        prompt "Kernel compression mode"
-        default KERNEL_GZIP
-        help
+	prompt "Kernel compression mode"
+	default KERNEL_GZIP
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
+	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
 	  in efficiency, compression and decompression speed.
@@ -123,34 +133,34 @@ choice
 	  If in doubt, select 'gzip'
 
 config KERNEL_GZIP
-       bool "Gzip"
-       help
-         The old and tried gzip compression. Its compression ratio is
-	 the poorest among the 3 choices; however its speed (both
-	 compression and decompression) is the fastest.
+	bool "Gzip"
+	depends on HAVE_KERNEL_GZIP
+	help
+	  The old and tried gzip compression. Its compression ratio is
+	  the poorest among the 3 choices; however its speed (both
+	  compression and decompression) is the fastest.
 
 config KERNEL_BZIP2
 	bool "Bzip2"
+	depends on HAVE_KERNEL_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the 3.
-	  The kernel size is about 10 per cent smaller with bzip2,
-	  in comparison to gzip.
-	  Bzip2 uses a large amount of memory. For modern kernels
-	  you will need at least 8MB RAM or more for booting.
+	  Decompression speed is slowest among the three.  The kernel
+	  size is about 10% smaller with bzip2, in comparison to gzip.
+	  Bzip2 uses a large amount of memory. For modern kernels you
+	  will need at least 8MB RAM or more for booting.
 
 config KERNEL_LZMA
-       bool "LZMA"
-       help
-         The most recent compression algorithm.
-	 Its ratio is best, decompression speed is between the other
-	 2. Compression is slowest.
-	 The kernel size is about 33 per cent smaller with lzma,
-	 in comparison to gzip.
+	bool "LZMA"
+	depends on HAVE_KERNEL_LZMA
+	help
+	  The most recent compression algorithm.
+	  Its ratio is best, decompression speed is between the other
+	  two. Compression is slowest.	The kernel size is about 33%
+	  smaller with LZMA in comparison to gzip.
 
 endchoice
 
-
 config SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK
-- 
1.5.6.6


--------------000808030606080401030606--
