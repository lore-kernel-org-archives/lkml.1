Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYHKXyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYHKXyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbYHKXxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:53:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38928 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbYHKXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:53:40 -0400
Message-Id: <20080811235325.485466148@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 16:53:27 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 4/5] Container Freezer: Skip frozen cgroups during power management resume
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a system is resumed after a suspend, it will also unfreeze
frozen cgroups.

This patchs modifies the resume sequence to skip the tasks which
are part of a frozen control group.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/power/process.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.27-rc1-mm1/kernel/power/process.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/power/process.c
+++ linux-2.6.27-rc1-mm1/kernel/power/process.c
@@ -135,6 +135,9 @@ static void thaw_tasks(bool nosig_only)
 		if (nosig_only && should_send_signal(p))
 			continue;
 
+		if (cgroup_frozen(p))
+			continue;
+
 		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);

-- 
