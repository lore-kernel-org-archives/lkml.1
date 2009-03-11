Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbZCKQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbZCKQRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZCKQRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:17:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZCKQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:17:36 -0400
Date: Wed, 11 Mar 2009 12:17:33 -0400
From: Kyle McMartin <kyle@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, jakub@redhat.com, linux-kbuild@vger.kernel.org
Subject: [PATCH] scripts/unifdef.c: rename getline symbol to something else
Message-ID: <20090311161733.GE5448@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Rawhide builds are currently failing to build unifdef.c, as the next
version of glibc changes the default _POSIX_C_SOURCE level, which
exposes getline() from <stdio.h>

scripts/unifdef.c:209: error: conflicting types for 'getline'
/usr/include/stdio.h:653: note: previous declaration of 'getline' was
here
make[2]: *** [scripts/unifdef] Error 1
make[1]: *** [__headers] Error 2
make: *** [vmlinux] Error 2

Rename the symbol in unifdef.c to parseline to avoid this conflicting
declaration.

Otherwise Jakub says we could add a -D_POSIX_C_SOURCE=200112L as a
workaround to unifdef CFLAGS, but this seems like it would be less
desirable in the long term.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 552025e..977e682 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -206,7 +206,7 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         parseline(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
@@ -512,7 +512,7 @@ process(void)
 
 	for (;;) {
 		linenum++;
-		lineval = getline();
+		lineval = parseline();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +526,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-getline(void)
+parseline(void)
 {
 	const char *cp;
 	int cursym;
