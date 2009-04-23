Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZDWHbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZDWHbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZDWH1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:30 -0400
Received: from sous-sol.org ([216.99.217.87]:48177 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754744AbZDWH1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:21 -0400
Message-Id: <20090423072206.498391285@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Michael K. Johnson" <johnsonm@rpath.com>,
       H Peter Anvin <hpa@zytor.com>
Subject: [patch 011/100] x86, setup: mark %esi as clobbered in E820 BIOS call
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=x86-setup-mark-esi-as-clobbered-in-e820-bios-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Michael K. Johnson <johnsonm@rpath.com>

upstream commit: 01522df346f846906eaf6ca57148641476209909

Jordan Hargrave diagnosed a BIOS clobbering %esi in the E820 call.
That particular BIOS has been fixed, but there is a possibility that
this is responsible for other occasional reports of early boot
failure, and it does not hurt to add %esi to the clobbers.

-stable candidate patch.

Cc: Justin Forbes <jmforbes@linuxtx.org>
Signed-off-by: Michael K Johnson <johnsonm@rpath.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/boot/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -27,13 +27,14 @@ static int detect_memory_e820(void)
 	do {
 		size = sizeof(struct e820entry);
 
-		/* Important: %edx is clobbered by some BIOSes,
-		   so it must be either used for the error output
+		/* Important: %edx and %esi are clobbered by some BIOSes,
+		   so they must be either used for the error output
 		   or explicitly marked clobbered. */
 		asm("int $0x15; setc %0"
 		    : "=d" (err), "+b" (next), "=a" (id), "+c" (size),
 		      "=m" (*desc)
-		    : "D" (desc), "d" (SMAP), "a" (0xe820));
+		    : "D" (desc), "d" (SMAP), "a" (0xe820)
+		    : "esi");
 
 		/* BIOSes which terminate the chain with CF = 1 as opposed
 		   to %ebx = 0 don't always report the SMAP signature on

