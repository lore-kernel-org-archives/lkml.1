Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYGDF4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYGDF4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 01:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYGDFz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 01:55:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbYGDFz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 01:55:58 -0400
Message-ID: <486DBB07.5050104@cn.fujitsu.com>
Date: Fri, 04 Jul 2008 13:54:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] devcgroup: fix odd behaviour when writing 'a' to devices.allow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # cat /devcg/devices.list
 a *:* rwm
 # echo a > devices.allow
 # cat /devcg/devices.list
 a *:* rwm
 a 0:0 rwm

This is odd and maybe confusing. With this patch, writing 'a'
to devices.allow will add 'a *:* rwm' to the whitelist.

Also a few fixes and updates to the document.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/controllers/devices.txt |    8 ++++++--
 security/device_cgroup.c              |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/controllers/devices.txt b/Documentation/controllers/devices.txt
index 4dcea42..7cc6e6a 100644
--- a/Documentation/controllers/devices.txt
+++ b/Documentation/controllers/devices.txt
@@ -13,7 +13,7 @@ either an integer or * for all.  Access is a composition of r
 The root device cgroup starts with rwm to 'all'.  A child device
 cgroup gets a copy of the parent.  Administrators can then remove
 devices from the whitelist or add new entries.  A child cgroup can
-never receive a device access which is denied its parent.  However
+never receive a device access which is denied by its parent.  However
 when a device access is removed from a parent it will not also be
 removed from the child(ren).
 
@@ -29,7 +29,11 @@ allows cgroup 1 to read and mknod the device usually known as
 
 	echo a > /cgroups/1/devices.deny
 
-will remove the default 'a *:* mrw' entry.
+will remove the default 'a *:* rwm' entry. Doing
+
+	echo a > /cgroups/1/devices.allow
+
+will add the 'a *:* rwm' entry to the whitelist.
 
 3. Security
 
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index baf3488..fd764a0 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -382,6 +382,8 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
 	case 'a':
 		wh.type = DEV_ALL;
 		wh.access = ACC_MASK;
+		wh.major = ~0;
+		wh.minor = ~0;
 		goto handle;
 	case 'b':
 		wh.type = DEV_BLOCK;
-- 
1.5.4.rc3
