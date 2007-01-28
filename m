Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbXA1QTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbXA1QTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 11:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXA1QTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 11:19:47 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41682 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752450AbXA1QTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 11:19:46 -0500
Date: Sun, 28 Jan 2007 17:19:50 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jiri Slaby <jirislaby@gmail.com>, swhiteho@redhat.com
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, cluster-devel@redhat.com
Subject: [-mm patch] fix GFS2 circular dependency
Message-ID: <20070128161950.GS6017@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org> <45BC7612.30701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BC7612.30701@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

---

 fs/dlm/Kconfig  |    3 +--
 fs/gfs2/Kconfig |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.20-rc6-mm1/fs/gfs2/Kconfig.old	2007-01-28 16:44:17.000000000 +0100
+++ linux-2.6.20-rc6-mm1/fs/gfs2/Kconfig	2007-01-28 16:44:59.000000000 +0100
@@ -34,11 +34,10 @@
 
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
 
--- linux-2.6.20-rc6-mm1/fs/dlm/Kconfig.old	2007-01-28 16:56:57.000000000 +0100
+++ linux-2.6.20-rc6-mm1/fs/dlm/Kconfig	2007-01-28 16:57:16.000000000 +0100
@@ -3,9 +3,8 @@
 
 config DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on IPV6 || IPV6=n
+	depends on SYSFS && (IPV6 || IPV6=n)
 	select CONFIGFS_FS
-	select SYSFS
 	select IP_SCTP if DLM_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace

