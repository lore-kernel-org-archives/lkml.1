Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbYI2XKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbYI2XKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYI2XKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:10:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:29887 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYI2XKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YhfOCFlINGgDjxbhjO4ToeY/Nj+cyQJtFUgnJ66yq7Z8MjuMKrVfmmZVWkVUdqoU9s
         OwV9SozpukIXzuRC/wcChI9Hurpvx6d0otJ4iS1Rr1OvfdvjqqCvFcS4wHe7dpKRH1Wb
         HaW59CGX4k1Gr4lHrGjsWrZ7nDV/Ym1cwCQTg=
Message-ID: <2137b82d0809291609w3a888087j8aec348345a6f076@mail.gmail.com>
Date: Mon, 29 Sep 2008 16:09:59 -0700
From: "Chad Zanonie" <chad.zanonie@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] oom-killer kills more than needed
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chad Zanonie

This mod firstly replaces a !p->mm check with PF_KTHREAD to more
accurately identify
kthreads. Secondly, it adds a (p->state & TASK_DEAD) check to identify processes
that have released their mm entirely.  Not waiting for a process to finish
releasing its memory entirely can cause the OOM killer to kill another
application unnecessarily (while p->mm is null but memory isn't yet available).


diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 64e5b4b..f325a87 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -216,7 +216,7 @@ static struct task_struct
*select_bad_process(unsigned long *ppoints,
                 * skip kernel threads and tasks which have already released
                 * their mm.
                 */
-               if (!p->mm)
+               if (p->flags & PF_KTHREAD || p->state & TASK_DEAD)
                        continue;
                /* skip the init task */
                if (is_global_init(p))
