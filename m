Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYLCTz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYLCTz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYLCTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:25 -0500
Received: from kroah.org ([198.145.64.141]:59535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752022AbYLCTuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:16 -0500
Date: Wed, 3 Dec 2008 11:48:45 -0800
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
       alan@lxorguk.ukuu.org.uk, Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [patch 014/104] sysvipc: fix the ipc structures initialization
Message-ID: <20081203194845.GO8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sysvipc-fix-the-ipc-structures-initialization.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nadia Derbey <Nadia.Derbey@bull.net>

commit e00b4ff7ebf098b11b11be403921c1cf41d9e321 upstream.

A problem was found while reviewing the code after Bugzilla bug
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

In ipc_addid(), the newly allocated ipc structure is inserted into the
ipcs tree (i.e made visible to readers) without locking it.  This is not
correct since its initialization continues after it has been inserted in
the tree.

This patch moves the ipc structure lock initialization + locking before
the actual insertion.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Reported-by: Clement Calmels <cboulte@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/util.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/ipc/util.c
+++ b/ipc/util.c
@@ -266,9 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	spin_lock_init(&new->lock);
+	new->deleted = 0;
+	rcu_read_lock();
+	spin_lock(&new->lock);
+
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
-	if (err)
+	if (err) {
+		spin_unlock(&new->lock);
+		rcu_read_unlock();
 		return err;
+	}
 
 	ids->in_use++;
 
@@ -280,10 +288,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 		ids->seq = 0;
 
 	new->id = ipc_buildid(id, new->seq);
-	spin_lock_init(&new->lock);
-	new->deleted = 0;
-	rcu_read_lock();
-	spin_lock(&new->lock);
 	return id;
 }
 

