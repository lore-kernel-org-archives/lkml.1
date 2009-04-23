Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZDWHp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZDWHp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZDWHbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:31:09 -0400
Received: from sous-sol.org ([216.99.217.87]:50558 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756594AbZDWHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:31:07 -0400
Message-Id: <20090423072513.934477545@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Cheng Renquan <crquan@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 041/100] dm target: use module refcount directly
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-target-use-module-refcount-directly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Cheng Renquan <crquan@gmail.com>

upstream commit: 5642b8a61a15436231adf27b2b1bd96901b623dd

The tt_internal's 'use' field is superfluous: the module's refcount can do
the work properly.  An acceptable side-effect is that this increases the
reference counts reported by 'lsmod'.

Remove the superfluous test when removing a target module.

[Crash possible without this on SMP - agk]

Cc: stable@kernel.org
Signed-off-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Reviewed-by: Alasdair G Kergon <agk@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-target.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -18,7 +18,6 @@ struct tt_internal {
 	struct target_type tt;
 
 	struct list_head list;
-	long use;
 };
 
 static LIST_HEAD(_targets);
@@ -44,12 +43,8 @@ static struct tt_internal *get_target_ty
 	down_read(&_lock);
 
 	ti = __find_target_type(name);
-	if (ti) {
-		if ((ti->use == 0) && !try_module_get(ti->tt.module))
-			ti = NULL;
-		else
-			ti->use++;
-	}
+	if (ti && !try_module_get(ti->tt.module))
+		ti = NULL;
 
 	up_read(&_lock);
 	return ti;
@@ -77,10 +72,7 @@ void dm_put_target_type(struct target_ty
 	struct tt_internal *ti = (struct tt_internal *) t;
 
 	down_read(&_lock);
-	if (--ti->use == 0)
-		module_put(ti->tt.module);
-
-	BUG_ON(ti->use < 0);
+	module_put(ti->tt.module);
 	up_read(&_lock);
 
 	return;
@@ -140,12 +132,6 @@ void dm_unregister_target(struct target_
 		BUG();
 	}
 
-	if (ti->use) {
-		DMCRIT("Attempt to unregister target still in use: %s",
-		       t->name);
-		BUG();
-	}
-
 	list_del(&ti->list);
 	kfree(ti);
 

