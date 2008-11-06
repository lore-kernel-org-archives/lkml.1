Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYKFIX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYKFIX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYKFIXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:23:18 -0500
Received: from eazy.amigager.de ([213.239.192.238]:45501 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYKFIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:23:17 -0500
Date: Thu, 6 Nov 2008 09:23:14 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106082314.GA18430@x61>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20081106003543.GA14766@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2008 at 01:35:44 +0100, Tino Keitel wrote:

[...]

> I tried to write a correct patch, but I got lost in all that
> fan_control_desired_level, fan_control_initial_status and
> tp_features.fan_ctrl_status_undef stuff.
> 
> My brain says that one would just read the current fan settings from
> the EC at initialization. Then, after resume, this setting is restored
> unconditionally, or at least if it differs from current_level. The
> attached patch works for me. However, I don't have all the knowledge
> about older models and their specific behaviour.
> 
> Correction: I just tested a bit further, and it doesn't work. If I set
> fan level to 3, suspend, resume, set fan level to auto, and
> resume/suspend again, fan level is restored to 3. This is because
> fan_control_desired_level isn't updated by fan_update_desired_level()
> if it is set back to auto, but kept at the old value. So, my impression
> is that all the values and states should be cleaned up a bit and
> simplified. In the current state, there are a lot of strage checks and
> quirks that have side effects when other parts are changed.

The whole fan level stuff looks a bit complicated to me. Especially the
fan_control_desired_level handling is somethat strange because it
considers values as invalid that are written by fan_set_level() before.
It ignores the TP_EC_FAN_FULLSPEED and TP_EC_FAN_AUTO values. Now, in
fan_resume(), this value is checked against TP_EC_FAN_FULLSPEED which
makes no sense to me.

The attached patch tries to simplify this a bit. It sets
fan_control_desired_level to the current EC value in fan_init(), and
also tries to keep fan_control_desired_level and the real EC value in
sync. I also removed the checks against 7 and TP_EC_FAN_FULLSPEED in
fan_resume() as they made no sense to me. This works as intended on my
X61s after rmmod/insmod and suspend/resume.

Regards,
Tino

--YiEDa0DAkWCtVeE4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="thinkpad-acpi_fan-level-restore-fix_v2.diff"

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 4db1cf9..7f095c4 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -5329,13 +5329,8 @@ TPACPI_HANDLE(sfan, ec, "SFAN",	/* 570 */
  */
 static void fan_update_desired_level(u8 status)
 {
-	if ((status &
-	     (TP_EC_FAN_AUTO | TP_EC_FAN_FULLSPEED)) == 0) {
-		if (status > 7)
-			fan_control_desired_level = 7;
-		else
-			fan_control_desired_level = status;
-	}
+	fan_control_desired_level = status &
+		(TP_EC_FAN_AUTO | TP_EC_FAN_FULLSPEED | 7);
 }
 
 static int fan_get_status(u8 *status)
@@ -5886,6 +5881,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 		if (likely(acpi_ec_read(fan_status_offset,
 					&fan_control_initial_status))) {
 			fan_status_access_mode = TPACPI_FAN_RD_TPEC;
+			fan_update_desired_level(fan_control_initial_status);
 
 			/* In some ThinkPads, neither the EC nor the ACPI
 			 * DSDT initialize the fan status, and it ends up
@@ -6025,9 +6021,8 @@ static void fan_resume(void)
 		break;
 	case TPACPI_FAN_WR_ACPI_FANS:
 	case TPACPI_FAN_WR_TPEC:
-		do_set = ((saved_fan_level & TP_EC_FAN_FULLSPEED) ||
-			  (saved_fan_level == 7 &&
-			   !(current_level & TP_EC_FAN_FULLSPEED)));
+		do_set = (current_level != saved_fan_level) && 
+			!(current_level & TP_EC_FAN_FULLSPEED);
 		break;
 	default:
 		return;

--YiEDa0DAkWCtVeE4--
