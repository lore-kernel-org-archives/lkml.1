Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbZB1ABm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbZB1ABm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZB1ABe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:01:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbZB1ABd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:01:33 -0500
Date: Fri, 27 Feb 2009 16:01:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: david-b@pacbell.net, me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-Id: <20090227160110.8cf8cd6e.akpm@linux-foundation.org>
In-Reply-To: <20090227153204.fc9c579c.akpm@linux-foundation.org>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<200902271350.32380.david-b@pacbell.net>
	<20090227140907.f159be9b.akpm@linux-foundation.org>
	<200902271518.58246.david-b@pacbell.net>
	<20090227153204.fc9c579c.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 15:32:04 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Why does this function:
> 
> static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> {
> 	int err;
> 	u8 value;
> 
> #ifdef CONFIG_LOCKDEP
> 	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> 	 * we don't want and can't tolerate.  Although it might be
> 	 * friendlier not to borrow this thread context...
> 	 */
> 	local_irq_enable();
> #endif
> 
> 	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> 				  STS_HW_CONDITIONS);
> 	if (!err)  {
> 		input_report_key(powerbutton_dev, KEY_POWER,
> 				 value & PWR_PWRON_IRQ);
> 	} else {
> 		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
> 			" PM_MASTER STS_HW_CONDITIONS register\n", err);
> 	}
> 
> 	return IRQ_HANDLED;
> }
> 
> Which is connected up via this statement:
> 
> 	err = request_irq(irq, powerbutton_irq,
> 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> 			"twl4030-pwrbutton", NULL);
> 
> reenable local interrupts?

ah, OK, twl4030_i2c_read_u8() does i2c I/O.

Can't do that.  If some random process currently holds
mutex_lock(&twl->xfer_lock) and an interrupt occurs then this interrupt
handler will try to acquire mutex_lock(&twl->xfer_lock).  Deadlock.

