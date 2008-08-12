Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYHLPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYHLPNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHLPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:13:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYHLPNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:13:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]: Make ioctl.h compatible with userland
Date: Tue, 12 Aug 2008 17:12:18 +0200
User-Agent: KMail/1.9.9
Cc: Michael Abbott <michael@araneidae.co.uk>, linux-kernel@vger.kernel.org
References: <20080728063957.J72435@saturn.araneidae.co.uk> <20080730011035.a7d84e55.akpm@linux-foundation.org>
In-Reply-To: <20080730011035.a7d84e55.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808121712.19207.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Va5EiBOIf2s5fRHkubOYNZTWoTLWKw3WyzIz
 G92Wjg1aOpnpPwrfgzjQGT8iITRPXmImRDX5Bq/39+QPhEmzcO
 SqHqYvRI4sw4qCSPgNIxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Make _IOC_TYPECHECK use BUILD_BUG_ON_ZERO

This converts _IOC_TYPECHECK from a link error to a compile-time
error using BUILD_BUG_ON_ZERO. This makes it possible to use
the standard _IOC macros in user space even with non-optizing
compilers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Wednesday 30 July 2008, Andrew Morton wrote:
> We could also replace that open-coded assertion with the shiny new
> BUILD_BUG_ON(), which would a) be cleaner and b) fix the problem which
> you describe.  I expect that would be quite safe, but obviously doesn't
> have all the testing which the above patch has, so shrug.

There is one significant difference: using BUILD_BUG_ON_ZERO will
break user space code that uses broken ioctl number definitions
like _IOC('x', 1, sizeof(int)) that were fixed up in the kernel
but not in external copies of the definitions.
I'm undecided whether such breakage would be a good or a bad thing.

--- a/include/asm-generic/ioctl.h
+++ b/include/asm-generic/ioctl.h
@@ -69,11 +69,9 @@
 	 ((size) << _IOC_SIZESHIFT))
 
 /* provoke compile error for invalid uses of size argument */
-extern unsigned int __invalid_size_argument_for_IOC;
-#define _IOC_TYPECHECK(t) \
-	((sizeof(t) == sizeof(t[1]) && \
-	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
-	  sizeof(t) : __invalid_size_argument_for_IOC)
+#define _IOC_TYPECHECK(t) (sizeof(t) + \
+	BUILD_BUG_ON_ZERO(sizeof(t) != sizeof(t[1]) || \
+			  sizeof(t) >= (1 << _IOC_SIZEBITS)))
 
 /* used to create numbers */
 #define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)
