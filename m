Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZBKN2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZBKN2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZBKN2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:28:21 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53494 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZBKN2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:28:20 -0500
Date: Wed, 11 Feb 2009 13:28:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Message-ID: <20090211132817.GD25898@shadowen.org>
References: <20090204191540.2d6abd87@infradead.org> <20090211014506.GA5075@srcf.ucam.org> <alpine.LRH.1.10.0902111315360.22097@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0902111315360.22097@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 01:17:02PM +0100, Jiri Kosina wrote:
> On Wed, 11 Feb 2009, Matthew Garrett wrote:
> 
> > https://lists.ubuntu.com/archives/kernel-team/2009-February/004335.html 
> > be related? It seems quite plausible that we want to do this on all 
> > hardware.
> 
> Actually I have also hit this on several machines. Dmitry, I would propose 
> to take Andy's patch (maybe even for 2.6.29?), it would save us a lot of 
> bugreports in the future.

Yes I was about to push this upstream.  I was supprised we had not seen
any other reports of it, seems that we have all been seeing it and not
realised.

Including the patch inline for those who prefer to avoid links.

-apw

>From cce152ae74a5084c7e3dffc25032d43908a5fa77 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Mon, 2 Feb 2009 16:32:25 +0000
Subject: [PATCH 1/1] psmouse/synaptics: ensure we reset the device on resume

When resuming from suspend newer Synaptics touchpads do not recover
correctly.  Analysis of the resume sequence as applied in Linux was
compared to that of other operating systems.  This indicated that the
other OSs were resetting the mouse before attempting to detect it (for
all Synaptics touchpads, old and new).  Applying this same modification
fixes these newer Synaptics touchpads and brings the driver into line
with common OS reset behaviour.

This patch adds this reset by default providing a module option to
restore the previous non-reset behaviour:

	psmouse.synaptics_resume_reset=N

Also a message is emmitted on resume hinting as to how to fix a broken
touchpad.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/input/mouse/synaptics.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d349c4a..5b01c14 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -60,11 +60,21 @@ static int synaptics_mode_cmd(struct psmouse *psmouse, unsigned char mode)
 	return 0;
 }
 
+static int synaptics_resume_reset = 1;
+module_param(synaptics_resume_reset, bool, 0);
+MODULE_PARM_DESC(synaptics_resume_reset,
+				"Enable reset on resume for Synaptics");
+
 int synaptics_detect(struct psmouse *psmouse, int set_properties)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[4];
 
+	if (synaptics_resume_reset) {
+		printk(KERN_CRIT "WARNING: synaptics was reset on resume, see synaptics_resume_reset if you have trouble on resume\n");
+		psmouse_reset(psmouse);
+	}
+
 	param[0] = 0;
 
 	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-- 
1.6.1.2.419.g0d87e
