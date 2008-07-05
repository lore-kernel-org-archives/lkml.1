Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYGEFlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYGEFlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 01:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYGEFlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 01:41:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63433 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbYGEFlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 01:41:21 -0400
Message-ID: <486F091C.8050803@cn.fujitsu.com>
Date: Sat, 05 Jul 2008 13:39:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH 2/2] devcgroup: fix permission check when adding entry to
 child cgroup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # cat devices.list
 c 1:3 r
 # echo 'c 1:3 w' > sub/devices.allow
 # cat sub/devices.list
 c 1:3 w

As illustrated, the parent group has no write permission to /dev/null,
so its child should not be allowed to add this write permission,
which is documented in Documentation/controllers/devices.txt.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 1e2e28a..ddd92ce 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -300,7 +300,7 @@ static int may_access_whitelist(struct dev_cgroup *c,
 			continue;
 		if (whitem->minor != ~0 && whitem->minor != refwh->minor)
 			continue;
-		if (refwh->access & (~(whitem->access | ACC_MASK)))
+		if (refwh->access & (~whitem->access))
 			continue;
 		return 1;
 	}
-- 
1.5.4.rc3
