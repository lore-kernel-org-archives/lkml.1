Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbZDBXjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbZDBXjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764651AbZDBXiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:38:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:18792 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765141AbZDBXiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=j0Apvj50FQ+z+nNkHUtOTUNcVDGVxzc4Jd/i/E0eGxg0x7wW8U+UwuPd4aQXq5wrAV
         xwzxUuAwf6AJasFFFFQ9l+gO5yCAeXXuE47fi2p+w+L8dNprjEtLzAAsPEtC2bkOd6Hv
         RT1eolY+j4a8DkW5cqxYeHoPEXaQxnON4s0Vw=
Date: Thu, 2 Apr 2009 17:38:46 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net/9p: return error when p9_client_stat fails
Message-ID: <20090402233846.GC7842@mallorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p9_client_stat function doesn't return correct value if it fails.
p9_client_stat should return ERR_PTR of the error value when it fails.
Instead, it always returns a value to the allocated p9_wstat struct even
when it is not populated correctly.

This patch makes p9_client_stat to handle failure correctly.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
diff --git a/net/9p/client.c b/net/9p/client.c
index f5634b5..6235528 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1208,10 +1208,14 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 		ret->name, ret->uid, ret->gid, ret->muid, ret->extension,
 		ret->n_uid, ret->n_gid, ret->n_muid);
 
+	p9_free_req(clnt, req);
+	return ret;
+
 free_and_error:
 	p9_free_req(clnt, req);
 error:
-	return ret;
+	kfree(ret);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(p9_client_stat);
 
