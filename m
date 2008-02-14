Return-Path: <linux-kernel-owner+w=401wt.eu-S1763865AbYBNSl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763865AbYBNSl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbYBNSlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:41:19 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:50063 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYBNSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:41:18 -0500
Date: Thu, 14 Feb 2008 12:32:31 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 4/4] IPMI: Convert locked counters to atomics in the system
 interface
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080214183231.GD20148@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Atomics are faster and neater than locked counters.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
@@ -120,6 +120,27 @@ static struct device_driver ipmi_driver 
 	.bus = &platform_bus_type
 };
 
+
+/*
+ * Indexes into stats[] in smi_info below.
+ */
+
+#define SI_STAT_short_timeouts		0
+#define SI_STAT_long_timeouts		1
+#define SI_STAT_timeout_restarts	2
+#define SI_STAT_idles			3
+#define SI_STAT_interrupts		4
+#define SI_STAT_attentions		5
+#define SI_STAT_flag_fetches		6
+#define SI_STAT_hosed_count		7
+#define SI_STAT_complete_transactions	8
+#define SI_STAT_events			9
+#define SI_STAT_watchdog_pretimeouts	10
+#define SI_STAT_incoming_messages	11
+
+/* If you add a stat, you must update this value. */
+#define SI_NUM_STATS			12
+
 struct smi_info
 {
 	int                    intf_num;
@@ -216,25 +237,18 @@ struct smi_info
 	unsigned char slave_addr;
 
 	/* Counters and things for the proc filesystem. */
-	spinlock_t count_lock;
-	unsigned long short_timeouts;
-	unsigned long long_timeouts;
-	unsigned long timeout_restarts;
-	unsigned long idles;
-	unsigned long interrupts;
-	unsigned long attentions;
-	unsigned long flag_fetches;
-	unsigned long hosed_count;
-	unsigned long complete_transactions;
-	unsigned long events;
-	unsigned long watchdog_pretimeouts;
-	unsigned long incoming_messages;
+	atomic_t stats[SI_NUM_STATS];
 
         struct task_struct *thread;
 
 	struct list_head link;
 };
 
+#define smi_inc_stat(smi, stat) \
+	atomic_inc(&(smi)->stats[SI_STAT_ ## stat])
+#define smi_get_stat(smi, stat) \
+	((unsigned int) atomic_read(&(smi)->stats[SI_STAT_ ## stat]))
+
 #define SI_MAX_PARMS 4
 
 static int force_kipmid[SI_MAX_PARMS];
@@ -398,9 +412,7 @@ static void handle_flags(struct smi_info
  retry:
 	if (smi_info->msg_flags & WDT_PRE_TIMEOUT_INT) {
 		/* Watchdog pre-timeout */
-		spin_lock(&smi_info->count_lock);
-		smi_info->watchdog_pretimeouts++;
-		spin_unlock(&smi_info->count_lock);
+		smi_inc_stat(smi_info, watchdog_pretimeouts);
 
 		start_clear_flags(smi_info);
 		smi_info->msg_flags &= ~WDT_PRE_TIMEOUT_INT;
@@ -545,9 +557,7 @@ static void handle_transaction_done(stru
 			smi_info->msg_flags &= ~EVENT_MSG_BUFFER_FULL;
 			handle_flags(smi_info);
 		} else {
-			spin_lock(&smi_info->count_lock);
-			smi_info->events++;
-			spin_unlock(&smi_info->count_lock);
+			smi_inc_stat(smi_info, events);
 
 			/* Do this before we deliver the message
 			   because delivering the message releases the
@@ -581,9 +591,7 @@ static void handle_transaction_done(stru
 			smi_info->msg_flags &= ~RECEIVE_MSG_AVAIL;
 			handle_flags(smi_info);
 		} else {
-			spin_lock(&smi_info->count_lock);
-			smi_info->incoming_messages++;
-			spin_unlock(&smi_info->count_lock);
+			smi_inc_stat(smi_info, incoming_messages);
 
 			/* Do this before we deliver the message
 			   because delivering the message releases the
@@ -700,18 +708,14 @@ static enum si_sm_result smi_event_handl
 
 	if (si_sm_result == SI_SM_TRANSACTION_COMPLETE)
 	{
-		spin_lock(&smi_info->count_lock);
-		smi_info->complete_transactions++;
-		spin_unlock(&smi_info->count_lock);
+		smi_inc_stat(smi_info, complete_transactions);
 
 		handle_transaction_done(smi_info);
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
 	}
 	else if (si_sm_result == SI_SM_HOSED)
 	{
-		spin_lock(&smi_info->count_lock);
-		smi_info->hosed_count++;
-		spin_unlock(&smi_info->count_lock);
+		smi_inc_stat(smi_info, hosed_count);
 
 		/* Do the before return_hosed_msg, because that
 		   releases the lock. */
@@ -733,9 +737,7 @@ static enum si_sm_result smi_event_handl
 	{
 		unsigned char msg[2];
 
-		spin_lock(&smi_info->count_lock);
-		smi_info->attentions++;
-		spin_unlock(&smi_info->count_lock);
+		smi_inc_stat(smi_info, attentions);
 
 		/* Got a attn, send down a get message flags to see
                    what's causing it.  It would be better to handle
@@ -753,9 +755,7 @@ static enum si_sm_result smi_event_handl
 
 	/* If we are currently idle, try to start the next message. */
 	if (si_sm_result == SI_SM_IDLE) {
-		spin_lock(&smi_info->count_lock);
-		smi_info->idles++;
-		spin_unlock(&smi_info->count_lock);
+		smi_inc_stat(smi_info, idles);
 
 		si_sm_result = start_next_msg(smi_info);
 		if (si_sm_result != SI_SM_IDLE)
@@ -946,23 +946,17 @@ static void smi_timeout(unsigned long da
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		/* Running with interrupts, only do long timeouts. */
 		smi_info->si_timer.expires = jiffies + SI_TIMEOUT_JIFFIES;
-		spin_lock_irqsave(&smi_info->count_lock, flags);
-		smi_info->long_timeouts++;
-		spin_unlock_irqrestore(&smi_info->count_lock, flags);
+		smi_inc_stat(smi_info, long_timeouts);
 		goto do_add_timer;
 	}
 
 	/* If the state machine asks for a short delay, then shorten
            the timer timeout. */
 	if (smi_result == SI_SM_CALL_WITH_DELAY) {
-		spin_lock_irqsave(&smi_info->count_lock, flags);
-		smi_info->short_timeouts++;
-		spin_unlock_irqrestore(&smi_info->count_lock, flags);
+		smi_inc_stat(smi_info, short_timeouts);
 		smi_info->si_timer.expires = jiffies + 1;
 	} else {
-		spin_lock_irqsave(&smi_info->count_lock, flags);
-		smi_info->long_timeouts++;
-		spin_unlock_irqrestore(&smi_info->count_lock, flags);
+		smi_inc_stat(smi_info, long_timeouts);
 		smi_info->si_timer.expires = jiffies + SI_TIMEOUT_JIFFIES;
 	}
 
@@ -980,9 +974,7 @@ static irqreturn_t si_irq_handler(int ir
 
 	spin_lock_irqsave(&(smi_info->si_lock), flags);
 
-	spin_lock(&smi_info->count_lock);
-	smi_info->interrupts++;
-	spin_unlock(&smi_info->count_lock);
+	smi_inc_stat(smi_info, interrupts);
 
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
@@ -1766,9 +1758,7 @@ static u32 ipmi_acpi_gpe(void *context)
 
 	spin_lock_irqsave(&(smi_info->si_lock), flags);
 
-	spin_lock(&smi_info->count_lock);
-	smi_info->interrupts++;
-	spin_unlock(&smi_info->count_lock);
+	smi_inc_stat(smi_info, interrupts);
 
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
@@ -2406,30 +2396,30 @@ static int stat_file_read_proc(char *pag
 
 	out += sprintf(out, "interrupts_enabled:    %d\n",
 		       smi->irq && !smi->interrupt_disabled);
-	out += sprintf(out, "short_timeouts:        %ld\n",
-		       smi->short_timeouts);
-	out += sprintf(out, "long_timeouts:         %ld\n",
-		       smi->long_timeouts);
-	out += sprintf(out, "timeout_restarts:      %ld\n",
-		       smi->timeout_restarts);
-	out += sprintf(out, "idles:                 %ld\n",
-		       smi->idles);
-	out += sprintf(out, "interrupts:            %ld\n",
-		       smi->interrupts);
-	out += sprintf(out, "attentions:            %ld\n",
-		       smi->attentions);
-	out += sprintf(out, "flag_fetches:          %ld\n",
-		       smi->flag_fetches);
-	out += sprintf(out, "hosed_count:           %ld\n",
-		       smi->hosed_count);
-	out += sprintf(out, "complete_transactions: %ld\n",
-		       smi->complete_transactions);
-	out += sprintf(out, "events:                %ld\n",
-		       smi->events);
-	out += sprintf(out, "watchdog_pretimeouts:  %ld\n",
-		       smi->watchdog_pretimeouts);
-	out += sprintf(out, "incoming_messages:     %ld\n",
-		       smi->incoming_messages);
+	out += sprintf(out, "short_timeouts:        %u\n",
+		       smi_get_stat(smi, short_timeouts));
+	out += sprintf(out, "long_timeouts:         %u\n",
+		       smi_get_stat(smi, long_timeouts));
+	out += sprintf(out, "timeout_restarts:      %u\n",
+		       smi_get_stat(smi, timeout_restarts));
+	out += sprintf(out, "idles:                 %u\n",
+		       smi_get_stat(smi, idles));
+	out += sprintf(out, "interrupts:            %u\n",
+		       smi_get_stat(smi, interrupts));
+	out += sprintf(out, "attentions:            %u\n",
+		       smi_get_stat(smi, attentions));
+	out += sprintf(out, "flag_fetches:          %u\n",
+		       smi_get_stat(smi, flag_fetches));
+	out += sprintf(out, "hosed_count:           %u\n",
+		       smi_get_stat(smi, hosed_count));
+	out += sprintf(out, "complete_transactions: %u\n",
+		       smi_get_stat(smi, complete_transactions));
+	out += sprintf(out, "events:                %u\n",
+		       smi_get_stat(smi, events));
+	out += sprintf(out, "watchdog_pretimeouts:  %u\n",
+		       smi_get_stat(smi, watchdog_pretimeouts));
+	out += sprintf(out, "incoming_messages:     %u\n",
+		       smi_get_stat(smi, incoming_messages));
 
 	return out - page;
 }
@@ -2677,6 +2667,7 @@ static int is_new_interface(struct smi_i
 static int try_smi_init(struct smi_info *new_smi)
 {
 	int rv;
+	int i;
 
 	if (new_smi->addr_source) {
 		printk(KERN_INFO "ipmi_si: Trying %s-specified %s state"
@@ -2739,7 +2730,6 @@ static int try_smi_init(struct smi_info 
 
 	spin_lock_init(&(new_smi->si_lock));
 	spin_lock_init(&(new_smi->msg_lock));
-	spin_lock_init(&(new_smi->count_lock));
 
 	/* Do low-level detection first. */
 	if (new_smi->handlers->detect(new_smi->si_sm)) {
@@ -2768,6 +2758,8 @@ static int try_smi_init(struct smi_info 
 	new_smi->curr_msg = NULL;
 	atomic_set(&new_smi->req_events, 0);
 	new_smi->run_to_completion = 0;
+	for (i = 0; i < SI_NUM_STATS; i++)
+		atomic_set(&new_smi->stats[i], 0);
 
 	new_smi->interrupt_disabled = 0;
 	atomic_set(&new_smi->stop_operation, 0);
