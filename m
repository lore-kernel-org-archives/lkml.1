Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZFWR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZFWR3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZFWR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:29:13 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36492
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbZFWR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:29:13 -0400
Message-ID: <4A411EED.8030201@microgate.com>
Date: Tue, 23 Jun 2009 12:29:01 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt fix transmit race and timeout
References: <1245181451.3727.5.camel@x2.microgate.com>	<20090622231937.2d32898e.akpm@linux-foundation.org>	<1245770161.3701.42.camel@x2.microgate.com>	<20090623092739.5a8e9dd5.akpm@linux-foundation.org>	<4A4116FA.1060603@microgate.com> <20090623100206.fac4dde7.akpm@linux-foundation.org>
In-Reply-To: <20090623100206.fac4dde7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'm referring to
> 
>   Where did the "7" come from?

Oops, I did not scroll down far enough.

+	/*
+	 * use worst case speed of 1200bps to calculate transmit timeout
+	 * based on data in buffers (tbuf_bytes) and FIFO (128 bytes)
+	 */
+	if (info->params.mode == MGSL_MODE_HDLC) {
+		int timeout  = (tbuf_bytes(info) * 7) + 1000;
+		mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(timeout));
+	}

7 is roughly the number of milliseconds to send a byte at 1200bps.

The problem with externally provided data clocks is that you
don't necessarily know the data rate before hand, so a somewhat
arbitrary worst case assumption is used.

> and
> 
>   I have a suspicion that tx_stop() should use del_timer_sync(), not
>   del_timer().  What happens if the timer handler is concurrently
>   running?

Everything is synchronized with info->lock spin_lock,
so nothing critical runs concurrently. tx_stop() is sometimes
called in interrupt context so it can't call del_timer_sync().
If the timer has already fired but has not
run yet it does nothing more than call tx_stop() itself and wake
any transmit waiters so there are no ill effects.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
