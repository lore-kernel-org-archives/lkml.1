Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXEKQck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXEKQck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760254AbXEKQcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:32:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759877AbXEKQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:32:31 -0400
Date: Fri, 11 May 2007 09:30:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Coywolf Qi Hunt <coywolf@gmail.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH] swsusp: Use platform mode by default
In-Reply-To: <200705111121.51704.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org>
References: <200611011323.14830.rjw@sisk.pl> <200611012240.13412.len.brown@intel.com>
 <2cd57c900705110136r11f23797gdf09df36559c6a3b@mail.gmail.com>
 <200705111121.51704.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> 
> We're working on fixing the breakage, but currently it's difficult, because
> none of my testboxes has problems with the 'platform' hibernation and I
> cannot reproduce the reported issues.

The rule for anything ACPI-related has been: no regressions.

It doesn't matter if something fixes 10 boxes, if it breaks a single one, 
it's going to get reverted.

We had much too much of the "two steps forward, one step back" dance with 
ACPI a few years ago, which is the reason that rule got installed (and 
which is why it's ACPI-only: in some other subsystems we accept the fact 
that sometimes we don't know how to fix some hardware issue, but the new 
situation is at least better than the old one).

I agree that it can be aggravating to know that you can fix a problem for 
some people, but then being limited by the fact that it breaks for others. 
But beign able to *rely* on something that used to work is just too 
important, and with ACPI, you can never make a good judgement of which way 
works better (since it really just depends on some random firmware issues 
that we have zero visibility into).

Also, quite often, it may *seem* like something fixes more boxes than it 
breaks, but it's because people report *breakage* only, and then a few 
months later it turns out that it's exactly the other way around: now it's 
a hundred people who report breakage with the *new* code, and the reason 
people thought it fixed more than it broke was that the people for whom 
the old code worked fine obviously never reported it!

So this is why "a single regression is considered more important than ten 
fixes" - because a single regressionr report tends to actually be just the 
first indication of a lot of people who simply haven't tested the new code 
yet! People for whom the old code is broken are more likely to test new 
things.

So I'd just suggest changing the default back to PM_DISK_SHUTDOWN (but 
leave the "pm_ops->enter" testing in place - ie not reverting the other 
commits in the series).

The patch would look something like this. Coywolf, does this fix it for 
you?

			Linus

---
 kernel/power/disk.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index b5f0543..f6aa06e 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -60,9 +60,9 @@ void hibernation_set_ops(struct hibernation_ops *ops)
 	}
 	mutex_lock(&pm_mutex);
 	hibernation_ops = ops;
-	if (ops)
-		hibernation_mode = HIBERNATION_PLATFORM;
-	else if (hibernation_mode == HIBERNATION_PLATFORM)
+
+	/* Turn off HIBERNATION_PLATFORM if we no longer have any platform ops */
+	if (!ops && hibernation_mode == HIBERNATION_PLATFORM)
 		hibernation_mode = HIBERNATION_SHUTDOWN;
 
 	mutex_unlock(&pm_mutex);
