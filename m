Return-Path: <linux-kernel-owner+w=401wt.eu-S1763942AbZAUKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763942AbZAUKvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZAUKvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:51:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZAUKvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:51:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=a2EfCuCCo6+/t9bnufL2tqQax4DoR458H792CXGMYpZzkO+/il5hgnOMWFMOCcIg/
	01MeeC04O47iHeMRCqGvQ==
From: Paul Menage <menage@google.com>
Subject: [PATCH] Add cpu_relax() calls in css_tryget() and
	cgroup_clear_css_refs()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2009 02:51:16 -0800
Message-ID: <20090121105116.1059.30614.stgit@menage.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.18
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpu_relax() calls in css_tryget() and cgroup_clear_css_refs()

css_tryget() and cgroup_clear_css_refs() contain polling loops; these
loops should have cpu_relax calls in them to reduce cross-cache
traffic.

Signed-off-by: Paul Menage <menage@google.com>

---

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e267e62..e4e8e11 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -99,6 +99,7 @@ static inline bool css_tryget(struct cgroup_subsys_state *css)
 	while (!atomic_inc_not_zero(&css->refcnt)) {
 		if (test_bit(CSS_REMOVED, &css->flags))
 			return false;
+		cpu_relax();
 	}
 	return true;
 }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2ae7cb4..adcd0bb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2509,7 +2509,7 @@ static int cgroup_clear_css_refs(struct cgroup *cgrp)
 	for_each_subsys(cgrp->root, ss) {
 		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 		int refcnt;
-		do {
+		while (1) {
 			/* We can only remove a CSS with a refcnt==1 */
 			refcnt = atomic_read(&css->refcnt);
 			if (refcnt > 1) {
@@ -2523,7 +2523,10 @@ static int cgroup_clear_css_refs(struct cgroup *cgrp)
 			 * css_tryget() to spin until we set the
 			 * CSS_REMOVED bits or abort
 			 */
-		} while (atomic_cmpxchg(&css->refcnt, refcnt, 0) != refcnt);
+			if (atomic_cmpxchg(&css->refcnt, refcnt, 0) == refcnt)
+				break;
+			cpu_relax();
+		}
 	}
  done:
 	for_each_subsys(cgrp->root, ss) {

