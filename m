Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZD2Mca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZD2Mca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZD2McV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:32:21 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:56763 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZD2McU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:32:20 -0400
Date: Wed, 29 Apr 2009 14:32:11 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] Fix bogus modpost warnings
Message-ID: <20090429123211.GA12874@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build the current kernel with gcc 4.4.0 will result in a large
number of apparently bogus warnings like these:

WARNING: crypto/cryptd.o (.text.T.349): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: drivers/block/pktcdvd.o (.text.T.772): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

emitted by modpost.  This is because with -ffunction-sections gcc may now
generate some section names like .text.T.772 itself instead of like in
the past deriving those from the function's name like .text.ipgre_close.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---

For now I see this patch as a proposal only.  I'm also not sure if with
this addition check there are still section names left for which the if
condition would ever be true.  Data sections maybe?

 scripts/mod/modpost.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8d46ea7..13e801e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -739,7 +739,8 @@ static int check_section(const char *modname, const char *sec)
 		/* consume all digits */
 		while (*e && e != sec && isdigit(*e))
 			e--;
-		if (*e == '.' && !strstr(sec, ".linkonce")) {
+		if (*e == '.' &&
+		    !strstr(sec, ".linkonce") && !strstr(sec, ".text")) {
 			warn("%s (%s): unexpected section name.\n"
 			     "The (.[number]+) following section name are "
 			     "ld generated and not expected.\n"
