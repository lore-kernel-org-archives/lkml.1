Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbXERG4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbXERG4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbXERG4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:56:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53825 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbXERG43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:56:29 -0400
Date: Fri, 18 May 2007 08:57:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Sylvain Munaut <tnt@246tNt.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 10/14] powerpc: Fix the MODALIAS generation in modpost for of devices
Message-ID: <20070518065711.GJ12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 61f24a916b640ae1ac5f7bc783d3bb4d7d833c00 Mon Sep 17 00:00:00 2001
From: Sylvain Munaut <tnt@246tNt.com>
Date: Tue, 8 May 2007 19:59:29 +1000
Subject: [PATCH 10/14] powerpc: Fix the MODALIAS generation in modpost for of devices

Since the devices may have multiple (or none) compatible properties,
the uevent generated internally by the kernel may have multiple
"C..." entries. So the MODALIAS stored in the module must have
wilcard before and after the compatible entry.
Also, if the 'compatible' field is not used for matching, there
will be no 'C' and that must handled as well.

The previous code handled all those case incorrectly and it
"mostly" worked ... but not always.

Signed-off-by: Sylvain Munaut <tnt@246tNt.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/file2alias.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index ed1244d..f646381 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -353,11 +353,16 @@ static int do_pcmcia_entry(const char *filename,
 
 static int do_of_entry (const char *filename, struct of_device_id *of, char *alias)
 {
+    int len;
     char *tmp;
-    sprintf (alias, "of:N%sT%sC%s",
+    len = sprintf (alias, "of:N%sT%s",
                     of->name[0] ? of->name : "*",
-                    of->type[0] ? of->type : "*",
-                    of->compatible[0] ? of->compatible : "*");
+                    of->type[0] ? of->type : "*");
+
+    if (of->compatible[0])
+        sprintf (&alias[len], "%sC%s",
+                     of->type[0] ? "*" : "",
+                     of->compatible);
 
     /* Replace all whitespace with underscores */
     for (tmp = alias; tmp && *tmp; tmp++)
-- 
1.5.1.rc3.20.gaa453

