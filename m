Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYLJP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYLJP5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYLJP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:57:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59946 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYLJP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:57:37 -0500
Date: Wed, 10 Dec 2008 09:57:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 1/1] devices cgroup: allow mkfifo
Message-ID: <20081210155721.GA15166@us.ibm.com>
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

Fix the behavior by bypassing access checks to mkfifo.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
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

