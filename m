Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbYBYXUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbYBYXUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYBYXUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:20:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:19175 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYBYXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:20:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=yG6KaQL+Jwyz4jrqK5VE9Kmc4AL2nJYqwO2qxq0FvGM1fmndfrI+QGH3xNYi1M7mPvhVuHmAxcqL2dgM1wKuvHViJEJyrym/1DRLVDwilgvFJEyXvhvBaRL0v1yYfvkGwvGPp98sHifIOIOBcAqBYlxUopsJ+4htHHa2STfK4/k=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH] Don't risk NULL deref in marker
Date: Tue, 26 Feb 2008 00:14:24 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260014.24253.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


get_marker() may return NULL, so test for it.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/kernel/marker.c b/kernel/marker.c
index 50effc0..f211f08 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -698,12 +698,11 @@ int marker_probe_unregister(const char *name,
 {
 	struct marker_entry *entry;
 	struct marker_probe_closure *old;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	if (!entry) {
-		ret = -ENOENT;
 		goto end;
 	}
 	if (entry->rcu_pending)
@@ -713,12 +712,16 @@ int marker_probe_unregister(const char *name,
 	marker_update_probes();		/* may update entry */
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
+	if (!entry) {
+		goto end;
+	}
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
+	ret = 0;
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
