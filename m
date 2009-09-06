Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZIFF2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZIFF2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZIFF2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:28:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52491 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZIFF2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:28:45 -0400
Date: Sun, 6 Sep 2009 07:28:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>
Subject: zaurus c3000 aka spitz: fix resume
Message-ID: <20090906052840.GF1324@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sharpsl_pm.c code tries to read battery state very early during
resume, but those battery meters are connected on SPI and that's only
resumed way later.

Replace the check with simple checking of battery fatal signal, that
actually works at this stage.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

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
