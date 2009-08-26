Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZHZFGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZHZFGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZHZFGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:06:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51784 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbZHZFGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:06:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Linux 2.6.31-rc7
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <10f740e80908230356j4622a042nb83da4952f940b2@mail.gmail.com>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <10f740e80908230356j4622a042nb83da4952f940b2@mail.gmail.com>
Message-Id: <20090826133307.394B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 26 Aug 2009 14:06:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Aug 22, 2009 at 03:26, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> > KOSAKI Motohiro (1):
> >      mm: revert "oom: move oom_adj value"
> 
> drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
> drivers/staging/android/lowmemorykiller.c:108: error: 'struct
> mm_struct' has no member named 'oom_adj'
> 
> I guess this one must be reverted as well?
> 
> commit a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b
> Author: David Rientjes <rientjes@google.com>
> Date:   Tue Jun 16 16:42:53 2009 -0700
> 
>     Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value fro
> 
>     I'm about to merge "oom: move oom_adj value from task_struct to
>     mm_struct", and this fixup is needed to repair linux-next's
>     drivers/staging/android/lowmemorykiller.c.
> 

Thank you for very kindly bug report.
Unfortunatelly I didn't notice this ugly crap driver.

Yes, you are right. it should be reverted too.


Linus, can you please consider to apply following revert patch?

============================================
Subject: [PATCH] Revert android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct"

commit 0753ba01 (mm: revert "oom: move oom_adj value") reverted some
regression patch. but it didn't revert one strange oom retrieved driver patch.

Then, it made build error on this android driver.

This reverts commit a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b too and
fixes the build error.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/staging/android/lowmemorykiller.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index f934393..fe72240 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -96,21 +96,19 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		if (!p->mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = mm->oom_adj;
+		oom_adj = p->oomkilladj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(mm);
+		tasksize = get_mm_rss(p->mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
-- 
1.6.2.5






