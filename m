Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbXK1X0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbXK1X0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbXK1X0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:26:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48191 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756567AbXK1X0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:26:12 -0500
Date: Thu, 29 Nov 2007 00:26:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071128232651.GD4947@elf.ucw.cz>
References: <20070920103225.GA4410@elf.ucw.cz> <20070920105002.GA4611@elf.ucw.cz> <200709212238.05130.david-b@pacbell.net> <20071128230451.GA1547@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128230451.GA1547@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> rtc-sysfs.c: why this?
> 
>         if (alarm > now) {
>                 /* Avoid accidentally clobbering active alarms; we
> can't
>                  * entirely prevent that here, without even the
> minimal
>                  * locking from the /dev/rtcN api.
>                  */
>                 retval = rtc_read_alarm(rtc, &alm);
>                 if (retval < 0)
>                         return retval;
>                 if (alm.enabled)
>                         return -EBUSY;
> 
>                 alm.enabled = 1;
> 
> People should not be "accidentally" writing to sysfs files...

If I remove "accidental alarm modify" logic, I can actually use rtc to
wake up more than once per boot.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 2ae0e83..ba5e806 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -149,16 +149,6 @@ rtc_sysfs_set_wakealarm(struct device *d
 
 	alarm = simple_strtoul(buf, NULL, 0);
 	if (alarm > now) {
-		/* Avoid accidentally clobbering active alarms; we can't
-		 * entirely prevent that here, without even the minimal
-		 * locking from the /dev/rtcN api.
-		 */
-		retval = rtc_read_alarm(rtc, &alm);
-		if (retval < 0)
-			return retval;
-		if (alm.enabled)
-			return -EBUSY;
-
 		alm.enabled = 1;
 	} else {
 		alm.enabled = 0;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
