Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXERGu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXERGu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXERGuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:50:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33567 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbXERGuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:50:15 -0400
Date: Fri, 18 May 2007 08:51:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>
Subject: [PATCH 03/14] kbuild: add "Section mismatch" warning whitelist for powerpc
Message-ID: <20070518065111.GC12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From bdfeed222963cadd30cbfcad799c89f3a7b94e02 Mon Sep 17 00:00:00 2001
From: Li Yang <leoli@freescale.com>
Date: Mon, 14 May 2007 18:04:28 +0800
Subject: [PATCH 03/14] kbuild: add "Section mismatch" warning whitelist for powerpc

This patch fixes the following class of "Section mismatch" warnings when
building powerpc platforms.

WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from prom_entry (offset 0x0)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.text:mpc8313_rdb_probe from .machine.desc after 'mach_mpc8313_rdb' (at offset 0x4)
....

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ecb0a15..b394629 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -650,9 +650,10 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec    = .init.text
  *
  * Pattern 10:
- *  ia64 has machvec table for each platform. It is mixture of function
- *  pointer of .init.text and .text.
- *  fromsec  = .machvec
+ *  ia64 has machvec table for each platform and
+ *  powerpc has a machine desc table for each platform.
+ *  It is mixture of function pointers of .init.text and .text.
+ *  fromsec  = .machvec | .machine.desc
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -751,7 +752,8 @@ static int secref_whitelist(const char *modname, const char *tosec,
 				return 1;
 
 	/* Check for pattern 10 */
-	if (strcmp(fromsec, ".machvec") == 0)
+	if ((strcmp(fromsec, ".machvec") == 0) ||
+	    (strcmp(fromsec, ".machine.desc") == 0))
 		return 1;
 
 	return 0;
@@ -887,6 +889,11 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 			     elf->strtab + before->st_name, refsymname))
 		return;
 
+	/* fromsec whitelist - without a valid 'before'
+	 * powerpc has a GOT table in .got2 section */
+	if (strcmp(fromsec, ".got2") == 0)
+		return;
+
 	if (before && after) {
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(between '%s' and '%s')\n",
-- 
1.5.1.rc3.20.gaa453

