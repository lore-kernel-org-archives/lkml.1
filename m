Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZHPOzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZHPOzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZHPOzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:55:01 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:37074 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbZHPOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:55:00 -0400
X-Trace: 247738890/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.90.41/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.90.41
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FAN66h0pPRVop/2dsb2JhbACBUo5BAcEqhBkFgU0
X-IronPort-AV: E=Sophos;i="4.43,389,1246834800"; 
   d="scan'208";a="247738890"
Date: Sun, 16 Aug 2009 15:54:37 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Dmitry Torokhov <dtor@mail.ru>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, mce: therm_throt: don't log redundant normality
Message-ID: <Pine.LNX.4.64.0908161544100.7929@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I'm delighted to find your 0d01f31439c1e4d602bf9fdc924ab66f407f5e38
"x86, mce: therm_throt - change when we print messages" in rc6:
thank you.

I too had been annoyed by "critical" CPU1 Temperature/speed normal
messages, with no indication that anything had been abnormal: after
resume on a Fujitsu-Siemens Esprimo Mobile (whereas startup decided
the Duo's CPU0 Thermal monitoring would be handled by SMI not by MCE).

I hadn't reported it yet, because I couldn't quite work out what to do
about it: your patch looks good, so long as someone else doesn't have
a machine which jumps between throttled and unthrottled too quickly.

But could we add one more thing on top of your patch?  Though it no
longer keeps announcing "I am normal", can we please also get rid
of the accompanying "Machine check events logged" message too?
If the non-event isn't worth showing (I agree that it isn't),
then I think it's not worth logging either.

Hugh


[PATCH] x86, mce: therm_throt - don't log redundant normality

0d01f31439c1e4d602bf9fdc924ab66f407f5e38 "x86, mce: therm_throt -
change when we print messages" removed redundant announcements of
"Temperature/speed normal".  They're not worth logging either:
remove their accompanying "Machine check events logged" messages.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- 2.6.31-rc6/arch/x86/kernel/cpu/mcheck/therm_throt.c	2009-08-14 09:34:06.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/therm_throt.c	2009-08-14 13:22:07.000000000 +0100
@@ -116,11 +116,14 @@ static int therm_throt_process(int curr)
 		       cpu, __get_cpu_var(thermal_throttle_count));
 
 		add_taint(TAINT_MACHINE_CHECK);
-	} else if (was_throttled) {
+		return 1;
+	}
+	if (was_throttled) {
 		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 #ifdef CONFIG_SYSFS
