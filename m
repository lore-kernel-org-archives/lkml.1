Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXLSUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXLSUBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXLSUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:01:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:42609 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbXLSUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:01:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:mime-version:x-mailer:content-transfer-encoding:sender:message-id;
        b=r/jUhsP4D1khM3HcmfCfdGHtaauHGVN6j5+P1ZfeoeVfjHz9JZGSeFl00r4TvaGuBIzoiPrvpvGWzayqXJcX2iiOk3f28skwFvKq46uebJQsaew+QbVjh2Lrpne2CTOHBheWplIJYc/ujimABMwDsI9HwvUhY5Az82FNkpjutD8=
References: <20071219194551.315868746@bohmer.net>>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 20:45:52 +0100
From: Remy Bohmer <linux@bohmer.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Juergen Beisert <jbe@pengutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, Remy Bohmer <linux@bohmer.net>
Subject: [patch 1/3] Add generic routine for parsing map-like options on
	kernel cmd-line (repost:CC to LKML)
Content-Disposition: inline; filename=add-map-functionality-to-kernel-cmdline.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Message-ID: <4769787e.01b4420a.2b28.ffff88cf@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a generic routine to the kernel, so that a map of
settings can be entered on the kernel commandline.

Signed-off-by: Remy Bohmer <linux@bohmer.net>

---
---
 include/linux/kernel.h |    1 
 lib/cmdline.c          |   58 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

Index: linux-2.6.24-rc5-rt1/include/linux/kernel.h
===================================================================
--- linux-2.6.24-rc5-rt1.orig/include/linux/kernel.h	2007-12-18 21:32:09.000000000 +0100
+++ linux-2.6.24-rc5-rt1/include/linux/kernel.h	2007-12-18 21:33:58.000000000 +0100
@@ -164,6 +164,7 @@ extern int vsscanf(const char *, const c
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
+extern int get_map_option(const char *str, const char *key, int *pint);
 extern unsigned long long memparse(char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
Index: linux-2.6.24-rc5-rt1/lib/cmdline.c
===================================================================
--- linux-2.6.24-rc5-rt1.orig/lib/cmdline.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.24-rc5-rt1/lib/cmdline.c	2007-12-18 21:33:58.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <asm/setup.h>
 
 /*
  *	If a hyphen was found in get_option, this will handle the
@@ -114,6 +115,63 @@ char *get_options(const char *str, int n
 }
 
 /**
+ *	get_map_option - Parse integer from an option map
+ *
+ *	This function parses an integer from an option map like
+ *           some_map=key1:99,key2:98,...,keyN:NN,NN
+ *	Only the value of the first match is returned, or if no
+ *	key option is given (key = NULL) the value of the first
+ *	field without a ':' is returned.
+ *
+ *	@str: option string
+ *	@key: The key inside the map, can be NULL
+ *	@pint: (output) integer value parsed from the map @str
+ *
+ *	Return values:
+ *	0 - no int in string
+ *	1 - int found
+ */
+int get_map_option(const char *str, const char *key, int *pint)
+{
+	char  buf[COMMAND_LINE_SIZE];
+	char  *p, *substr;
+	int   found = 0;
+
+	/* We must copy the string to the stack, because strsep()
+	   changes it.*/
+	strncpy(buf, str, COMMAND_LINE_SIZE);
+	buf[COMMAND_LINE_SIZE-1] = '\0';
+
+	p = buf;
+	substr = strsep(&p, ",");
+	while ((!found) && (substr != NULL)) {
+		if (strlen(substr) != 0) {
+			if (key == NULL) {
+				/* Check for the absence of any ':' */
+				if (strchr(substr, ':') == NULL) {
+					sscanf(substr, "%d", pint);
+					found = 1;
+				}
+			} else {
+				/* check if the first part of the key matches */
+				if (!strncmp(substr, key, strlen(key))) {
+					substr += strlen(key);
+					/* Now the next char must be a ':',
+					   if not, search for the next match */
+					if (*substr == ':') {
+						substr++;
+						sscanf(substr, "%d", pint);
+						found = 1;
+					}
+				}
+			}
+		}
+		substr = strsep(&p, ",");
+	}
+	return found;
+}
+
+/**
  *	memparse - parse a string with mem suffixes into a number
  *	@ptr: Where parse begins
  *	@retptr: (output) Pointer to next char after parse completes

-- 

