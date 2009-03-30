Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZC3SQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZC3SQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZC3SPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:56589 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZC3SPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:14 -0400
Message-Id: <20090330181010.178949983@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:22 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 07/35 error-handling] reiserfs: prepare_error_buf wrongly consumes va_arg
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.fixes/reiserfs-varargs-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 vsprintf will consume varargs on its own. Skipping them manually
 results in garbage in the error buffer, or Oopses in the case of
 pointers.

 This patch removes the advancement and fixes a number of bugs where
 crashes were observed as side effects of a regular error report.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/reiserfs/prints.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -157,19 +157,16 @@ static void sprintf_disk_child(char *buf
 		dc_size(dc));
 }
 
-static char *is_there_reiserfs_struct(char *fmt, int *what, int *skip)
+static char *is_there_reiserfs_struct(char *fmt, int *what)
 {
 	char *k = fmt;
 
-	*skip = 0;
-
 	while ((k = strchr(k, '%')) != NULL) {
 		if (k[1] == 'k' || k[1] == 'K' || k[1] == 'h' || k[1] == 't' ||
 		    k[1] == 'z' || k[1] == 'b' || k[1] == 'y' || k[1] == 'a') {
 			*what = k[1];
 			break;
 		}
-		(*skip)++;
 		k++;
 	}
 	return k;
@@ -193,18 +190,15 @@ static void prepare_error_buf(const char
 	char *fmt1 = fmt_buf;
 	char *k;
 	char *p = error_buf;
-	int i, j, what, skip;
+	int what;
 
 	strcpy(fmt1, fmt);
 
-	while ((k = is_there_reiserfs_struct(fmt1, &what, &skip)) != NULL) {
+	while ((k = is_there_reiserfs_struct(fmt1, &what)) != NULL) {
 		*k = 0;
 
 		p += vsprintf(p, fmt1, args);
 
-		for (i = 0; i < skip; i++)
-			j = va_arg(args, int);
-
 		switch (what) {
 		case 'k':
 			sprintf_le_key(p, va_arg(args, struct reiserfs_key *));


