Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZFFVsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZFFVsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZFFVsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:48:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59766 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZFFVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:48:01 -0400
Date: Sat, 6 Jun 2009 22:47:11 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] headers_check fixes
Message-ID: <20090606214711.GA4813@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244292857.2473.4.camel@ht.satnam> <20090606130210.GA9343@flint.arm.linux.org.uk> <1244299177.2473.21.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244299177.2473.21.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, below is a patch to unifdef.c which allows it to work out if
an #if expression always evaluates true or false for symbols which
are being undefined/always defined.

The patch is slightly more complicated than I'd hoped because unifdef
needs to see lines fully evaluated - doing otherwise causes it to
mark the line as "dirty" and copy it over no matter what.

What follows this email is the diff of what effect it has on the
headers copied over - as can be seen, all resulting changes are of
net benefit.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 05a31a6..30d459f 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -678,8 +678,10 @@ eval_unary(const struct ops *ops, int *valp, const char **cpp)
 	if (*cp == '!') {
 		debug("eval%d !", ops - eval_ops);
 		cp++;
-		if (eval_unary(ops, valp, &cp) == LT_IF)
+		if (eval_unary(ops, valp, &cp) == LT_IF) {
+			*cpp = cp;
 			return (LT_IF);
+		}
 		*valp = !*valp;
 	} else if (*cp == '(') {
 		cp++;
@@ -700,13 +702,16 @@ eval_unary(const struct ops *ops, int *valp, const char **cpp)
 			return (LT_IF);
 		cp = skipcomment(cp);
 		sym = findsym(cp);
-		if (sym < 0)
-			return (LT_IF);
-		*valp = (value[sym] != NULL);
 		cp = skipsym(cp);
 		cp = skipcomment(cp);
 		if (*cp++ != ')')
 			return (LT_IF);
+		if (sym >= 0)
+			*valp = (value[sym] != NULL);
+		else {
+			*cpp = cp;
+			return (LT_IF);
+		}
 		keepthis = false;
 	} else if (!endsym(*cp)) {
 		debug("eval%d symbol", ops - eval_ops);
@@ -741,11 +746,11 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 	const struct op *op;
 	const char *cp;
 	int val;
+	Linetype lhs, rhs;
 
 	debug("eval%d", ops - eval_ops);
 	cp = *cpp;
-	if (ops->inner(ops+1, valp, &cp) == LT_IF)
-		return (LT_IF);
+	lhs = ops->inner(ops+1, valp, &cp);
 	for (;;) {
 		cp = skipcomment(cp);
 		for (op = ops->op; op->str != NULL; op++)
@@ -755,14 +760,32 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 			break;
 		cp += strlen(op->str);
 		debug("eval%d %s", ops - eval_ops, op->str);
-		if (ops->inner(ops+1, &val, &cp) == LT_IF)
-			return (LT_IF);
-		*valp = op->fn(*valp, val);
+		rhs = ops->inner(ops+1, &val, &cp);
+		if (op->fn == op_and && (lhs == LT_FALSE || rhs == LT_FALSE)) {
+			debug("eval%d: and always false", ops - eval_ops);
+			if (lhs == LT_IF)
+				*valp = val;
+			lhs = LT_FALSE;
+			continue;
+		}
+		if (op->fn == op_or && (lhs == LT_TRUE || rhs == LT_TRUE)) {
+			debug("eval%d: or always true", ops - eval_ops);
+			if (lhs == LT_IF)
+				*valp = val;
+			lhs = LT_TRUE;
+			continue;
+		}
+		if (rhs == LT_IF)
+			lhs = LT_IF;
+		if (lhs != LT_IF)
+			*valp = op->fn(*valp, val);
 	}
 
 	*cpp = cp;
 	debug("eval%d = %d", ops - eval_ops, *valp);
-	return (*valp ? LT_TRUE : LT_FALSE);
+	if (lhs != LT_IF)
+		lhs = (*valp ? LT_TRUE : LT_FALSE);
+	return lhs;
 }
 
 /*
@@ -773,12 +796,15 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 static Linetype
 ifeval(const char **cpp)
 {
+	const char *cp = *cpp;
 	int ret;
 	int val;
 
 	debug("eval %s", *cpp);
 	keepthis = killconsts ? false : true;
-	ret = eval_table(eval_ops, &val, cpp);
+	ret = eval_table(eval_ops, &val, &cp);
+	if (ret != LT_IF)
+		*cpp = cp;
 	debug("eval = %d", val);
 	return (keepthis ? LT_IF : ret);
 }

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
