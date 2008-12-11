Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYLKPur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYLKPur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYLKPui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:50:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43837 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbYLKPuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:50:37 -0500
Date: Thu, 11 Dec 2008 09:50:27 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: torvalds@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, stable@kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 1/1] devices cgroup: allow mkfifo
Message-ID: <20081211155027.GB12750@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devcgroup_inode_permission() hook in the devices whitelist
cgroup has always bypassed access checks on fifos.  But the
mknod hook did not.  The devices whitelist is only about block
and char devices, and fifos can't even be added to the whitelist,
so fifos can't be created at all except by tasks which have 'a'
in their whitelist (meaning they have access to all devices).

Fix the behavior by bypassing access checks to mkfifo (and mksock).

(Thanks, Daniel, for finding this)

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 5ba7870..df9d491 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -513,6 +513,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
+	if (!S_ISBLK(mode) && !S_ISCHR(mode))
+		return 0;
+
 	rcu_read_lock();
 
 	dev_cgroup = task_devcgroup(current);
-- 
1.5.4.3

