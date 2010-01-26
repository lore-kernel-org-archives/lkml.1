Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604Ab0A0AAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0A0AAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348Ab0AZXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:25 -0500
Received: from kroah.org ([198.145.64.141]:35192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0AZXnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233924.939074140@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Frank Filz <ffilzlnx@us.ibm.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [31/98] nfsd: Fix sort_pacl in fs/nfsd/nf4acl.c to actually sort groups
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frank Filz <ffilzlnx@us.ibm.com>

commit aba24d71580180dfdf6a1a83a5858a1c048fd785 upstream.

We have been doing some extensive testing of Linux support for ACLs on
NFDS v4. We have noticed that the server rejects ACLs where the groups
are out of order, for example, the following ACL is rejected:

A::OWNER@:rwaxtTcCy
A::user101@domain:rwaxtcy
A::GROUP@:rwaxtcy
A:g:group102@domain:rwaxtcy
A:g:group101@domain:rwaxtcy
A::EVERYONE@:rwaxtcy

Examining the server code, I found that after converting an NFS v4 ACL
to POSIX, sort_pacl is called to sort the user ACEs and group ACEs.
Unfortunately, a minor bug causes the group sort to be skipped.

Signed-off-by: Frank Filz <ffilzlnx@us.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -389,7 +389,7 @@ sort_pacl(struct posix_acl *pacl)
 	sort_pacl_range(pacl, 1, i-1);
 
 	BUG_ON(pacl->a_entries[i].e_tag != ACL_GROUP_OBJ);
-	j = i++;
+	j = ++i;
 	while (pacl->a_entries[j].e_tag == ACL_GROUP)
 		j++;
 	sort_pacl_range(pacl, i, j-1);


