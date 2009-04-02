Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbZDBXe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbZDBXe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZDBXeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:34:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:15751 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZDBXep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IlQRW6EjFjd1sbg/+8qwq38vt3Z0V99aQMFjg4LF71UhGa1Z3c7tDTSUbdiD2/gf8X
         bOa+MJb2RwqICTPbJvVVNW2wf/XGMMdhkLvQubnh+xbST5DwE/eK6EfarNUQpv2Hi9Pt
         ngoyjCn/cMeFYDjy8aoh4F9yBwR7YrMLpxfRc=
Date: Thu, 2 Apr 2009 17:34:40 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net/9p: set correct stat size when sending Twstat messages
Message-ID: <20090402233440.GA7842@mallorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 9P2000 Twstat message requires the size of the stat structure to be
specified. Currently the 9p code writes zero instead of the actual size.
This behavior confuses some of the file servers that check if the size is
correct. 

This patch adds a new function that calculcates the stat size and puts the
value in the appropriate place in the 9P message.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

diff --git a/net/9p/client.c b/net/9p/client.c
index 1eb580c..c079df6 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1251,12 +1251,41 @@ error:
 }
 EXPORT_SYMBOL(p9_client_stat);
 
+static int p9_client_statsize(struct p9_wstat *wst, int optional)
+{
+	int ret;
+
+	ret = 2+2+4+13+			/* size[2] type[2] dev[4] qid[13] */
+		4+4+4+8+		/* mode[4] atime[4] mtime[4] length[8]*/
+		2+2+2+2;		/* name[s] uid[s] gid[s] muid[s] */
+
+	if (wst->name)
+		ret += strlen(wst->name);
+	if (wst->uid)
+		ret += strlen(wst->uid);
+	if (wst->gid)
+		ret += strlen(wst->gid);
+	if (wst->muid)
+		ret += strlen(wst->muid);
+
+	if (optional) {
+		ret += 2+4+4+4;	/* extension[s] n_uid[4] n_gid[4] n_muid[4] */
+		if (wst->extension)
+			ret += strlen(wst->extension);
+	}
+
+	return ret;
+}
+
 int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 {
 	int err;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
+	err = 0;
+	clnt = fid->clnt;
+	wst->size = p9_client_statsize(wst, clnt->dotu);
 	P9_DPRINTK(P9_DEBUG_9P, ">>> TWSTAT fid %d\n", fid->fid);
 	P9_DPRINTK(P9_DEBUG_9P,
 		"     sz=%x type=%x dev=%x qid=%x.%llx.%x\n"
@@ -1268,10 +1297,8 @@ int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 		wst->atime, wst->mtime, (unsigned long long)wst->length,
 		wst->name, wst->uid, wst->gid, wst->muid, wst->extension,
 		wst->n_uid, wst->n_gid, wst->n_muid);
-	err = 0;
-	clnt = fid->clnt;
 
-	req = p9_client_rpc(clnt, P9_TWSTAT, "dwS", fid->fid, 0, wst);
+	req = p9_client_rpc(clnt, P9_TWSTAT, "dwS", fid->fid, wst->size, wst);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
