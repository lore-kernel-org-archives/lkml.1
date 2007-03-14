Return-Path: <linux-kernel-owner+w=401wt.eu-S1030842AbXCNJxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030842AbXCNJxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030843AbXCNJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:53:34 -0400
Received: from www.osadl.org ([213.239.205.134]:34327 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030842AbXCNJxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:53:33 -0400
Subject: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Johannes Bauer <JohannesBauer@gmx.de>, linux-kernel@vger.kernel.org,
       schwab@suse.de, Stable Kernel Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1173817985.13341.120.camel@localhost.localdomain>
References: <45F6F3A6.9060405@gmx.de>  <45F7033B.2030204@redhat.com>
	 <1173817985.13341.120.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 11:00:12 +0100
Message-Id: <1173866413.13341.154.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_forward() does not check for the possible overflow of
timer->expires. This can happen on 64 bit machines with large interval
values and results currently in an endless loop in the softirq because
the expiry value becomes negative and therefor the timer is expired all
the time.

Check for this condition and set the expiry value to the max. expiry
time in the future.

The fix should be applied to stable kernel series as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix,de>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ec4cb9f..5e7122d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -644,6 +644,12 @@ hrtimer_forward(struct hrtimer *timer, k
 		orun++;
 	}
 	timer->expires = ktime_add(timer->expires, interval);
+	/*
+	 * Make sure, that the result did not wrap with a very large
+	 * interval.
+	 */
+	if (timer->expires.tv64 < 0)
+		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
 
 	return orun;
 }


