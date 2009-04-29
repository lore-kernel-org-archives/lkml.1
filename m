Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbZD2W2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbZD2W2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbZD2WV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:26 -0400
Received: from kroah.org ([198.145.64.141]:40366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZD2WVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:25 2009
Message-Id: <20090429220925.755690732@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:18 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Michael K Johnson <johnsonm@rpath.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 19/58] x86, setup: mark %esi as clobbered in E820 BIOS call
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0011-x86-setup-mark-esi-as-clobbered-in-E820-BIOS-call.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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


