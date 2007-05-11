Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXEKFpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXEKFpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 01:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXEKFpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 01:45:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33552 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028AbXEKFpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 01:45:07 -0400
Date: Fri, 11 May 2007 15:45:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sam@ravnborg.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PowerPC64 symbols start with '.'
Message-Id: <20070511154501.1961fb92.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

which we want to skip during modpost processing.  We need this to make
some of the whitelisting work.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/mod/modpost.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..748b058 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -164,7 +164,13 @@ static inline unsigned int tdb_hash(const char *name)
 static struct symbol *alloc_symbol(const char *name, unsigned int weak,
 				   struct symbol *next)
 {
-	struct symbol *s = NOFAIL(malloc(sizeof(*s) + strlen(name) + 1));
+	struct symbol *s;
+
+	/* For our purposes, .foo matches foo.  PPC64 needs this. */
+	if (name[0] == '.')
+		name++;
+
+	s = NOFAIL(malloc(sizeof(*s) + strlen(name) + 1));
 
 	memset(s, 0, sizeof(*s));
 	strcpy(s->name, name);
@@ -180,6 +186,10 @@ static struct symbol *new_symbol(const char *name, struct module *module,
 	unsigned int hash;
 	struct symbol *new;
 
+	/* For our purposes, .foo matches foo.  PPC64 needs this. */
+	if (name[0] == '.')
+		name++;
+
 	hash = tdb_hash(name) % SYMBOL_HASH_SIZE;
 	new = symbolhash[hash] = alloc_symbol(name, 0, symbolhash[hash]);
 	new->module = module;
@@ -684,6 +694,12 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		NULL
 	};
 
+	/* For our purposes, .foo matches foo.  PPC64 needs this. */
+	if (atsym[0] == '.')
+		atsym++;
+	if (refsymname[0] == '.')
+		refsymname++;
+
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
 		f1 = 0;
-- 
1.5.1.4

