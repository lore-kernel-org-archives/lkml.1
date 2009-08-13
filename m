Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbZHMTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbZHMTr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbZHMTr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:58 -0400
Received: from kroah.org ([198.145.64.141]:36769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbZHMTr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:38 2009
Message-Id: <20090813194338.459687099@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>, David Howells <dhowells@redhat.com>
Subject: [patch 18/28] flat: fix uninitialized ptr with shared libs
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=flat-fix-uninitialized-ptr-with-shared-libs.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3440625d78711bee41a84cf29c3d8c579b522666 upstream.

The new credentials code broke load_flat_shared_library() as it now uses
an uninitialized cred pointer.

Reported-by: Bernd Schmidt <bernds_cb1@t-online.de>
Tested-by: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_flat.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -824,15 +824,22 @@ static int load_flat_shared_library(int 
 	if (IS_ERR(bprm.file))
 		return res;
 
+	bprm.cred = prepare_exec_creds();
+	res = -ENOMEM;
+	if (!bprm.cred)
+		goto out;
+
 	res = prepare_binprm(&bprm);
 
 	if (res <= (unsigned long)-4096)
 		res = load_flat_file(&bprm, libs, id, NULL);
-	if (bprm.file) {
-		allow_write_access(bprm.file);
-		fput(bprm.file);
-		bprm.file = NULL;
-	}
+
+	abort_creds(bprm.cred);
+
+out:
+	allow_write_access(bprm.file);
+	fput(bprm.file);
+
 	return(res);
 }
 


