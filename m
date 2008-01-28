Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbYA1PKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbYA1PKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbYA1PKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:10:22 -0500
Received: from sacred.ru ([62.205.161.221]:49432 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbYA1PKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:10:20 -0500
Message-ID: <479DF05B.9020608@openvz.org>
Date: Mon, 28 Jan 2008 18:10:19 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 2/4] Pidns: fix badly converted mqueues pid handling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 28 Jan 2008 18:09:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending the pid namespaces patches I wrongly converted 
the tsk->tgid into task_pid_vnr(tsk) in mqueue-s (the git id
of this patch is b488893a390edfe027bae7a46e9af8083e740668).

The proper behavior is to get the task_tgid_vnr(tsk).

This seem to be the only mistake of that kind.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 ipc/mqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index eb3f489..b83e983 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -509,7 +509,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			sig_i.si_pid = task_pid_vnr(current);
+			sig_i.si_pid = task_tgid_vnr(current);
 			sig_i.si_uid = current->uid;
 
 			kill_pid_info(info->notify.sigev_signo,
-- 
1.5.3.4

