Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYISSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYISSGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYISSGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:06:47 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42838 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYISSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hxEjttADfF3qcT7/Wy8UWabRAvQZkr2CxtBw+zQE3OnB4/cdUCeZMlfNSRWdRpWnZU
         P7RBtg9Wu4aK71lZWv3IOWgxVODgAc2Z2lEl/H47HA4PApNyu2d/xc9AVZDjeNonVyJ+
         uFcZ5UDF+H5O8EpC6wxAyeZuhXzvVtwNK7ZpE=
Message-ID: <2137b82d0809191106x7822f788k390b4c57e6ce5eb7@mail.gmail.com>
Date: Fri, 19 Sep 2008 11:06:45 -0700
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

Signed-off-by: Chad Zanonie <chad.zanonie@gmail.com>

Possibility exists for an exiting application to be in between
marking its mm NULL and calling mmput when out_of_memory is
invoked. select_bad_process() will continue past this process as
opposed to returning -1UL due to its mm being NULL. This causes
the oom killer in certain scenarios to not only kill the memory
culprit, but also kill the runner up.

EXIT_DEAD seems to be the only flag that guarantees that mmput()
has finished. Checking for PF_KTHREAD should replace p->mm
regardless. Adding EXIT_DEAD to the check seems to prevent
unnecessary kills in local testing.


diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 64e5b4b..ad3928a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -216,7 +216,7 @@ static struct task_struct
*select_bad_process(unsigned long *ppoints,
                * skip kernel threads and tasks which have already
released
                * their mm.
                */
-               if (!p->mm)
+               if (p->flags & PF_KTHREAD || p->flags & EXIT_DEAD)
                       continue;
               /* skip the init task */
               if (is_global_init(p))
