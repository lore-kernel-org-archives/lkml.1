Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYGAPXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYGAPXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbYGAPWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:43324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbYGAPWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:22 -0400
Date: Tue, 1 Jul 2008 08:19:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 6/9] sched: fix cpu hotplug
Message-ID: <20080701151913.GG3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-cpu-hotplug.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Commit 79c537998d143b127c8c662a403c3356cb885f1c upstream

the CPU hotplug problems (crashes under high-volume unplug+replug
tests) seem to be related to migrate_dead_tasks().

Firstly I added traces to see all tasks being migrated with
migrate_live_tasks() and migrate_dead_tasks(). On my setup the problem
pops up (the one with "se == NULL" in the loop of
pick_next_task_fair()) shortly after the traces indicate that some has
been migrated with migrate_dead_tasks()). btw., I can reproduce it
much faster now with just a plain cpu down/up loop.

[disclaimer] Well, unless I'm really missing something important in
this late hour [/desclaimer] pick_next_task() is not something
appropriate for migrate_dead_tasks() :-)

the following change seems to eliminate the problem on my setup
(although, I kept it running only for a few minutes to get a few
messages indicating migrate_dead_tasks() does move tasks and the
system is still ok)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5728,6 +5728,7 @@ static void migrate_dead_tasks(unsigned 
 		next = pick_next_task(rq, rq->curr);
 		if (!next)
 			break;
+		next->sched_class->put_prev_task(rq, next);
 		migrate_dead(dead_cpu, next);
 
 	}

-- 
