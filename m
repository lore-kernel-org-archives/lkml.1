Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZGNLo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZGNLo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZGNLo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:44:26 -0400
Received: from rtitmf2.realtek.com ([60.250.210.236]:3992 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZGNLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:44:24 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 07:44:23 EDT
Message-ID: <48F90369174947C98F6AE82888FA60C5@realtek.com.tw>
From: =?big5?B?qkyr2KZ3?= <colin@realtek.com.tw>
To: <linux-kernel@vger.kernel.org>
Subject: jiffies got lost because of printk
Date: Tue, 14 Jul 2009 19:39:03 +0800
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="big5"; reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,
We found that system time is not synced with RTC time on our embedded 
system.
This is because sometimes we print too many chars to console.
For these lines in the function, release_console_sem, of printk.c,
        for ( ; ; ) {
                spin_lock_irqsave(&logbuf_lock, flags);
                wake_klogd |= log_start - log_end;
                if (con_start == log_end)
                        break;                  /* Nothing to print */
                _con_start = con_start;
                _log_end = log_end;
                con_start = log_end;            /* Flush */
                spin_unlock(&logbuf_lock);
                call_console_drivers(_con_start, _log_end);
                local_irq_restore(flags);
        }

Interrupt will be disabled before calling call_console_drivers and enabled 
after call_console_drivers finishes.
For the setting of com port baud rate 115200 and HZ 100, if there are more 
than 115200/8/100 bytes waiting for output,
interrupt will be disabled for more than 1 HZ and timer interrupt will be 
lost.
I know that printing too much in kernel level is not proper. But for 1000HZ, 
interrupt may be lost even just output 15 chars.
Any idea?

Regards,
Colin


