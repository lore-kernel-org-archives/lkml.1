Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZC0Rmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZC0Rmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZC0RmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:42:15 -0400
Received: from rdu-nat.rpath.com ([66.192.95.194]:57733 "EHLO
	rdu-nat.rpath.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbZC0RmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:42:14 -0400
X-Greylist: delayed 1648 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 13:42:13 EDT
Date: Fri, 27 Mar 2009 13:14:41 -0400
From: "Michael K. Johnson" <johnsonm@rpath.com>
To: jmforbes@linuxtx.org, hpa@zytor.com
Cc: Jordan_Hargrave@Dell.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mark %esi as clobbered in E820 BIOS call
Message-ID: <20090327171441.GD4363@logo.rdu.rpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin and Peter, please review this for stable .y trees.  Peter,
please review this for trunk unless you decide to do a more 
extensive workaround for BIOS register clobbering.

Thanks!

$ cat e820-esi-clobber-workaround.patch
Jordan Hargrave diagnosed a BIOS clobbering %esi in the E820 call.
That particular BIOS has been fixed, but there is a possibility that
this is responsible for other occasional reports of early boot
failure, and it does not hurt to add %esi to the clobbers.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>

Signed-off-by: Michael K Johnson <johnsonm@rpath.com>

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 8c3c25f..fa85af7 100644
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
+		    : "%esi");
 
 		/* BIOSes which terminate the chain with CF = 1 as opposed
 		   to %ebx = 0 don't always report the SMAP signature on
