Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AQASA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AQASA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 19:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093Ab0AQAR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 19:17:59 -0500
Received: from ozlabs.org ([203.10.76.45]:39232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0AQAR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 19:17:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] modpost: fix segfault in sym_is() with prefixed arches
Date: Sun, 17 Jan 2010 08:27:34 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
References: <1259812252-22041-1-git-send-email-vapier@gentoo.org> <200912031822.44004.rusty@rustcorp.com.au> <8bd0f97a1001140045l3c75c49fk5894fcda78f0cf0b@mail.gmail.com>
In-Reply-To: <8bd0f97a1001140045l3c75c49fk5894fcda78f0cf0b@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001170827.34393.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

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
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 scripts/mod/file2alias.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
