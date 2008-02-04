Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYBDXZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYBDXZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbYBDXZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:25:44 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:48327 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbYBDXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:25:43 -0500
Message-ID: <47A79EC8.6060700@tiscali.nl>
Date: Tue, 05 Feb 2008 00:24:56 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: len.brown@intel.com, ibm-acpi@hmh.eng.br,
       ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/misc/thinkpad_acpi.c] duplicate test if (level &
 TP_EC_FAN_FULLSPEED)
References: <47A78CBB.2090401@tiscali.nl> <ada8x20gykq.fsf@cisco.com>
In-Reply-To: <ada8x20gykq.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  >                 /* safety net should the EC not support AUTO
>  >                  * or FULLSPEED mode bits and just ignore them */
>  >                 if (level & TP_EC_FAN_FULLSPEED)
>  >                         level |= 7;     /* safety min speed 7 */
>  >                 else if (level & TP_EC_FAN_FULLSPEED)
>  >                         level |= 4;     /* safety min speed 4 */
>  > 
>  > Note the duplicate test 'if (level & TP_EC_FAN_FULLSPEED)'. should
>  > this be replaced by
> 
> Actually I suspect one of the two tests should be against TP_EC_FAN_AUTO
> (based on the comment).
> 

Thanks Roland, for your info

based on the comments in commit eaa7571b2d1a08873e4bdd8e6db3431df61cd9ad,
I think this should be modified like below:

ACPI: thinkpad-acpi: add a safety net for TPEC fan control mode
The Linux ThinkPad community is not positive that all ThinkPads that do
HFSP EC fan control do implement full-speed and auto modes, some of the
earlier ones supporting HFSP might not.

If the EC ignores the AUTO or FULL-SPEED bits, it will pay attention to the
lower three bits that set the fan level. And as thinkpad-acpi was leaving
these set to zero, it would stop(!) the fan, which is Not A Good Thing.
So, as a safety net, we now make sure to also set the fan level part of the
HFSP register to speed 7 for full-speed, and a minimum of speed 4 for auto
mode.
--
second TP_EC_FAN_FULLSPEED should be P_EC_FAN_AUTO


Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index cf56647..3c323fe 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -4138,7 +4138,7 @@ static int fan_set_level(int level)
 		 * or FULLSPEED mode bits and just ignore them */
 		if (level & TP_EC_FAN_FULLSPEED)
 			level |= 7;	/* safety min speed 7 */
-		else if (level & TP_EC_FAN_FULLSPEED)
+		else if (level & TP_EC_FAN_AUTO)
 			level |= 4;	/* safety min speed 4 */
 
 		if (!acpi_ec_write(fan_status_offset, level))

