Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYG2LuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYG2LuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYG2Lt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:49:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:36482 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbYG2Lt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=avmSDmRWkb/ffBhbXCMFaq2udDnHeo4tdMDibyQbrQyrqSYszeLpT0h55AfMEynyER
         /JQMhEDpd0c16Y8k0Fb5nKAzZIEQ32xgJhhROfFCAnHnCnWecpwp2bynB5tS+BlskMKD
         J6CfE+AR6mQ49TbrOPw3I3qYdDe+9Tz14CM24=
Subject: [PATCH] fs/fat/dir.c fix resource leak
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, hirofumi@mail.parknet.co.jp
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Jul 2008 10:03:33 +1000
Message-Id: <1217289813.9367.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people,

Coverity CID 2332 & 2333 RESOURCE_LEAK


In fat_search_long() if fat_parse_long() returns a -ve value we return
without first freeing unicode and bufname.
This patch free's them on this error path.

Patch against linux-next commit 99be8ca04aa13c0ff10bbb3ba5f90676b050fcc6
Only compile tested

﻿﻿﻿﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 34541d0..8a9d7fa 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -346,14 +346,16 @@ parse_record:
 		if (de->attr == ATTR_EXT) {
 			int status = fat_parse_long(inode, &cpos, &bh, &de,
 						    &unicode, &nr_slots);
-			if (status < 0)
-				return status;
-			else if (status == PARSE_INVALID)
+			if (status < 0) {
+				err = status;
+				goto EODir;
+			} else if (status == PARSE_INVALID) {
 				continue;
-			else if (status == PARSE_NOT_LONGNAME)
+			} else if (status == PARSE_NOT_LONGNAME) {
 				goto parse_record;
-			else if (status == PARSE_EOF)
+			} else if (status == PARSE_EOF) {
 				goto EODir;
+			}
 		}
 
 		memcpy(work, de->name, sizeof(de->name));


