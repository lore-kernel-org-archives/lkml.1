Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbZCaTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbZCaTfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZCaTfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:35:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZCaTfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:35:23 -0400
Message-ID: <49D27072.8070504@zytor.com>
Date: Tue, 31 Mar 2009 12:35:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: Jike Song <albcamus@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: "make oldconfig" problem
References: <804dabb00903302349j5bdbabeaxbbd09291b1cf6e4@mail.gmail.com>	 <df9815e70903310147l1ae6675ag1fa4c2e99250cef4@mail.gmail.com> <804dabb00903310151y2d091ef3u5bbef0c7a264cb29@mail.gmail.com>
In-Reply-To: <804dabb00903310151y2d091ef3u5bbef0c7a264cb29@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040708080907090302060306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040708080907090302060306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Peter Teoh wrote:
>>>
>> Seems to be caused by
>> 40297927575a50b1d0d308d735c445924d33fba6("bzip2/lzma: don't ask for
>> compression mode for the default initramfs").
>>
>> I get no errors with that commit reverted.
> 
> Thank you, will try that.
> 

Linus complained about a choice that didn't make sense for most users. 
Unfortunately Kconfig doesn't seem to have a sane block to deal with 
having alternatives to conditionalized choice blocks.

Fortunately, CONFIG_INITRAMFS_COMPRESSION_NONE doesn't actually *do* 
anything, so this is probably the preferred hack.

Could you try this out?  If it works as expected for you as well as me, 
I'll push it to Linus.

	-hpa


--------------040708080907090302060306
Content-Type: text/x-patch;
 name="0001-bzip2-lzma-quiet-Kconfig-warning-for-INITRAMFS_COMP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-bzip2-lzma-quiet-Kconfig-warning-for-INITRAMFS_COMP.pat";
 filename*1="ch"

>From 758d6f7ba5a26b07ecd99ad7966b5ce3531b1f0a Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Tue, 31 Mar 2009 12:24:17 -0700
Subject: [PATCH] bzip2/lzma: quiet Kconfig warning for INITRAMFS_COMPRESSION_NONE

Impact: quiet Kconfig warning

It appears that Kconfig simply has no way to provide defaults for
entries that exist inside a conditionalized choice block.
Fortunately, it turns out we don't actually ever use
CONFIG_INITRAMFS_COMPRESSION_NONE, so we can just drop it for
everything outside the choice block.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 usr/Kconfig  |   15 +--------------
 usr/Makefile |    3 ---
 2 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
index 588c588..1c3039f 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -72,10 +72,8 @@ config RD_LZMA
 	  Support loading of a LZMA encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
-if INITRAMFS_SOURCE!=""
-
 choice
-	prompt "Built-in initramfs compression mode"
+	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
 	help
 	  This option decides by which algorithm the builtin initramfs
 	  will be compressed.  Several compression algorithms are
@@ -134,14 +132,3 @@ config INITRAMFS_COMPRESSION_LZMA
 	  smaller with LZMA in comparison to gzip.
 
 endchoice
-
-endif
-
-if INITRAMFS_SOURCE=""
-# The builtin initramfs is so small so we don't want to bug the user...
-
-config INITRAMFS_COMPRESSION_NONE
-	bool
-	default y
-
-endif
diff --git a/usr/Makefile b/usr/Makefile
index b84894b..245145a 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -6,9 +6,6 @@ klibcdirs:;
 PHONY += klibcdirs
 
 
-# No compression
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_NONE)   =
-
 # Gzip, but no bzip2
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   = .gz
 
-- 
1.6.0.6


--------------040708080907090302060306--
