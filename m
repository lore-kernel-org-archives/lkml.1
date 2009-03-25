Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbZCYAvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbZCYAvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbZCYAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:50 -0400
Received: from kroah.org ([198.145.64.141]:54224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756934AbZCYAaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Banks <gnb@melbourne.sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/61] Dynamic debug: allow simple quoting of words
Date: Tue, 24 Mar 2009 17:27:04 -0700
Message-Id: <1237940825-22904-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Banks <gnb@melbourne.sgi.com>

Allow simple quoting of words in the dynamic debug control language.

This allows more natural specification when using the control language
to match against printk formats, e.g

#echo -n 'format "Setting node for non-present cpu" +p' >
	/mnt/debugfs/dynamic_debug/control

instead of

#echo -n 'format Setting\040node\040for\040non-present\040cpu +p' >
	/mnt/debugfs/dynamic_debug/control

Adjust the dynamic debug documention to describe that and provide a
new example.  Adjust the existing examples in the documentation to
reflect the current whitespace escaping behaviour when reading the
control file.  Fix some minor documentation trailing whitespace.

Signed-off-by: Greg Banks <gnb@melbourne.sgi.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/dynamic-debug-howto.txt |   20 +++++++++----
 lib/dynamic_debug.c                   |   53 ++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 6839482..674c566 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -49,10 +49,10 @@ via:
 
 nullarbor:~ # cat <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA\040Module\040Removed,\040deregister\040RPC\040RDMA\040transport\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline\040\040\040\040\040\040\040:\040%d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth\040\040\040\040\040\040\040\040\040:\040%d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests\040\040\040\040\040:\040%d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline       : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth         : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests     : %d\012"
 ...
 
 
@@ -72,7 +72,7 @@ you can view all the debug statement callsites with any non-default flags:
 
 nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process:\040st_sendto\040returned\040%d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
 
 
 Command Language Reference
@@ -166,11 +166,15 @@ format
     entire format, only some part.  Whitespace and other
     special characters can be escaped using C octal character
     escape \ooo notation, e.g. the space character is \040.
+    Alternatively, the string can be enclosed in double quote
+    characters (") or single quote characters (').
     Examples:
 
     format svcrdma:	    // many of the NFS/RDMA server dprintks
     format readahead	    // some dprintks in the readahead cache
-    format nfsd:\040SETATTR // how to match a format with whitespace
+    format nfsd:\040SETATTR // one way to match a format with whitespace
+    format "nfsd: SETATTR"  // a neater way to match a format with whitespace
+    format 'nfsd: SETATTR'  // yet another way to match a format with whitespace
 
 line
     The given line number or range of line numbers is compared
@@ -230,3 +234,7 @@ nullarbor:~ # echo -n 'func svc_process +p' >
 // disable all 12 messages in the function svc_process()
 nullarbor:~ # echo -n 'func svc_process -p' >
 				<debugfs>/dynamic_debug/control
+
+// enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
+nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
+				<debugfs>/dynamic_debug/control
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 9e123ae..833139c 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -196,32 +196,45 @@ static void ddebug_change(const struct ddebug_query *query,
 }
 
 /*
- * Wrapper around strsep() to collapse the multiple empty tokens
- * that it returns when fed sequences of separator characters.
- * Now, if we had strtok_r()...
- */
-static inline char *nearly_strtok_r(char **p, const char *sep)
-{
-	char *r;
-
-	while ((r = strsep(p, sep)) != NULL && *r == '\0')
-		;
-	return r;
-}
-
-/*
  * Split the buffer `buf' into space-separated words.
- * Return the number of such words or <0 on error.
+ * Handles simple " and ' quoting, i.e. without nested,
+ * embedded or escaped \".  Return the number of words
+ * or <0 on error.
  */
 static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 {
 	int nwords = 0;
 
-	while (nwords < maxwords &&
-	       (words[nwords] = nearly_strtok_r(&buf, " \t\r\n")) != NULL)
-		nwords++;
-	if (buf)
-		return -EINVAL;	/* ran out of words[] before bytes */
+	while (*buf) {
+		char *end;
+
+		/* Skip leading whitespace */
+		while (*buf && isspace(*buf))
+			buf++;
+		if (!*buf)
+			break;	/* oh, it was trailing whitespace */
+
+		/* Run `end' over a word, either whitespace separated or quoted */
+		if (*buf == '"' || *buf == '\'') {
+			int quote = *buf++;
+			for (end = buf ; *end && *end != quote ; end++)
+				;
+			if (!*end)
+				return -EINVAL;	/* unclosed quote */
+		} else {
+			for (end = buf ; *end && !isspace(*end) ; end++)
+				;
+			BUG_ON(end == buf);
+		}
+		/* Here `buf' is the start of the word, `end' is one past the end */
+
+		if (nwords == maxwords)
+			return -EINVAL;	/* ran out of words[] before bytes */
+		if (*end)
+			*end++ = '\0';	/* terminate the word */
+		words[nwords++] = buf;
+		buf = end;
+	}
 
 	if (verbose) {
 		int i;
-- 
1.6.2

