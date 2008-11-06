Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYKFOLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYKFOLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYKFOL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:11:27 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60326 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbYKFOL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:11:26 -0500
X-Sasl-enc: xhym16KDYcf1j40LMud2Ifvc7/W13vstVuRS/mP8En3m 1225980684
Date: Thu, 6 Nov 2008 12:11:21 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106141121.GB23278@khazad-dum.debian.net>
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106003543.GA14766@x61>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008, Tino Keitel wrote:
> On Wed, Nov 05, 2008 at 14:24:01 -0200, Henrique de Moraes Holschuh wrote:
> In fan_init(), fan_control_desired_level is set to 7, and never changed
> to anything else. It is not set in fan_suspend() because
> tp_features.fan_ctrl_status_undef is 0 (also set in fan_init()).

fan_suspend calls fan_get_status_safe(NULL).

fan_get_status_safe(NULL) will update fan_control_desired_level if it can
get the fan status without an error... unless it is set to AUTO or FULL
SPEED, and it is VERY likely to be set to AUTO.

So it is borked, indeed.  That explains why it is not being initialized to
something else than 7.  Weird that I didn't notice it here when testing,
must have confused it with the effects of the T43 firmware bug.

> I tried to write a correct patch, but I got lost in all that
> fan_control_desired_level, fan_control_initial_status and
> tp_features.fan_ctrl_status_undef stuff.

Ignore fan_ctrl_status_undef, it is a workaround for a firmware bug you
don't have (it is specific to the T43 ACPI DSDT).  Basically, you cannot
trust a fan_get_status() return of level 7 while fan_ctrl_status_undef is
active, it could be AUTO instead.

> My brain says that one would just read the current fan settings from
> the EC at initialization. Then, after resume, this setting is restored
> unconditionally, or at least if it differs from current_level. The

Never.  I will sooner remove the keep settings across suspend/resume than
touch the fan controller unconditionally.  The ACPI DSDT or the EC itself
may have changed the fan mode while we were sleeping, and for a good reason
(like a thermal emergency).

The fan must NEVER be slowed down by the fan_resume() method.  This pretty
much means it can only restore the fan to full-speed, auto or level 7 on a
new-style fan control like the one found on your thinkpad.  And that it
needs to query the state first, must do nothing if it cannot read the state,
and must set it to the higher of (saved, current) using this rule:

fulll-speed > 7 > AUTO.

> Correction: I just tested a bit further, and it doesn't work. If I set
> fan level to 3, suspend, resume, set fan level to auto, and
> resume/suspend again, fan level is restored to 3. This is because
> fan_control_desired_level isn't updated by fan_update_desired_level()

Fan level should NEVER be restored to 3, it should end up set to auto,
full-speed, or 7 when the box finishes resuming.  If it can be restored to
3, something is hideously broken.

Maybe something in the hwmon class is also trying to keep values across
sleep/suspend?

Could you instrument fan_set_level() and check what levels it is being
called with, and when?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
