Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbXGRPJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbXGRPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXGRPJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:09:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbXGRPJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:09:18 -0400
Message-ID: <469E2CE2.3070805@redhat.com>
Date: Wed, 18 Jul 2007 11:08:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070718010700.1ca7fd9f.akpm@linux-foundation.org> <20070718094142.GA12330@linux.vnet.ibm.com>
In-Reply-To: <20070718094142.GA12330@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2007 05:41 AM, Dhaval Giani wrote:
> On Wed, Jul 18, 2007 at 01:07:00AM -0700, Andrew Morton wrote:
>> On Wed, 18 Jul 2007 13:26:48 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>>
>>> I was running kernbench on top of 2.6.22-rc6-mm1 and I got a Hangcheck
>>> alert (This is when kernbench reached make -j).
>> hm, never had a report of that before.  It's the first time I've seen
>> hangcheck produce anything useful, frankly.
>>
>> Was the softlockup detector not enabled?
> 
> I notice CONFIG_DETECT_SOFTLOCKUP=y
>>> Also make -j is hanging.
>> Please try to capture the full sysrq-T output when it is hung.
> 
> Available at http://dhaval.giani.googlepages.com/sysrq-t-trace.bz2
> 
> In the meantime I will go and check if it was there in 2.6.22-rc4-mm2
> 

Softlockup is broken in 2.6.22.

=======================================================================

Subject: fix the softlockup watchdog to actually work
From: Ingo Molnar <mingo@elte.hu>

this Xen related commit:

   commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
   Author: Jeremy Fitzhardinge <jeremy@goop.org>
   Date:   Tue May 8 00:28:02 2007 -0700

       Ignore stolen time in the softlockup watchdog

broke the softlockup watchdog to never report any lockups. (!)

print_timestamp defaults to 0, this makes the following condition
always true:

	if (print_timestamp < (touch_timestamp + 1) ||

and we'll in essence never report soft lockups.

apparently the functionality of the soft lockup watchdog was never
actually tested with that patch applied ...

[this is -stable material too.]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -79,10 +79,11 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if (print_timestamp < (touch_timestamp + 1) ||
-		did_panic ||
-			!per_cpu(watchdog_task, this_cpu))
+	if ((print_timestamp >= touch_timestamp &&
+			print_timestamp < (touch_timestamp + 1)) ||
+			did_panic || !per_cpu(watchdog_task, this_cpu)) {
 		return;
+	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
