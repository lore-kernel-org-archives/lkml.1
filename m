Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYALUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYALUL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbYALULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:11:19 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:43945 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbYALULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:11:19 -0500
Message-ID: <47891E21.8060209@keyaccess.nl>
Date: Sat, 12 Jan 2008 21:08:01 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@suse.cz>, Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>,
       linux-pm@lists.linux-foundation.org
Subject: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch breaks
 resuming isapnp cards
References: <200801092343.48726.linux@rainbow-software.org> <20080112162150.1ec9cad0@poseidon.drzeus.cx> <4788F226.7040101@keyaccess.nl> <200801122008.10313.rjw@sisk.pl>
In-Reply-To: <200801122008.10313.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------030900050006070904040005"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030900050006070904040005
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

pnp-do-not-stop-start-devices-in-suspend-resume-path.patch in current -mm 
breaks resuming isapnp cards from hibernation. They need the pnp_start_dev 
to enable the device again after hibernation.

They don't really need the pnp_stop_dev() which the above mentioned patch 
also removes but with the pnp_start_dev() restored it seems pnp_stop_dev() 
should also stay. Bjorn Helgaas should decide  -- currently the patch as you 
have it breaks drivers though. Could you drop it?

Then, if so and after you do that, could you apply the attached? That's also 
needed to resume (ALSA) ISA-PnP cards from hibernation due to the 
RES_DO_NOT_CHANGE test triggering for ALSA drivers and the pnp_start_dev() 
still not happening. More in the changelog...

On 12-01-08 20:08, Rafael J. Wysocki wrote:

> On Saturday, 12 of January 2008, Rene Herman wrote:

>> It seems all PnP drivers would need to stick a pnp_start_dev in their resume 
>> method
> 
> Yes.
> 
>> then which means it really belongs in core.
> 
> Yes, if practical.
> 
>> One important point where PnP and PCI differ is that PnP allows to change the
>> resources on a protocol level and I don't see how it could ever not be
>> necessary to restore the state a user may have set if power has been
>> removed. Hibernate is just that, isn't it?
> 
> Basically, yes, it is.

Rene.


--------------030900050006070904040005
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

--------------030900050006070904040005--
