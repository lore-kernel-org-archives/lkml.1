Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYEFLCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYEFLCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYEFLCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:02:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45340 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYEFLCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:02:40 -0400
Date: Tue, 06 May 2008 20:02:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] mm/cgroup.c add error check
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on heavy workload, call_usermodehelper() may failure
because it use kzmalloc(GFP_ATOMIC).

but userland want receive release notificcation even heavy workload.

thus, We should retry if -ENOMEM happend.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Paul Menage" <menage@google.com>
CC: Li Zefan <lizf@cn.fujitsu.com>

---
 kernel/cgroup.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/kernel/cgroup.c
===================================================================
--- a/kernel/cgroup.c   2008-04-29 18:00:53.000000000 +0900
+++ b/kernel/cgroup.c   2008-05-06 20:28:23.000000000 +0900
@@ -3072,6 +3072,8 @@ void __css_put(struct cgroup_subsys_stat
  */
 static void cgroup_release_agent(struct work_struct *work)
 {
+       int err;
+
        BUG_ON(work != &release_agent_work);
        mutex_lock(&cgroup_mutex);
        spin_lock(&release_list_lock);
@@ -3111,7 +3113,13 @@ static void cgroup_release_agent(struct
                 * since the exec could involve hitting disk and hence
                 * be a slow process */
                mutex_unlock(&cgroup_mutex);
-               call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+
+retry:
+               err = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+               if (err == -ENOMEM) {
+                       schedule();
+                       goto retry;
+               }
                kfree(pathbuf);
                mutex_lock(&cgroup_mutex);
                spin_lock(&release_list_lock);



