Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529Ab0A0Jbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0A0Jbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461Ab0A0Jbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:31:49 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:46064 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0A0Jbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:31:47 -0500
Message-ID: <4B60080E.2000508@xenontk.org>
Date: Wed, 27 Jan 2010 15:01:58 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, yakui.zhao@intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Fix For Korg Bug #14897 (GM45 Display Flicker)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse, Yakui,

Sorry for the delay, but I was busy with other work last week. I got
some time to look into this on Monday and the problem seems to be this:

With the external display connected on VGA, intel_update_watermarks
calls update_wm a couple of times in sequence with the following params:

1) planea_clock = 148500 planeb_clock = 0, sr_hdisplay=1920 (VGA)
2) planea_clock = 148500 planeb_clock = 72330, sr_hdisplay=1366 (LVDS)

In update_wm (in my case g4x_update_wm), for 1) sr_entries is calculated
correctly and self refresh is enabled. For 2) sr_entries remains zero
and the SR watermark is set as such. However, SR remains
active. On mode switch to console, this causes a FIFO underrun and the
display flicker.

The solution that I see is to simply disable SR if more than one pipe is
enabled. I've written a patch that does this. Also another point is that
the G45 docs state that a particular sequence has to be followed if SR
is to be used when only one pipe is active for Cantiga (Pg 30, G45 Vol
3). I didn't see any code doing this, but I did not see any untoward
behaviour either, with only my patch applied.

I've updated the patch to fix i965 and i9xx as I assume the same problem
will occur on those chipsets as well, but this has _not_been tested as I
don't have the relevant platforms.

Patch follows this mail. Please let me know if any changes are required.

The VGA output powering-on on mode change mentioned in my bug report is
a separate DRM bug for which I will send a patch later.

Regards,
David.
