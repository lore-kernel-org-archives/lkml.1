Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbYBFRr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbYBFRr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbYBFRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:46:32 -0500
Received: from [198.99.130.12] ([198.99.130.12]:44529 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbYBFRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:46:31 -0500
Date: Wed, 6 Feb 2008 12:44:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Jim Meyering <meyering@redhat.com>
Subject: [PATCH 3/5] UML - Improved error handling while locating temp dir
Message-ID: <20080206174447.GA7861@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Meyering <meyering@redhat.com>

* arch/um/os-Linux/mem.c (make_tempfile): Don't deref NULL upon failed malloc.

* arch/um/os-Linux/mem.c (make_tempfile): Handle NULL tempdir.
Don't let a long tempdir (e.g., via TMPDIR) provoke heap corruption.

[ jdike - formatting cleanups, deleted obsolete comment ]

Signed-off-by: Jim Meyering <meyering@redhat.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/mem.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6-git/arch/um/os-Linux/mem.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/mem.c	2008-02-05 13:20:46.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/mem.c	2008-02-05 16:37:37.000000000 -0500
@@ -162,11 +162,6 @@ found:
 	goto out;
 }
 
-/*
- * This proc still used in tt-mode
- * (file: kernel/tt/ptproxy/proxy.c, proc: start_debugger).
- * So it isn't 'static' yet.
- */
 static int __init make_tempfile(const char *template, char **out_tempname,
 				int do_unlink)
 {
@@ -175,10 +170,13 @@ static int __init make_tempfile(const ch
 
 	which_tmpdir();
 	tempname = malloc(MAXPATHLEN);
-	if (!tempname)
-		goto out;
+	if (tempname == NULL)
+		return -1;
 
 	find_tempdir();
+	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
+		return -1;
+
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
 	else
@@ -196,9 +194,8 @@ static int __init make_tempfile(const ch
 	}
 	if (out_tempname) {
 		*out_tempname = tempname;
-	} else {
+	} else
 		free(tempname);
-	}
 	return fd;
 out:
 	free(tempname);
