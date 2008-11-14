Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbYKNCbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbYKNCbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYKNCbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:31:14 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43899 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYKNCbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:31:12 -0500
Date: Fri, 14 Nov 2008 02:30:55 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28?] sprint_symbol use less stack
Message-ID: <Pine.LNX.4.64.0811140223450.5027@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sprint_symbol(), itself used when dumping stacks, has been wasting 128
bytes of stack: lookup the symbol directly into the buffer supplied by
the caller, instead of using a locally declared namebuf.

I believe the name != buffer strcpy() is obsolete: the design here dates
from when module symbol lookup pointed into a supposedly const but sadly
volatile table; nowadays it copies, but an uncalled strcpy() looks better
here than the risk of a recursive BUG_ON().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Perhaps this is too late for 2.6.28: your decision.

 kernel/kallsyms.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- 2.6.28-rc4/kernel/kallsyms.c	2008-10-24 09:28:25.000000000 +0100
+++ linux/kernel/kallsyms.c	2008-11-12 11:52:44.000000000 +0000
@@ -304,17 +304,24 @@ int sprint_symbol(char *buffer, unsigned
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN];
+	int len;
 
-	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
+	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
 	if (!name)
 		return sprintf(buffer, "0x%lx", address);
 
+	if (name != buffer)
+		strcpy(buffer, name);
+	len = strlen(buffer);
+	buffer += len;
+
 	if (modname)
-		return sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
-				size, modname);
+		len += sprintf(buffer, "+%#lx/%#lx [%s]",
+						offset, size, modname);
 	else
-		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
+		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+
+	return len;
 }
 
 /* Look up a kernel symbol and print it to the kernel messages. */
