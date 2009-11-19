Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZKSRWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZKSRWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZKSRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZKSRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/28] FS-Cache: Make sure FSCACHE_COOKIE_LOOKING_UP cleared
	on lookup failure
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:16 +0000
Message-ID: <20091119172216.1679.81427.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must make sure that FSCACHE_COOKIE_LOOKING_UP is cleared on lookup failure
(if an object reaches the LC_DYING state), and we should clear it before
clearing FSCACHE_COOKIE_CREATING.

If this doesn't happen then fscache_wait_for_deferred_lookup() may hold
allocation and retrieval operations indefinitely until they're interrupted by
signals - which in turn pins the dying object until they go away.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 1a1afa8..74bc562 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -105,6 +105,7 @@ static inline void fscache_done_parent_op(struct fscache_object *object)
 static void fscache_object_state_machine(struct fscache_object *object)
 {
 	enum fscache_object_state new_state;
+	struct fscache_cookie *cookie;
 
 	ASSERT(object != NULL);
 
@@ -158,11 +159,17 @@ static void fscache_object_state_machine(struct fscache_object *object)
 
 		spin_lock(&object->lock);
 		object->state = FSCACHE_OBJECT_DYING;
-		if (object->cookie &&
-		    test_and_clear_bit(FSCACHE_COOKIE_CREATING,
-				       &object->cookie->flags))
-			wake_up_bit(&object->cookie->flags,
-				    FSCACHE_COOKIE_CREATING);
+		cookie = object->cookie;
+		if (cookie) {
+			if (test_and_clear_bit(FSCACHE_COOKIE_LOOKING_UP,
+					       &cookie->flags))
+				wake_up_bit(&cookie->flags,
+					    FSCACHE_COOKIE_LOOKING_UP);
+			if (test_and_clear_bit(FSCACHE_COOKIE_CREATING,
+					       &cookie->flags))
+				wake_up_bit(&cookie->flags,
+					    FSCACHE_COOKIE_CREATING);
+		}
 		spin_unlock(&object->lock);
 
 		fscache_done_parent_op(object);

