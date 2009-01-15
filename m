Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbZAOK2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbZAOK2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763615AbZAOK2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:28:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58930 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283AbZAOK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:28:20 -0500
Date: Thu, 15 Jan 2009 19:27:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 2/4] cgroup:add css_is_populated
Message-Id: <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cgroup creation is done in several stages.
After allocated and linked to cgroup's hierarchy tree, all necessary
control files are created.

When using CSS_ID, scanning cgroups without cgrouo_lock(), status
of cgroup is important. At removal of cgroup/css, css_tryget() works fine
and we can write a safe code. At creation, we need some flag to show 
"This cgroup is not ready yet"

This patch adds CSS_POPULATED flag.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
Index: mmotm-2.6.29-Jan14/include/linux/cgroup.h
===================================================================
--- mmotm-2.6.29-Jan14.orig/include/linux/cgroup.h
+++ mmotm-2.6.29-Jan14/include/linux/cgroup.h
@@ -69,6 +69,7 @@ struct cgroup_subsys_state {
 enum {
 	CSS_ROOT, /* This CSS is the root of the subsystem */
 	CSS_REMOVED, /* This CSS is dead */
+	CSS_POPULATED, /* This CSS finished all initialization */
 };
 
 /*
@@ -90,6 +91,11 @@ static inline bool css_is_removed(struct
 	return test_bit(CSS_REMOVED, &css->flags);
 }
 
+static inline bool css_is_populated(struct cgroup_subsys_state *css)
+{
+	return test_bit(CSS_POPULATED, &css->flags);
+}
+
 /*
  * Call css_tryget() to take a reference on a css if your existing
  * (known-valid) reference isn't already ref-counted. Returns false if
Index: mmotm-2.6.29-Jan14/kernel/cgroup.c
===================================================================
--- mmotm-2.6.29-Jan14.orig/kernel/cgroup.c
+++ mmotm-2.6.29-Jan14/kernel/cgroup.c
@@ -2326,8 +2326,10 @@ static int cgroup_populate_dir(struct cg
 	}
 
 	for_each_subsys(cgrp->root, ss) {
+		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 		if (ss->populate && (err = ss->populate(ss, cgrp)) < 0)
 			return err;
+		set_bit(CSS_POPULATED, &css->flags);
 	}
 
 	return 0;

