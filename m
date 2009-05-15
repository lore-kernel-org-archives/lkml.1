Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZEOJJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZEOJJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbZEOJIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:08:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36285 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbZEOJIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:08:48 -0400
Date: Fri, 15 May 2009 11:08:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org
Subject: suspending machine from kernel (was Re: [linux-pm] [RFC] why do we
	need run disk sync before entering S3)
Message-ID: <20090515090843.GC32740@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0905131000360.3004-100000@iolanthe.rowland.org> <200905131616.27334.rjw@sisk.pl> <20090514094249.GG6417@elf.ucw.cz> <20090515010055.GB21718@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515010055.GB21718@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-14 22:00:56, Henrique de Moraes Holschuh wrote:
> On Thu, 14 May 2009, Pavel Machek wrote:
> > But remember there are even in-kernel s2ram triggers, for example on
> > zaurus when battery goes critical.
> 
> Are there?  I am quite interested on this!

Yes.

It is a bit of mess, but see

common/sharpsl_pm.c:

   /* Suspend if critical battery level */
        if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
                        && (sharpsl_pm.battstat.mainbat_status ==
APM_BATTERY_STATUS_CRITICAL)
                        && !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
                sharpsl_pm.flags |= SHARPSL_APM_QUEUED;
                dev_err(sharpsl_pm.dev, "Fatal Off\n");
                apm_queue_event(APM_CRITICAL_SUSPEND);
        }

it eventually triggers regular s2ram paths.

Older versions did suspend on power button press. (You can't really
turn zaurus _off_, AFAICT.)

> Are they safe on x86?

Well, probably safe but definitely would need some cleanup.

> thinkpad-acpi receives some critical alarms from the firmware, for which the
> recommended action by the vendor is to go into S3 immediately.  There is
> also one which requires S4 as the recommended damage control measure.

While s2ram should always work on hardware that supports it (zaurus),
S4 is more tricky. It needs swap to be configured, and userspace
cooperation in uswsusp case.

I guess sending signal to init would be right solution in that
case. (ACPI already does that on overheat.)

								Pavel
(Sorry about breaking Ccs)
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
