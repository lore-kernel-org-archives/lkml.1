Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYJGS20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYJGS20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYJGS2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:28:18 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:16199 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYJGS2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:28:17 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Prevent modpost from looking for a .cmd file for a static library linked into a module
Date: Tue, 7 Oct 2008 11:26:15 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334038D52CF@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Prevent modpost from looking for a .cmd file for a static library linked into a module
Thread-Index: Ackoqi6xfwiJBK4/QFW98B75MrAXOw==
From: "Ashutosh Naik" <ashutosh@chelsio.com>
To: <linux-kernel@vger.kernel.org>, <stable@kernel.org>, <akpm@osdl.org>,
       <rusty@rustcorp.com.au>, "Karen Xie" <kxie@chelsio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch prevents modpost to look for a .cmd file when a module is
linked with a static library

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

diff -ruN linux-2.6.26.5/scripts/mod/sumversion.c
linux-2.6.26.5-mod/scripts/mod/sumversion.c
--- linux-2.6.26.5/scripts/mod/sumversion.c	2008-09-08
10:40:20.000000000 -0700
+++ linux-2.6.26.5-mod/scripts/mod/sumversion.c	2008-10-07
09:32:24.000000000 -0700
@@ -290,6 +290,15 @@
 	release_file(file, len);
 	return 1;
 }
+/* Check whether the file is a static library or not */
+static int is_static_library(const char *objfile)
+{
+	int len = strlen(objfile);
+	if((objfile[len -2]=='.') && (objfile[len - 1]=='a'))
+		return 1;
+	else
+		return 0;	
+}
 
 /* We have dir/file.o.  Open dir/.file.o.cmd, look for deps_ line to
  * figure out source file. */
@@ -420,7 +429,7 @@
 	while ((fname = strsep(&sources, " ")) != NULL) {
 		if (!*fname)
 			continue;
-		if (!parse_source_files(fname, &md))
+		if (!(is_static_library(fname)) &&
!parse_source_files(fname, &md))
 			goto release;
 	}
