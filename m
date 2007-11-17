Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXKQIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXKQIfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 03:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXKQIe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 03:34:59 -0500
Received: from delta.dailydns.net ([204.16.247.150]:49772 "EHLO
	delta.dailydns.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXKQIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:34:58 -0500
Date: Sat, 17 Nov 2007 10:34:52 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Aristeu Rozanski <aris@ruivo.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix a deadlock in set_rtc_mmss()
Message-ID: <20071117083452.GA8531@localdomain>
References: <20071115165528.GA25520@localdomain> <20071115183046.GD8068@cathedrallabs.org> <473D0DD9.3000600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D0DD9.3000600@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - delta.dailydns.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:26:17AM +0800, Li Zefan wrote:
> Aristeu Rozanski wrote:
> > Hello Dan,
> >> Patch is valid only for 2.6.23.x, guessing from the recent arch/ changes 
> >> in 2.6.24-rc.
> >>
> >> set_rtc_mmss() was used to be called from interrupt context in 2.6.22,
> >> however in 2.6.23, it is called from a timer context, where interrupts
> >> are enabled. This patch ensures that rtc_interrupt() won't dead-lock 
> >> with set_rtc_mmss().
> > 
> >> diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
> >> index 6241b50..8414236 100644
> >> --- a/arch/x86_64/kernel/time.c
> >> +++ b/arch/x86_64/kernel/time.c
> >> @@ -87,13 +87,14 @@ static int set_rtc_mmss(unsigned long nowtime)
> >>  	int retval = 0;
> >>  	int real_seconds, real_minutes, cmos_minutes;
> >>  	unsigned char control, freq_select;
> >> +	unsigned long flags;
> >>  
> >>  /*
> >>   * IRQs are disabled when we're called from the timer interrupt,
> >>   * no need for spin_lock_irqsave()
> >>   */
> >>  
> >> -	spin_lock(&rtc_lock);
> >> +	spin_lock_irqsave(&rtc_lock, flags);
> > I think it's a good idea to update or just remove the comment above.
> > 
> 
> David P. Reed has sent a patch to fix this bug before you.
> 
> http://lkml.org/lkml/2007/11/14/435

Yes, missed by a day. Although that patch was aimed for 2.6.24-rc, 
I am currently more concerned about the 2.6.23.x tree.

Greg, can this be added to 2.6.23-stable?

Signed-off-by: Dan Aloni <da-x@monatomic.org>

---
commit 26c05aa66d10e95de63d95a348023ada4827ceed
tree 7c12f2b35fcba31c9f62ba278b9d232406f80e83
parent ad1765c56c2178a09e87d123548a35f221e1fc05
author Dan Aloni <da-x@monatomic.org> Sat, 17 Nov 2007 10:31:01 +0200
committer Dan Aloni <da-x@monatomic.org> Sat, 17 Nov 2007 10:31:01 +0200

 arch/x86_64/kernel/time.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 6d48a4e..fde5796 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -87,13 +87,9 @@ static int set_rtc_mmss(unsigned long nowtime)
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
+	unsigned long flags;
 
-/*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
- */
-
-	spin_lock(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 
 /*
  * Tell the clock it's being set and stop it.
@@ -143,7 +139,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return retval;
 }


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
