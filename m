Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYGEGc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYGEGc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYGEGcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:32:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbYGEGcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:32:19 -0400
Message-ID: <486F1509.4020509@cn.fujitsu.com>
Date: Sat, 05 Jul 2008 14:30:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH] devcgroup: code cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove a redundant memset()
- use simple_strtoul() to parse major/minor

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index ddd92ce..98826b0 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -188,7 +188,7 @@ static struct cgroup_subsys_state *devcgroup_create(struct cgroup_subsys *ss,
 		}
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
-		wh->access = ACC_MKNOD | ACC_READ | ACC_WRITE;
+		wh->access = ACC_MASK;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
@@ -250,7 +250,6 @@ static char type_to_char(short type)
 
 static void set_majmin(char *str, unsigned m)
 {
-	memset(str, 0, MAJMINLEN);
 	if (m == ~0)
 		sprintf(str, "*");
 	else
@@ -405,11 +404,7 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = 0;
-		while (isdigit(*b)) {
-			wh.major = wh.major*10+(*b-'0');
-			b++;
-		}
+		wh.major = simple_strtoul(b, &b, 0);
 	} else {
 		retval = -EINVAL;
 		goto out2;
@@ -425,11 +420,7 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = 0;
-		while (isdigit(*b)) {
-			wh.minor = wh.minor*10+(*b-'0');
-			b++;
-		}
+		wh.minor = simple_strtoul(b, &b, 0);
 	} else {
 		retval = -EINVAL;
 		goto out2;
-- 
1.5.4.rc3
