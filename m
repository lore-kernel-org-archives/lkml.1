Return-Path: <linux-kernel-owner+w=401wt.eu-S939610AbXHJSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939610AbXHJSci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765853AbXHJScM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:32:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762039AbXHJScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:32:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:content-type:organization:date:
	message-id:mime-version:x-mailer:content-transfer-encoding;
	b=QFwOJlxxuAVz5nrIdc/k7/NHYNHizF5z7PCR4a9AaC+970tQIciHTBDC5HohMZYuQ
	Xe7R/bbb80+IfhLv0mUfw==
Subject: [PATCH 2.6.23-rc2] getrusage: return ru_maxrss
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 10 Aug 2007 11:31:51 -0700
Message-Id: <1186770711.18535.9.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fill in ru_maxrss by, for RUSAGE_BOTH or RUSAGE_CHILDREN, walking the
list of children and summing the hiwater_rss for each.  For RUSAGE_BOTH
or RUSAGE_SELF also include the hiwater_rss for the calling process.

diff --git a/kernel/sys.c b/kernel/sys.c
index 449b81b..71b2850 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2101,6 +2101,19 @@ static void k_getrusage(struct task_stru
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
 
+			read_lock(&tasklist_lock);
+			list_for_each(_p, &p->children) {
+				struct task_struct *mp;
+
+				mp = list_entry(_p, struct task_struct, sibling);
+				mm = get_task_mm(mp);
+				hiwater_rss = get_mm_rss(mm);
+				if (hiwater_rss < mm->hiwater_rss)
+					hiwater_rss = mm->hiwater_rss;
+				r->ru_maxrss += hiwater_rss;
+			}
+			read_unlock(&tasklist_lock);
+
 			if (who == RUSAGE_CHILDREN)
 				break;
 
@@ -2125,6 +2138,11 @@ static void k_getrusage(struct task_stru
 				r->ru_oublock += task_io_get_oublock(t);
 				t = next_thread(t);
 			} while (t != p);
+			mm = get_task_mm(p);
+			hiwater_rss = get_mm_rss(mm);
+			if (hiwater_rss < mm->hiwater_rss)
+				hiwater_rss = mm->hiwater_rss;
+			r->ru_maxrss += hiwater_rss;
 			break;
 
 		default:
---

Like a number of other folks, we recently had a need for a non-/proc way
of getting the RSS of a process and happened on getrusage().  Unlike the
rest, though, we fixed the system call to do what we want.

The code itself was lifted from task_mem() in proc/task_mmu.c.  The only
questionable bit is where it does the read_lock() of the tasklist_lock;
although it seems safe enough, I would appreciate if those more
knowledgeable about that locking vet it (briefly) for safety.

Signed-off-by:  Frank Mayhar <fmayhar@google.com>
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

