Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbZFJDd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZFJDd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZFJDdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:04 -0400
Received: from kroah.org ([198.145.64.141]:56510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZFJDdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:02 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:40 2009
Message-Id: <20090610002340.084093628@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frank Filz <ffilzlnx@us.ibm.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/60] nfs: Fix NFS v4 client handling of MAY_EXEC in nfs_permission.
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=nfs-fix-nfs-v4-client-handling-of-may_exec-in-nfs_permission.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Frank Filz <ffilzlnx@us.ibm.com>

commit 7ee2cb7f32b299c2b06a31fde155457203e4b7dd upstream.

The problem is that permission checking is skipped if atomic open is
possible, but when exec opens a file, it just opens it O_READONLY which
means EXEC permission will not be checked at that time.

This problem is observed by the following sequence (executed as root):

  mount -t nfs4 server:/ /mnt4
  echo "ls" >/mnt4/foo
  chmod 744 /mnt4/foo
  su guest -c "mnt4/foo"

Signed-off-by: Frank Filz <ffilzlnx@us.ibm.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1925,7 +1925,8 @@ int nfs_permission(struct inode *inode, 
 		case S_IFREG:
 			/* NFSv4 has atomic_open... */
 			if (nfs_server_capable(inode, NFS_CAP_ATOMIC_OPEN)
-					&& (mask & MAY_OPEN))
+					&& (mask & MAY_OPEN)
+					&& !(mask & MAY_EXEC))
 				goto out;
 			break;
 		case S_IFDIR:


