Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZIJVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZIJVSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZIJVSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:18:30 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:55821 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZIJVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:18:29 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 17:18:29 EDT
Date: Thu, 10 Sep 2009 23:13:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Brassow <jbrassow@redhat.com>
cc: dm-devel@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] md: Fix "strchr" [drivers/md/dm-log-userspace.ko]
 undefined!
Message-ID: <alpine.DEB.2.00.0909102311520.10463@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b8313b6da7e2e7c7f47d93d8561969a3ff9ba0ea ("dm log: remove incorrect
field from userspace table output") added a call to strstr() with a
single-character "needle" string parameter.
Unfortunately some versions of gcc replace such calls to strstr() by calls
to strchr() behind our back.  This causes linking errors if strchr() is
defined as an inline function in <asm/string.h> (e.g. on m68k):

| WARNING: "strchr" [drivers/md/dm-log-userspace.ko] undefined!

Avoid this by explicitly calling strchr() instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org
---
This fixes a regression introduced in 2.6.31-rc9, and detected by m68k
allmodconfig, cfr. http://kisskb.ellerman.id.au/kisskb/config/164/

 drivers/md/dm-log-userspace-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 6e186b1..652bd33 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -582,7 +582,7 @@ static int userspace_status(struct dm_dirty_log *log, status_type_t status_type,
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		table_args = strstr(lc->usr_argv_str, " ");
+		table_args = strchr(lc->usr_argv_str, ' ');
 		BUG_ON(!table_args); /* There will always be a ' ' */
 		table_args++;
 
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
