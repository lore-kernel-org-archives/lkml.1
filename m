Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYJKPjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYJKPjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYJKPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:38:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49032 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753519AbYJKPiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:38:55 -0400
Date: Sat, 11 Oct 2008 16:38:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] mfd: Add WM8350 subdevice registration helper
Message-ID: <20081011153853.GB4633@opensource.wolfsonmicro.com>
References: <1223650696-15552-6-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-7-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-8-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-9-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-10-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-11-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-12-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-13-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-14-git-send-email-broonie@opensource.wolfsonmicro.com> <20081011141820.GC2712@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011141820.GC2712@sortiz.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 04:18:20PM +0200, Samuel Ortiz wrote:
> On Fri, Oct 10, 2008 at 03:58:16PM +0100, Mark Brown wrote:

> > Most of the subdevices for the WM8350 code are registered in the same
> > fashion so factor out the code to do the initial registration.

> Out of curiosity (and also because I would like to start working on improving
> mfd-core), why didnt you consider using the mfd-core API ?

I did actually consider that - if it hadn't been so near the merge
window it'd have got a bit more attention but I'd been going for a
minimally invasive approach.

Originally the major issue was that the MFD API only worked for platform
devices but that has now been resolved.  Now the main issue for the
WM8350 is that the MFD core API uses platform_device_add_resources()
unconditionally but that fails if the device has no resources as will be
the case for anything on the WM8350, at least until I integrate the
interrupt controller with the standard interrupt interface.   The MFD
core does ignore the result of the call currently but it probably
shouldn't and I didn't want to rely on it continuing to do so.  The
patch below ought to address that, though it's tested with my "Hey,
look!  It compiles!" test plan - if it looks sane to you I'll give it a
test and repost with a proper changelog.

It's not an issue for the WM8350 but some devices with interrupt
controllers may have issues since currently the MFD API wants to put all
the interrupts within a per-device range but for some devices there will
be interrupts exposed via separate IRQ lines (so you don't have to take
the hit of working with an I2C/SPI interrupt controller) meaning that
some of the interrupts for subdevices may be in different ranges.  For
the WM8350 this isn't such a problem since everything *can* go via the
main interrupt controller and overrides can be provided via platform
data (as they are at present, though the main interrupt controller
doesn't use the standard API) but if use of a separate interrupt line
were non-optional it'd be a problem.

There's also the issue of passing over the pointer to the shared device
data for arbitration - you can use platform data but the MFD API wants
to copy it so it's a bit fiddly.  I'm thinking that the sensible thing
may just be to have the child devices use the parent link in the device
tree for this which is already fine with the MFD core.

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 9c9c126..9384206 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -60,7 +60,12 @@ static int mfd_add_device(struct device *parent, int id,
 		}
 	}
 
-	platform_device_add_resources(pdev, res, cell->num_resources);
+	if (cell->num_resources) {
+		ret = platform_device_add_resources(pdev, res,
+						    cell->num_resources);
+		if (ret)
+			goto fail_device;
+	}
 
 	ret = platform_device_add(pdev);
 	if (ret)
