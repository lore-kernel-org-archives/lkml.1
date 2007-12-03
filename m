Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXLCJt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXLCJt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXLCJtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:49:22 -0500
Received: from sacred.ru ([62.205.161.221]:32980 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLCJtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:49:21 -0500
Message-ID: <4753D0F7.3020202@openvz.org>
Date: Mon, 03 Dec 2007 12:48:39 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH] Avoid potential NULL dereference in unregister_sysctl_table
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 03 Dec 2007 12:48:38 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register_sysctl_table() can return NULL sometimes, e.g. when
kmalloc() returns NULL or when sysctl check fails.

I've also noticed, that many (most?) code in the kernel doesn't check 
for the return value from register_sysctl_table() and later simply
calls the unregister_sysctl_table() with potentially NULL argument.

This is unlikely on a common kernel configuration, but in case we're 
dealing with modules and/or fault-injection support, there's a slight 
possibility of an OOPS.

Changing all the users to check for return code from the registering
does not look like a good solution - there are too many code doing this 
and failure in sysctl tables registration is not a good reason to abort
module loading (in most of the cases).

So I think, that we can just have this check in unregister_sysctl_table
just to avoid accidental OOPS-es (actually, the unregister_sysctl_table() 
did exactly this, before the start_unregistering() appeared).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a34545..8308b74 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1746,6 +1746,10 @@ struct ctl_table_header *register_sysctl_table(struct ctl_table *table)
 void unregister_sysctl_table(struct ctl_table_header * header)
 {
 	might_sleep();
+
+	if (header == NULL)
+		return;
+
 	spin_lock(&sysctl_lock);
 	start_unregistering(header);
 	spin_unlock(&sysctl_lock);
