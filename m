Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYIIPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYIIPWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYIIPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:21:59 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44082 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYIIPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:21:57 -0400
Message-ID: <1044.69.2.248.210.1220971907.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48C60685.60303@suse.de>
References: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>
    <48C60685.60303@suse.de>
Date: Tue, 9 Sep 2008 08:51:47 -0600 (MDT)
Subject: Re: 2.6.27-rc5 acpi: EC Storm error message on bootup
From: jmerkey@wolfmountaingroup.com
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It does not disable EC, it disables EC GPE (interrupt from EC).
> Could you please test patch from comment #81 in bug #9998?
> http://bugzilla.kernel.org/attachment.cgi?id=17695&action=view
>
> Thanks,
> Alex.

Patch does not apply correctly to 2.6.27-rc5 -- do you have a patch a
little closer to 2.6.27-rc6?

Here is what ended up in the .rej file after I applied it:

***************
*** 140,208 ****
  	outb(data, ec->data_addr);
  }

- static inline int acpi_ec_check_status(struct acpi_ec *ec, enum ec_event
event)
  {
- 	if (test_bit(EC_FLAGS_WAIT_GPE, &ec->flags))
- 		return 0;
- 	if (event == ACPI_EC_EVENT_OBF_1) {
- 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_OBF)
- 			return 1;
- 	} else if (event == ACPI_EC_EVENT_IBF_0) {
- 		if (!(acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF))
- 			return 1;
- 	}
-
  	return 0;
  }

- static void ec_schedule_ec_poll(struct acpi_ec *ec)
  {
- 	if (test_bit(EC_FLAGS_RESCHEDULE_POLL, &ec->flags))
- 		schedule_delayed_work(&ec->work,
- 				      msecs_to_jiffies(ACPI_EC_DELAY));
  }

- static void ec_switch_to_poll_mode(struct acpi_ec *ec)
  {
  	set_bit(EC_FLAGS_NO_GPE, &ec->flags);
  	clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
- 	acpi_disable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
- 	set_bit(EC_FLAGS_RESCHEDULE_POLL, &ec->flags);
  }

- static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int
force_poll)
  {
- 	atomic_set(&ec->irq_count, 0);
- 	if (likely(test_bit(EC_FLAGS_GPE_MODE, &ec->flags)) &&
- 	    likely(!force_poll)) {
- 		if (wait_event_timeout(ec->wait, acpi_ec_check_status(ec, event),
- 				       msecs_to_jiffies(ACPI_EC_DELAY)))
- 			return 0;
- 		clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
- 		if (acpi_ec_check_status(ec, event)) {
- 			/* missing GPEs, switch back to poll mode */
- 			if (printk_ratelimit())
- 				pr_info(PREFIX "missing confirmations, "
- 						"switch off interrupt mode.\n");
- 			ec_switch_to_poll_mode(ec);
- 			ec_schedule_ec_poll(ec);
- 			return 0;
- 		}
- 	} else {
- 		unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
- 		clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
- 		while (time_before(jiffies, delay)) {
- 			if (acpi_ec_check_status(ec, event))
- 				return 0;
- 			msleep(1);
- 		}
- 		if (acpi_ec_check_status(ec,event))
- 			return 0;
  	}
- 	pr_err(PREFIX "acpi_ec_wait timeout, status = 0x%2.2x, event = %s\n",
- 		acpi_ec_read_status(ec),
- 		(event == ACPI_EC_EVENT_OBF_1) ? "\"b0=1\"" : "\"b1=0\"");
- 	return -ETIME;
  }

  static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
--- 159,219 ----
  	outb(data, ec->data_addr);
  }

+ static int ec_transaction_done(struct acpi_ec *ec)
  {
+ 	if (!ec_read_command(ec))
+ 		return 1;
+ 	if (!ec->t.wlen && !ec->t.rlen)
+ 		return 1;
  	return 0;
  }

+ static void gpe_transaction(struct acpi_ec *ec, u8 status)
  {
+ 	if (!ec_read_command(ec))
+ 		return;
+ 	if (ec->t.wlen > 0) {
+ 		if ((status & ACPI_EC_FLAG_IBF) == 0) {
+ 			acpi_ec_write_data(ec, *(ec->t.wdata++));
+ 			--ec->t.wlen;
+ 		} else
+ 			/* false interrupt, state didn't change */
+ 			atomic_inc(&ec->irq_count);
+
+ 	} else if (ec->t.rlen > 0) {
+ 		if ((status & ACPI_EC_FLAG_OBF) == 1) {
+ 			*(ec->t.rdata++) = acpi_ec_read_data(ec);
+ 			--ec->t.rlen;
+ 		} else
+ 			/* false interrupt, state didn't change */
+ 			atomic_inc(&ec->irq_count);
+ 	}
  }

+ static int acpi_ec_wait(struct acpi_ec *ec)
  {
+ 	if (wait_event_timeout(ec->wait, ec_transaction_done(ec),
+ 			       msecs_to_jiffies(ACPI_EC_DELAY)))
+ 		return 0;
+ 	/* missing GPEs, switch back to poll mode */
+ 	if (printk_ratelimit())
+ 		pr_info(PREFIX "missing confirmations, "
+ 				"switch off interrupt mode.\n");
  	set_bit(EC_FLAGS_NO_GPE, &ec->flags);
  	clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
+ 	return 1;
  }

+ static void acpi_ec_gpe_query(void *ec_cxt);
+
+ static int ec_check_sci(struct acpi_ec *ec, u8 state)
  {
+ 	if (state & ACPI_EC_FLAG_SCI) {
+ 		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
+ 			return acpi_os_execute(OSL_EC_BURST_HANDLER,
+ 				acpi_ec_gpe_query, ec);
  	}
+ 	return 0;
  }

  static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,

Jeff

