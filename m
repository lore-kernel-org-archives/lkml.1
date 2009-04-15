Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZDOBb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZDOBb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZDOBbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:31:20 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:5213
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbZDOBbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:31:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlABACvW5El8qNo9/2dsb2JhbAAI0GODfAY
X-IronPort-AV: E=Sophos;i="4.40,188,1238947200"; 
   d="scan'208";a="467041133"
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
	irq handling on AVR32
From: Ben Nizette <bn@niasdigital.com>
To: tglx@linutronix.de
Cc: David Brownell <david-b@pacbell.net>, hskinnemoen@atmel.com,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       imre.deak@nokia.com, mingo@elte.hu
In-Reply-To: <1239698225.29831.14.camel@linux-51e8.site>
References: <1239685153.19815.12.camel@linux-51e8.site>
	 <1239698225.29831.14.camel@linux-51e8.site>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 11:30:53 +1000
Message-Id: <1239759053.29831.37.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 18:37 +1000, Ben Nizette wrote:

> If no one beats me to it i'll try and scatter printks and narrow down
> exactly *where* it all explodes tomorrow.

static irqreturn_t ads7846_irq(int irq, void *handle)
{
	struct ads7846 *ts = handle;
	unsigned long flags;

	spin_lock_irqsave(&ts->lock, flags);
	if (likely(get_pendown_state(ts))) {
		if (!ts->irq_disabled) {
			/* The ARM do_simple_IRQ() dispatcher doesn't act
			 * like the other dispatchers:  it will report IRQs
			 * even after they've been disabled.  We work around
			 * that here.  (The "generic irq" framework may help...)
			 */
			ts->irq_disabled = 1;
			disable_irq(ts->spi->irq);
			ts->pending = 1;
			hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
					HRTIMER_MODE_REL);
		}
	}
	spin_unlock_irqrestore(&ts->lock, flags);

	return IRQ_HANDLED;
}

Right, a scattering of printks in there shows execution gets at least as
far as inside the inner-most code block.  A printk directly before the
disable_irq() doesn't make it to my console so I'm guessing that the
hang is in there somewhere.

Hope this helps,
	--Ben.



