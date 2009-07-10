Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZGJH2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZGJH2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZGJH2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:28:11 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:56808 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZGJH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:28:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch; 2.6.28.8 OK
Date: Fri, 10 Jul 2009 09:28:05 +0200
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, barryn@pobox.com,
       bugme-daemon@bugzilla.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907100928.07369.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2009 07:28:08.0596 (UTC) FILETIME=[F8FDE540:01CA012F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009, Linus Torvalds wrote:
> On Thu, 9 Apr 2009, Andrew Morton wrote:
> > -fwrapv killed Barry's gcc-4.1.2-compiled kernel in 2.6.27.x,
> > 2.6.28.x and presumably 2.6.29, 2.6.30.
>
> Auughh. I hate compiler bugs. They're horrible to debug.
>
> I _think_ 'fwrapv' only really matters with gcc-4.3, so maybe we could
> just enable it for new versions.
>
> HOWEVER, I also wonder if we could instead of "-fwrapv" use
> "-fno-strict-overflow". They are apparently subtly different, and maybe
> the bug literally only happens with -fwrapv.
>
> Barry, can you see if that simple "replace -fwrapv with
> -fno-strict-overflow" works for you?
>
> Or just go with Barry's helpful debugging:
> > > I also noticed that the problem only happens with some gcc's:
> > >
> > > Problem occurs:
> > > gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
> > > gcc-4.1 (GCC) 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)
> > >
> > > Problem does not occur (i.e. 2.6.28.9 works and I don't have to
> > > revert anything):
> > > gcc-4.2 (GCC) 4.2.4 (Debian 4.2.4-6)
> > > gcc (Debian 4.3.2-1.1) 4.3.2
>
> and consider 4.2 to be the point where it's ok.
>
> Do we have some gcc developer who
>  (a) knows what the rules are
> and
>  (b) might even help us figure out where the bug occurs?

The discussion on issue looks to have died, but it has bitten Debian 
stable ("Lenny") [1] as it causes init to die on s390 after a kernel 
update.

Here's a possible patch. The exact gcc version to check for is still a bit 
open I guess. For the s390 issue I've confirmed that 4.2.4 is OK, but for 
safety and because of Andrew's comment above I've set the test for 4.3 in 
the patch.

Cheers,
FJP

[1] http://bugs.debian.org/536354

---
From: Frans Pop <elendil@planet.nl>
Subject: Only add '-fwrapv' to gcc CFLAGS for gcc 4.3 and later

This flag has been shown to cause init to segfault for kernels
compiled with gcc-4.1. gcc version 4.2.4 has been shown to be OK,
but as there is some uncertainty the flag is only added for 4.3
and later.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13012.

Reported-by: Barry K. Nathan <barryn@pobox.com>
Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/Makefile b/Makefile
index 0aeec59..2f8756e 100644
--- a/Makefile
+++ b/Makefile
@@ -565,7 +565,8 @@ KBUILD_CFLAGS += $(call 
cc-option,-Wdeclaration-after-statement,)
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
-KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
+KBUILD_CFLAGS  += $(shell if [ $(call cc-version) -ge 0430 ]; then \
+		    echo $(call cc-option,-fwrapv); fi ;)
 
 # revert to pre-gcc-4.4 behaviour of .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
