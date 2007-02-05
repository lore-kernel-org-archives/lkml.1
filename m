Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbXBEOjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbXBEOjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbXBEOjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:39:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbXBEOjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:39:45 -0500
Subject: [GFS2/DLM] fix GFS2 circular dependency [48/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:45:46 +0000
Message-Id: <1170686746.11001.367.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From e0d8f8673de341dbd2db39b8990a405683a3338f Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 28 Jan 2007 17:19:50 +0100
Subject: [PATCH] [GFS2/DLM] fix GFS2 circular dependency

On Sun, Jan 28, 2007 at 11:08:18AM +0100, Jiri Slaby wrote:
> Andrew Morton napsal(a):
> >Temporarily at
> >
> >	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
>
> Unable to select IPV6. Menuconfig doesn't offer it when INET is selected.
> When it's not it appears in the menu, but after state change it gets away.
> The same behaviour in xconfig, gconfig.
>
> $ mkdir ../a/tst
> $ make O=../a/tst menuconfig
>   HOSTCC  scripts/basic/fixdep
> [...]
>   HOSTLD  scripts/kconfig/mconf
> scripts/kconfig/mconf arch/i386/Kconfig
> Warning! Found recursive dependency: INET GFS2_FS_LOCKING_DLM SYSFS
> OCFS2_FS INET
>
> Maybe this is the problem?

Yes, patch below.

> regards,

cu
Adrian

<--  snip  -->

This patch fixes a circular dependency by letting GFS2_FS_LOCKING_DLM
and DLM depend on instead of select SYSFS.

Since SYSFS depends on EMBEDDED this change shouldn't cause any problems
for users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index d1359b9..7e264b7 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -3,9 +3,8 @@ menu "Distributed Lock Manager"
 
 config DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on IPV6 || IPV6=n
+	depends on SYSFS && (IPV6 || IPV6=n)
 	select CONFIGFS_FS
-	select SYSFS
 	select IP_SCTP if DLM_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 2c184a9..cbd5f33 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -34,11 +34,10 @@ config GFS2_FS_LOCKING_NOLOCK
 
 config GFS2_FS_LOCKING_DLM
 	tristate "GFS2 DLM locking module"
-	depends on GFS2_FS && NET && INET && (IPV6 || IPV6=n)
+	depends on GFS2_FS && SYSFS && NET && INET && (IPV6 || IPV6=n)
 	select IP_SCTP if DLM_SCTP
 	select CONFIGFS_FS
 	select DLM
-	select SYSFS
 	help
 	Multiple node locking module for GFS2
 
-- 
1.4.4.2



