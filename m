Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbZBYK6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbZBYK6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZBYK6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:58:03 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51615 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZBYK6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:58:00 -0500
Date: Wed, 25 Feb 2009 16:28:31 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 1/2] New cgroup subsystem API (->initialize())
Message-ID: <20090225105831.GB4008@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090225105730.GA4008@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225105730.GA4008@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji Rao <balajirrao@gmail.com>

cgroup: Add ->initialize() to cgroup_subsys structure

Some cgroup subsystems (like cpu controller) would need subsystem
specific initialization. Such subsystems can define ->initialize()
which gets called during cgroup_init() (and not cgroup_init_early()).

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 Documentation/cgroups/cgroups.txt |    6 ++++++
 include/linux/cgroup.h            |    1 +
 kernel/cgroup.c                   |    2 ++
 3 files changed, 9 insertions(+)

--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -534,6 +534,12 @@ and root cgroup. Currently this will onl
 the default hierarchy (which never has sub-cgroups) and a hierarchy
 that is being created/destroyed (and hence has no sub-cgroups).
 
+void initialize(void)
+
+Called during cgroup initialization (cgroup_init()) to do any subsystem
+specific initialization. This is not called during early cgroup
+initialialization (cgroup_init_early().
+
 4. Questions
 ============
 
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -359,6 +359,7 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
+	void (*initialize)(void);
 
 	int subsys_id;
 	int active;
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2707,6 +2707,8 @@ int __init cgroup_init(void)
 		struct cgroup_subsys *ss = subsys[i];
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
+		if (ss->initialize)
+			ss->initialize();
 	}
 
 	/* Add init_css_set to the hash table */
