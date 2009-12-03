Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZLCDus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZLCDus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZLCDus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:50:48 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46475 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbZLCDur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:50:47 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] modpost: fix segfault in sym_is() with prefixed arches
Date: Wed,  2 Dec 2009 22:50:52 -0500
Message-Id: <1259812252-22041-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sym_is() compares a symbol in an attempt to automatically skip symbol
prefixes.  It does this first by searching the real symbol with the normal
unprefixed symbol.  But then it uses the length of the original symbol to
check the end of the substring instead of the length of the symbol it is
looking for.  On non-prefixed arches, this is effectively the same thing,
so there is no problem.  On prefixed-arches, since this is exceeds by just
one byte, a crash is rare and it is usually a NUL byte anyways.  But every
once in a blue moon, you get the right page alignment and it segfaults.

For example, on the Blackfin arch, sym_is() will be called with the real
symbol "___mod_usb_device_table" as "symbol" when looking for the normal
symbol "__mod_usb_device_table" as "name".  The substring will thus return
one byte into "symbol" and store it into "match".  But then "match" will
be indexed with the length of "symbol" instead of "name" and so we will
exceed the storage.  i.e. the code ends up doing:
	char foo[] = "abc"; return foo[strlen(foo)+1] == '\0';

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/mod/file2alias.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 40e0045..1ffd1e4 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -726,7 +726,7 @@ static inline int sym_is(const char *symbol, const char *name)
 	match = strstr(symbol, name);
 	if (!match)
 		return 0;
-	return match[strlen(symbol)] == '\0';
+	return match[strlen(name)] == '\0';
 }
 
 static void do_table(void *symval, unsigned long size,
-- 
1.6.5.3

