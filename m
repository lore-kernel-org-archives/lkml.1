Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbYDYTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbYDYTYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYDYTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:24:10 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:43321 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbYDYTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:24:09 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2008 15:24:08 EDT
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:Date:
   Message-Id:From:To:Cc:Subject:Content-Type:
   Content-Transfer-Encoding;
  b=s2CW0qKSEH3wnkNZCaxkDREYa78zt36UxtE+/KAxStcpb8NFTKzfXx7t
   n56s/pZo4U3tit3oI6QJG+bNQ6nldgZYuG33Tr59BrruV939q+MuQk/m1
   ehmRun+kV1643Jt;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.25,707,1199660400"; 
   d="scan'208";a="10892473"
Date: Fri, 25 Apr 2008 21:14:06 +0200
Message-Id: <200804251914.m3PJE61B001189@plim.pdb.fsc.net>
From: bstroesser@fujitsu-siemens.com
To: linux-kernel@vger.kernel.org
Cc: bstroesser@fujitsu-siemens.com
Subject: hrtimer: timeout too long when using HRTIMER_CB_SOFTIRQ
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3PJOPEB010018

There seems to be a bug in hrtimer, when callback is handledin softirq. Sometimes clockevent is missing, so timers aredefered. The patch is for 2.5.22.5, but the problem seems topersist in 2.6.25.
Please CC me, I'm not on the list.
Best regardsBodo

============================================================When using hrtimer with timer->cb_mode == HRTIMER_CB_SOFTIRQin some cases the clockevent is not programmed.This happens, if: - a timer is rearmed while it's state is HRTIMER_STATE_CALLBACK - hrtimer_reprogram() returns -ETIME, when it is called after   CALLBACK is finished. This occurs if the new timer->expires   is in the past when CALLBACK is done.In this case, the timer needs to be removed from the tree and putonto the pending list again.
The patch is against 2.6.22.5, but AFAICS, it is relevantfor 2.6.25 also (in run_hrtimer_pending()).
Signed-off-by: Bodo Stroesser <bstroesser@fujitsu-siemens.com>--- kernel/hrtimer.c |   15 +++++++++++++-- 1 file changed, 13 insertions(+), 2 deletions(-)
Index: linux-2.6.22.5-31/kernel/hrtimer.c===================================================================--- linux-2.6.22.5-31.orig/kernel/hrtimer.c+++ linux-2.6.22.5-31/kernel/hrtimer.c@@ -1124,8 +1124,19 @@ static void run_hrtimer_softirq(struct s 			 * If the timer was rearmed on another CPU, reprogram 			 * the event device. 			 */-			if (timer->base->first == &timer->node)-				hrtimer_reprogram(timer, timer->base);+			struct hrtimer_clock_base *base = timer->base;++			if (base->first == &timer->node &&+			    hrtimer_reprogram(timer, base)) {+				/*+				 * Timer is expired. Thus move it from tree to+				 * pending list again.+				 */+				__remove_hrtimer(timer, base,+						 HRTIMER_STATE_PENDING, 0);+				list_add_tail(&timer->cb_entry,+					      &base->cpu_base->cb_pending);+			} 		} 	} 	spin_unlock_irq(&cpu_base->lock);ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
