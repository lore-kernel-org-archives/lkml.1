Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZGJUF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZGJUF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZGJUFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:05:52 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:58948 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbZGJUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:05:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH,v2] Only add '-fwrapv' to gcc CFLAGS for gcc 4.2 and later
Date: Fri, 10 Jul 2009 22:05:47 +0200
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, barryn@pobox.com,
       bugme-daemon@bugzilla.kernel.org
References: <200907100928.07369.elendil@planet.nl>
In-Reply-To: <200907100928.07369.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907102205.49642.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2009 20:05:50.0388 (UTC) FILETIME=[D254D740:01CA0199]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, Frans Pop wrote:
> The discussion on issue looks to have died, but it has bitten Debian
> stable ("Lenny") [1] as it causes init to die on s390 after a kernel
> update.
>
> Here's a possible patch. The exact gcc version to check for is still a
> bit open I guess. For the s390 issue I've confirmed that 4.2.4 is OK,
> but for safety and because of Andrew's comment above I've set the test
> for 4.3 in the patch.

Here's an updated patch as I found the gcc version check was incorrect 
(0430 should have been 0403; sorry).

I've now changed the check to allow -fwrapv for gcc 4.2 as that has been 
shown to work and because of the consideration mentioned in my previous 
mail.

---
From: Frans Pop <elendil@planet.nl>
Subject: Only add '-fwrapv' to gcc CFLAGS for gcc 4.2 and later

This flag has been shown to cause init to segfault for kernels
compiled with gcc-4.1. gcc version 4.2.4 has been shown to be OK.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13012.

Reported-by: Barry K. Nathan <barryn@pobox.com>
Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/Makefile b/Makefile
index 0aeec59..2519fde 100644
--- a/Makefile
+++ b/Makefile
@@ -565,7 +565,8 @@ KBUILD_CFLAGS += $(call 
cc-option,-Wdeclaration-after-statement,)
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
-KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
+KBUILD_CFLAGS  += $(shell if [ $(call cc-version) -ge 0402 ]; then \
+		    echo $(call cc-option,-fwrapv); fi ;)
 
 # revert to pre-gcc-4.4 behaviour of .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
