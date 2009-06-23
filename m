Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZFWFoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZFWFoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZFWFo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:44:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36308 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbZFWFo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:44:29 -0400
Date: Tue, 23 Jun 2009 15:44:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH v2] fbdev: work around old compiler bug
Message-Id: <20090623154428.e2f4ddc9.sfr@canb.auug.org.au>
In-Reply-To: <20090622183415.46fa786b.sfr@canb.auug.org.au>
References: <20090622180420.2e0424e4.sfr@canb.auug.org.au>
	<20090622183415.46fa786b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with a 4.1.x compiler on powerpc64 (at least) we get
this error:

drivers/video/logo/logo_linux_mono.c:81: error: logo_linux_mono causes a section type conflict

This was introduced by commit ae52bb2384f721562f15f719de1acb8e934733cb
("fbdev: move logo externs to header file").  This is a partial revert
of that commit sufficient to not hit the compiler bug.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/pnmtologo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

v2: also convert _clut arrays from __initconst to __initdata.

diff --git a/scripts/pnmtologo.c b/scripts/pnmtologo.c
index 64f5ddb..5c11312 100644
--- a/scripts/pnmtologo.c
+++ b/scripts/pnmtologo.c
@@ -237,7 +237,7 @@ static void write_header(void)
     fprintf(out, " *  Linux logo %s\n", logoname);
     fputs(" */\n\n", out);
     fputs("#include <linux/linux_logo.h>\n\n", out);
-    fprintf(out, "static const unsigned char %s_data[] __initconst = {\n",
+    fprintf(out, "static unsigned char %s_data[] __initdata = {\n",
 	    logoname);
 }
 
@@ -374,7 +374,7 @@ static void write_logo_clut224(void)
     fputs("\n};\n\n", out);
 
     /* write logo clut */
-    fprintf(out, "static const unsigned char %s_clut[] __initconst = {\n",
+    fprintf(out, "static unsigned char %s_clut[] __initdata = {\n",
 	    logoname);
     write_hex_cnt = 0;
     for (i = 0; i < logo_clutsize; i++) {
-- 
1.6.3.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
