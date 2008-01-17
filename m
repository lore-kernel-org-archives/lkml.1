Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYAQAaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYAQAaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYAQAaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:30:00 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:35316 "EHLO
	laptop.nigel.suspend2.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752487AbYAQA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:29:59 -0500
Message-ID: <478EA17B.30601@nigel.suspend2.net>
Date: Thu, 17 Jan 2008 11:29:47 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       TuxOnIce-devel <tuxonice-devel@lists.tuxonice.net>
Subject: [PATCH] (2.4.25 material?) Fix unbalanced helper_lock in kernel/kmod.c
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------010902060709000307020500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010902060709000307020500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all.

First up, sorry for not inlining the patch - trouble with line wrapping.

In 2.6.24-rc8, call_usermodehelper_exec has an exit path that can leave
the helper_lock() call at the top of the routine unbalanced. The
attached patch fixes this issue.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>




--------------010902060709000307020500
Content-Type: text/x-patch;
 name="helper-lock-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="helper-lock-fix.patch"

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
 


--------------010902060709000307020500--
