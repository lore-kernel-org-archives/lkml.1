Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYEDLAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYEDLAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYEDLAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:00:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbYEDLAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=hPD1s2VHsf41lfIyM/6t6x5RbOJ6pcv+qkwNvhtNApUSBCfR0ei0eSsMg0pJpiX2Nj0FD+tnQopBdsgT/gcHD3SbHIbr3SexOQru4kMwnNuZKqsbIfAP+ZPsOdeQC7a+ddeBHi5xPEvmzrUa2VQTJt/3nLZq2L6ZX8CCxxg6lbI=
Date: Sun, 4 May 2008 13:00:38 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
Message-ID: <20080504110038.GA8532@damson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805040156i614db705xc642b301259a4d04@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, here's try #2. (That's what I get for making patches too early in the
morning.)

This checks dependencies instead of the "default" property. I don't know how
useful this is, though, as it will generate some false positives. Actually,
a lot of them.


Vegard


>From c5587b1c4a442ae8edde7e22f36ab9058d1e9121 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 4 May 2008 07:24:04 +0200
Subject: [PATCH] kconfig: warn about complex selects

"Complex selects" are selects that depend on symbols with dependencies. These
are effectively circumventing the rest of the dependency chains of kconfig,
often leading to build errors.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 scripts/kconfig/symbol.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..4848588 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -790,6 +790,41 @@ static struct symbol *sym_check_expr_deps(struct expr *e)
 	return NULL;
 }
 
+static bool sym_is_complex(struct symbol *sym)
+{
+	struct expr *expr;
+	struct property *prop;
+
+	for_all_prompts(sym, prop) {
+		expr = prop->visible.expr;
+
+		if (!expr)
+			continue;
+		if (expr->type != E_NONE)
+			return true;
+	}
+
+	return false;
+}
+
+static void sym_check_select(struct symbol *sym)
+{
+	struct property *prop;
+
+	for (prop = sym->prop; prop; prop = prop->next) {
+		if (prop->type != P_SELECT)
+			continue;
+
+		if (!sym_is_complex(prop->expr->left.sym))
+			continue;
+
+		fprintf(stderr, "%s:%d:error: found complex select: "
+			"%s -> %s\n",
+			sym->prop->file->name, sym->prop->lineno,
+			sym->name, prop->expr->left.sym->name);
+	}
+}
+
 /* return NULL when dependencies are OK */
 static struct symbol *sym_check_sym_deps(struct symbol *sym)
 {
@@ -864,6 +899,8 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	if (sym->flags & SYMBOL_CHECKED)
 		return NULL;
 
+	sym_check_select(sym);
+
 	if (sym_is_choice_value(sym)) {
 		/* for choice groups start the check with main choice symbol */
 		prop = sym_get_choice_prop(sym);
-- 
1.5.4.1

