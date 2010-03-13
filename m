Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935380Ab0CMAbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:31:09 -0500
Received: from kroah.org ([198.145.64.141]:46604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935318Ab0CMAaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:35 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.935225811@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>
Subject: [008/145] memcg: fix oom killing a child process in an other cgroup
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 5a2d41961dd6815b874b5c0afec0ac96cd90eea4 upstream.

Presently the oom-killer is memcg aware and it finds the worst process
from processes under memcg(s) in oom.  Then, it kills victim's child
first.

It may kill a child in another cgroup and may not be any help for
recovery.  And it will break the assumption users have.

This patch fixes it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -426,6 +426,8 @@ static int oom_kill_process(struct task_
 	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
+		if (mem && !task_in_mem_cgroup(c, mem))
+			continue;
 		if (!oom_kill_task(c))
 			return 0;
 	}


