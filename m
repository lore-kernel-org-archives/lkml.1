Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZFVUw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZFVUw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZFVUwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:52:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbZFVUwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:52:06 -0400
Date: Mon, 22 Jun 2009 13:48:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mike Frysinger <vapier@gentoo.org>
cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       stable@kernel.org, David Howells <dhowells@redhat.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: [PATCH] FLAT: fix uninitialized ptr with shared libs
In-Reply-To: <1245699332-1872-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.LFD.2.01.0906221338360.3240@localhost.localdomain>
References: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain> <1245699332-1872-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, Mike Frysinger wrote:
>
> should be cleaned up to apply to the master branch

Hmm. Can somebody explain why we even bother to test bprm.cred for NULL 
that second time?

Or why we test bprm.file, for that matter? How could it possibly suddenly 
become NULL?

Finally, if that bprm.cred _is_ NULL in the first test, then 'res' will be 
NULL (from the previous statement), and with the "goto out" we'll return 
_success_ from this function when we failed to allocate a cred.

IOW, the whole patch really seems to be total and utter crap. Why didn't 
people spend a bit more effort lookin at it?

IOW, shouldn't the patch be something like the appended?

UNTESTED. I did not compile this, or the previous patch. I have not tried 
it. I'm not going to commit it. I'm hoping to get a patch back that is 
tested and/or explains my concerns with the previous one..

		Linus

---
 fs/binfmt_flat.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 697f6b5..e92f229 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -828,15 +828,22 @@ static int load_flat_shared_library(int id, struct lib_info *libs)
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
 
