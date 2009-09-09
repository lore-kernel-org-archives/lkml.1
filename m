Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZIIOMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZIIOMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZIIOMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:12:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZIIOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:11:59 -0400
Date: Wed, 9 Sep 2009 09:50:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
Message-ID: <20090909075024.GA1400@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus!

Spitz resume was broken for year or likely two, and it would be very
nice to fix it for 2.6.31 release. One liner is below, and it really
can not harm. It already is in Eric's fix queue, so pulling that for
.31 should work, too.

Do you think you could take it?
								Pavel

---


sharpsl_pm.c code tries to read battery state very early during
resume, but those battery meters are connected on SPI and that's only
resumed way later.

Replace the check with simple checking of battery fatal signal, that
actually works at this stage.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Stanislav Brabec <utx@penguin.cz>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

--- linux-rc/arch/arm.ofic/mach-pxa/sharpsl_pm.c	2009-08-28 00:19:10.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/sharpsl_pm.c	2009-09-04 11:18:33.000000000 +0200
@@ -678,8 +678,8 @@
 		dev_dbg(sharpsl_pm.dev, "User triggered wakeup in offline charger.\n");
 	}
 
-	if ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || (sharpsl_fatal_check() < 0) )
-	{
+	if ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || 
+	    (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_FATAL)))	{
 		dev_err(sharpsl_pm.dev, "Fatal condition. Suspend.\n");
 		corgi_goto_sleep(alarm_time, alarm_enable, state);
 		return 1;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
