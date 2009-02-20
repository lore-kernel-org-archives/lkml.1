Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZBTMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZBTMcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZBTMcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:32:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZBTMcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:32:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29958.1235131881@redhat.com>
References: <29958.1235131881@redhat.com> <20090219161211.9b80c129.akpm@linux-foundation.org> <20090212104000.26766.11068.stgit@warthog.procyon.org.uk> <20090212104010.26766.20813.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, dwmw2@infradead.org, bernds_cb1@t-online.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] NOMMU: Make it possible for RomFS to use MTD devices directly
Date: Fri, 20 Feb 2009 12:31:54 +0000
Message-ID: <30590.1235133114@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > My x86_64 usualconfig just exploded with
> > 
> > fs/romfs/storage.c:18:2: error: #error no ROMFS backing store interface configured
> 
> To be able to use romfs you have to set one or both of the two backing store
> options with this patch.  Commenting out the #error isn't good enough.  This
> needs some Kconfig magic, but I'm not sure what.

Perhaps a choice item?  The attached patch seems to work quite nicely.  I
wouldn't really want to do this if there were more than two options.

If you like it, I can fold it into the main patch.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Fix the RomFS Kconfig to ensure at least one backing store is selected

Fix the configuration of the RomFS to make sure that at least one backing store
method is always selected.  This is done by rendering it down to a choice item
that selects between Block, MTD and both.

This also works correctly in the case that CONFIG_MTD=m: MTD cannot be selected
as a backing store unless CONFIG_ROMFS_FS is also 'm'.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/romfs/Kconfig |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)


diff --git a/fs/romfs/Kconfig b/fs/romfs/Kconfig
index 802c742..ce2d6bc 100644
--- a/fs/romfs/Kconfig
+++ b/fs/romfs/Kconfig
@@ -1,6 +1,6 @@
 config ROMFS_FS
 	tristate "ROM file system support"
-	depends on BLOCK
+	depends on BLOCK || MTD
 	---help---
 	  This is a very small read-only file system mainly intended for
 	  initial ram disks of installation disks, but it could be used for
@@ -15,9 +15,19 @@ config ROMFS_FS
 	  If you don't know whether you need it, then you don't need it:
 	  answer N.
 
-config ROMFS_ON_BLOCK
-	bool "Block device-backed ROM file system support" if (ROMFS_ON_MTD && EMBEDDED)
-	depends on ROMFS_FS && BLOCK
+#
+# Select the backing stores to be supported
+#
+choice
+	prompt "RomFS backing stores"
+	depends on ROMFS_FS
+	default ROMFS_BACKED_BY_BLOCK
+	help
+	  Select the backing stores to be supported.
+
+config ROMFS_BACKED_BY_BLOCK
+	bool "Block device-backed ROM file system support"
+	depends on BLOCK
 	help
 	  This permits ROMFS to use block devices buffered through the page
 	  cache as the medium from which to retrieve data.  It does not allow
@@ -25,9 +35,8 @@ config ROMFS_ON_BLOCK
 
 	  If unsure, answer Y.
 
-config ROMFS_ON_MTD
+config ROMFS_BACKED_BY_MTD
 	bool "MTD-backed ROM file system support"
-	depends on ROMFS_FS
 	depends on MTD=y || (ROMFS_FS=m && MTD)
 	help
 	  This permits ROMFS to use MTD based devices directly, without the
@@ -38,3 +47,16 @@ config ROMFS_ON_MTD
 
 	  If unsure, answer Y.
 
+config ROMFS_BACKED_BY_BOTH
+	bool "Both the above"
+	depends on BLOCK && (MTD=y || (ROMFS_FS=m && MTD))
+endchoice
+
+
+config ROMFS_ON_BLOCK
+	bool
+	default y if ROMFS_BACKED_BY_BLOCK || ROMFS_BACKED_BY_BOTH
+
+config ROMFS_ON_MTD
+	bool
+	default y if ROMFS_BACKED_BY_MTD || ROMFS_BACKED_BY_BOTH
