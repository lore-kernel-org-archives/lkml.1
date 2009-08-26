Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZHZJcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZHZJcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZHZJct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:32:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36589 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbZHZJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:32:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [mmotm][PATCH 0/4] per-process OOM kill v3
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090826182634.3968.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 26 Aug 2009 18:32:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog
  since v2
    - rebase to latest mmotm
    - fixed strstrip abuse
    - oom_adjust_write() use strict_strtol() instead simple_strtol()
    - remove unnecessary signal lock (pointed by Oleg)


--------------------------------------------------------
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

This patch moves oom_adj to signal_struct instead mm_struct. signal_struct is
shared by thread but isn't shared vfork.

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





