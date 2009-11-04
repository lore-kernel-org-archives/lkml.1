Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZKDBkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZKDBkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZKDBkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:40:35 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:63756 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZKDBke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=fbRYLniTBtk/rAwkGagczylarAwUazjypRgwJajOXmesXxPqkcQ0YhOcz0KgXJHOCa
         BHM1zp4VNwJOLnLi05M1g6acPHrnglrYGA0uPAcy70uRaifx/pudNLVwr1R8qZXXhssN
         prwSnuSmyK/fGQUPda6OWJqZFEX/CdK8aXK/0=
MIME-Version: 1.0
Date: Wed, 4 Nov 2009 09:40:40 +0800
Message-ID: <b741c2440911031740m52f8c11dt6e57b549cc6ce465@mail.gmail.com>
Subject: [PATCH] cgroup: Fixes the un-paired cgroup lock problem
From: Liu Aleaxander <aleaxander@gmail.com>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Aleaxander <Aleaxander@gmail.com>
Date: Wed, 4 Nov 2009 09:27:06 +0800
Subject: [PATCH] Fixes the un-paired cgroup lock problem

In cgroup_lock_live_group, it locks the cgroup by mutex_lock, while in the
cgroup_tasks_write, it unlock it by cgroup_unlock. Even though they are
equal, but I do think we should make it pair.

BTW, should we replace others with cgroup_lock and cgroup_unlock?
Since we already have a wrapper one and it's meaningful.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0249f4b..ee2274e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1660,9 +1660,9 @@ static int cgroup_tasks_write(struct cgroup
*cgrp, struct cftype *cft, u64 pid)
  */
 bool cgroup_lock_live_group(struct cgroup *cgrp)
 {
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	if (cgroup_is_removed(cgrp)) {
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return false;
 	}
 	return true;
-- 
1.6.2.5

-- 
regards
Liu Aleaxander
