Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYKFAf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYKFAf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYKFAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:35:47 -0500
Received: from eazy.amigager.de ([213.239.192.238]:50815 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYKFAfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:35:47 -0500
Date: Thu, 6 Nov 2008 01:35:44 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106003543.GA14766@x61>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20081105162401.GF14931@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2008 at 14:24:01 -0200, Henrique de Moraes Holschuh wrote:

[...]

> It should not have set the fan to level 7, so it means we will need to add
> debugging hints to the driver.  I don't have my T43 with me right now, or I
> could try to reproduce the issue.
> 
> Are you confortable with adding some printk's to kernel source?  If so, try
> to printk the interesting bits in fan_suspend and fan_resume on
> drivers/misc/thinkpad_acpi.c.

In fan_init(), fan_control_desired_level is set to 7, and never changed
to anything else. It is not set in fan_suspend() because
tp_features.fan_ctrl_status_undef is 0 (also set in fan_init()).

In fan_resume(), saved_fan_level is taken from
fan_control_desired_level. current_level is read and set to
TP_EC_FAN_AUTO.

Now the following check is true:

saved_fan_level == 7 && !(current_level & TP_EC_FAN_FULLSPEED))

So do_set is set to true and the fan speed is set to 7 at resume.

I tried to write a correct patch, but I got lost in all that
fan_control_desired_level, fan_control_initial_status and
tp_features.fan_ctrl_status_undef stuff.

My brain says that one would just read the current fan settings from
the EC at initialization. Then, after resume, this setting is restored
unconditionally, or at least if it differs from current_level. The
attached patch works for me. However, I don't have all the knowledge
about older models and their specific behaviour.

Correction: I just tested a bit further, and it doesn't work. If I set
fan level to 3, suspend, resume, set fan level to auto, and
resume/suspend again, fan level is restored to 3. This is because
fan_control_desired_level isn't updated by fan_update_desired_level()
if it is set back to auto, but kept at the old value. So, my impression
is that all the values and states should be cleaned up a bit and
simplified. In the current state, there are a lot of strage checks and
quirks that have side effects when other parts are changed.

Regards,
Tino

--EeQfGwPcQSOJBaQU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="thinkpad-acpi_fan-level-restore-fix.diff"

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 4db1cf9..fa2b8df 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -5886,6 +5886,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 		if (likely(acpi_ec_read(fan_status_offset,
 					&fan_control_initial_status))) {
 			fan_status_access_mode = TPACPI_FAN_RD_TPEC;
+			fan_control_desired_level = fan_control_initial_status;
 
 			/* In some ThinkPads, neither the EC nor the ACPI
 			 * DSDT initialize the fan status, and it ends up
@@ -6025,9 +6026,7 @@ static void fan_resume(void)
 		break;
 	case TPACPI_FAN_WR_ACPI_FANS:
 	case TPACPI_FAN_WR_TPEC:
-		do_set = ((saved_fan_level & TP_EC_FAN_FULLSPEED) ||
-			  (saved_fan_level == 7 &&
-			   !(current_level & TP_EC_FAN_FULLSPEED)));
+		do_set = 1;
 		break;
 	default:
 		return;

--EeQfGwPcQSOJBaQU--
