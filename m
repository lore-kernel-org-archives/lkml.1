Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZIPOzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZIPOzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZIPOzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZIPOzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:55:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Have the garbage collector set its timer for live
	expired keys
To: torvalds@osdl.org, jmorris@namei.org, eparis@redhat.com, mingo@elte.hu
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Wed, 16 Sep 2009 15:54:14 +0100
Message-ID: <20090916145414.31860.16602.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key garbage collector sets a timer to start a new collection cycle at the
point the earliest key to expire should be considered garbage.  However, it
currently only does this if the key it is considering hasn't yet expired.

If the key being considering has expired, but hasn't yet reached the collection
time then it is ignored, and won't be collected until some other key provokes a
round of collection.

Make the garbage collector set the timer for the earliest key that hasn't yet
passed its collection time, rather than the earliest key that hasn't yet
expired.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/gc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/security/keys/gc.c b/security/keys/gc.c
index 485fc62..4770be3 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -169,9 +169,9 @@ static void key_garbage_collector(struct work_struct *work)
 
 	/* trawl through the keys looking for keyrings */
 	for (;;) {
-		if (key->expiry > now && key->expiry < new_timer) {
+		if (key->expiry > limit && key->expiry < new_timer) {
 			kdebug("will expire %x in %ld",
-			       key_serial(key), key->expiry - now);
+			       key_serial(key), key->expiry - limit);
 			new_timer = key->expiry;
 		}
 

