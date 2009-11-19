Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZKSRYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZKSRYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZKSRV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbZKSRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/28] FS-Cache: The object-available state can't rely on the
	cookie to be available
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:45 +0000
Message-ID: <20091119172145.1679.65083.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The object-available state in the object processing state machine (as
processed by fscache_object_available()) can't rely on the cookie to be
available because the FSCACHE_COOKIE_CREATING bit may have been cleared by
fscache_obtained_object() prior to the object being put into the
FSCACHE_OBJECT_AVAILABLE state.

Clearing the FSCACHE_COOKIE_CREATING bit on a cookie permits
__fscache_relinquish_cookie() to proceed and detach the cookie from the
object.

To deal with this, we don't dereference object->cookie in
fscache_object_available() if the object has already been detached.

In addition, a couple of assertions are added into fscache_drop_object() to
make sure the object is unbound from the cookie before it gets there.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 0d65c0c..1a1afa8 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -158,7 +158,8 @@ static void fscache_object_state_machine(struct fscache_object *object)
 
 		spin_lock(&object->lock);
 		object->state = FSCACHE_OBJECT_DYING;
-		if (test_and_clear_bit(FSCACHE_COOKIE_CREATING,
+		if (object->cookie &&
+		    test_and_clear_bit(FSCACHE_COOKIE_CREATING,
 				       &object->cookie->flags))
 			wake_up_bit(&object->cookie->flags,
 				    FSCACHE_COOKIE_CREATING);
@@ -594,7 +595,8 @@ static void fscache_object_available(struct fscache_object *object)
 
 	spin_lock(&object->lock);
 
-	if (test_and_clear_bit(FSCACHE_COOKIE_CREATING, &object->cookie->flags))
+	if (object->cookie &&
+	    test_and_clear_bit(FSCACHE_COOKIE_CREATING, &object->cookie->flags))
 		wake_up_bit(&object->cookie->flags, FSCACHE_COOKIE_CREATING);
 
 	fscache_done_parent_op(object);
@@ -631,6 +633,9 @@ static void fscache_drop_object(struct fscache_object *object)
 
 	_enter("{OBJ%x,%d}", object->debug_id, object->n_children);
 
+	ASSERTCMP(object->cookie, ==, NULL);
+	ASSERT(hlist_unhashed(&object->cookie_link));
+
 	spin_lock(&cache->object_list_lock);
 	list_del_init(&object->cache_link);
 	spin_unlock(&cache->object_list_lock);

