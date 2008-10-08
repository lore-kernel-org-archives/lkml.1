Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYJHV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYJHV4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYJHV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:56:10 -0400
Received: from kara.rubysoft.com ([64.34.171.174]:42666 "EHLO
	kara.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYJHV4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:56:09 -0400
Date: Wed, 8 Oct 2008 15:56:03 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: Chris Snook <csnook@redhat.com>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <48ED2A89.3000902@redhat.com>
Message-ID: <Pine.LNX.4.64.0810081554380.14982@ren>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com>
 <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com>
 <Pine.LNX.4.64.0810081542300.14815@ren> <48ED2A89.3000902@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[HRTIMER]: Add highres=noverify option to bypass clocksource verification

This disregards the CLOCK_SOURCE_MUST_VERIFY flag on all clocksources.
This is particularly useful on legacy x86_32 systems that have no ACPI,
LAPIC, or HPET timers, where only TSC and PIT are available.

Thanks to Chris Snook for suggesting this.

Signed-off-by: Jeff Hansen <jhansen@cardaccess-inc.com>
---
  Documentation/kernel-parameters.txt |    7 ++++---
  include/linux/clocksource.h         |    2 ++
  kernel/hrtimer.c                    |    2 ++
  kernel/time/clocksource.c           |    3 ++-
  4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b52f47d..9611505 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -730,9 +730,10 @@ and is between 256 and 4096 characters. It is defined in the file
  			highmem otherwise. This also works to reduce highmem
  			size on bigger boxes.

-	highres=	[KNL] Enable/disable high resolution timer mode.
-			Valid parameters: "on", "off"
-			Default: "on"
+	highres=	[KNL] Modify high resolution timer parameters.
+			highres=on: Enable high-resolution timer mode (default)
+			highres=off: Disable high-resolution timer mode
+			highres=noverify: Assume all clocksources are stable

  	hisax=		[HW,ISDN]
  			See Documentation/isdn/README.HiSax.
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 55e434f..90ae835 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -104,6 +104,8 @@ extern struct clocksource *clock;	/* current clocksource */
  #define CLOCK_SOURCE_WATCHDOG			0x10
  #define CLOCK_SOURCE_VALID_FOR_HRES		0x20

+extern int clocksource_noverify;
+
  /* simplify initialization of mask field */
  #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ab80515..2fdf59f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -476,6 +476,8 @@ static int __init setup_hrtimer_hres(char *str)
  		hrtimer_hres_enabled = 0;
  	else if (!strcmp(str, "on"))
  		hrtimer_hres_enabled = 1;
+	else if (!strcmp(str, "noverify"))
+		clocksource_noverify = 1;
  	else
  		return 0;
  	return 1;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index dadde53..d3c14c1 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
  static DEFINE_SPINLOCK(clocksource_lock);
  static char override_name[32];
  static int finished_booting;
+int clocksource_noverify;

  /* clocksource_done_booting - Called near the end of core bootup
   *
@@ -165,7 +166,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
  	unsigned long flags;

  	spin_lock_irqsave(&watchdog_lock, flags);
-	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+	if (!clocksource_noverify && cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
  		int started = !list_empty(&watchdog_list);

  		list_add(&cs->wd_list, &watchdog_list);
-- 
1.5.6.4

On Wed, 8 Oct 2008, Chris Snook wrote:

> Jeff Hansen wrote:
>>  [HRTIMER]: Add highres=noverify option to bypass clocksource verification
>>
>>  This disregards the CLOCK_SOURCE_MUST_VERIFY flag on all clocksources.
>>  This is particularly useful on legacy x86_32 systems that have no ACPI,
>>  LAPIC, or HPET timers, where only TSC and PIT are available.
>>
>>  Thanks to Chris Snook for suggesting this.
>>  ---
>>   include/linux/clocksource.h |    2 ++
>>   kernel/hrtimer.c            |    2 ++
>>   kernel/time/clocksource.c   |    3 ++-
>>   3 files changed, 6 insertions(+), 1 deletions(-)
>
> Please also update Documentation/kernel-parameters.txt, and resubmit with 
> your Signed-off-by tag.
>
> -- Chris
>
>>  diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
>>  index 55e434f..90ae835 100644
>>  --- a/include/linux/clocksource.h
>>  +++ b/include/linux/clocksource.h
>>  @@ -104,6 +104,8 @@ extern struct clocksource *clock;    /* current
>>  clocksource */
>>   #define CLOCK_SOURCE_WATCHDOG            0x10
>>   #define CLOCK_SOURCE_VALID_FOR_HRES        0x20
>>
>>  +extern int clocksource_noverify;
>>  +
>>   /* simplify initialization of mask field */
>>   #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ?
>>  ((1ULL<<(bits))-1) : -1)
>>
>>  diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>>  index ab80515..2fdf59f 100644
>>  --- a/kernel/hrtimer.c
>>  +++ b/kernel/hrtimer.c
>>  @@ -476,6 +476,8 @@ static int __init setup_hrtimer_hres(char *str)
>>           hrtimer_hres_enabled = 0;
>>       else if (!strcmp(str, "on"))
>>           hrtimer_hres_enabled = 1;
>>  +    else if (!strcmp(str, "noverify"))
>>  +        clocksource_noverify = 1;
>>       else
>>           return 0;
>>       return 1;
>>  diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>>  index dadde53..d3c14c1 100644
>>  --- a/kernel/time/clocksource.c
>>  +++ b/kernel/time/clocksource.c
>>  @@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
>>   static DEFINE_SPINLOCK(clocksource_lock);
>>   static char override_name[32];
>>   static int finished_booting;
>>  +int clocksource_noverify;
>>
>>   /* clocksource_done_booting - Called near the end of core bootup
>>    *
>>  @@ -165,7 +166,7 @@ static void clocksource_check_watchdog(struct
>>  clocksource *cs)
>>       unsigned long flags;
>>
>>       spin_lock_irqsave(&watchdog_lock, flags);
>>  -    if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
>>  +    if (!clocksource_noverify && cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
>>           int started = !list_empty(&watchdog_list);
>>
>>           list_add(&cs->wd_list, &watchdog_list);
>
>
>
