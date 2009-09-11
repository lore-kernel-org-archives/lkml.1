Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZIKUVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZIKUVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZIKUVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:21:11 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:49643 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZIKUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:21:11 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 16:21:10 EDT
Date: Fri, 11 Sep 2009 22:16:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Wessel <jason.wessel@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] kgdb: Replace strstr() by strchr() for single-character
 needles
Message-ID: <alpine.DEB.2.00.0909112214370.15464@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of gcc replace calls to strstr() with single-character
"needle" string parameters by calls to strchr() behind our back.
This causes linking errors if strchr() is defined as an inline function
in <asm/string.h> (e.g. on m68k, which BTW doesn't have kgdb support).

Prevent this by explicitly calling strchr() instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is the single remaining case where strstr() is used with a
single-character needle.  Cfr.
commit 0d03d59d9b31cd1e33b7e46a80b6fef66244b1f2 ("md: Fix "strchr"
[drivers/md/dm-log-userspace.ko] undefined!")
commit d8b0fb51ef1563c631d26cb649a5479b5cc4899c ("[PATCH] libertas link error
due to gcc `smartness'")

 drivers/misc/kgdbts.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index e4ff50b..2a43d8c 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -885,16 +885,16 @@ static void kgdbts_run_tests(void)
 	int nmi_sleep = 0;
 	int i;
 
-	ptr = strstr(config, "F");
+	ptr = strchr(config, 'F');
 	if (ptr)
 		fork_test = simple_strtol(ptr + 1, NULL, 10);
-	ptr = strstr(config, "S");
+	ptr = strchr(config, 'S');
 	if (ptr)
 		do_sys_open_test = simple_strtol(ptr + 1, NULL, 10);
-	ptr = strstr(config, "N");
+	ptr = strchr(config, 'N');
 	if (ptr)
 		nmi_sleep = simple_strtol(ptr+1, NULL, 10);
-	ptr = strstr(config, "I");
+	ptr = strchr(config, 'I');
 	if (ptr)
 		sstep_test = simple_strtol(ptr+1, NULL, 10);
 
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
