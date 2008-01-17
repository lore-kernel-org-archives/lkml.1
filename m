Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYAQSB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYAQSB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYAQSAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:00:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYAQSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:00:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [PATCH] (2.4.25 material?) Fix unbalanced helper_lock in kernel/kmod.c
Date: Thu, 17 Jan 2008 19:02:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       TuxOnIce-devel <tuxonice-devel@lists.tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
References: <478EA17B.30601@nigel.suspend2.net>
In-Reply-To: <478EA17B.30601@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171902.44133.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of January 2008, Nigel Cunningham wrote:
> Hi all.

Hi,

> First up, sorry for not inlining the patch - trouble with line wrapping.

No big deal.

> In 2.6.24-rc8, call_usermodehelper_exec has an exit path that can leave
> the helper_lock() call at the top of the routine unbalanced. The
> attached patch fixes this issue.

Thanks a lot for the patch (reproduced below), I think it's 2.6.24 material.
Andrew?

> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

---
From: Nigel Cunningham <nigel@tuxonice.net>

In 2.6.24-rc8, call_usermodehelper_exec has an exit path that can leave
the helper_lock() call at the top of the routine unbalanced.  Fix it.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
diff --git a/kernel/kmod.c b/kernel/kmod.c
index c6a4f8a..de27e15 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -468,8 +468,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
+	if (wait == UMH_NO_WAIT) { /* task has freed sub_info */
+		helper_unlock();
 		return 0;
+	}
 	wait_for_completion(&done);
 	retval = sub_info->retval;
 

