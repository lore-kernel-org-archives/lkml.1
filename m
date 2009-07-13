Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZGMCtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZGMCtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZGMCtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:49:19 -0400
Received: from eta-ori.net ([91.121.142.51]:39415 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZGMCtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:49:19 -0400
Message-ID: <4A5AA0AD.2030502@impulze.org>
Date: Mon, 13 Jul 2009 04:49:17 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090628)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Re: Parsing kernel parameters and escaping "
References: <4A50B09B.9030901@impulze.org> <200907121911.58333.rusty@rustcorp.com.au> <4A5A248B.1070606@impulze.org> <200907130927.16203.rusty@rustcorp.com.au>
In-Reply-To: <200907130927.16203.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------070508060206050107080803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070508060206050107080803
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Rusty Russell wrote:
> It might be nice to have that test code somewhere at the bottom of param.c,
> at least while we're playing with the code.
Umm, I'm not sure where test-code is supposed to go in kernel code.
Should it be a main() function, a test() function, just a comment, could
you elaborate? All i did now was to build a small program that reads
argv[1] and uses next_arg just like parse_args() in params.c does.

> Well, IMO it's a maintainer's job to give feedback, and patches should always be welcomed (even if not applied!).
Ok, we'll see where this goes. So far I'm fine chatting about this with
everyone.

> I really prefer "i" instead of "iterator".  I actually think i as an
> unsigned/size_t here would probably make the code neater, but that's an aside.
Fixed.

> memmove?
Fixed.

> How about:
> 	if (strchr(delim, *iterator))
> 		return length;
I really should do more C. :-P Fixed.

> Note that this will undo another pending patch, which changes this to
> isspace() to handle tabs et al.
I will re-do the patch against that commit then once it's done.

> Thanks!
Ditto.


-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22

--------------070508060206050107080803
Content-Type: text/plain;
 name="kernel2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel2.patch"

>From 36d93d40b535ce7f1253d7740f214dc65b2975b9 Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Tue, 7 Jul 2009 00:54:38 +0200
Subject: [PATCH] Attempt to handle quotes in kernel parameters

There was a limitation for kernel parameters with regards to quoting. It
wasn't possible to escape quotes or use quotes to form space-filled
values _inside_ parameters. This patch attempts to make that possible,
kernel parameters are now parsed as follows:
'"param= value"' [param= value][]
'param=" value "" combination "' [param][ value  combination ]
'param=" \" test"' [param][ " test]
'"param"=another' [param][another]

Signed-off-by: Daniel Mierswa <impulze@impulze.org>
---
 kernel/params.c |  111 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 66 insertions(+), 45 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 7f6912c..5908623 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -72,58 +72,83 @@ static int parse_one(char *param,
 	return -ENOENT;
 }
 
-/* You can use " around spaces, but can't escape ". */
-/* Hyphens and underscores equivalent in parameter names. */
-static char *next_arg(char *args, char **param, char **val)
+/* modifies args with handled quotes
+ * [" foo bar "] => [ foo bar ]
+ * [" foo \" "]  => [ foo " ]
+ * [\"foo]       => [\"foo]
+ * [\"foo\" ]    => [\"foo" ]
+ */
+int printf(char const *,...);
+static size_t pull_token(char *args, char const *delim)
 {
-	unsigned int i, equals = 0;
-	int in_quote = 0, quoted = 0;
-	char *next;
-
-	if (*args == '"') {
-		args++;
-		in_quote = 1;
-		quoted = 1;
-	}
+	size_t i;
+	char *last_quote = NULL;
 
 	for (i = 0; args[i]; i++) {
-		if (args[i] == ' ' && !in_quote)
+		if (args[i] == '"') {
+			if (last_quote) {
+				size_t remain_len = strlen(args + i + 1);
+
+				/* remove both quotes by moving strings */
+				memmove(last_quote, last_quote + 1, args + i - 1 - last_quote);
+				memmove(args + i - 1, args + i + 1, remain_len + 1);
+
+				/* fill the blank we've left */
+				args[i + remain_len] = '\0';
+
+				/* removed 2 quotes, decrease the iterator  */
+				i -= 2;
+				last_quote = NULL;
+			} else {
+				last_quote = args + i;
+			}
+
+			continue;
+		}
+
+		if (last_quote) {
+			/* escaped quote */
+			if (args[i] == '\\' && args[i + 1] == '"') {
+				/* move all characters back */
+				memmove(args + i, args + i + 1, strlen(args + i + 1) + 1);
+			}
+
+			continue;
+		}
+
+		if (strchr(delim, args[i])) {
 			break;
-		if (equals == 0) {
-			if (args[i] == '=')
-				equals = i;
 		}
-		if (args[i] == '"')
-			in_quote = !in_quote;
 	}
 
+	return i;
+}
+
+static char *next_arg(char *args, char **param, char **val)
+{
+	size_t len;
+ 
+	/* Chew leading spaces */
+	while (*args == ' ')
+		args++;
+ 
+	len = pull_token(args, " \t\n=");
 	*param = args;
-	if (!equals)
+	args += len;
+
+	if (*args == '=') {
+		(*param)[len] = '\0';
+		args++;
+		len = pull_token(args, " \t\n");
+		*val = args;
+		args += len;
+		(*val)[len] = '\0';
+	} else {
+		(*param)[len] = '\0';
 		*val = NULL;
-	else {
-		args[equals] = '\0';
-		*val = args + equals + 1;
-
-		/* Don't include quotes in value. */
-		if (**val == '"') {
-			(*val)++;
-			if (args[i-1] == '"')
-				args[i-1] = '\0';
-		}
-		if (quoted && args[i-1] == '"')
-			args[i-1] = '\0';
 	}
 
-	if (args[i]) {
-		args[i] = '\0';
-		next = args + i + 1;
-	} else
-		next = args + i;
-
-	/* Chew up trailing spaces. */
-	while (*next == ' ')
-		next++;
-	return next;
+	return args + 1;
 }
 
 /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
@@ -137,10 +162,6 @@ int parse_args(const char *name,
 
 	DEBUGP("Parsing ARGS: %s\n", args);
 
-	/* Chew leading spaces */
-	while (*args == ' ')
-		args++;
-
 	while (*args) {
 		int ret;
 		int irq_was_disabled;
-- 
1.6.3.3


--------------070508060206050107080803--
