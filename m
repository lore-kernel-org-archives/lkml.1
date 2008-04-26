Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYDZMLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYDZMLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 08:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYDZMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 08:11:09 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39043 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYDZMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 08:11:04 -0400
Date: Sat, 26 Apr 2008 08:10:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] LIB: Allow memparse() to accept a NULL and ignorable second
 parm.
Message-ID: <alpine.LFD.1.10.0804260806480.13845@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Extend memparse() to allow the caller to use a NULL second parameter,
which would represent no interest in returning the address of the end
of the parsed string.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  in numerous cases, callers invoke memparse() to parse a
possibly-suffixed string (such as "64K" or "2G" or whatever) and
define a character pointer to accept the end pointer being returned by
memparse() even though they have no interest in it and promptly throw
it away.

  this (backward-compatible) enhancement allows callers to use NULL in
the cases where they just don't care about getting back that end
pointer.

  compile-tested on x86.

diff --git a/lib/cmdline.c b/lib/cmdline.c
index f596c08..34129cf 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -116,7 +116,7 @@ char *get_options(const char *str, int nints, int *ints)
 /**
  *	memparse - parse a string with mem suffixes into a number
  *	@ptr: Where parse begins
- *	@retptr: (output) Pointer to next char after parse completes
+ *	@retptr: (output) Optional pointer to next char after parse completes
  *
  *	Parses a string into a number.  The number stored at @ptr is
  *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
@@ -128,9 +128,11 @@ char *get_options(const char *str, int nints, int *ints)

 unsigned long long memparse (char *ptr, char **retptr)
 {
-	unsigned long long ret = simple_strtoull (ptr, retptr, 0);
+	char *endptr;	/* local pointer to end of parsed string */

-	switch (**retptr) {
+	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
+
+	switch (*endptr) {
 	case 'G':
 	case 'g':
 		ret <<= 10;
@@ -140,10 +142,15 @@ unsigned long long memparse (char *ptr, char **retptr)
 	case 'K':
 	case 'k':
 		ret <<= 10;
-		(*retptr)++;
+		endptr++;
 	default:
 		break;
 	}
+
+	if (retptr) {
+		*retptr = endptr;
+	}
+
 	return ret;
 }

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
