Return-Path: <linux-kernel-owner+w=401wt.eu-S933633AbZHEHIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbZHEHIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933515AbZHEHIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:08:25 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:4602 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933509AbZHEHIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:08:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAL/LeEpR9dJI/2dsb2JhbADUUgmEDwU
Date: Wed, 5 Aug 2009 09:08:22 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add watchdog driver for w90p910
Message-ID: <20090805070822.GC30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

>  I'm much obliged to you for helping me.

With pleasure :-).

> >> +static irqreturn_t w90p910_wdt_irq(int irq, void *dev_id)
> >> +{
> >> +     w90p910_wdt_keepalive();
> >> +     return IRQ_HANDLED;
> >> +}
> >
> > How does the interrupt work? what does the watchdog do when it times out?
> > (Is there a datasheet available somewhere?)
> >
> 
> The mechanism of watchdog of w90p910 is that the interrupt will occur
> periodicity every a given time interval.
> 
> Hmm, there are only two choices to confirm the system running, one to
> clear this WTIF and  WTR bits in handler of interrupt, the other to
> reset them in user application before interrupt occurs.

Hmm, I'm confused now. how does the watchdog then reboot your system?
The way we implement watchdog's in linux is that you start the watchdog and that userspace needs to trigger/ping/keep-the-watchdog-alive before the timeout period is finished/over. If the userspace daemon can keep doing this (or with other words: the system is healthy enough to operate normally without to much delay) your system doesn't get rebooted. If it doesn't manage to do it, then the watchdog knows that your system is not stable/healthy enough and will reboot your system.

Here I think that the watchdog is started. Then userspace start pinging the watchdog and everything is OK. If userspace doesn't ping the watchdog in time an interrupt is being generated and instead of rebooting the system, the watchdog is being triggered... If this is indeed what it does then this is wrong.

> > The read-write cyclus to REG_WTCR should also be guarded with a spinlock.
> > Can you incorporate the call to w90p910_wdt_start() in the ioctl code into this function?
> >
> 
> Do you mean that I should merge the "w90p910_wdt_settimeout" to
> "w90p910_wdt_start()"? or contrary?

I mean the contrary.
If your watchdog needs to be restarted when you set a new timeout, then it is best to have this in the settimeout function.
It is also better to do a ping to the watchdog once the new timeout was set. It might however be that a ping is enough and that a restart is not needed.
So something like the following diff could be it:
--- w90p910_wdt.c	2009-08-05 06:44:14.286477908 +0000
+++ w90p910_wdt.c	2009-08-05 06:46:04.496353102 +0000
@@ -144,6 +144,9 @@
 	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
 
 	wdt_time = new_time_level;
+
+	w90p910_wdt_start();
+
 	return 0;
 }
 
@@ -182,9 +185,7 @@
 			return -EFAULT;
 		if (w90p910_wdt_settimeout(new_value))
 			return -EINVAL;
-
-		w90p910_wdt_start();
-
+		w90p910_wdt_keepalive();
 		return put_user(wdt_time, p);
 	case WDIOC_GETTIMEOUT:
 		return put_user(wdt_time, p);
---

I have an additional question: which timeout values can you set? is it 0, 1, 2 and 3 seconds?

Kind regards,
Wim.

