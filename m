Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZLAOrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZLAOrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZLAOrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:47:41 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:40320 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZLAOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:47:38 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Tony Finch <dot@dotat.at>
To: Michal Marek <mmarek@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>, Tony Finch <dot@dotat.at>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Date: Fri, 27 Nov 2009 15:50:30 +0000
Subject: [PATCHv2] unifdef: update to upstream revision 1.190
References: <4B151704.7020102@suse.cz>
    <20091127210408.GA16310@merkur.ravnborg.org>
    <E1NE3M6-0003Za-OJ@hermes-1.csi.cam.ac.uk>
    <20091127181749.GA16177@merkur.ravnborg.org>
    <alpine.LSU.2.00.0911271901430.6581@hermes-1.csi.cam.ac.uk>
Message-Id: <E1NFU0t-0002UG-0R@hermes-1.csi.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix handling of input files (e.g. with no newline at EOF) that could
make unifdef get into an unexpected state and call abort().

The new -B option compresses blank lines around a deleted section
so that blank lines around "paragraphs" of code don't get doubled.

The evaluator can now handle macros with arguments, and unbracketed
arguments to the "defined" operator.

Add myself to MAINTAINERS for unifdef.

Obtained-from: http://dotat.at/prog/unifdef/
Signed-off-by: Tony Finch <dot@dotat.at>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---

On Tue, 1 Dec 2009, Michal Marek wrote:
>
> I don't have the patch and I can't find it in the archives either. Could
> you please resend it?

Could it have been lost in moderation? I'm not directly subscribed to
any kernel lists... Anyway, here's a slightly updated version.

The only change between rev. 1.189 and 1.190 is to fix an out-of-bounds
array index that can occur just before unifdef bombs out because the
#if nesting level is too deep.

I've added Sam's ack. I hope this is correct etiquette...

Tony.

---
 MAINTAINERS       |    6 +
 scripts/unifdef.c |  343 ++++++++++++++++++++++++++++++++---------------------
 2 files changed, 214 insertions(+), 135 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c824b4d..7adda17 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5283,6 +5283,12 @@ F:	drivers/uwb/*
 F:	include/linux/uwb.h
 F:	include/linux/uwb/
 
+UNIFDEF
+M:	Tony Finch <dot@dotat.at>
+W:	http://dotat.at/prog/unifdef
+S:	Maintained
+F:	scripts/unifdef.c
+
 UNIFORM CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 W:	http://www.kernel.dk
diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 30d459f..44d3978 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -1,13 +1,5 @@
 /*
- * Copyright (c) 2002 - 2005 Tony Finch <dot@dotat.at>.  All rights reserved.
- *
- * This code is derived from software contributed to Berkeley by Dave Yost.
- * It was rewritten to support ANSI C by Tony Finch. The original version of
- * unifdef carried the following copyright notice. None of its code remains
- * in this version (though some of the names remain).
- *
- * Copyright (c) 1985, 1993
- *	The Regents of the University of California.  All rights reserved.
+ * Copyright (c) 2002 - 2009 Tony Finch <dot@dotat.at>
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -31,23 +23,20 @@
  * SUCH DAMAGE.
  */
 
-#include <sys/cdefs.h>
+/*
+ * This code was derived from software contributed to Berkeley by Dave Yost.
+ * It was rewritten to support ANSI C by Tony Finch. The original version
+ * of unifdef carried the 4-clause BSD copyright licence. None of its code
+ * remains in this version (though some of the names remain) so it now
+ * carries a more liberal licence.
+ *
+ * The latest version is available from http://dotat.at/prog/unifdef
+ */
 
-#ifndef lint
-#if 0
-static const char copyright[] =
-"@(#) Copyright (c) 1985, 1993\n\
-	The Regents of the University of California.  All rights reserved.\n";
-#endif
-#ifdef __IDSTRING
-__IDSTRING(Berkeley, "@(#)unifdef.c	8.1 (Berkeley) 6/6/93");
-__IDSTRING(NetBSD, "$NetBSD: unifdef.c,v 1.8 2000/07/03 02:51:36 matt Exp $");
-__IDSTRING(dotat, "$dotat: things/unifdef.c,v 1.171 2005/03/08 12:38:48 fanf2 Exp $");
-#endif
-#endif /* not lint */
-#ifdef __FBSDID
-__FBSDID("$FreeBSD: /repoman/r/ncvs/src/usr.bin/unifdef/unifdef.c,v 1.20 2005/05/21 09:55:09 ru Exp $");
-#endif
+static const char * const copyright[] = {
+    "@(#) Copyright (c) 2002 - 2009 Tony Finch <dot@dotat.at>\n",
+    "$dotat: unifdef/unifdef.c,v 1.190 2009/11/27 17:21:26 fanf2 Exp $",
+};
 
 /*
  * unifdef - remove ifdef'ed lines
@@ -72,8 +61,6 @@ __FBSDID("$FreeBSD: /repoman/r/ncvs/src/usr.bin/unifdef/unifdef.c,v 1.20 2005/05
 #include <string.h>
 #include <unistd.h>
 
-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 /* types of input lines: */
 typedef enum {
 	LT_TRUEI,		/* a true #if with ignore flag */
@@ -90,6 +77,7 @@ typedef enum {
 	LT_DODGY_LAST = LT_DODGY + LT_ENDIF,
 	LT_PLAIN,		/* ordinary line */
 	LT_EOF,			/* end of file */
+	LT_ERROR,		/* unevaluable #if */
 	LT_COUNT
 } Linetype;
 
@@ -100,7 +88,7 @@ static char const * const linetype_name[] = {
 	"DODGY IF", "DODGY TRUE", "DODGY FALSE",
 	"DODGY ELIF", "DODGY ELTRUE", "DODGY ELFALSE",
 	"DODGY ELSE", "DODGY ENDIF",
-	"PLAIN", "EOF"
+	"PLAIN", "EOF", "ERROR"
 };
 
 /* state of #if processing */
@@ -168,11 +156,13 @@ static char const * const linestate_name[] = {
  * Globals.
  */
 
+static bool             compblank;		/* -B: compress blank lines */
+static bool             lnblank;		/* -b: blank deleted lines */
 static bool             complement;		/* -c: do the complement */
 static bool             debugging;		/* -d: debugging reports */
 static bool             iocccok;		/* -e: fewer IOCCC errors */
+static bool             strictlogic;		/* -K: keep ambiguous #ifs */
 static bool             killconsts;		/* -k: eval constant #ifs */
-static bool             lnblank;		/* -l: blank deleted lines */
 static bool             lnnum;			/* -n: add #line directives */
 static bool             symlist;		/* -s: output symbol list */
 static bool             text;			/* -t: this is a text file */
@@ -196,7 +186,9 @@ static bool             ignoring[MAXDEPTH];	/* ignore comments state */
 static int              stifline[MAXDEPTH];	/* start of current #if */
 static int              depth;			/* current #if nesting */
 static int              delcount;		/* count of deleted lines */
-static bool             keepthis;		/* don't delete constant #if */
+static unsigned         blankcount;		/* count of blank lines */
+static unsigned         blankmax;		/* maximum recent blankcount */
+static bool             constexpr;		/* constant #if expression */
 
 static int              exitstat;		/* program exit status */
 
@@ -206,13 +198,14 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         get_line(void);
+static Linetype         parseline(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
 static void             keywordedit(const char *);
 static void             nest(void);
 static void             process(void);
+static const char      *skipargs(const char *);
 static const char      *skipcomment(const char *);
 static const char      *skipsym(const char *);
 static void             state(Ifstate);
@@ -220,7 +213,7 @@ static int              strlcmp(const char *, const char *, size_t);
 static void             unnest(void);
 static void             usage(void);
 
-#define endsym(c) (!isalpha((unsigned char)c) && !isdigit((unsigned char)c) && c != '_')
+#define endsym(c) (!isalnum((unsigned char)c) && c != '_')
 
 /*
  * The main program.
@@ -230,7 +223,7 @@ main(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "i:D:U:I:cdeklnst")) != -1)
+	while ((opt = getopt(argc, argv, "i:D:U:I:BbcdeKklnst")) != -1)
 		switch (opt) {
 		case 'i': /* treat stuff controlled by these symbols as text */
 			/*
@@ -255,6 +248,13 @@ main(int argc, char *argv[])
 		case 'I':
 			/* no-op for compatibility with cpp */
 			break;
+		case 'B': /* compress blank lines around removed section */
+			compblank = true;
+			break;
+		case 'b': /* blank deleted lines instead of omitting them */
+		case 'l': /* backwards compatibility */
+			lnblank = true;
+			break;
 		case 'c': /* treat -D as -U and vice versa */
 			complement = true;
 			break;
@@ -264,12 +264,12 @@ main(int argc, char *argv[])
 		case 'e': /* fewer errors from dodgy lines */
 			iocccok = true;
 			break;
+		case 'K': /* keep ambiguous #ifs */
+			strictlogic = true;
+			break;
 		case 'k': /* process constant #ifs */
 			killconsts = true;
 			break;
-		case 'l': /* blank deleted lines instead of omitting them */
-			lnblank = true;
-			break;
 		case 'n': /* add #line directive after deleted lines */
 			lnnum = true;
 			break;
@@ -284,6 +284,8 @@ main(int argc, char *argv[])
 		}
 	argc -= optind;
 	argv += optind;
+	if (compblank && lnblank)
+		errx(2, "-B and -b are mutually exclusive");
 	if (argc > 1) {
 		errx(2, "can only do one file");
 	} else if (argc == 1 && strcmp(*argv, "-") != 0) {
@@ -302,7 +304,7 @@ main(int argc, char *argv[])
 static void
 usage(void)
 {
-	fprintf(stderr, "usage: unifdef [-cdeklnst] [-Ipath]"
+	fprintf(stderr, "usage: unifdef [-BbcdeKknst] [-Ipath]"
 	    " [-Dsym[=val]] [-Usym] [-iDsym[=val]] [-iUsym] ... [file]\n");
 	exit(2);
 }
@@ -383,46 +385,46 @@ static state_fn * const trans_table[IS_COUNT][LT_COUNT] = {
 /* IS_OUTSIDE */
 { Itrue, Ifalse,Fpass, Ftrue, Ffalse,Eelif, Eelif, Eelif, Eelse, Eendif,
   Oiffy, Oiffy, Fpass, Oif,   Oif,   Eelif, Eelif, Eelif, Eelse, Eendif,
-  print, done },
+  print, done,  abort },
 /* IS_FALSE_PREFIX */
 { Idrop, Idrop, Fdrop, Fdrop, Fdrop, Mpass, Strue, Sfalse,Selse, Dendif,
   Idrop, Idrop, Fdrop, Fdrop, Fdrop, Mpass, Eioccc,Eioccc,Eioccc,Eioccc,
-  drop,  Eeof },
+  drop,  Eeof,  abort },
 /* IS_TRUE_PREFIX */
 { Itrue, Ifalse,Fpass, Ftrue, Ffalse,Dfalse,Dfalse,Dfalse,Delse, Dendif,
   Oiffy, Oiffy, Fpass, Oif,   Oif,   Eioccc,Eioccc,Eioccc,Eioccc,Eioccc,
-  print, Eeof },
+  print, Eeof,  abort },
 /* IS_PASS_MIDDLE */
 { Itrue, Ifalse,Fpass, Ftrue, Ffalse,Pelif, Mtrue, Delif, Pelse, Pendif,
   Oiffy, Oiffy, Fpass, Oif,   Oif,   Pelif, Oelif, Oelif, Pelse, Pendif,
-  print, Eeof },
+  print, Eeof,  abort },
 /* IS_FALSE_MIDDLE */
 { Idrop, Idrop, Fdrop, Fdrop, Fdrop, Pelif, Mtrue, Delif, Pelse, Pendif,
   Idrop, Idrop, Fdrop, Fdrop, Fdrop, Eioccc,Eioccc,Eioccc,Eioccc,Eioccc,
-  drop,  Eeof },
+  drop,  Eeof,  abort },
 /* IS_TRUE_MIDDLE */
 { Itrue, Ifalse,Fpass, Ftrue, Ffalse,Melif, Melif, Melif, Melse, Pendif,
   Oiffy, Oiffy, Fpass, Oif,   Oif,   Eioccc,Eioccc,Eioccc,Eioccc,Pendif,
-  print, Eeof },
+  print, Eeof,  abort },
 /* IS_PASS_ELSE */
 { Itrue, Ifalse,Fpass, Ftrue, Ffalse,Eelif, Eelif, Eelif, Eelse, Pendif,
   Oiffy, Oiffy, Fpass, Oif,   Oif,   Eelif, Eelif, Eelif, Eelse, Pendif,
-  print, Eeof },
+  print, Eeof,  abort },
 /* IS_FALSE_ELSE */
 { Idrop, Idrop, Fdrop, Fdrop, Fdrop, Eelif, Eelif, Eelif, Eelse, Dendif,
   Idrop, Idrop, Fdrop, Fdrop, Fdrop, Eelif, Eelif, Eelif, Eelse, Eioccc,
-  drop,  Eeof },
+  drop,  Eeof,  abort },
 /* IS_TRUE_ELSE */
 { Itrue, Ifalse,Fpass, Ftrue, Ffalse,Eelif, Eelif, Eelif, Eelse, Dendif,
   Oiffy, Oiffy, Fpass, Oif,   Oif,   Eelif, Eelif, Eelif, Eelse, Eioccc,
-  print, Eeof },
+  print, Eeof,  abort },
 /* IS_FALSE_TRAILER */
 { Idrop, Idrop, Fdrop, Fdrop, Fdrop, Dfalse,Dfalse,Dfalse,Delse, Dendif,
   Idrop, Idrop, Fdrop, Fdrop, Fdrop, Dfalse,Dfalse,Dfalse,Delse, Eioccc,
-  drop,  Eeof }
+  drop,  Eeof,  abort }
 /*TRUEI  FALSEI IF     TRUE   FALSE  ELIF   ELTRUE ELFALSE ELSE  ENDIF
   TRUEI  FALSEI IF     TRUE   FALSE  ELIF   ELTRUE ELFALSE ELSE  ENDIF (DODGY)
-  PLAIN  EOF */
+  PLAIN  EOF    ERROR */
 };
 
 /*
@@ -463,9 +465,11 @@ keywordedit(const char *replacement)
 static void
 nest(void)
 {
-	depth += 1;
-	if (depth >= MAXDEPTH)
+	if (depth > MAXDEPTH-1)
+		abort(); /* bug */
+	if (depth == MAXDEPTH-1)
 		error("Too many levels of nesting");
+	depth += 1;
 	stifline[depth] = linenum;
 }
 static void
@@ -490,15 +494,23 @@ flushline(bool keep)
 	if (symlist)
 		return;
 	if (keep ^ complement) {
-		if (lnnum && delcount > 0)
-			printf("#line %d\n", linenum);
-		fputs(tline, stdout);
-		delcount = 0;
+		bool blankline = tline[strspn(tline, " \t\n")] == '\0';
+		if (blankline && compblank && blankcount != blankmax) {
+			delcount += 1;
+			blankcount += 1;
+		} else {
+			if (lnnum && delcount > 0)
+				printf("#line %d\n", linenum);
+			fputs(tline, stdout);
+			delcount = 0;
+			blankmax = blankcount = blankline ? blankcount + 1 : 0;
+		}
 	} else {
 		if (lnblank)
 			putc('\n', stdout);
 		exitstat = 1;
 		delcount += 1;
+		blankcount = 0;
 	}
 }
 
@@ -510,9 +522,12 @@ process(void)
 {
 	Linetype lineval;
 
+	/* When compressing blank lines, act as if the file
+	   is preceded by a large number of blank lines. */
+	blankmax = blankcount = 1000;
 	for (;;) {
 		linenum++;
-		lineval = get_line();
+		lineval = parseline();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +541,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-get_line(void)
+parseline(void)
 {
 	const char *cp;
 	int cursym;
@@ -595,9 +610,21 @@ get_line(void)
 			if (incomment)
 				linestate = LS_DIRTY;
 		}
-		/* skipcomment should have changed the state */
-		if (linestate == LS_HASH)
-			abort(); /* bug */
+		/* skipcomment normally changes the state, except
+		   if the last line of the file lacks a newline, or
+		   if there is too much whitespace in a directive */
+		if (linestate == LS_HASH) {
+			size_t len = cp - tline;
+			if (fgets(tline + len, MAXLINE - len, input) == NULL) {
+				/* append the missing newline */
+				tline[len+0] = '\n';
+				tline[len+1] = '\0';
+				cp++;
+				linestate = LS_START;
+			} else {
+				linestate = LS_DIRTY;
+			}
+		}
 	}
 	if (linestate == LS_DIRTY) {
 		while (*cp != '\0')
@@ -610,17 +637,40 @@ get_line(void)
 
 /*
  * These are the binary operators that are supported by the expression
- * evaluator. Note that if support for division is added then we also
- * need short-circuiting booleans because of divide-by-zero.
+ * evaluator.
  */
-static int op_lt(int a, int b) { return (a < b); }
-static int op_gt(int a, int b) { return (a > b); }
-static int op_le(int a, int b) { return (a <= b); }
-static int op_ge(int a, int b) { return (a >= b); }
-static int op_eq(int a, int b) { return (a == b); }
-static int op_ne(int a, int b) { return (a != b); }
-static int op_or(int a, int b) { return (a || b); }
-static int op_and(int a, int b) { return (a && b); }
+static Linetype op_strict(int *p, int v, Linetype at, Linetype bt) {
+	if(at == LT_IF || bt == LT_IF) return (LT_IF);
+	return (*p = v, v ? LT_TRUE : LT_FALSE);
+}
+static Linetype op_lt(int *p, Linetype at, int a, Linetype bt, int b) {
+	return op_strict(p, a < b, at, bt);
+}
+static Linetype op_gt(int *p, Linetype at, int a, Linetype bt, int b) {
+	return op_strict(p, a > b, at, bt);
+}
+static Linetype op_le(int *p, Linetype at, int a, Linetype bt, int b) {
+	return op_strict(p, a <= b, at, bt);
+}
+static Linetype op_ge(int *p, Linetype at, int a, Linetype bt, int b) {
+	return op_strict(p, a >= b, at, bt);
+}
+static Linetype op_eq(int *p, Linetype at, int a, Linetype bt, int b) {
+	return op_strict(p, a == b, at, bt);
+}
+static Linetype op_ne(int *p, Linetype at, int a, Linetype bt, int b) {
+	return op_strict(p, a != b, at, bt);
+}
+static Linetype op_or(int *p, Linetype at, int a, Linetype bt, int b) {
+	if (!strictlogic && (at == LT_TRUE || bt == LT_TRUE))
+		return (*p = 1, LT_TRUE);
+	return op_strict(p, a || b, at, bt);
+}
+static Linetype op_and(int *p, Linetype at, int a, Linetype bt, int b) {
+	if (!strictlogic && (at == LT_FALSE || bt == LT_FALSE))
+		return (*p = 0, LT_FALSE);
+	return op_strict(p, a && b, at, bt);
+}
 
 /*
  * An evaluation function takes three arguments, as follows: (1) a pointer to
@@ -629,8 +679,8 @@ static int op_and(int a, int b) { return (a && b); }
  * value of the expression; and (3) a pointer to a char* that points to the
  * expression to be evaluated and that is updated to the end of the expression
  * when evaluation is complete. The function returns LT_FALSE if the value of
- * the expression is zero, LT_TRUE if it is non-zero, or LT_IF if the
- * expression could not be evaluated.
+ * the expression is zero, LT_TRUE if it is non-zero, LT_IF if the expression
+ * depends on an unknown symbol, or LT_ERROR if there is a parse failure.
  */
 struct ops;
 
@@ -649,7 +699,7 @@ static const struct ops {
 	eval_fn *inner;
 	struct op {
 		const char *str;
-		int (*fn)(int, int);
+		Linetype (*fn)(int *, Linetype, int, Linetype, int);
 	} op[5];
 } eval_ops[] = {
 	{ eval_table, { { "||", op_or } } },
@@ -664,8 +714,8 @@ static const struct ops {
 
 /*
  * Function for evaluating the innermost parts of expressions,
- * viz. !expr (expr) defined(symbol) symbol number
- * We reset the keepthis flag when we find a non-constant subexpression.
+ * viz. !expr (expr) number defined(symbol) symbol
+ * We reset the constexpr flag in the last two cases.
  */
 static Linetype
 eval_unary(const struct ops *ops, int *valp, const char **cpp)
@@ -673,68 +723,83 @@ eval_unary(const struct ops *ops, int *valp, const char **cpp)
 	const char *cp;
 	char *ep;
 	int sym;
+	bool defparen;
+	Linetype lt;
 
 	cp = skipcomment(*cpp);
 	if (*cp == '!') {
 		debug("eval%d !", ops - eval_ops);
 		cp++;
-		if (eval_unary(ops, valp, &cp) == LT_IF) {
-			*cpp = cp;
-			return (LT_IF);
+		lt = eval_unary(ops, valp, &cp);
+		if (lt == LT_ERROR)
+			return (LT_ERROR);
+		if (lt != LT_IF) {
+			*valp = !*valp;
+			lt = *valp ? LT_TRUE : LT_FALSE;
 		}
-		*valp = !*valp;
 	} else if (*cp == '(') {
 		cp++;
 		debug("eval%d (", ops - eval_ops);
-		if (eval_table(eval_ops, valp, &cp) == LT_IF)
-			return (LT_IF);
+		lt = eval_table(eval_ops, valp, &cp);
+		if (lt == LT_ERROR)
+			return (LT_ERROR);
 		cp = skipcomment(cp);
 		if (*cp++ != ')')
-			return (LT_IF);
+			return (LT_ERROR);
 	} else if (isdigit((unsigned char)*cp)) {
 		debug("eval%d number", ops - eval_ops);
 		*valp = strtol(cp, &ep, 0);
+		if (ep == cp)
+			return (LT_ERROR);
+		lt = *valp ? LT_TRUE : LT_FALSE;
 		cp = skipsym(cp);
 	} else if (strncmp(cp, "defined", 7) == 0 && endsym(cp[7])) {
 		cp = skipcomment(cp+7);
 		debug("eval%d defined", ops - eval_ops);
-		if (*cp++ != '(')
-			return (LT_IF);
-		cp = skipcomment(cp);
+		if (*cp == '(') {
+			cp = skipcomment(cp+1);
+			defparen = true;
+		} else {
+			defparen = false;
+		}
 		sym = findsym(cp);
-		cp = skipsym(cp);
-		cp = skipcomment(cp);
-		if (*cp++ != ')')
-			return (LT_IF);
-		if (sym >= 0)
+		if (sym < 0) {
+			lt = LT_IF;
+		} else {
 			*valp = (value[sym] != NULL);
-		else {
-			*cpp = cp;
-			return (LT_IF);
+			lt = *valp ? LT_TRUE : LT_FALSE;
 		}
-		keepthis = false;
+		cp = skipsym(cp);
+		cp = skipcomment(cp);
+		if (defparen && *cp++ != ')')
+			return (LT_ERROR);
+		constexpr = false;
 	} else if (!endsym(*cp)) {
 		debug("eval%d symbol", ops - eval_ops);
 		sym = findsym(cp);
-		if (sym < 0)
-			return (LT_IF);
-		if (value[sym] == NULL)
+		cp = skipsym(cp);
+		if (sym < 0) {
+			lt = LT_IF;
+			cp = skipargs(cp);
+		} else if (value[sym] == NULL) {
 			*valp = 0;
-		else {
+			lt = LT_FALSE;
+		} else {
 			*valp = strtol(value[sym], &ep, 0);
 			if (*ep != '\0' || ep == value[sym])
-				return (LT_IF);
+				return (LT_ERROR);
+			lt = *valp ? LT_TRUE : LT_FALSE;
+			cp = skipargs(cp);
 		}
-		cp = skipsym(cp);
-		keepthis = false;
+		constexpr = false;
 	} else {
 		debug("eval%d bad expr", ops - eval_ops);
-		return (LT_IF);
+		return (LT_ERROR);
 	}
 
 	*cpp = cp;
 	debug("eval%d = %d", ops - eval_ops, *valp);
-	return (*valp ? LT_TRUE : LT_FALSE);
+	return (lt);
 }
 
 /*
@@ -746,11 +811,13 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 	const struct op *op;
 	const char *cp;
 	int val;
-	Linetype lhs, rhs;
+	Linetype lt, rt;
 
 	debug("eval%d", ops - eval_ops);
 	cp = *cpp;
-	lhs = ops->inner(ops+1, valp, &cp);
+	lt = ops->inner(ops+1, valp, &cp);
+	if (lt == LT_ERROR)
+		return (LT_ERROR);
 	for (;;) {
 		cp = skipcomment(cp);
 		for (op = ops->op; op->str != NULL; op++)
@@ -760,32 +827,16 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 			break;
 		cp += strlen(op->str);
 		debug("eval%d %s", ops - eval_ops, op->str);
-		rhs = ops->inner(ops+1, &val, &cp);
-		if (op->fn == op_and && (lhs == LT_FALSE || rhs == LT_FALSE)) {
-			debug("eval%d: and always false", ops - eval_ops);
-			if (lhs == LT_IF)
-				*valp = val;
-			lhs = LT_FALSE;
-			continue;
-		}
-		if (op->fn == op_or && (lhs == LT_TRUE || rhs == LT_TRUE)) {
-			debug("eval%d: or always true", ops - eval_ops);
-			if (lhs == LT_IF)
-				*valp = val;
-			lhs = LT_TRUE;
-			continue;
-		}
-		if (rhs == LT_IF)
-			lhs = LT_IF;
-		if (lhs != LT_IF)
-			*valp = op->fn(*valp, val);
+		rt = ops->inner(ops+1, &val, &cp);
+		if (rt == LT_ERROR)
+			return (LT_ERROR);
+		lt = op->fn(valp, lt, *valp, rt, val);
 	}
 
 	*cpp = cp;
 	debug("eval%d = %d", ops - eval_ops, *valp);
-	if (lhs != LT_IF)
-		lhs = (*valp ? LT_TRUE : LT_FALSE);
-	return lhs;
+	debug("eval%d lt = %s", ops - eval_ops, linetype_name[lt]);
+	return (lt);
 }
 
 /*
@@ -796,17 +847,14 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 static Linetype
 ifeval(const char **cpp)
 {
-	const char *cp = *cpp;
 	int ret;
-	int val;
+	int val = 0;
 
 	debug("eval %s", *cpp);
-	keepthis = killconsts ? false : true;
-	ret = eval_table(eval_ops, &val, &cp);
-	if (ret != LT_IF)
-		*cpp = cp;
+	constexpr = killconsts ? false : true;
+	ret = eval_table(eval_ops, &val, cpp);
 	debug("eval = %d", val);
-	return (keepthis ? LT_IF : ret);
+	return (constexpr ? LT_IF : ret == LT_ERROR ? LT_IF : ret);
 }
 
 /*
@@ -918,6 +966,31 @@ skipcomment(const char *cp)
 }
 
 /*
+ * Skip macro arguments.
+ */
+static const char *
+skipargs(const char *cp)
+{
+	const char *ocp = cp;
+	int level = 0;
+	cp = skipcomment(cp);
+	if (*cp != '(')
+		return (cp);
+	do {
+		if (*cp == '(')
+			level++;
+		if (*cp == ')')
+			level--;
+		cp = skipcomment(cp+1);
+	} while (level != 0 && *cp != '\0');
+	if (level == 0)
+		return (cp);
+	else
+	/* Rewind and re-detect the syntax error later. */
+		return (ocp);
+}
+
+/*
  * Skip over an identifier.
  */
 static const char *
@@ -929,7 +1002,7 @@ skipsym(const char *cp)
 }
 
 /*
- * Look for the symbol in the symbol table. If is is found, we return
+ * Look for the symbol in the symbol table. If it is found, we return
  * the symbol table index, else we return -1.
  */
 static int
-- 
1.6.0.1

