Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZHLMRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZHLMRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZHLMRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:17:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45626 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbZHLMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:17:47 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1249980905.27150.11.camel@pc1117.cambridge.arm.com>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
	 <20090802111453.GA24927@elte.hu>
	 <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
	 <20090810184527.GA9601@elte.hu>
	 <1249945003.26205.23.camel@pc1117.cambridge.arm.com>
	 <20090811073205.GA17476@elte.hu>
	 <1249980905.27150.11.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 12 Aug 2009 13:17:27 +0100
Message-Id: <1250079447.20332.27.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 12:17:28.0172 (UTC) FILETIME=[DBBCBAC0:01CA1B46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 2009-08-11 at 09:55 +0100, Catalin Marinas wrote:
> On Tue, 2009-08-11 at 09:32 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > I tried similar config and with the mainline kernel I get some 
> > > lockups (several seconds) with CONFIG_PREEMPT disabled on ARM 
> > > machines or x86 during a scanning episode but it eventually 
> > > completes the scanning. With the kmemleak patches for the next 
> > > merging window, I don't get any lockups as it has more 
> > > cond_resched() calls.
> > 
> > How big are those patches? Kmemleak is new in .31 so if it fixes a 
> > real problem it might still be acceptable.
> 
> My patches for -next were posted here -
> http://lkml.org/lkml/2009/7/24/166 - but the relevant ones are pretty
> small (review/ack is welcomed):
> 
> http://lkml.org/lkml/2009/7/24/176 - allow rescheduling during object
> scanning

I tried the kernel last night on x86 with most debug options enabled.
They slow down kmemleak considerably and scanning the memory while
rebuilding a kernel took several minutes with visible lockup (though it
eventually recovered).

Trying only the above patch to allow rescheduling during object scanning
seems to have eliminated those lockups. So maybe we can merge this now
and leave the task stacks for the upcoming window. I included the patch
below for review:


kmemleak: Allow rescheduling during an object scanning

From: Catalin Marinas <catalin.marinas@arm.com>

If the object size is bigger than a predefined value (4K in this case),
release the object lock during scanning and call cond_resched().
Re-acquire the lock after rescheduling and test whether the object is
still valid.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7e8e4b0..c665626 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -107,6 +107,7 @@
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
+#define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -950,10 +951,20 @@ static void scan_object(struct kmemleak_object *object)
 	if (!(object->flags & OBJECT_ALLOCATED))
 		/* already freed object */
 		goto out;
-	if (hlist_empty(&object->area_list))
-		scan_block((void *)object->pointer,
-			   (void *)(object->pointer + object->size), object, 0);
-	else
+	if (hlist_empty(&object->area_list)) {
+		void *start = (void *)object->pointer;
+		void *end = (void *)(object->pointer + object->size);
+
+		while (start < end && (object->flags & OBJECT_ALLOCATED)) {
+			scan_block(start, min(start + MAX_SCAN_SIZE, end),
+				   object, 0);
+			start += MAX_SCAN_SIZE;
+
+			spin_unlock_irqrestore(&object->lock, flags);
+			cond_resched();
+			spin_lock_irqsave(&object->lock, flags);
+		}
+	} else
 		hlist_for_each_entry(area, elem, &object->area_list, node)
 			scan_block((void *)(object->pointer + area->offset),
 				   (void *)(object->pointer + area->offset


Thanks.

-- 
Catalin

