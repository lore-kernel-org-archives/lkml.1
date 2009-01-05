Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZAEQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZAEQtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZAEQtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:49:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZAEQtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:49:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090102164505.GA10465@fieldses.org>
References: <20090102164505.GA10465@fieldses.org> <20090102051905.GC1073@fieldses.org> <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com> <32481.1230897578@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]
Date: Mon, 05 Jan 2009 16:48:52 +0000
Message-ID: <806.1231174132@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> And the test failure
> is nfsd_lookup() returning OK on a directory when it should return
> nfserr_perm.  I assume that's the result of inode_permission(directory
> inode, MAY_EXEC) returning 0 when it shouldn't, but I haven't confirmed
> that.

The first problem directly related to this is, I think, addressed by the
attached patch.

There seems to be more to it, though.

David
---

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 0184fe9..64bc1f5 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -76,7 +76,7 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 
 	ret = set_groups(new, gi);
 	put_group_info(gi);
-	if (!ret)
+	if (ret < 0)
 		goto error;
 
 	if (new->uid)
