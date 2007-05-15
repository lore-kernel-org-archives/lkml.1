Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbXEOPwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbXEOPwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbXEOPwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:52:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbXEOPwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:52:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] AFS: Fix afs_prepare_write()
To: akpm@osdl.org, nickpiggin@yahoo.com.au
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 15 May 2007 16:52:24 +0100
Message-ID: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

afs_prepare_write() should not mark a page up to date if it only partially
fills it in, in expectation of the caller filling in the rest prior to calling
commit_write().  commit_write(), however, should mark the page up to date.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/write.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 28f3751..a03b92a 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -206,7 +206,6 @@ int afs_prepare_write(struct file *file, struct page *page,
 			_leave(" = %d [prep]", ret);
 			return ret;
 		}
-		SetPageUptodate(page);
 	}
 
 try_again:
@@ -311,8 +310,8 @@ int afs_commit_write(struct file *file, struct page *page,
 		spin_unlock(&vnode->writeback_lock);
 	}
 
+	SetPageUptodate(page);
 	set_page_dirty(page);
-
 	if (PageDirty(page))
 		_debug("dirtied");
 

