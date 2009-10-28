Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbZJ1JBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbZJ1JBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbZJ1JBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:01:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37634 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739AbZJ1JBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:01:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 17:58:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       aarcange@redhat.com, vedran.furac@gmail.com,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] oom_kill: use rss value instead of vm size for badness
Message-Id: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I may add more tweaks based on this. But simple start point as this patch
will be good. This patch is based on mmotm + Kosaki's
http://marc.info/?l=linux-kernel&m=125669809305167&w=2

Test results on various environment are appreciated.

Regards.
-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's reported that OOM-Killer kills Gnone/KDE at first...
And yes, we can reproduce it easily.

Now, oom-killer uses mm->total_vm as its base value. But in recent
applications, there are a big gap between VM size and RSS size.
Because
  - Applications attaches much dynamic libraries. (Gnome, KDE, etc...)
  - Applications may alloc big VM area but use small part of them.
    (Java, and multi-threaded applications has this tendency because
     of default-size of stack.)

I think using mm->total_vm as score for oom-kill is not good.
By the same reason, overcommit memory can't work as expected.
(In other words, if we depends on total_vm, using overcommit more positive
 is a good choice.)

This patch uses mm->anon_rss/file_rss as base value for calculating badness.

Following is changes to OOM score(badness) on an environment with 1.6G memory
plus memory-eater(500M & 1G).

Top 10 of badness score. (The highest one is the first candidate to be killed)
Before
badness program
91228	gnome-settings-
94210	clock-applet
103202	mixer_applet2
106563	tomboy
112947	gnome-terminal
128944	mmap              <----------- 500M malloc
129332	nautilus
215476	bash              <----------- parent of 2 mallocs.
256944	mmap              <----------- 1G malloc
423586	gnome-session

After
badness 
1911	mixer_applet2
1955	clock-applet
1986	xinit
1989	gnome-session
2293	nautilus
2955	gnome-terminal
4113	tomboy
104163	mmap             <----------- 500M malloc.
168577	bash             <----------- parent of 2 mallocs
232375	mmap             <----------- 1G malloc

seems good for me. 

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/oom_kill.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: mm-test-kernel/mm/oom_kill.c
===================================================================
--- mm-test-kernel.orig/mm/oom_kill.c
+++ mm-test-kernel/mm/oom_kill.c
@@ -93,7 +93,7 @@ unsigned long badness(struct task_struct
 	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
-	points = mm->total_vm;
+	points = get_mm_counter(mm, anon_rss) + get_mm_counter(mm, file_rss);
 
 	/*
 	 * After this unlock we can no longer dereference local variable `mm'
@@ -116,8 +116,12 @@ unsigned long badness(struct task_struct
 	 */
 	list_for_each_entry(child, &p->children, sibling) {
 		task_lock(child);
-		if (child->mm != mm && child->mm)
-			points += child->mm->total_vm/2 + 1;
+		if (child->mm != mm && child->mm) {
+			unsigned long cpoints;
+			cpoints = get_mm_counter(child->mm, anon_rss);
+				  + get_mm_counter(child->mm, file_rss);
+			points += cpoints/2 + 1;
+		}
 		task_unlock(child);
 	}
 

