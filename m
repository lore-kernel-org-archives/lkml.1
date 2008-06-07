Return-Path: <linux-kernel-owner+w=401wt.eu-S933752AbYFGBbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbYFGBbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932377AbYFGBPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:15:23 -0400
Received: from sous-sol.org ([216.99.217.87]:51068 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762615AbYFGBPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:15:20 -0400
Message-Id: <20080607010609.714244995@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cedric Le Goater <clg@fr.ibm.com>, "Paul Menage" <menage@google.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [patch 20/50] cgroups: remove node_ prefix_from ns subsystem
Content-Disposition: inline; filename=cgroups-remove-node_-prefix_from-ns-subsystem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Cedric Le Goater <clg@fr.ibm.com>

upstream commit: 5c02b575780d0d785815a1e7b79a98edddee895a

This is a slight change in the namespace cgroup subsystem api.

The change is that previously when cgroup_clone() was called (currently
only from the unshare path in ns_proxy cgroup, you'd get a new group named
"node_$pid" whereas now you'll get a group named after just your pid.)

The only users who would notice it are those who are using the ns_proxy
cgroup subsystem to auto-create cgroups when namespaces are unshared -
something of an experimental feature, which I think really needs more
complete container/namespace support in order to be useful.  I suspect the
only users are Cedric and Serge, or maybe a few others on
containers@lists.linux-foundation.org.  And in fact it would only be
noticed by the users who make the assumption about how the name is
generated, rather than getting it from the /proc/<pid>/cgroups file for
the process in question.

Whether the change is actually needed or not I'm fairly agnostic on, but I
guess it is more elegant to just use the pid as the new group name rather
than adding a fairly arbitrary "node_" prefix on the front.

[menage@google.com: provided changelog]
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2808,7 +2808,7 @@ int cgroup_clone(struct task_struct *tsk
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
-	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
+	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
 
 	/* Pin the hierarchy */
 	atomic_inc(&parent->root->sb->s_active);

-- 
