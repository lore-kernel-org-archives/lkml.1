Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYHPCca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYHPCca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYHPCcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:32:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYHPCcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:32:21 -0400
Message-ID: <48A63AD1.3010907@ds.jp.nec.com>
Date: Fri, 15 Aug 2008 22:26:25 -0400
From: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: menage@google.com, balbir@linux.vnet.ibm.com
CC: Linux Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: memory.force_empty can make system slowdown
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cgroup's memory controller has a control file "memory.force_empty"
to reset usage account charged to a cgroup.  The account shouldn't
be reset if one or more processes are attached to the cgroup (at
least for memory controller, IMHO).  So mem_cgroup_force_empty()
is implemented to return -EBUSY and do nothing if so.
However, cgroup on hierarchy root faultily might be a exception.
Even if processes are attached to root cgroup (which is a "default"
cgroup for processes), forcing-empty can run by writing something to
memory.force_empty and it'll never end.

Following patch prevents this issue.

This patch is for cgroup infrastructure code.  The issue can be
measured by modifying memory controller code also, namely to change
mem_cgroup_force_empty() to see CSS_ROOT bit of css->flags.
I believe cgroup->count approach like the patch below is rather
generic and reasonable, how does that sound?

Paul, Balbir?



Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>

diff -uNrp linux-2.6.27-rc3.orig/kernel/cgroup.c linux-2.6.27-rc3/kernel/cgroup.c
--- linux-2.6.27-rc3.orig/kernel/cgroup.c	2008-08-12 21:55:39.000000000 -0400
+++ linux-2.6.27-rc3/kernel/cgroup.c	2008-08-15 20:52:52.000000000 -0400
@@ -2264,8 +2264,10 @@ static void init_cgroup_css(struct cgrou
 	css->cgroup = cgrp;
 	atomic_set(&css->refcnt, 0);
 	css->flags = 0;
-	if (cgrp == dummytop)
+	if (cgrp == dummytop) {
 		set_bit(CSS_ROOT, &css->flags);
+		atomic_set(&css->cgroup->count, 1);
+	}
 	BUG_ON(cgrp->subsys[ss->subsys_id]);
 	cgrp->subsys[ss->subsys_id] = css;
 }



-- 
IKEDA, Munehiro
  NEC Corporation of America
    m-ikeda@ds.jp.nec.com

