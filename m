Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbXKULHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbXKULHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXKULH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:07:26 -0500
Received: from sacred.ru ([62.205.161.221]:57583 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbXKULHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:07:25 -0500
Message-ID: <4744113B.5010309@openvz.org>
Date: Wed, 21 Nov 2007 14:06:35 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH] Isolate the UTS namespace's domainname and hostname back
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 21 Nov 2007 14:06:36 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commit

commit 7d69a1f4a72b18876c99c697692b78339d491568
Author: Cedric Le Goater <clg@fr.ibm.com>
Date:   Sun Jul 15 23:40:58 2007 -0700

    remove CONFIG_UTS_NS and CONFIG_IPC_NS

accidentally removed the code, that prevented the uts->hostname
and uts->domainname values from being overwritten from another
namespace. In other words, setting hostname/domainname via sysfs 
(echo xxx > /proc/sys/kernel/(host|domain)name) cased the new
value to be set in init UTS namespace only.

Return the isolation back.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index c76c064..fe3a56c 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -18,6 +18,10 @@
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
+	struct uts_namespace *uts_ns;
+
+	uts_ns = current->nsproxy->uts_ns;
+	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
 
 	if (!write)
 		down_read(&uts_sem);
