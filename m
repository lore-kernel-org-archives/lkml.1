Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYALB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYALB0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbYALB0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:26:40 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:41823 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbYALB0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:26:39 -0500
Message-ID: <4788168F.8070403@keyaccess.nl>
Date: Sat, 12 Jan 2008 02:23:27 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ondrej Zary <linux@rainbow-software.org>, Pierre Ossman <drzeus@drzeus.cx>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
References: <200801092343.48726.linux@rainbow-software.org> <20080111080141.75aaad5f@poseidon.drzeus.cx> <47877B83.5040604@keyaccess.nl> <200801111940.22023.linux@rainbow-software.org>
In-Reply-To: <200801111940.22023.linux@rainbow-software.org>
Content-Type: multipart/mixed;
 boundary="------------010602020600060407080608"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010602020600060407080608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-01-08 19:40, Ondrej Zary wrote:

> On Friday 11 January 2008 15:21:55 Rene Herman wrote:

>> Hrmpf. Well, okay. Ondrej -- I assume this patch fixes things?
> 
> Yes, it works fine. 3c509 card still does not work after resume, but that
> looks like another problem.

Okay. Would now only still like to know why the test in resume() means 
trouble for you while it seems the same test in suspend() should've 
triggered as well and not have stopped the device in the first place.

Know absolutely nothing about hibernation so added the listed maintainers to 
the CC.

Pavel, Rafael -- the attached fixes snd-cs4236 not coming back to life for 
Ondrej after hibernation due to the PNP_DRIVER_RES_DO_NOT_CHANGE test 
triggering in pnp_bus_resume() and keeping the card in a suspended state.

There's issues on wether or not the flag _should_ be set (that is, be part 
of PNP_DRIVER_RES_DISABLE) and that it shouldn't be tested by these code 
patchs in the first place, but is it in fact expected that this would be 
neccessary?

That is, is it expected/designed that the same test in pnp_bus_suspend() 
didn't cause the device to not be disabled in the first place?

Rene.

--------------010602020600060407080608
Content-Type: text/plain;
 name="pnp_driver_res_do_not_test.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp_driver_res_do_not_test.diff"

commit 7d16e8b3e7739599d32c8006f9e84fadb86b8296
Author: Rene Herman <rene.herman@gmail.com>
Date:   Sat Jan 12 00:00:35 2008 +0100

    PNP: do not test PNP_DRIVER_RES_DO_NOT_CHANGE on suspend/resume
    
    The PNP_DRIVER_RES_DO_NOT_CHANGE flag is meant to signify that
    the PNP core should not change resources for the device -- not
    that it shouldn't disable/enable the device on suspend/resume.
    
    ALSA ISAPnP drivers set PNP_DRIVER_RES_DO_NOT_CHANAGE (0x0001)
    through setting PNP_DRIVER_RES_DISABLE (0x0003). The latter
    including the former may in itself be considered rather
    unexpected but doesn't change that suspend/resume wouldn't seem
    to have any business testing the flag.
    
    As reported by Ondrej Zary for snd-cs4236, ALSA driven ISAPnP
    cards don't survive swsusp hibernation with the resume skipping
    setting the resources due to testing the flag -- the same test
    in the suspend path isn't enough to keep hibernation from
    disabling the card it seems.
    
    These tests were added (in 2005) by Piere Ossman in commit
    68094e3251a664ee1389fcf179497237cbf78331, "alsa: Improved PnP
    suspend support" who doesn't remember why. This deletes them.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>
    Tested-by: Ondrej Zary <linux@rainbow-software.org>

diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index a262762..12a1645 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -161,8 +161,7 @@ static int pnp_bus_suspend(struct device *dev, pm_message_t state)
 			return error;
 	}
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
-	    pnp_can_disable(pnp_dev)) {
+	if (pnp_can_disable(pnp_dev)) {
 		error = pnp_stop_dev(pnp_dev);
 		if (error)
 			return error;
@@ -185,14 +184,17 @@ static int pnp_bus_resume(struct device *dev)
 	if (pnp_dev->protocol && pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
+	if (pnp_can_write(pnp_dev)) {
 		error = pnp_start_dev(pnp_dev);
 		if (error)
 			return error;
 	}
 
-	if (pnp_drv->resume)
-		return pnp_drv->resume(pnp_dev);
+	if (pnp_drv->resume) {
+		error = pnp_drv->resume(pnp_dev);
+		if (error)
+			return error;
+	}
 
 	return 0;
 }

--------------010602020600060407080608--
