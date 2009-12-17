Return-Path: <linux-kernel-owner+w=401wt.eu-S1765442AbZLQWI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765442AbZLQWI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763394AbZLQWI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:08:27 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:47068 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760075AbZLQWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:08:26 -0500
Date: Thu, 17 Dec 2009 16:08:21 -0600
From: Corey Minyard <minyard@acm.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] IPMI: Add parameter to limit CPU usage in kipmid
Message-id: <20091217220821.GA4513@minyard.local>
Reply-to: minyard@acm.org
References: <20091216212354.GA13097@minyard.local>
 <200912171136.48086.jdelvare@suse.de> <4B2A79B7.9040301@acm.org>
 <200912172107.45393.jdelvare@suse.de>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-disposition: inline
Content-transfer-encoding: 8bit
In-reply-to: <200912172107.45393.jdelvare@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:07:45PM +0100, Jean Delvare wrote:
> Le jeudi 17 décembre 2009 19:34, Corey Minyard a écrit :
> > I agree, these should be inlines.  I should have caught that.  I can 
> > convert them and address adding comments as Andrew suggests.

Jean,

I cleaned up the patch some.  I added some state results to the list of
things to be busy waited for (should improve performance a bit) and
changed the schedule_timeout_interruptible back to 1, since that's
what it's supposed to be.  And I added some comments.

I did some testing on my system here.  On my system, kipmid uses almost
no CPU normally.  If I set the kipmid_max_busy_us value to 500, the
interface was more than 5 times slower.  I had to set the value up to
35000 for it to go back to the normal performance, and it was pretty
linear between the two values.  So this is definiately not for all
systems.

Can you try this out to make sure its ok?

-corey


From: Martin Wilck <martin.wilck@ts.fujitsu.com>

In some cases kipmid can use a lot of CPU.  This is generally due to
the bad design of the hardware, it doesn't have interrupts and must be
polled constantly.  Different controllers run at different speeds and
have different latencies, so it is difficult to account for
automatically.

This adds a way to tune the CPU used by kipmid to help in those cases.
By setting kipmid_max_busy_us to a value between 100 and 500, it is
possible to bring down kipmid CPU load to practically 0.  This will
cost some performance, and that will vary from system to system.  Not
setting the value, or setting the value to zero, causes operation to
be unaffected.

Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: Jean Delvare <jdelvare@suse.de>

Reworked to clean things up, add comments, do other stylistic things, and
enhance performance a bit.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index e58ea4c..b914249 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -297,6 +297,9 @@ struct smi_info {
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
+static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
+static int num_max_busy_us;
+
 static int unload_when_empty = 1;
 
 static int try_smi_init(struct smi_info *smi);
@@ -927,12 +930,88 @@ static void set_run_to_completion(void *send_info, int i_run_to_completion)
 	}
 }
 
+/*
+ * Handle busy waiting flags in the timespec.  We use a -1 in tv_nsec
+ * to mark that we are not currently busy waiting.
+ */
+static inline void ipmi_si_set_not_busy(struct timespec *ts)
+{
+	ts->tv_nsec = -1;
+}
+static inline int ipmi_si_is_busy(struct timespec *ts)
+{
+	return ts->tv_nsec != -1;
+}
+
+static inline int ipmi_result_allow_busy_wait(enum si_sm_result smi_result)
+{
+	/*
+	 * In these states we allow a busy wait.  SI_SM_CALL_WITHOUT_DELAY
+	 * is caught before here, so that will not be handled here.  In the
+	 * other results besides the ones below and SI_SM_CALL_WITHOUT_DELAY,
+	 * do a full tick delay before checking again in kipmid.
+	 */
+	switch (smi_result) {
+	case SI_SM_CALL_WITH_DELAY:
+	case SI_SM_TRANSACTION_COMPLETE:
+	case SI_SM_ATTN:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Return true if the kthread should busy wait, and false if not.  This is
+ * used to tune the operation of the kthread to not use too much CPU.
+ */
+static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
+				 const struct smi_info *smi_info,
+				 struct timespec *busy_until)
+{
+	unsigned int max_busy_us = 0;
+
+	if (!ipmi_result_allow_busy_wait(smi_result))
+		return 0;
+
+	if (smi_info->intf_num < num_max_busy_us)
+		max_busy_us = kipmid_max_busy_us[smi_info->intf_num];
+
+	if (max_busy_us <= 0)
+		/* Busy wait timing is disabled, just busy wait forever. */
+		ipmi_si_set_not_busy(busy_until);
+	else if (!ipmi_si_is_busy(busy_until)) {
+		/*
+		 * Need to start busy waiting.  Record the time to stop busy
+		 * waiting and do a full delay.
+		 */
+		getnstimeofday(busy_until);
+		timespec_add_ns(busy_until, max_busy_us * NSEC_PER_USEC);
+	} else {
+		struct timespec now;
+
+		/*
+		 * We are busy waiting.  If we have exceeded our time then
+		 * return false to do a full delay.
+		 */
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
+			ipmi_si_set_not_busy(busy_until);
+			return 0;
+		}
+	}
+	return 1;
+}
+
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_until;
 
+	ipmi_si_set_not_busy(&busy_until);
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
@@ -940,7 +1019,8 @@ static int ipmi_thread(void *data)
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (ipmi_thread_busy_wait(smi_result, smi_info,
+					       &busy_until))
 			schedule();
 		else
 			schedule_timeout_interruptible(1);
@@ -1213,6 +1293,13 @@ module_param(unload_when_empty, int, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param_array(kipmid_max_busy_us, int, &num_max_busy_us, 0644);
+MODULE_PARM_DESC(kipmid_max_busy_us,
+		 "Max time (in microseconds) for kipmid to busy-wait for"
+		 " IPMI data before sleeping. 0 (default) means to wait"
+		 " forever. Set to a positive value, generally in the 100"
+		 " to 500 range, if kipmid is using up a lot of CPU time."
+		 " This will reduce performace, so balance is required.");
 
 
 static void std_irq_cleanup(struct smi_info *info)
