Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbYJSLx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbYJSLx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 07:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYJSLxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 07:53:18 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38653 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYJSLxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 07:53:18 -0400
Date: Sun, 19 Oct 2008 12:52:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Dave Airlie <airlied@redhat.com>
cc: Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Export tiny shmem_file_setup for DRM-GEM
Message-ID: <Pine.LNX.4.64.0810191242220.22825@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're trying to keep the !CONFIG_SHMEM tiny-shmem.c (using ramfs without
swap) in synch with CONFIG_SHMEM shmem.c (and mpm is preparing patches
to combine them).  I was glad to see EXPORT_SYMBOL_GPL(shmem_file_setup)
go into shmem.c, but why not support DRM-GEM when !CONFIG_SHMEM too?
But caution says still depend on MMU, since !CONFIG_MMU is.. different.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I should admit that I've not actually tested this patch,
but can't imagine why it would be a problem: if you gobble
up too much RAM, well, that's just life with tiny-shmem.

I did promise a patch to make read_mapping_page() return -EINVAL instead
of oopsing when the underlying filesystem doesn't support it.  But that
was when people were trying to persuade GEM to map files on whatever fs:
I can't now see the point of such a patch while you're known to be on
tmpfs or ramfs, and intending later to use a new interface from Nick.

 drivers/gpu/drm/Kconfig |    2 +-
 mm/tiny-shmem.c         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -6,7 +6,7 @@
 #
 menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
-	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && SHMEM
+	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -95,6 +95,7 @@ put_dentry:
 put_memory:
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL_GPL(shmem_file_setup);
 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
