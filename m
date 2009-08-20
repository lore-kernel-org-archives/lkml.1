Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZHTF1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZHTF1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZHTF1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:27:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54547 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZHTF1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:27:23 -0400
Date: Thu, 20 Aug 2009 15:07:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhao Yakui <yakui.zhao@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20090820150740.e810a35f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/drm_edid.c between commit
ebb177d2afb8532a8a316489aed545ed0c170802 ("drm/edid: fixup detailed
timings like the X server.") from Linus' tree and commit
5c61259e6c7290082108e93815f7f72f27da14f4 ("drm/mode: get the modeline for
standard timing in EDID by using CVT/GTF") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_edid.c
index 7f2728b,bbcb2e2..0000000
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@@ -502,40 -547,12 +547,41 @@@ static int add_detailed_info(struct drm
  		struct detailed_non_pixel *data = &timing->data.other_data;
  		struct drm_display_mode *newmode;
  
 -		/* EDID up to and including 1.2 may put monitor info here */
 -		if (edid->version == 1 && edid->revision < 3)
 -			continue;
 -
 -		/* Detailed mode timing */
 -		if (timing->pixel_clock) {
 +		/* X server check is version 1.1 or higher */
 +		if (edid->version == 1 && edid->revision >= 1 &&
 +		    !timing->pixel_clock) {
 +			/* Other timing or info */
 +			switch (data->type) {
 +			case EDID_DETAIL_MONITOR_SERIAL:
 +				break;
 +			case EDID_DETAIL_MONITOR_STRING:
 +				break;
 +			case EDID_DETAIL_MONITOR_RANGE:
 +				/* Get monitor range data */
 +				break;
 +			case EDID_DETAIL_MONITOR_NAME:
 +				break;
 +			case EDID_DETAIL_MONITOR_CPDATA:
 +				break;
 +			case EDID_DETAIL_STD_MODES:
 +				/* Five modes per detailed section */
 +				for (j = 0; j < 5; i++) {
 +					struct std_timing *std;
 +					struct drm_display_mode *newmode;
 +
 +					std = &data->data.timings[j];
- 					newmode = drm_mode_std(dev, std);
++					newmode = drm_mode_std(dev, std,
++							timing_level);
 +					if (newmode) {
 +						drm_mode_probed_add(connector, newmode);
 +						modes++;
 +					}
 +				}
 +				break;
 +			default:
 +				break;
 +			}
 +		} else {
  			newmode = drm_mode_detailed(dev, edid, timing, quirks);
  			if (!newmode)
  				continue;
