Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZBFWSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZBFWSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZBFWS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:18:28 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38126 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZBFWS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:18:27 -0500
Date: Fri, 6 Feb 2009 22:17:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
In-Reply-To: <200902060849.45851.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.64.0902062205540.5710@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <1233898836.4612.116.camel@pasglop>
 <Pine.LNX.4.64.0902061248010.14011@blonde.anvils> <200902060849.45851.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Jesse Barnes wrote:
> 
> Hugh, did you get a chance to try my X patch (w/o Ben's patch applied)?  If it 
> also works, we should apply it to X too, if only to make porting to future 
> platforms a little easier.

I have tried it now: I'm sorry to say it does not work, fails with
(WW) xf86MapDomainMem():  mmap() failure: No such device or address

Fatal server error:
AddScreen/ScreenInit failed for driver 0

The "mmap() failure" line is of course the one you're intentionally
showing, but the AddScreen/ScreenInit one is not what you want.
Presumably it demands something other than a NULL addr returned,
but I haven't followed that up at all.

I have tried the obvious patch below, which reverts to the original
code if the mmap fails: this works, but presumably negates much of
what you intended to achieve with legacy_mem.

Easy for me to try something else, fire away.

Hugh

--- a/hw/xfree86/os-support/bus/linuxPci.c
+++ b/hw/xfree86/os-support/bus/linuxPci.c
@@ -501,8 +501,10 @@ xf86MapDomainMemory(int ScreenNum, int F
     if (fd >= 0)
 	close(fd);
     if (addr == NULL || addr == MAP_FAILED) {
-	perror("mmap failure");
-	FatalError("xf86MapDomainMem():  mmap() failure\n");
+	xf86Msg(X_WARNING, "xf86MapDomainMem():  mmap() failure: %s\n",
+		strerror(errno));
+	return linuxMapPci(ScreenNum, Flags, dev, Base, Size,
+			   PCIIOC_MMAP_IS_MEM);
     }
     return addr;
 }
