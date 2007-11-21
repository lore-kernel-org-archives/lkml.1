Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXKUK6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXKUK6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXKUK5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:57:52 -0500
Received: from srv02.itamservices.de ([87.106.7.29]:57342 "EHLO
	itamservices.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbXKUK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:57:51 -0500
Message-ID: <47440F2B.2030402@itamservices.de>
Date: Wed, 21 Nov 2007 11:57:47 +0100
From: Daniel Reichelt <nl@itamservices.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Johannes Weiner <hannes-kernel@saeurebad.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Patch: Hide process info from other users/users not in my group
References: <4742B82C.3060001@itamservices.de> <20071120175303.GA19475@cataract>
In-Reply-To: <20071120175303.GA19475@cataract>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry, I messed up the #ifdef directives (confused them with C++...). Here's
the really working patch:

--- linux-2.6.23.8/fs/Kconfig   2007-11-16 19:14:27.000000000 +0100
+++ linux-2.6.23.8-dhr/fs/Kconfig       2007-11-20 19:54:54.000000000 +0100
@@ -918,6 +918,36 @@
         help
         Exports the dump image of crashed kernel in ELF format.

+choice
+       prompt "Restrict access to /proc/<pid>-dirs"
+       default PROC_PIDDIRS_UNRESTRICTED
+config PROC_PIDDIRS_UNRESTRICTED
+       bool "no restriction"
+       depends on PROC_FS
+       help
+         Don't restrict access to /proc/<pid>-dirs, i.e. leave mode at 555
+         respectively r-xr-xr-x . This is the traditional mode of operation.
+
+         If unsure, say Y.
+config PROC_PIDDIRS_RESTRICT_TO_UG
+       bool "restrict to user and group
+       depends on PROC_FS
+       help
+         Restrict access to /proc/<pid>-dirs to user and group, i.e. set mode
+         to 550 respectively r-xr-x--- .
+
+         If unsure, say N.
+
+config PROC_PIDDIRS_RESTRICT_TO_U
+       bool "restrict to user
+       depends on PROC_FS
+       help
+         Restrict access to /proc/<pid>-dirs to user only, i.e. set mode to
+         500 respectively r-x------ .
+
+         If unsure, say N.
+endchoice
+
 config PROC_SYSCTL
        bool "Sysctl support (/proc/sys)" if EMBEDDED
        depends on PROC_FS
--- linux-2.6.23.8/fs/proc/base.c       2007-11-16 19:14:27.000000000 +0100
+++ linux-2.6.23.8-dhr/fs/proc/base.c   2007-11-21 10:44:17.000000000 +0100
@@ -2200,7 +2200,13 @@
        if (!inode)
                goto out;

+#if defined CONFIG_PROC_PIDDIRS_UNRESTRICTED
        inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+#elif defined CONFIG_PROC_PIDDIRS_RESTRICT_TO_UG
+       inode->i_mode = S_IFDIR|S_IRUSR|S_IRGRP|S_IXUSR|S_IXGRP;
+#elif defined CONFIG_PROC_PIDDIRS_RESTRICT_TO_U
+       inode->i_mode = S_IFDIR|S_IRUSR|S_IXUSR;
+#endif
        inode->i_op = &proc_tgid_base_inode_operations;
        inode->i_fop = &proc_tgid_base_operations;
        inode->i_flags|=S_IMMUTABLE;

--
Daniel
