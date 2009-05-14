Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbZENCVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbZENCVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZENCVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:21:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:62717 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZENCVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lTmcb7EQvmTKQFZ3D9jjZ51rwHxHBSrxbFcQe1FR0Gwyca/LqanKEuVSbfVNnCbZG3
         Rh8AnOMY2qWObxK7puAnotdjL6wlY5c5o1+IbjvkSJ5bECCkXhHyxC4ctnd0gDASbjP4
         IfNxEqD775G5f2MNsJd18a7dVbS3zuKkwPT3c=
Date: Wed, 13 May 2009 19:21:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Alessandro Rubini <rubini@vision.unipv.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] psmouse:  ESD workaround fix for OLPC XO touchpad
Message-ID: <20090514022126.GA9461@dtor-d630.eng.vmware.com>
References: <20090514011603.GA12494@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514011603.GA12494@plexity.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Deepak,

On Thu, May 14, 2009 at 01:16:03AM +0000, Deepak Saxena wrote:
> This issue was found during testing back in 2007, before I
> was involved, and the fix has been carried in the OLPC tree 
> since then. Not sure how this would affect other systems so 
> wondering if we should wrap this specific check around 
> '#ifdef OLPC'?
> 

*sigh* Why can't we just implement standard?

I don't like the #ifdef, how about checking protocol type instead?

-- 
Dmitry


Input: psmouse - ESD workaround fix for OLPC XO touchpad

From: Zephaniah E. Hull <warp@aehallh.com>

It appears that when the XO touchpad unit resets from ESD, it sends AA
AA instead of AA 00, the psmouse-base code handles the case of AA 00 by
triggering a serio reconnect for the port, causing a full reprobe of
the device.

Testing with OFW shows that this is likely to solve the problem, so
the attached patch simply expands the existing test to also catch AA AA.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/psmouse-base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 4683b13..df31888 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -328,7 +328,9 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 			goto out;
 		}
 
-		if (psmouse->packet[1] == PSMOUSE_RET_ID) {
+		if (psmouse->packet[1] == PSMOUSE_RET_ID ||
+		    (psmouse->type == PSMOUSE_HGPK &&
+		     psmouse->packet[1] == PSMOUSE_RET_BAT)) {
 			__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
 			serio_reconnect(serio);
 			goto out;
