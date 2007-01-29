Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbXA2FUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbXA2FUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbXA2FUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:20:04 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22271 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933124AbXA2FUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:20:01 -0500
Date: Sun, 28 Jan 2007 21:14:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-Id: <20070128211424.de321492.randy.dunlap@oracle.com>
In-Reply-To: <200701290258.l0T2wQjU003810@turing-police.cc.vt.edu>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	<6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
	<45BBC444.8090109@imap.cc>
	<20070127134116.06bdadd8.akpm@osdl.org>
	<200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
	<200701290258.l0T2wQjU003810@turing-police.cc.vt.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 21:58:26 -0500 Valdis.Kletnieks@vt.edu wrote:

> On 26/01/07, akpm@osdl.org <akpm@osdl.org> wrote:
> > The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 
> Aliens ate my brain, part 2:
> 
> My IPv6 configuration evaporated, totally, out of my .config.  I tracked it
> down to wierdness with net/Kconfig:
> 
> if INET   
>           
> source "net/ipv4/Kconfig"
> source "net/netlabel/Kconfig"
>           
> endif # if INET
>           
> source "net/ipv6/Kconfig"
> 
> (Yes, the ipv6 is now *outside* the if/endif - that's what I had to do to make
> it work).  If that last 'source' was *inside* that if/endif, it became
> invisible unless I set INET to *N*, at which point ipv4 and netlabel would
> disappear, and ipv6 would become visible.  If I set INET to Y, then ipv4 and
> netlabel would come back, and ipv6 would go poof again. This affected both
> 'make menuconfig' and 'make [silent]oldconfig'.
> 
> .config follows.  I have *no* idea what caused it.

Possibly my (bad) gfs2/dlm patch...

Please try applying Adrian Bunk's patch to see if that fixes the
IPV6 disappearing trick. (below)

---
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

-
