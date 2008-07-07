Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYGGEMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYGGEMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 00:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYGGEMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 00:12:40 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21484 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750705AbYGGEMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 00:12:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sUsXjeyM3bw6SFZJRZu0XkX9rKFnE+eheMjNxkFezjySRWhTXIZ8mWozgq05Hk2nNbp+kx14Q0rFKzu2y4AjbsYkX3j76nSu/0iknLXMjIitqKuSBeYl5eH6noLe5D52RE8YmZwLfGN4QOheYjWDGQe3bn0nwAYqC8OhYn5cDbQ=  ;
X-YMail-OSG: 7nCgV3MVM1k4IOFlMIHFciMyCTuyrQ_WSBeuLcUY0fqCLfvThD88Kc4MEgVWXSaFXewO49P2Fqm5om_esU1FCLZyMD5j_bR_R7abd6_Ej4jrTp_YxN11j.e0GK3thiY.DwRlXCttHx3IqqNKd41BTUL2YbbzfInEP.ffMsl4hCMTvGmUuC0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Date: Sun, 6 Jul 2008 21:12:38 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       mingo@elte.hu, pavel@suse.cz
References: <200805291333.42057.david-b@pacbell.net> <20080529162257.03426e48.akpm@linux-foundation.org>
In-Reply-To: <20080529162257.03426e48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807062112.38209.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address some of Andrew's comments on the patch now in
MMOTM with name "pm-boot-time-suspend-selftest.patch".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 kernel/power/main.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/kernel/power/main.c	2008-07-06 21:06:35.000000000 -0700
+++ b/kernel/power/main.c	2008-07-06 21:06:35.000000000 -0700
@@ -160,10 +160,19 @@ static void suspend_test_finish(const ch
 	long nj = jiffies - suspend_test_start_time;
 	unsigned msec;
 
-	msec = jiffies_to_msecs((nj >= 0) ? nj : -nj);
+	msec = jiffies_to_msecs(abs(nj));
 	pr_info("PM: %s took %d.%03d seconds\n", label,
 			msec / 1000, msec % 1000);
-	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));
+
+	/* Warning on suspend means the RTC alarm period needs to be
+	 * larger -- the system was sooo slooowwww to suspend that the
+	 * alarm (should have) fired before the system went to sleep!
+	 *
+	 * Warning on either suspend or resume also means the system
+	 * has some performance issues.  The stack dump of a WARN_ON
+	 * is more likely to get the right attention than a printk...
+	 */
+	WARN_ON(msec > (TEST_SUSPEND_SECONDS * 1000));
 }
 
 #else
@@ -579,13 +588,13 @@ core_initcall(pm_init);
 
 static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
 {
-	static char		err_readtime [] __initdata =
+	static char err_readtime[] __initdata =
 		KERN_ERR "PM: can't read %s time, err %d\n";
-	static char		err_wakealarm [] __initdata =
+	static char err_wakealarm [] __initdata =
 		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
-	static char		err_suspend [] __initdata =
+	static char err_suspend[] __initdata =
 		KERN_ERR "PM: suspend test failed, error %d\n";
-	static char		info_test [] __initdata =
+	static char info_test[] __initdata =
 		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
 
 	unsigned long		now;
