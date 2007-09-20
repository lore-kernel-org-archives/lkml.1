Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXITVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXITVIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXITVH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:07:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXITVH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:07:58 -0400
Message-ID: <46F2E103.8000907@redhat.com>
Date: Thu, 20 Sep 2007 17:07:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
References: <46B10BB7.60900@redhat.com>	<20070803113407.0b04d44e.akpm@linux-foundation.org>	<20070804084426.GA20464@kobayashi-maru.wspse.de>	<20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org>
In-Reply-To: <20070809095534.25ae1c42.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2007 12:55 PM, Andrew Morton wrote:
> On Thu, 9 Aug 2007 11:59:43 +0200 Matthias Hensler <matthias@wspse.de> wrote:
> 
>> On Sat, Aug 04, 2007 at 10:44:26AM +0200, Matthias Hensler wrote:
>>> On Fri, Aug 03, 2007 at 11:34:07AM -0700, Andrew Morton wrote:
>>> [...]
>>> I am also willing to try the patch posted by Richard.
>> I want to give some update here:
>>
>> 1. We finally hit the problem on a third system, with a total different
>>    setup and hardware. However, again high I/O load caused the problem
>>    and the affected filesystems were mounted with noatime.
>>
>> 2. I installed a recompiled kernel with just the two line patch from
>>    Richard Kennedy (http://lkml.org/lkml/2007/8/2/89). That system has 5
>>    days uptime now and counting. I believe the patch fixed the problem.
>>    However, I will continue running "vmstat 1" and the endless loop of
>>    "cat /proc/meminfo", just in case I am wrong.
>>
> 
> Did we ever see the /proc/meminfo and /proc/vmstat output during the stall?
> 
> If Richard's patch has indeed fixed it then this confirms that we're seeing
> contention over the dirty-memory limits.  Richard's patch isn't really the
> right one because it allows unlimited dirty-memory windup in some situations
> (large number of disks with small writes, or when we perform queue congestion
> avoidance).
> 
> As you're seeing this happening when multiple disks are being written to it is
> possible that the per-device-dirty-threshold patches which recently went into
> -mm (and which appear to have a bug) will fix it.
> 
> But I worry that the stall appears to persist *forever*.  That would indicate
> that we have a dirty-memory accounting leak, or that for some reason the
> system has decided to stop doing writeback to one or more queues (might be
> caused by an error in a lower-level driver's queue congestion state management).
> 
> If it is the latter, then it could be that running "sync" will clear the
> problem.  Temporarily, at least.  Because sync will ignore the queue congestion
> state.
> 

This is still a problem for people, and no fix is in sight until 2.6.24.
Can we get some kind of band-aid, like making the endless 'for' loop in
balance_dirty_pages() terminate after some number of iterations? Clearly
if we haven't written "write_chunk" pages after a few tries, *and* we
haven't encountered congestion, there's no point in trying forever...

[not even compile tested patch follows]

---
 mm/page-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.22.noarch.orig/mm/page-writeback.c
+++ linux-2.6.22.noarch/mm/page-writeback.c
@@ -208,11 +208,12 @@ static void balance_dirty_pages(struct a
 	long background_thresh;
 	long dirty_thresh;
 	unsigned long pages_written = 0;
+	int i;
 	unsigned long write_chunk = sync_writeback_pages();
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
-	for (;;) {
+	for (i = 0; ; i++) {
 		struct writeback_control wbc = {
 			.bdi		= bdi,
 			.sync_mode	= WB_SYNC_NONE,
@@ -250,6 +251,8 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+			if (i >= write_chunk && !wbc.encountered_congestion)
+				break;		/* nothing to write? */
 		}
 		congestion_wait(WRITE, HZ/10);
 	}
