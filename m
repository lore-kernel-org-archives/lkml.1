Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZLFM6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZLFM6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZLFM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:58:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbZLFM6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:58:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Avoid maybe-used-uninitialised warning on variable
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Dec 2009 12:58:02 +0000
Message-ID: <20091206125802.18076.58619.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton's compiler sees the following warning in FS-Cache:

fs/fscache/object-list.c: In function 'fscache_objlist_lookup':
fs/fscache/object-list.c:94: warning: 'obj' may be used uninitialized in this function

which my compiler doesn't.  This is a false positive as obj can only be used
in the comparison against minobj if minobj has been set to something other
than NULL, but for that to happen, obj has to be first set to something.

Deal with this by preclearing obj too.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object-list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index e590242..3221a0c 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -91,7 +91,7 @@ EXPORT_SYMBOL(fscache_object_destroy);
  */
 static struct fscache_object *fscache_objlist_lookup(loff_t *_pos)
 {
-	struct fscache_object *pobj, *obj, *minobj = NULL;
+	struct fscache_object *pobj, *obj = NULL, *minobj = NULL;
 	struct rb_node *p;
 	unsigned long pos;
 

