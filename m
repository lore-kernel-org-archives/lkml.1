Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYAKBWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYAKBWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYAKBWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:22:09 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:54550 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbYAKBWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:22:08 -0500
Message-ID: <4786C40B.8050005@keyaccess.nl>
Date: Fri, 11 Jan 2008 02:19:07 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>
CC: ALSA development <alsa-devel@alsa-project.org>,
       Ondrej Zary <linux@rainbow-software.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@osdl.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
References: <200801092343.48726.linux@rainbow-software.org>	<47857A82.4050005@keyaccess.nl> <Pine.LNX.4.61.0801100849290.30240@tm8103.perex-int.cz>
In-Reply-To: <Pine.LNX.4.61.0801100849290.30240@tm8103.perex-int.cz>
Content-Type: multipart/mixed;
 boundary="------------080904060105090909000903"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080904060105090909000903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 10-01-08 08:58, Jaroslav Kysela wrote:

> On Thu, 10 Jan 2008, Rene Herman wrote:
> 
>> On 09-01-08 23:43, Ondrej Zary wrote:
>>
>> Jaroslav -- in your role as ISA-PnP maintainer and Bjorn, in yours as 
>> having been foollish enough to touch PnP recently:
>>
>>> as hibernation (swsusp) started to work with my CPU, I found that my Turtle 
>>> Beach Malibu stops working after resume from hibernation. It's caused by fact 
>>> that the card is not enabled on the pnp layer during resume - and thus card 
>>> registers are inaccessible (reads return FFs, writes go nowhere).
>>>
>>> During resume, pnp_bus_resume() in drivers/pnp/driver.c is called for each pnp 
>>> device. This function calls pnp_start_dev() only when the 
>>> PNP_DRIVER_RES_DO_NOT_CHANGE bit is NOT seting pnp_drv->flags. But the cs4236 
>>> driver in sound/isa/cs423x/cs4236.c explicitly sets the .flags to 
>>> PNP_DRIVER_RES_DISABLE - it's value is 3 and that includes 
>>> PNP_DRIVER_RES_DO_NOT_CHANGE bit.
>> Ehm. Isn't that a bit unexpected:
>>
>> #define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
>> of the device */
>> #define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
>> disabled */
>>
>> I'd say that disabling is changing, so isn't this just a braino where 
>> someone meant to write 2 instead of 3?
> 
> It's irrelevant. I think that condition in driver.c in suspend and resume 
> callbacks is invalid, because PNP_DRIVER_RES_DO_NOT_CHANGE means that 
> resources should not be changed in the pnp core but only in the driver, 
> but in suspend/resume process are resources preserved, so the condition 
> should be removed.

I see a PnP resume _consists_ of setting the resources so I can see the test 
implementation wise, but yes, conceptually it seems this test shouldn't be 
present. So just like the attached then?

Pierre, what was the idea here? Added the other SOBs to the CC as well...

> Author of this code is:
> 
> author Pierre Ossman <drzeus-list@drzeus.cx> Tue, 29 Nov 2005 09:09:32 +0100
> committer Jaroslav Kysela <perex@suse.cz> Tue, 03 Jan 2006 12:31:30 +0100
> 
>     [ALSA] [PATCH] alsa: Improved PnP suspend support
> 
>     Also use the PnP functions to start/stop the devices during the suspend so
>     that drivers will not have to duplicate this code.
> 
>     Cc: Adam Belay <ambx1@neo.rr.com>
>     Cc: Jaroslav Kysela <perex@suse.cz>
>     Cc: Takashi Iwai <tiwai@suse.de>
> 
>     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>

Rene.


--------------080904060105090909000903
Content-Type: text/plain;
 name="pnp_driver_res_do_not_test.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp_driver_res_do_not_test.diff"

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

--------------080904060105090909000903--
