Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYDJI07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYDJI07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYDJI0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:26:49 -0400
Received: from sacred.ru ([62.205.161.221]:38034 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYDJI0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:26:49 -0400
Message-ID: <47FDD326.8070105@openvz.org>
Date: Thu, 10 Apr 2008 12:43:18 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/10] Pidns: use kzalloc to allocate new pid namespace
References: <47FDD267.80700@openvz.org>
In-Reply-To: <47FDD267.80700@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 10 Apr 2008 12:18:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes many fields initialization implicit, fixes void * = 0
(the ns->pidmap[i].page = 0) noise and will help in auto-setting 
to NULL bsd-acct related field.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/pid_namespace.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index cb17497..06331cc 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -71,7 +71,7 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
 	struct pid_namespace *ns;
 	int i;
 
-	ns = kmem_cache_alloc(pid_ns_cachep, GFP_KERNEL);
+	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
 
@@ -84,17 +84,13 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
 		goto out_free_map;
 
 	kref_init(&ns->kref);
-	ns->last_pid = 0;
-	ns->child_reaper = NULL;
 	ns->level = level;
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
 
-	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = 0;
+	for (i = 1; i < PIDMAP_ENTRIES; i++)
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
-	}
 
 	return ns;
 
-- 
1.5.3.4

