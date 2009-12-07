Return-Path: <linux-kernel-owner+w=401wt.eu-S934454AbZLGA1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbZLGA1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934411AbZLGA1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:27:47 -0500
Received: from kroah.org ([198.145.64.141]:34417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415AbZLGANK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:49 2009
Message-Id: <20091207000649.274041422@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [051/119] NFSv4: Fix a cache validation bug which causes getcwd() to return ENOENT
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=nfsv4-fix-a-cache-validation-bug-which-causes-getcwd-to-return-enoent.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 96d25e532234bec1a1989e6e1baf702d43a78b0d upstream.

Changeset a65318bf3afc93ce49227e849d213799b072c5fd (NFSv4: Simplify some
cache consistency post-op GETATTRs) incorrectly changed the getattr
bitmap for readdir().
This causes the readdir() function to fail to return a
fileid/inode number, which again exposed a bug in the NFS readdir code that
causes spurious ENOENT errors to appear in applications (see
http://bugzilla.kernel.org/show_bug.cgi?id=14541).

The immediate band aid is to revert the incorrect bitmap change, but more
long term, we should change the NFS readdir code to cope with the
fact that NFSv4 servers are not required to support fileids/inode numbers.

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2740,7 +2740,7 @@ static int _nfs4_proc_readdir(struct den
 		.pages = &page,
 		.pgbase = 0,
 		.count = count,
-		.bitmask = NFS_SERVER(dentry->d_inode)->cache_consistency_bitmask,
+		.bitmask = NFS_SERVER(dentry->d_inode)->attr_bitmask,
 	};
 	struct nfs4_readdir_res res;
 	struct rpc_message msg = {


