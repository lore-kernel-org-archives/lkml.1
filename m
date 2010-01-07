Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106Ab0AGAW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0AGAW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995Ab0AGAW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:22:57 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:35529 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755309Ab0AGAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:22:56 -0500
Message-ID: <4B4528C8.3020603@lougher.demon.co.uk>
Date: Thu, 07 Jan 2010 00:20:24 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH V2 6/8] lzma: Make lzma available to non initramfs/initrd
 code
References: <E1NIuOW-0001ol-RC@dylan.lougher.demon.co.uk> <20100106140409.ba0f63d1.akpm@linux-foundation.org>
In-Reply-To: <20100106140409.ba0f63d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> So what to do?  I guess I could go ahead with the mainline merge, and
> Stephen drops <whatever that tree was> from linux-next until it has
> been fixed up?
> 

Yes, I'm happy with that.  The following patch is the necessary fix
that needs to go into linux-next when you've gone ahead with the
mainline merge of the lib-add-support-for-lzo-compressed-kernels.patch.

Once I know the mainline merge has gone ahead, I can add this to
my linux-next tree.


Phillip


 From 1cf6d32e1427398368ff189aece68aa533092e98 Mon Sep 17 00:00:00 2001
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 6 Jan 2010 23:50:12 +0000
Subject: [PATCH] lzo: Fix-up add support for lzo compressed kernels patch

The add support for lzo compressed kernels patch relies on
INIT and error definitions which have been moved to
separate xxx_mm.h files for each decompressor.

This patch adds a unlzo_mm.h file which supplies these
definitions.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  include/linux/decompress/unlzo_mm.h |   13 +++++++++++++
  lib/decompress_unlzo.c              |    1 +
  2 files changed, 14 insertions(+), 0 deletions(-)
  create mode 100644 include/linux/decompress/unlzo_mm.h

diff --git a/include/linux/decompress/unlzo_mm.h b/include/linux/decompress/unlzo_mm.h
new file mode 100644
index 0000000..27fe0ab
--- /dev/null
+++ b/include/linux/decompress/unlzo_mm.h
@@ -0,0 +1,13 @@
+#ifndef UNLZO_MM_H
+#define UNLZO_MM_H
+
+#ifdef STATIC
+/* Code active when included from pre-boot environment: */
+#define INIT
+#else
+/* Compile for initramfs/initrd code only */
+#define INIT __init
+static void(*error)(char *m);
+#endif
+
+#endif
diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index db521f4..edd82c3 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -39,6 +39,7 @@

  #include <linux/types.h>
  #include <linux/lzo.h>
+#include <linux/decompress/unlzo_mm.h>
  #include <linux/decompress/mm.h>

  #include <linux/compiler.h>
-- 
1.6.3.3

