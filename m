Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZAZST4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZAZST4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZAZSTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:19:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:52025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZAZSTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:19:21 -0500
Message-ID: <497DFEA4.4040101@vlnb.net>
Date: Mon, 26 Jan 2009 21:19:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net
Subject: [PATCH][SCST]: Fix for minor scst_user race
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19bLjtcVmEqV65Xi9avVlrDrHVNTTQAPNfC5Ph
 jf6KI+G6MxTu1GKG1EmaIJ6ZkdcpoADOxlkCC4DIU+186yPMYm
 L/ckH8u9XFMIYH6GkyRmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed race in scst_user module, which can lead to usage of already freed
command. A misbehaving user space handler can make ucmd to get dead immediately
after the lock is released and we should catch it.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 scst_user.c |    8 ++++++--
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: scst/src/dev_handlers/scst_user.c
===================================================================
--- scst/src/dev_handlers/scst_user.c	(revision 641)
+++ scst/src/dev_handlers/scst_user.c	(working copy)
@@ -1721,6 +1729,7 @@ static int dev_user_reply_get_cmd(struct
 	kmem_cache_free(user_get_cmd_cachep, cmd);
 
 	spin_lock_irq(&dev->cmd_lists.cmd_list_lock);
+again:
 	res = dev_user_get_next_cmd(dev, &ucmd);
 	if (res == 0) {
 		int len;
@@ -1730,12 +1739,15 @@ static int dev_user_reply_get_cmd(struct
 		 * copy of dead data to the user space, which can lead to a
 		 * leak of sensitive information.
 		 */
-		ucmd_get(ucmd);
+		if (unlikely(ucmd_get_check(ucmd))) {
+			/* Oops, this ucmd is already being destroyed. Retry. */
+			goto again;
+		}
 		spin_unlock_irq(&dev->cmd_lists.cmd_list_lock);
 
 		EXTRACHECKS_BUG_ON(ucmd->user_cmd_payload_len == 0);

