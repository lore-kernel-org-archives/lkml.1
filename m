Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZGLR7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZGLR7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 13:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZGLR7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 13:59:44 -0400
Received: from eta-ori.net ([91.121.142.51]:59712 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZGLR7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 13:59:44 -0400
Message-ID: <4A5A248B.1070606@impulze.org>
Date: Sun, 12 Jul 2009 19:59:39 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090628)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Re: Parsing kernel parameters and escaping "
References: <4A50B09B.9030901@impulze.org> <4A5282B4.8070302@impulze.org> <4A529CBA.4030408@impulze.org> <200907121911.58333.rusty@rustcorp.com.au>
In-Reply-To: <200907121911.58333.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050008090408070104050009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050008090408070104050009
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Rusty Russell wrote:
>    Yes, we've never had the ability to escape quotes (and you're the first to
> ask), so when I wrote this code I kept it simple.  You can have spaced out
> values, but you need to quote the whole thing "param=some value with spaces".
True, but that would leave quotes where they are instead of removing them.

>    We have to be careful not to break existing cmdlines tho: I don't know
> if anyone uses \ currently, but simply interpreting \" is probably safe.
Yes, the only way that compatibility seems to break is that now \" in a quoted
string is replaced by a single ".

> add_token is a weird name for this.  It actually mangles the argument, and it
> really should return the char *.
Fixed.

> How about something like:
> 	static unsigned int pull_token(char *args, const char *delim)
Fixed.

> Which unescapes and returns the length of the token, or zero if it simply
> swallowed delimeters?  Assuming it always nul terminates, then the caller can
> simply do:
> [...]
Fixed.

> Important cases to test are:
> 	x			param = "x", val = NULL
> 	x=			param = "x", val = ""
> 	x=y=1		param = "x", val = "y=1"
> 
> Plus all variations where x and y contain quotes.
Tested:

|param| => [param[(none)]]
|param=| => [param[]]
|param=value| => [param[value]]
|param=value=withequal | => [param[value=withequal]]
|param="value with spaces" | => [param[value with spaces]]
|param="value with spaces and quotes \"" | => [param[value with spaces and quotes "]]
|param=\"foo\" | => [param[\"foo" ]]
|"param = value" | => [param = value[(none)]]

> Cheers,
> Rusty.

Thanks for your kind feedback, I'm willing to put more effort into this when needed. I really
first wanted to check if patches for this are welcomed.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22

--------------050008090408070104050009
Content-Type: text/plain;
 name="kernel2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel2.patch"

>From 21402346a295eb539a111b777ee54f3dd5263b6f Mon Sep 17 00:00:00 2001
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
 kernel/params.c |  128 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 82 insertions(+), 46 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 7f6912c..5f9709d 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -72,58 +72,98 @@ static int parse_one(char *param,
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
+static size_t pull_token(char *args, char const *delim)
 {
-	unsigned int i, equals = 0;
-	int in_quote = 0, quoted = 0;
-	char *next;
+	size_t length = 0;
+	char *iterator = NULL, *last_quote = NULL;
+
+	for (iterator = args; *iterator; iterator++, length++) {
+		if (*iterator == '"') {
+			if (last_quote) {
+				char *mover = last_quote;
+
+				/* move whole string back until current " is reached */
+				while (mover != iterator - 1) {
+					*mover = *(mover + 1);
+					mover++;
+				}
+
+				/* ignore the current " and move the rest of the string back */
+				while (*mover) {
+					*mover = *(mover + 2);
+					mover++;
+				}
+
+				/* ignored 2 quotes, decrease the iterator and length */
+				length -= 2;
+				iterator -= 2;
+				last_quote = NULL;
+			} else {
+				last_quote = iterator;
+			}
 
-	if (*args == '"') {
-		args++;
-		in_quote = 1;
-		quoted = 1;
-	}
+			continue;
+		}
 
-	for (i = 0; args[i]; i++) {
-		if (args[i] == ' ' && !in_quote)
-			break;
-		if (equals == 0) {
-			if (args[i] == '=')
-				equals = i;
+		if (last_quote) {
+			/* escaped quote */
+			if (*iterator == '\\' && *(iterator + 1) == '"') {
+				char *mover = NULL;
+
+				/* move all characters back */
+				for (mover = iterator; *mover; mover++) {
+					*mover = *(mover + 1);
+				}
+			}
+
+			continue;
+		}
+
+		{
+			/* check for delimiter */
+			char const *delim_iterator = NULL;
+			for (delim_iterator = delim; *delim_iterator; delim_iterator++) {
+				if (*iterator == *delim_iterator) {
+					return length;
+				}
+			}
 		}
-		if (args[i] == '"')
-			in_quote = !in_quote;
 	}
 
+	return length;
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
@@ -137,10 +177,6 @@ int parse_args(const char *name,
 
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


--------------050008090408070104050009--
