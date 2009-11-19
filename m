Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZKSRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZKSRYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZKSRYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:24:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZKSRWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/28] FS-Cache: Actually requeue an object when requested
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:27 +0000
Message-ID: <20091119172226.1679.31718.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS-Cache objects have an FSCACHE_OBJECT_EV_REQUEUE event that can theoretically
be raised to ask the state machine to requeue the object for further processing
before the work function returns to the slow-work facility.

However, fscache_object_work_execute() was clearing that bit before checking
the event mask to see whether the object has any pending events that require it
to be requeued immediately.

Instead, the bit should be cleared after the check and enqueue.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index c85c9f5..f3f952c 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -353,13 +353,12 @@ static void fscache_object_slow_work_execute(struct slow_work *work)
 
 	_enter("{OBJ%x}", object->debug_id);
 
-	clear_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
-
 	start = jiffies;
 	fscache_object_state_machine(object);
 	fscache_hist(fscache_objs_histogram, start);
 	if (object->events & object->event_mask)
 		fscache_enqueue_object(object);
+	clear_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
 }
 
 /*

