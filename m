Return-Path: <linux-kernel-owner+w=401wt.eu-S1750884AbZK3FAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750884AbZK3FAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 00:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZK3FAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 00:00:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZK3FAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 00:00:16 -0500
Date: Sun, 29 Nov 2009 23:59:20 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@medozas.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Amerigo Wang <amwang@redhat.com>, James Morris <jmorris@namei.org>,
       akpm@linux-foundation.org, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <20091130050219.3897.55458.sendpatchset@localhost.localdomain>
Subject: [Patch] 'sysctl_max_map_count' should be non-negative
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jan Engelhardt reported we have this problem:

setting max_map_count to a value large enough results in programs dying
at first try.
This is on 2.6.31.6.

15:59 borg:/proc/sys/vm # echo $[1<<31-1] >max_map_count
15:59 borg:/proc/sys/vm # cat max_map_count
1073741824
15:59 borg:/proc/sys/vm # echo $[1<<31] >max_map_count
15:59 borg:/proc/sys/vm # cat max_map_count
Killed


This is because we have a chance to make 'max_map_count' negative.
but it's meaningless. Make it only accept non-negative values.

Reported-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: James Morris <jmorris@namei.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: stable@kernel.org

---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..212360e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1245,7 +1245,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= &proc_dointvec_minmax,
+		.extra1		= &zero,
 	},
 #else
 	{
