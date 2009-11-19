Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZKSRVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZKSRVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZKSRVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbZKSRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/28] FS-Cache: Clear netfs pointers in cookie after
	detaching object, not before
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:30 +0000
Message-ID: <20091119172130.1679.5838.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the pointers from the fscache_cookie struct to netfs private data after
clearing the pointer to the cookie from the fscache_object struct and
releasing the object lock, rather than before.

This allows the netfs private data pointers to be relied on simply by holding
the object lock, rather than having to hold the cookie lock.  This is makes
things simpler as the cookie lock has to be taken before the object lock, but
sometimes the object pointer is all that the code has.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/cookie.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 432482e..b1870a6 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -437,12 +437,8 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 
 	event = retire ? FSCACHE_OBJECT_EV_RETIRE : FSCACHE_OBJECT_EV_RELEASE;
 
-	/* detach pointers back to the netfs */
 	spin_lock(&cookie->lock);
 
-	cookie->netfs_data	= NULL;
-	cookie->def		= NULL;
-
 	/* break links with all the active objects */
 	while (!hlist_empty(&cookie->backing_objects)) {
 		object = hlist_entry(cookie->backing_objects.first,
@@ -465,6 +461,10 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 			BUG();
 	}
 
+	/* detach pointers back to the netfs */
+	cookie->netfs_data	= NULL;
+	cookie->def		= NULL;
+
 	spin_unlock(&cookie->lock);
 
 	if (cookie->parent) {

