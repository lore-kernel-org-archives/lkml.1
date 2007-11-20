Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXKTBlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXKTBlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbXKTBlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:41:37 -0500
Received: from gw.goop.org ([64.81.55.164]:42324 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbXKTBlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:41:36 -0500
Message-ID: <47423B26.1090607@goop.org>
Date: Mon, 19 Nov 2007 17:40:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>, David <david@unsolicited.net>,
       Ingo Molnar <mingo@elte.hu>,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <473F88B0.1030309@goop.org> <20071119232252.GC3528@suse.de>
In-Reply-To: <20071119232252.GC3528@suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Can you try applying the patch below to see if that solves the problem
> for you?
>   

I don't think this patch will help; it only has cosmetic changes in
addition to the original message printing fix.  I think it also needs
change a3b13c23f186ecb57204580cc1f2dbe9c284953a:

diff -r 79f0ea1e0e70 -r 06f060ab58aa kernel/softlockup.c
--- a/kernel/softlockup.c	Tue Oct 09 21:00:40 2007 +0000
+++ b/kernel/softlockup.c	Wed Oct 17 08:42:46 2007 -0700
@@ -40,14 +40,16 @@ static struct notifier_block panic_block
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(void)
+static unsigned long get_timestamp(int this_cpu)
 {
-	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
+	int this_cpu = raw_smp_processor_id();
+
+	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -91,7 +93,7 @@ void softlockup_tick(void)
 		return;
 	}
 
-	now = get_timestamp();
+	now = get_timestamp(this_cpu);
 
 	/* Wake up the high-prio watchdog task every second: */
 	if (now > (touch_timestamp + 1))


    J
