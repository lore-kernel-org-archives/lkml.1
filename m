Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0BMAxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 19:53:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab0BMAxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 19:53:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=RPKW_zuRCcMA:10 a=7U3hwN5JcxgA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=XNxWABbOhPGsRS-9MaAA:9 a=Nt8p6-wguHoR_uGm_lAA:7 a=ilu5rM7_9ethdgvsbdy3i_M4AhAA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][trace-cmd] parse-events: Make input buffer const char *
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Feb 2010 19:53:04 -0500
Message-ID: <1266022384.24271.106.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johill,

I just wanted you to see a recent change I made. It touches your work
around you added for the older kernels that did not convert your macro
to a string. I'm sending this to you to make sure that it still works
for your liking.

Also, I think I see a bug in the original code (and I kept) where you
added a \ to %s. Perhaps its not a bug, but is it really needed? We
don't process this code through any printf formatting.

-- Steve


commit 4314457fc4de51b5ef5cc2df35f4d669299ae2b8
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Feb 12 19:45:22 2010 -0500

    parse-events: Make input buffer const char *
    
    Make the input buffer that the parse events reads into a const char *.
    This will be needed by later patches to make sure the input buffer
    does not get modified.
    
    In doing this change, the work around by Johannes Berg needed to
    be rewritten, since the push_str modified the input buffer.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/parse-events.c b/parse-events.c
index 7b3b440..c5e8080 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -30,11 +30,11 @@
 
 #include "parse-events.h"
 
-static char *input_buf;
+static const char *input_buf;
 static unsigned long long input_buf_ptr;
 static unsigned long long input_buf_siz;
 
-static void init_input_buf(char *buf, unsigned long long size)
+static void init_input_buf(const char *buf, unsigned long long size)
 {
 	input_buf = buf;
 	input_buf_siz = size;
@@ -657,26 +657,6 @@ static enum event_type get_type(int ch)
 	return EVENT_OP;
 }
 
-static void __push_char(char c)
-{
-	if (input_buf_ptr <= 0)
-		die("too much pushback");
-	input_buf[--input_buf_ptr] = c;
-}
-
-static void __push_str(char *s)
-{
-	char *e = s;
-
-	while (*e++)
-		/* nothing */;
-	e--;
-	while (s != e) {
-		e--;
-		__push_char(*e);
-	}
-}
-
 static int __read_char(void)
 {
 	if (input_buf_ptr >= input_buf_siz)
@@ -693,6 +673,8 @@ static int __peek_char(void)
 	return input_buf[input_buf_ptr];
 }
 
+static enum event_type force_token(const char *str, char **tok);
+
 static enum event_type __read_token(char **tok)
 {
 	char buf[BUFSIZ];
@@ -848,24 +830,45 @@ static enum event_type __read_token(char **tok)
 		if (strcmp(*tok, "LOCAL_PR_FMT") == 0) {
 			free(*tok);
 			*tok = NULL;
-			__push_str("\"\%s\" ");
-			return __read_token(tok);
+			return force_token("\"\%s\" ", tok);
 		} else if (strcmp(*tok, "STA_PR_FMT") == 0) {
 			free(*tok);
 			*tok = NULL;
-			__push_str("\" sta:%pM\" ");
-			return __read_token(tok);
+			return force_token("\" sta:%pM\" ", tok);
 		} else if (strcmp(*tok, "VIF_PR_FMT") == 0) {
 			free(*tok);
 			*tok = NULL;
-			__push_str("\" vif:%p(%d)\" ");
-			return __read_token(tok);
+			return force_token("\" vif:%p(%d)\" ", tok);
 		}
 	}
 
 	return type;
 }
 
+static enum event_type force_token(const char *str, char **tok)
+{
+	const char *save_input_buf;
+	unsigned long long save_input_buf_ptr;
+	unsigned long long save_input_buf_siz;
+	enum event_type type;
+	
+	/* save off the current input pointers */
+	save_input_buf = input_buf;
+	save_input_buf_ptr = input_buf_ptr;
+	save_input_buf_siz = input_buf_siz;
+
+	init_input_buf(str, strlen(str));
+
+	type = __read_token(tok);
+
+	/* reset back to original token */
+	input_buf = save_input_buf;
+	input_buf_ptr = save_input_buf_ptr;
+	input_buf_siz = save_input_buf_siz;
+
+	return type;
+}
+
 static void free_token(char *tok)
 {
 	if (tok)


