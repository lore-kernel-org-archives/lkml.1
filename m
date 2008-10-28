Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJ1JgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJ1JgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJ1JgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:36:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:64772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYJ1JgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:36:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,498,1220252400"; 
   d="scan'208";a="632373810"
Subject: Re: [2.6.28-rc2] EeePC ACPI errors & exceptions
From: Zhao Yakui <yakui.zhao@intel.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	 <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
Content-Type: multipart/mixed; boundary="=-WYPueH2SoQzXRYMVWAHV"
Date: Tue, 28 Oct 2008 17:42:46 +0800
Message-Id: <1225186966.5189.143.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WYPueH2SoQzXRYMVWAHV
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-10-27 at 15:52 -0700, Darren Salt wrote:
> EeePC 901, BIOS revision 1603, current Debian lenny; running on AC.
> 
> I've noticed the following errors & exceptions, apparently coinciding with
> the startup of xfce4-sensors-plugin:
> 
> ACPI: EC: missing confirmations, switch off interrupt mode.
> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for [EmbeddedControl] [20080926]
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.BST2] (Node f7030d38), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.CBST] (Node f70336f8), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.BAT0._BST] (Node f7031c48), AE_TIME
> ACPI Exception (battery-0360): AE_TIME, Evaluating _BST [20080926]
Will you please try the attached patch on the 2.6.28-rc2 and see whether
the issue still exists?
    After the test, please attach the output of dmesg.
    

The following is included by the attached patch.
   a. EC transaction is divided into several phases.
        For example: EC write transaction
        a. issue EC write command
        b. wait until the input is empty and then write the internal
address
        c. wait until the input is empty and write the data
        d. wait until the input is empty. If it is empty, it indicates
        that EC transaction is finished.
   At the same time EC driver will be started in EC GEP mode. And when
there is no EC GPE confirmation for some EC transaction on some broken
laptops,the EC driver will be switched to polling mode. But EC GPE is
still enabled.

b. Some delay is added in the EC GPE handler on some broken BIOS.
   The delay won't be added for most laptops.Only when more than five
interrupts happen in the same jiffies and EC status are the same, OS
will add some delay in the EC GPE handler. If the same issue still
happens after adding delay,the delay time will be increased.But the max
delay time is ten microseconds.

Thanks.

> 
> Also, this (which, unlike the above, is also present with 2.6.27.*):
> 
> ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> ACPI: Device needs an ACPI driver
> 
> Full dmesg & config are attached.
> 
> (The Elantech touchpad patch from http://arjan.opmeer.net/elantech/ is
> applied to this kernel.)
> 

--=-WYPueH2SoQzXRYMVWAHV
Content-Disposition: attachment; filename=ec_all.patch
Content-Type: text/x-patch; name=ec_all.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

a. EC transaction is divided into several phases.
        For example: EC write transaction
        a. issue EC write command
        b. wait until the input is empty and then write the internal address
        c. wait until the input is empty and write the data
        d. wait until the input is empty. If it is empty, it indicates
        that EC transaction is finished.
At the same time EC driver will be started in EC GEP mode. And when there is
no EC GPE confirmation for some EC transaction on some broken laptops,the EC
driver will be switched to polling mode. But EC GPE is still enabled.

b. Some delay is added in the EC GPE handler on some broken BIOS.
   The delay won't be added for most laptops.Only when more than five
interrupts happen in the same jiffies and EC status are the same, OS will add
some delay in the EC GPE handler. If the same issue still happens after adding
delay,the delay time will be increased.But the max delay time is ten
microseconds.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
---
 drivers/acpi/ec.c |  333 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 233 insertions(+), 100 deletions(-)

Index: linux-2.6/drivers/acpi/ec.c
===================================================================
--- linux-2.6.orig/drivers/acpi/ec.c
+++ linux-2.6/drivers/acpi/ec.c
@@ -65,15 +65,25 @@ enum ec_command {
 	ACPI_EC_BURST_DISABLE = 0x83,
 	ACPI_EC_COMMAND_QUERY = 0x84,
 };
+/* EC events */
+enum ec_event {
+	ACPI_EC_EVENT_OBF_1 = 1,	/* Output buffer full */
+	ACPI_EC_EVENT_IBF_0,		/* Input buffer empty */
+};
 
 #define ACPI_EC_DELAY		500	/* Wait 500ms max. during EC ops */
 #define ACPI_EC_UDELAY_GLK	1000	/* Wait 1ms max. to get global lock */
 #define ACPI_EC_UDELAY		100	/* Wait 100us before polling EC again */
 
+#define EC_IRQ_NUM 		5	/* the EC interrupt storm threshold */
+#define EC_MAX_UDELAY		10	/* the max udelay time */
+
 #define ACPI_EC_STORM_THRESHOLD 20	/* number of false interrupts
 					   per one transaction */
 
 enum {
+	EC_FLAGS_WAIT_GPE,		/* Don't check EC status
+					 * until GPE arrives*/
 	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
 	EC_FLAGS_GPE_MODE,		/* Expect GPE to be sent
 					 * for status change */
@@ -111,11 +121,21 @@ static struct acpi_ec {
 	unsigned long data_addr;
 	unsigned long global_lock;
 	unsigned long flags;
+	unsigned long pre_jiffies;
+	/* record the jiffies when last EC interrupt happens */
 	struct mutex lock;
 	wait_queue_head_t wait;
 	struct list_head list;
 	struct transaction *curr;
 	spinlock_t curr_lock;
+	u8 pre_state;
+	/* record the EC status when last EC interrrupt happens */
+	atomic_t ec_irq_count;
+	unsigned long udelay;
+	/*
+	 * this is for the input parameter of udelay in EC GPE interrupt.
+	 * the max value is IRQ_MAX_UDELAY.(10)
+	 */
 } *boot_ec, *first_ec;
 
 /* 
@@ -210,18 +230,60 @@ unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
 
-static int acpi_ec_wait(struct acpi_ec *ec)
+static inline int acpi_ec_check_status(struct acpi_ec *ec,
+			enum ec_event event)
 {
-	if (wait_event_timeout(ec->wait, ec_transaction_done(ec),
-			       msecs_to_jiffies(ACPI_EC_DELAY)))
+	if (test_bit(EC_FLAGS_WAIT_GPE, &ec->flags))
 		return 0;
-	/* missing GPEs, switch back to poll mode */
-	if (printk_ratelimit())
-		pr_info(PREFIX "missing confirmations, "
-				"switch off interrupt mode.\n");
-	set_bit(EC_FLAGS_NO_GPE, &ec->flags);
-	clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
-	return 1;
+	if (event == ACPI_EC_EVENT_OBF_1) {
+		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_OBF)
+			return 1;
+	} else if (event == ACPI_EC_EVENT_IBF_0) {
+		if (!(acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
+{
+	if (likely(test_bit(EC_FLAGS_GPE_MODE, &ec->flags)) &&
+	    likely(!force_poll)) {
+		if (wait_event_timeout(ec->wait,
+				acpi_ec_check_status(ec, event),
+					msecs_to_jiffies(ACPI_EC_DELAY)))
+			return 0;
+		/* Check whether the bogus timeout happens */
+		if (!test_bit(EC_FLAGS_WAIT_GPE, &ec->flags) &&
+			acpi_ec_check_status(ec, event))
+			return 0;
+
+		clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
+		if (acpi_ec_check_status(ec, event)) {
+			/*
+			 * Clear GPE mode flags. When EC internal register is
+			 * accessed, EC driver will work in polling mode.
+			 * But GPE is still enabled.
+			 */
+			clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
+			return 0;
+		}
+	} else {
+		unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
+		clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
+		while (time_before(jiffies, delay)) {
+			if (acpi_ec_check_status(ec, event))
+				return 0;
+			msleep(1);
+		}
+		if (acpi_ec_check_status(ec, event))
+			return 0;
+	}
+	pr_err(PREFIX "acpi_ec_wait timeout, status = 0x%2.2x, event = %s\n",
+		acpi_ec_read_status(ec),
+		(event == ACPI_EC_EVENT_OBF_1) ? "\"b0=1\"" : "\"b1=0\"");
+	return -ETIME;
 }
 
 static void acpi_ec_gpe_query(void *ec_cxt);
@@ -248,48 +310,51 @@ static int ec_poll(struct acpi_ec *ec)
 	}
 	return -ETIME;
 }
-
-static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
-					struct transaction *t,
+static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
+					const u8 *wdata, unsigned wdata_len,
+					u8 *rdata, unsigned rdata_len,
 					int force_poll)
 {
-	unsigned long tmp;
-	int ret = 0;
+	int result = 0;
+	set_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
 	pr_debug(PREFIX "transaction start\n");
-	/* disable GPE during transaction if storm is detected */
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
-		acpi_disable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
-	}
-	/* start transaction */
-	spin_lock_irqsave(&ec->curr_lock, tmp);
-	/* following two actions should be kept atomic */
-	t->irq_count = 0;
-	ec->curr = t;
-	acpi_ec_write_cmd(ec, ec->curr->command);
-	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
+	acpi_ec_write_cmd(ec, command);
+	for (; wdata_len > 0; --wdata_len) {
+		result = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, force_poll);
+		if (result) {
+			pr_err(PREFIX
+			       "write_cmd timeout, command = %d\n", command);
+			goto end;
+		}
+		set_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
+		acpi_ec_write_data(ec, *(wdata++));
+	}
+
+	if (!rdata_len) {
+		result = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, force_poll);
+		if (result) {
+			pr_err(PREFIX
+			       "finish-write timeout, command = %d\n", command);
+			goto end;
+		}
+	} else if (command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
-	spin_unlock_irqrestore(&ec->curr_lock, tmp);
-	/* if we selected poll mode or failed in GPE-mode do a poll loop */
-	if (force_poll ||
-	    !test_bit(EC_FLAGS_GPE_MODE, &ec->flags) ||
-	    acpi_ec_wait(ec))
-		ret = ec_poll(ec);
-	pr_debug(PREFIX "transaction end\n");
-	spin_lock_irqsave(&ec->curr_lock, tmp);
-	ec->curr = NULL;
-	spin_unlock_irqrestore(&ec->curr_lock, tmp);
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		/* check if we received SCI during transaction */
-		ec_check_sci(ec, acpi_ec_read_status(ec));
-		/* it is safe to enable GPE outside of transaction */
-		acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
-	} else if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&
-		   t->irq_count > ACPI_EC_STORM_THRESHOLD) {
-		pr_debug(PREFIX "GPE storm detected\n");
-		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
+
+	for (; rdata_len > 0; --rdata_len) {
+		result = acpi_ec_wait(ec, ACPI_EC_EVENT_OBF_1, force_poll);
+		if (result) {
+			pr_err(PREFIX "read timeout, command = %d\n", command);
+			goto end;
+		}
+		/* Don't expect GPE after last read */
+		if (rdata_len > 1)
+			set_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
+
+		*(rdata++) = acpi_ec_read_data(ec);
 	}
-	return ret;
+end:
+	pr_debug(PREFIX "transaction end\n");
+	return result;
 }
 
 static int ec_check_ibf0(struct acpi_ec *ec)
@@ -310,35 +375,47 @@ static int ec_wait_ibf0(struct acpi_ec *
 	return -ETIME;
 }
 
-static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t,
+static int acpi_ec_transaction(struct acpi_ec *ec, u8 command,
+			       const u8 *wdata, unsigned wdata_len,
+			       u8 *rdata, unsigned rdata_len,
 			       int force_poll)
 {
 	int status;
 	u32 glk;
-	if (!ec || (!t) || (t->wlen && !t->wdata) || (t->rlen && !t->rdata))
+
+	if (!ec || (wdata_len && !wdata) || (rdata_len && !rdata))
 		return -EINVAL;
-	if (t->rdata)
-		memset(t->rdata, 0, t->rlen);
+
+	if (rdata)
+		memset(rdata, 0, rdata_len);
+
 	mutex_lock(&ec->lock);
 	if (ec->global_lock) {
 		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
 		if (ACPI_FAILURE(status)) {
-			status = -ENODEV;
-			goto unlock;
+			mutex_unlock(&ec->lock);
+			return -ENODEV;
 		}
 	}
-	if (ec_wait_ibf0(ec)) {
+
+	status = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, 0);
+	if (status) {
 		pr_err(PREFIX "input buffer is not empty, "
 				"aborting transaction\n");
-		status = -ETIME;
 		goto end;
 	}
-	status = acpi_ec_transaction_unlocked(ec, t, force_poll);
+
+	status = acpi_ec_transaction_unlocked(ec, command,
+					      wdata, wdata_len,
+					      rdata, rdata_len,
+					      force_poll);
+
 end:
+
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
-unlock:
 	mutex_unlock(&ec->lock);
+
 	return status;
 }
 
@@ -349,32 +426,35 @@ unlock:
 int acpi_ec_burst_enable(struct acpi_ec *ec)
 {
 	u8 d;
-	struct transaction t = {.command = ACPI_EC_BURST_ENABLE,
-				.wdata = NULL, .rdata = &d,
-				.wlen = 0, .rlen = 1};
-
-	return acpi_ec_transaction(ec, &t, 0);
+	/*
+	 * When burst enable command is issused, EC will put the EC burst
+	 * acknowledge byte (0x90) into output buffer.
+	 * Maybe it is worth checking the returned acknowledge bytes.
+	 */
+	return acpi_ec_transaction(ec, ACPI_EC_BURST_ENABLE, NULL, 0, &d, 1, 0);
 }
 
 int acpi_ec_burst_disable(struct acpi_ec *ec)
 {
-	struct transaction t = {.command = ACPI_EC_BURST_DISABLE,
-				.wdata = NULL, .rdata = NULL,
-				.wlen = 0, .rlen = 0};
+	u8 d = acpi_ec_read_status(ec);
+	if (d & ACPI_EC_FLAG_BURST) {
+		/*
+		 * Only when EC is in burst mode, it is necessary to disable.
+		 */
+		return acpi_ec_transaction(ec, ACPI_EC_BURST_DISABLE, NULL,
+						0, NULL, 0, 0);
+	}
+	return 0;
 
-	return (acpi_ec_read_status(ec) & ACPI_EC_FLAG_BURST) ?
-				acpi_ec_transaction(ec, &t, 0) : 0;
 }
 
 static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 * data)
 {
 	int result;
 	u8 d;
-	struct transaction t = {.command = ACPI_EC_COMMAND_READ,
-				.wdata = &address, .rdata = &d,
-				.wlen = 1, .rlen = 1};
 
-	result = acpi_ec_transaction(ec, &t, 0);
+	result = acpi_ec_transaction(ec, ACPI_EC_COMMAND_READ,
+				     &address, 1, &d, 1, 0);
 	*data = d;
 	return result;
 }
@@ -382,11 +462,8 @@ static int acpi_ec_read(struct acpi_ec *
 static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
 {
 	u8 wdata[2] = { address, data };
-	struct transaction t = {.command = ACPI_EC_COMMAND_WRITE,
-				.wdata = wdata, .rdata = NULL,
-				.wlen = 2, .rlen = 0};
-
-	return acpi_ec_transaction(ec, &t, 0);
+	return acpi_ec_transaction(ec, ACPI_EC_COMMAND_WRITE,
+				   wdata, 2, NULL, 0, 0);
 }
 
 /*
@@ -448,13 +525,12 @@ int ec_transaction(u8 command,
 		   u8 * rdata, unsigned rdata_len,
 		   int force_poll)
 {
-	struct transaction t = {.command = command,
-				.wdata = wdata, .rdata = rdata,
-				.wlen = wdata_len, .rlen = rdata_len};
 	if (!first_ec)
 		return -ENODEV;
 
-	return acpi_ec_transaction(first_ec, &t, force_poll);
+	return acpi_ec_transaction(first_ec, command, wdata,
+				   wdata_len, rdata, rdata_len,
+				   force_poll);
 }
 
 EXPORT_SYMBOL(ec_transaction);
@@ -463,9 +539,7 @@ static int acpi_ec_query(struct acpi_ec 
 {
 	int result;
 	u8 d;
-	struct transaction t = {.command = ACPI_EC_COMMAND_QUERY,
-				.wdata = NULL, .rdata = &d,
-				.wlen = 0, .rlen = 1};
+
 	if (!ec || !data)
 		return -EINVAL;
 
@@ -475,7 +549,8 @@ static int acpi_ec_query(struct acpi_ec 
 	 * bit to be cleared (and thus clearing the interrupt source).
 	 */
 
-	result = acpi_ec_transaction(ec, &t, 0);
+	result = acpi_ec_transaction(ec, ACPI_EC_COMMAND_QUERY,
+						NULL, 0, &d, 1, 0);
 	if (result)
 		return result;
 
@@ -549,29 +624,77 @@ static void acpi_ec_gpe_query(void *ec_c
 	}
 	mutex_unlock(&ec->lock);
 }
+/*******************************************************************************
+*
+* FUNCTION:	acpi_ec_gpe_delay
+*
+* PARAMETERS:	struct acpi_ec *ec, the EC device
+		u8 state  - the EC status when EC GPE interrupt happens
+
+* RETURN:	No
+*
+* DESCRIPTION: detect whether there exists EC GPE interrupt storm. If yes, it
+		will try to add some delay to reduce the number of EC GPE
+		interrupts.
+******************************************************************************/
+static void acpi_ec_gpe_delay(struct acpi_ec *ec, u8 state)
+{
+	static int warn_done;
+	if ((jiffies == ec->pre_jiffies) && (state == ec->pre_state)) {
+		atomic_inc(&ec->ec_irq_count);
+		if (atomic_read(&ec->ec_irq_count) > EC_IRQ_NUM) {
+			/*
+			 * If the ec_irq_count is above EC_IRQ_NUM, it will
+			 * be regarded as EC GPE interrupt storm. We will
+			 * try to add some udelay in acpi_ec_gpe_delay.
+			 */
+			atomic_set(&ec->ec_irq_count, 0);
+			if (ec->udelay > EC_MAX_UDELAY) {
+				if (!warn_done) {
+					printk(KERN_WARNING "EC GPE interrupt"
+					" storm. And it is hardware issue\n");
+					warn_done++;
+				}
+			} else {
+				/*
+				 * the input parameter of udelay will be
+				 * increased.
+				 */
+				ec->udelay = ec->udelay + 1;
+			}
+		}
+	} else {
+		ec->pre_jiffies = jiffies;
+		ec->pre_state = state;
+		atomic_set(&ec->ec_irq_count, 0);
+	}
+	if (ec->udelay)
+		udelay(ec->udelay);
+}
 
 static u32 acpi_ec_gpe_handler(void *data)
 {
 	struct acpi_ec *ec = data;
-	u8 status;
+	u8 status ;
+	acpi_status ec_status = AE_OK;
 
 	pr_debug(PREFIX "~~~> interrupt\n");
 	status = acpi_ec_read_status(ec);
 
-	gpe_transaction(ec, status);
-	if (ec_transaction_done(ec) && (status & ACPI_EC_FLAG_IBF) == 0)
+	clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
+	if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags))
 		wake_up(&ec->wait);
 
-	ec_check_sci(ec, status);
-	if (!test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&
-	    !test_bit(EC_FLAGS_NO_GPE, &ec->flags)) {
-		/* this is non-query, must be confirmation */
-		if (printk_ratelimit())
-			pr_info(PREFIX "non-query interrupt received,"
-				" switching to interrupt mode\n");
-		set_bit(EC_FLAGS_GPE_MODE, &ec->flags);
+	if (status & ACPI_EC_FLAG_SCI) {
+		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags)) {
+			ec_status = acpi_os_execute(OSL_EC_BURST_HANDLER,
+				acpi_ec_gpe_query, ec);
+		}
 	}
-	return ACPI_INTERRUPT_HANDLED;
+	acpi_ec_gpe_delay(ec, status);
+
+	return ACPI_SUCCESS(ec_status) ?
+			ACPI_INTERRUPT_HANDLED : ACPI_INTERRUPT_NOT_HANDLED;
 }
 
 /* --------------------------------------------------------------------------
@@ -712,10 +835,22 @@ static struct acpi_ec *make_acpi_ec(void
 	if (!ec)
 		return NULL;
 	ec->flags = 1 << EC_FLAGS_QUERY_PENDING;
+	/*
+	 * Start GPE mode.
+	 * When EC driver is started, it will work in GPE mode.
+	 * It means that the EC GPE interrupt is expected when EC status is
+	 * changed.
+	 * Of course if there is no EC GPE interrupt in some EC transaction,
+	 * it will be cleared and EC will work in polling mode when EC
+	 * internal register is accessed.
+	 */
+	set_bit(EC_FLAGS_GPE_MODE, &ec->flags);
 	mutex_init(&ec->lock);
 	init_waitqueue_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
 	spin_lock_init(&ec->curr_lock);
+	ec->pre_jiffies = jiffies;
+	atomic_set(&ec->ec_irq_count, 0);
 	return ec;
 }
 
@@ -1004,8 +1139,6 @@ int __init acpi_ec_ecdt_probe(void)
 static int acpi_ec_suspend(struct acpi_device *device, pm_message_t state)
 {
 	struct acpi_ec *ec = acpi_driver_data(device);
-	/* Stop using GPE */
-	set_bit(EC_FLAGS_NO_GPE, &ec->flags);
 	clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
 	acpi_disable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
 	return 0;
@@ -1014,9 +1147,9 @@ static int acpi_ec_suspend(struct acpi_d
 static int acpi_ec_resume(struct acpi_device *device)
 {
 	struct acpi_ec *ec = acpi_driver_data(device);
-	/* Enable use of GPE back */
-	clear_bit(EC_FLAGS_NO_GPE, &ec->flags);
 	acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
+	/* Enable use of GPE back */
+	set_bit(EC_FLAGS_GPE_MODE, &ec->flags);
 	return 0;
 }
 

--=-WYPueH2SoQzXRYMVWAHV--

