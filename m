Return-Path: <linux-kernel-owner+w=401wt.eu-S966001AbXCFSnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966001AbXCFSnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966013AbXCFSnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:43:12 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:60714 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966009AbXCFSmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:42:45 -0500
Message-ID: <45EDB61F.9050301@simon.arlott.org.uk>
Date: Tue, 06 Mar 2007 18:42:39 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [PATCH (update 4)] timer: Run calc_load halfway through each
 round_jiffies second
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk> <45E720E8.1010809@simon.arlott.org.uk> <45E75911.3070907@simon.arlott.org.uk> <20020101030506.GB4106@ucw.cz> <45EC9B15.6090908@simon.arlott.org.uk>
In-Reply-To: <45EC9B15.6090908@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/07 22:35, Simon Arlott wrote:
> On 01/01/02 03:05, Pavel Machek wrote:
>>> This changes calc_load so that it updates load half a second after 
>>> any tasks scheduled using round_jiffies.
>>
>> Hmm, otoh this makes calc_load more expensive, power-wise, because it
>> needs to wake the cpu once more?

I suddenly realised that since calc_load was already being called at 
second + 1 tick, moving it back 1 tick should mean it gets called and 
allowed to finish before the other tasks:

[ 1392.745730] cxacru_poll_status jiffies=1064000 [start]
[ 1392.765628] cxacru_poll_status jiffies=1064020 [finish]
[ 1393.745284] calc_load(1) jiffies=1065000 count=5000 count=5000
[ 1393.745320] cxacru_poll_status jiffies=1065000 [start]
[ 1393.754412] cxacru_poll_status jiffies=1065009 [finish]

How will this work in the presence of multiple CPUs? Will the scheduled 
task be run on another CPU while calc_load is run? I don't have anything 
I can test it on.

However since 5*HZ is unlikely to be a factor of 2^32, as soon as jiffies 
wraps a second time it will no longer be in sync:

HZ=100 0 (time after jiffies wrap that calc_load will be run)
HZ=100 4
HZ=100 8
HZ=100 12
HZ=100 16
...

It takes 3.2 *years* (increasing 40ms each time) at HZ=100 before it's 
back in sync. This would be ok for my task which is unlikely to ever take 
40ms or more to complete, but could still hit other tasks.

HZ=1000 0
HZ=1000 704
HZ=1000 408
HZ=1000 112
HZ=1000 816
...

It takes 16.9 years (jumping around, only <=40ms 4 times) at HZ=1000 
before it's back in sync.

Since calc_load is now running on the second already and this is 
preferable to different times during a second than other tasks, it can 
be rounded more easily than before:

 kernel/timer.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6663a87..4abead0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1226,17 +1226,19 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
 	static int count = LOAD_FREQ;
 
 	count -= ticks;
-	if (unlikely(count < 0)) {
+	if (unlikely(count <= 0)) {
 		active_tasks = count_active_tasks();
 		do {
 			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
 			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
 			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
 			count += LOAD_FREQ;
-		} while (count < 0);
+		} while (count <= 0);
+
+		count = round_jiffies_relative(count);
 	}
 }
 

-- 
Simon Arlott
