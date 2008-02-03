Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYBCVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYBCVeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYBCVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:34:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:65043 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYBCVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hWhJxti8hWZSIGuugdxg3TM61yDbOT9Sj8tn19yhA67RjyyBzIHZjc1OIQUMu51X0Ymf7SMtwImHgdbPDRqee0Qwb4Mxvze0p1HmgTQOjzNCdjI9DXOizk0AyPKHafermiUOUqr4N7iL4yZKwSuYzMlEfNkhwtqd0CLJMHEmg1k=
Subject: Re: latencytop: optimize LT_BACKTRACEDEPTH loops a bit
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dmitry.adamushko@gmail.com
Content-Type: text/plain
Date: Sun, 03 Feb 2008 22:33:58 +0100
Message-Id: <1202074439.4765.7.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/02/2008, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Dmitry Adamushko wrote:
> > Subject: latencytop: optimize LT_BACKTRACEDEPTH loops a bit.
> >
> > It looks like there is no need to loop any longer when 'same == 0'.
> 
> thanks for the contribution!
> while I like your patch, I wonder if we should go even a little further in
> cleaning this up
> 
> > @@ -73,12 +73,12 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
> >                       continue;
> >               }
> >               for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
> > -                     if (latency_record[i].backtrace[q] !=
> > -                             lat->backtrace[q])
> > +                     unsigned long record = lat->backtrace[q];
> > 
> > +                     if (latency_record[i].backtrace[q] != record)
> >                               same = 0;
> > -                     if (same && lat->backtrace[q] == 0)
> > -                             break;
> > -                     if (same && lat->backtrace[q] == ULONG_MAX)
> > +
> > +                     if (!same || record == 0 || record == ULONG_MAX)
> >                               break;
> >               }
> 
> I mean, we could make it look like this:

Yeah, I had some doubts regarding the '!same' case. We'd probably be better off taking a decision (i.e. break)
from inside the first branch so to avoid the second one (I guess, it can be a bit more efficient,
wrt the CPU's branch-prediction logic).

what about this one instead?

(I'd prefer to have a single 'if' for 'record == 0 || record == ULONG_MAX',
it's just a matter of taste though)

---

Subject: latencytop: optimize LT_BACKTRACEDEPTH loops a bit.

It looks like there is no need to loop any longer when 'same == 0'.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index b4e3c85..5e4743d 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -64,8 +64,8 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 		return;
 
 	for (i = 0; i < MAXLR; i++) {
-		int q;
-		int same = 1;
+		int q, same = 1;
+
 		/* Nothing stored: */
 		if (!latency_record[i].backtrace[0]) {
 			if (firstnonnull > i)
@@ -73,12 +73,15 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 			continue;
 		}
 		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
-			if (latency_record[i].backtrace[q] !=
-				lat->backtrace[q])
+			unsigned long record = lat->backtrace[q];
+
+			if (latency_record[i].backtrace[q] != record) {
 				same = 0;
-			if (same && lat->backtrace[q] == 0)
 				break;
-			if (same && lat->backtrace[q] == ULONG_MAX)
+			}
+
+			/* 0 and ULONG_MAX entries denote the end of backtrace: */
+			if (record == 0 || record == ULONG_MAX)
 				break;
 		}
 		if (same) {
@@ -143,14 +146,18 @@ account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	for (i = 0; i < LT_SAVECOUNT ; i++) {
 		struct latency_record *mylat;
 		int same = 1;
+
 		mylat = &tsk->latency_record[i];
 		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
-			if (mylat->backtrace[q] !=
-				lat.backtrace[q])
+			unsigned long record = lat.backtrace[q];
+
+			if (mylat->backtrace[q] != record) {
 				same = 0;
-			if (same && lat.backtrace[q] == 0)
 				break;
-			if (same && lat.backtrace[q] == ULONG_MAX)
+			}
+
+			/* 0 and ULONG_MAX entries denote the end of backtrace: */
+			if (record == 0 || record == ULONG_MAX)
 				break;
 		}
 		if (same) {



-- 
Best regards,
Dmitry Adamushko


