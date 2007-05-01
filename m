Return-Path: <linux-kernel-owner+w=401wt.eu-S1946503AbXEAEAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946503AbXEAEAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946587AbXEAEAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473AbXEAD6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:23 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [24/30] x86_64: Shut up warnings for vfat compat ioctls on other file systems
Message-Id: <20070501035822.B3FC613CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


vfat implements compat handlers for these ioctls, but when they
were executed on other file systems the kernel would still complain
about an unknown compat ioctl.  Just declare them as compatible
and let them be rejected when not needed by the normal path.

This makes wine runs a lot quieter

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/compat_ioctl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c
+++ linux/fs/compat_ioctl.c
@@ -2627,6 +2627,15 @@ COMPATIBLE_IOCTL(LPRESET)
 /*LPGETSTATS not implemented, but no kernels seem to compile it in anyways*/
 COMPATIBLE_IOCTL(LPGETFLAGS)
 HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_trans)
+
+/* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
+   but we don't want warnings on other file systems. So declare
+   them as compatible here. */
+#define VFAT_IOCTL_READDIR_BOTH32       _IOR('r', 1, struct compat_dirent[2])
+#define VFAT_IOCTL_READDIR_SHORT32      _IOR('r', 2, struct compat_dirent[2])
+
+IGNORE_IOCTL(VFAT_IOCTL_READDIR_BOTH32)
+IGNORE_IOCTL(VFAT_IOCTL_READDIR_SHORT32)
 };
 
 int ioctl_table_size = ARRAY_SIZE(ioctl_start);
