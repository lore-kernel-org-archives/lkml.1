Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYGIQMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYGIQMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYGIQMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:12:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:63137 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYGIQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v3YA+6WmXLIr9q4jbyDNjuVw3XvhxBW8iL+LY1rCnjtInGS3+2PpyPY3EOxwEjYp4s
         Rs9nZwuidtInqp8vsaHJMPdnyQeRQk6/eiIfl2lTq5nlPdeE1qVir9vgienVVhAemWbd
         YCMSrELo2HmxdwukuUUUE2wSSSC9EgNnZQkUc=
Message-ID: <c384c5ea0807090911i790ac4een40633a3721810071@mail.gmail.com>
Date: Wed, 9 Jul 2008 18:11:59 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux-RT Kernel List" <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Leon Woestenberg" <leon@sidebranch.com>,
       "John Kacur" <jkacur@gmail.com>
Subject: Re: [PATCH 2.6.24.7-rt14 v2] rt: {queue,schedule}_work_prio() allowing work priorities other than caller's priority
In-Reply-To: <486f7032.01b6420a.65e1.6a88@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486f7032.01b6420a.65e1.6a88@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 5, 2008 at 2:59 PM,  <leon.woestenberg@gmail.com> wrote:
> The faulty case was a non-FIFO serial driver that deferred LED blinking to
> a workqueue using schedule_work(). However, that work used GPIO bitbanged I2C,
> which uses 50 usecs udelay()s. With the work inheriting the serial IRQ priority,
> it easily missed the ~60 usec deadline of 115200 bps communications.
>
John Kacur asked forthe (custom) code showing this case on IRC.

I suspect the current kernel also has drivers that *also* depend on
workqueue's not pre-empting or delaying their calling interrupt
handler.


See http://www.sidebranch.com/leon/ for the code. A short file roadmap
and explanation of the analysis:

lowlevel_16550.c: non-FIFO UART driver
axonbus.c: protocol handler
max7311.c: I2C -> GPIO extender, driving a few LEDs.

Queueing the "blink a LED" work happens in this code path:

lowlevel_16550.c:axonbus_isr() -> axonbus.c:ab_cmd_receive() ->
boardsupport.c:ll_blink()

The queued work then performs this code path, running at the same
real-time priority as the originating IRQ:
ll_blink_work() -> do_max7311_read() -> i2c-algo-bit.c:* -> udelay(50)

The udelay(50) thus keeps the 16550 interrupt from being serviced.

Scheduling the work at lower priority solved this.

Regards,

Leon.

p.s. we will submit the max7311 driver for upstream.
