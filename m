Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbZHDKZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbZHDKZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbZHDKZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:25:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54704 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbZHDKZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:25:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for 2.6.31 0/4] fix oom_adj regression v2
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Message-Id: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  4 Aug 2009 19:25:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 2ff05b2b (oom: move oom_adj value) move oom_adj value to mm_struct.
It is very good first step for sanitize OOM.

However Paul Menage reported the commit makes regression to his job scheduler.
Current OOM logic can kill OOM_DISABLED process.

Why? His program has the code of similar to the following.

	...
	set_oom_adj(OOM_DISABLE); /* The job scheduler never killed by oom */
	...
	if (vfork() == 0) {
		set_oom_adj(0); /* Invoked child can be killed */
		execve("foo-bar-cmd")
	}
	....

vfork() parent and child are shared the same mm_struct. then above set_oom_adj(0) doesn't
only change oom_adj for vfork() child, it's also change oom_adj for vfork() parent.
Then, vfork() parent (job scheduler) lost OOM immune and it was killed.

Actually, fork-setting-exec idiom is very frequently used in userland program. We must
not break this assumption.

This patch series are slightly big, but we must fix any regression soon.



Sorting out OOM requirements:
-----------------------
  - select_bad_process() must select killable process.
    otherwise OOM might makes following livelock.
      1. select_bad_process() select unkillable process
      2. oom_kill_process() do no-op and return.
      3. exit out_of_memory and makes next OOM soon. then, goto 1 again.
  - vfork parent and child must not shared oom_adj.


My proposal
-----------------------
  - oom_adj become per-process property. it have been documented long time.
    but the implementaion was not correct.
  - oom_score also become per-process property. it makes oom logic simpler and faster.
  - remove bogus vfork() parent killing logic





