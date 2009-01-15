Return-Path: <linux-kernel-owner+w=401wt.eu-S932988AbZAOW4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988AbZAOW4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935499AbZAOWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:32:35 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:26400 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934956AbZAOWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:32:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=T/jkjbY9I3qB1C1Y5DnLbRc04+UqXRVHglmg3dQfFixLy9wYe+Jc39ZVCNtuj5PIAy8uqMsdypQP+HoWDpRhN0O2EZUgXZtt+MXqST3YR0bxPFNNdGkbI+2QvdvYqlA25B4uYws1fhsDQmvRjLiU93zD8HhXR5LOW0EdY7eNybw=  ;
X-YMail-OSG: 9hRyuCAVM1n.VD3tPw6qpWaOQcclfmDPC.xOT7s79t1.V6RUPsdZxtVNdu_xVES1K5IX3vuYLkB9D_qSTCeO6EgekC2g402EFjdFlNPFoBrSDKGM_iZNLEa36IvdnxFPzc.KMDE0h70uttjPruGRjKELYuDAl_o31_mS4ILQl1B0MeVBJapH4wu2RSo1.ggC4hzHOdzKM5bhVvSRtlx65zADMIGiE74vlY23sQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Thu, 15 Jan 2009 14:32:30 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200901142303.09217.david-b@pacbell.net> <20090115122937.GC2147@sirena.org.uk>
In-Reply-To: <20090115122937.GC2147@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901151432.31130.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Mark Brown wrote:
> > That raises an issue:  how can Linux get such regulators to
> > turn off?  Clock frameworks have the same issue, and they
> > tend to resolve this with a SoC-specific Kconfig option to
> > disable unused clocks (in a late_initcall, after everthing
> > has had a chance to start up).  That conserves power.
> 
> That's something that should be done by constraints - add a new flag
> that can be set.

That doesn't make any sense to me, any more than
adding a per-clock flag would.


> > I'm thinking it'd be worth having a similar Kconfig option
> > for regulators too.  It could kick in regulator core code to
> > call regulator_ops.disable() whenever regulator_dev.use_count
> > is zero, possibly warning if !regulator_ops.is_disabled().
> > (Handling constraints.always_on too.)
> 
> > Comments?
> 
> Given the model the API has of not doing anything unless explicitly
> told to

... e.g. by CONFIG_REGULATOR_DISABLE_UNUSED being explicitly
set, indicating that the regulator support for that platform
(and its drivers) is complete enough that it can safely paper
over such early init issues.


> I'd not expect to see this as a Kconfig option but rather as 
> something enabled per regulator or at least per board.

Why not, though?  That works well with clocks, once the
drivers are debugged.  Having dozens of fiddly little knobs
is not an advantage.

 
> The warning would be a bit interesting; ideally there should be one
> since it's probably an indication that something is wrong but there
> are probably going to be use cases for it that can't be covered by
> always_on, not that I can think of any right now.

The "boot_on" flag seems redundant with given "always_on"; as
a rule you can *tell* if the bootloader enabled a supply, so
the issue is more like whether it should stay on, even when no
driver wants it on.  Especially considering that bootloaders
seldom guarantee to enable only a minimal set of supplies.

See the appended patch.

- Dave


=========== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

Let the regulator framework disable regulators that have wrongly
been left enabled.  In the same manner as various implementations
of the clock framework, this is done by a late_initcall after all
drivers have had a chance to say what should be enabled.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/Kconfig |   11 +++++++++++
 drivers/regulator/core.c  |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -32,6 +32,17 @@ config REGULATOR_FIXED_VOLTAGE
 	tristate
 	default n
 
+config REGULATOR_DISABLE_UNUSED
+	bool "Disable unused regulators"
+	help
+	  Board initialization sometimes leaves a few regulators
+	  active even though they are not being used.  This option
+	  disables such regulators after all drivers have had a chance
+	  to initialize and enable their regulators, conserving power.
+
+	  If you're not sure that all your drivers have been properly
+	  integrated with the regulator framework, say no.
+
 config REGULATOR_VIRTUAL_CONSUMER
 	tristate "Virtual regulator consumer support"
 	default n
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -763,6 +763,7 @@ static int set_machine_constraints(struc
 			rdev->constraints = NULL;
 			goto out;
 		}
+		rdev->use_count = 1;
 	}
 
 	print_constraints(rdev);
@@ -2106,3 +2107,36 @@ static int __init regulator_init(void)
 
 /* init early to allow our consumers to complete system booting */
 core_initcall(regulator_init);
+
+static int __init regulator_disable_unused(void)
+{
+	struct regulator_dev *rdev;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rdev, &regulator_list, list) {
+		int	status;
+
+		if (rdev->use_count > 0)
+			continue;
+
+		status = _regulator_is_enabled(rdev);
+		if (status == 0)
+			continue;
+
+		if (status > 0)
+			dev_warn(&rdev->dev, "%s is unused but enabled\n",
+				rdev->desc->name);
+
+#ifdef CONFIG_REGULATOR_DISABLE_UNUSED
+		if (!rdev->desc->ops->disable)
+			continue;
+		status = rdev->desc->ops->disable(rdev);
+		if (status < 0)
+			dev_err(&rdev->dev, "%s error %d when disabling\n",
+					rdev->desc->name, status);
+#endif
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return 0;
+}
+late_initcall(regulator_disable_unused);
