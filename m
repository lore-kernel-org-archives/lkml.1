Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbXK3NKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbXK3NKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXK3NKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:10:06 -0500
Received: from sacred.ru ([62.205.161.221]:49370 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbXK3NKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:10:04 -0500
Message-ID: <47500BA3.60301@openvz.org>
Date: Fri, 30 Nov 2007 16:09:55 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 3/7][SYSVIPC] Use the ctl paths to register tables
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:09:53 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theoretically, IPC sysctl variables may be in different 
namespaces and we have to register an appropriate ctl root
and new tables for each namespace.

On the other hand, the sysctl names do not differ from
namespace to namespace, and we already tuned the IPC
sysctl code to handle the multy-namespace variables. 

I think, that registering tables for each namespace is
just a waste of kernel memory and unneeded code. Thus, 
I just switch the IPC code to use the paths and keep 
current namespaces management code as is.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 7f4235b..705fd82 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -161,19 +161,17 @@ static struct ctl_table ipc_kern_table[] = {
 	{}
 };
 
-static struct ctl_table ipc_root_table[] = {
+static struct ctl_path ipc_root_path[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= ipc_kern_table,
+		.ctl_name	= CTL_KERN,
 	},
 	{}
 };
 
 static int __init ipc_sysctl_init(void)
 {
-	register_sysctl_table(ipc_root_table);
+	register_sysctl_paths(ipc_root_path, ipc_kern_table);
 	return 0;
 }
 
-- 
1.5.3.4

