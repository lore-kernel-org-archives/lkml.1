Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZAERUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZAERUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAERTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:19:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33975 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZAERTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:19:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix NFSD regression
To: bfields@fieldses.org
Cc: dhowells@redhat.com, hch@lst.de, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 05 Jan 2009 17:19:37 +0000
Message-ID: <20090105171937.4463.98583.stgit@warthog.procyon.org.uk>
In-Reply-To: <806.1231174132@redhat.com>
References: <806.1231174132@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression in NFSD's permission checking introduced by the credentials
patches.  There are two parts to the problem, both in nfsd_setuser():

 (1) The return value of set_groups() is -ve if in error, not 0, and should be
     checked appropriately.  0 indicates success.

 (2) The UID to use for fs accesses is in new->fsuid, not new->uid (which is
     0).  This causes CAP_DAC_OVERRIDE to always be set, rather than being
     cleared if the UID is anything other than 0 after squashing.

Reported-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfsd/auth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 0184fe9..c903e04 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -76,10 +76,10 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 
 	ret = set_groups(new, gi);
 	put_group_info(gi);
-	if (!ret)
+	if (ret < 0)
 		goto error;
 
-	if (new->uid)
+	if (new->fsuid)
 		new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
 	else
 		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,

