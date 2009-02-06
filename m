Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZBFWp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZBFWp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZBFWpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:45:16 -0500
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:53402 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307AbZBFWpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:45:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=dWbaOAnxsR0GrZo60cZ1CfiwLk6jzyn11KWxePFvGdC0YJTGFvSgtooCyHbX68UCICmnVF9M5zr7VooJj5nGTsI29My7v28eV9IsyCdru6z1hbX5+qp5L/1zWlFemToS;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
Date: Fri, 6 Feb 2009 14:45:10 -0800
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <200902060849.45851.jbarnes@virtuousgeek.org> <Pine.LNX.4.64.0902062205540.5710@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902062205540.5710@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061445.11379.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 2:17 pm Hugh Dickins wrote:
> On Fri, 6 Feb 2009, Jesse Barnes wrote:
> > Hugh, did you get a chance to try my X patch (w/o Ben's patch applied)? 
> > If it also works, we should apply it to X too, if only to make porting to
> > future platforms a little easier.
>
> I have tried it now: I'm sorry to say it does not work, fails with
> (WW) xf86MapDomainMem():  mmap() failure: No such device or address
>
> Fatal server error:
> AddScreen/ScreenInit failed for driver 0
>
> The "mmap() failure" line is of course the one you're intentionally
> showing, but the AddScreen/ScreenInit one is not what you want.
> Presumably it demands something other than a NULL addr returned,
> but I haven't followed that up at all.
>
> I have tried the obvious patch below, which reverts to the original
> code if the mmap fails: this works, but presumably negates much of
> what you intended to achieve with legacy_mem.
>
> Easy for me to try something else, fire away.
>
> Hugh
>
> --- a/hw/xfree86/os-support/bus/linuxPci.c
> +++ b/hw/xfree86/os-support/bus/linuxPci.c
> @@ -501,8 +501,10 @@ xf86MapDomainMemory(int ScreenNum, int F
>      if (fd >= 0)
>  	close(fd);
>      if (addr == NULL || addr == MAP_FAILED) {
> -	perror("mmap failure");
> -	FatalError("xf86MapDomainMem():  mmap() failure\n");
> +	xf86Msg(X_WARNING, "xf86MapDomainMem():  mmap() failure: %s\n",
> +		strerror(errno));
> +	return linuxMapPci(ScreenNum, Flags, dev, Base, Size,
> +			   PCIIOC_MMAP_IS_MEM);
>      }
>      return addr;
>  }

Yeah that should work.  I always hated this code (well most of X actually); we
could probably clean up the logic a little.  If this works I'll send it
out to the Xorg list for review.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/hw/xfree86/os-support/bus/linuxPci.c b/hw/xfree86/os-support/bus/linuxPci.c
index 263fd8f..fa0fc0a 100644
--- a/hw/xfree86/os-support/bus/linuxPci.c
+++ b/hw/xfree86/os-support/bus/linuxPci.c
@@ -471,23 +471,18 @@ xf86MapDomainMemory(int ScreenNum, int Flags, struct pci_device *dev,
     int fd = -1;
     pointer addr;
 
-    /*
-     * We use /proc/bus/pci on non-legacy addresses or if the Linux sysfs
-     * legacy_mem interface is unavailable.
-     */
-    if ((Base > 1024*1024) || ((fd = linuxOpenLegacy(dev, "legacy_mem")) < 0))
-	return linuxMapPci(ScreenNum, Flags, dev, Base, Size,
-			   PCIIOC_MMAP_IS_MEM);
-    else
-	addr = mmap(NULL, Size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, Base);
-
-    if (fd >= 0)
-	close(fd);
-    if (addr == NULL || addr == MAP_FAILED) {
-	perror("mmap failure");
-	FatalError("xf86MapDomainMem():  mmap() failure\n");
+    if (Base <= 1024*1024) {
+        /* Try legacy_mem (may not be available or implemented) */
+        if ((fd = linuxOpenLegacy(dev, "legacy_mem")) < 0) {
+            addr = mmap(NULL, Size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, Base);
+            close(fd);
+            if (addr && addr != MAP_FAILED)
+                return addr;
+        }
     }
-    return addr;
+
+    /* Fall back to old method if legacy_mem fails or Base >= 1M */
+    return linuxMapPci(ScreenNum, Flags, dev, Base, Size, PCIIOC_MMAP_IS_MEM);
 }
 
 /**
