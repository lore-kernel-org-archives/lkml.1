Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYENXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYENXk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYENXkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:40:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49387 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYENXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:40:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org>
	<200803140231.39282.rjw@sisk.pl>
	<m1prtsug2e.fsf@ebiederm.dsl.xmission.com>
	<200805142341.52078.maximlevitsky@gmail.com>
Date: Wed, 14 May 2008 16:34:48 -0700
In-Reply-To: <200805142341.52078.maximlevitsky@gmail.com> (Maxim Levitsky's
	message of "Wed, 14 May 2008 23:41:51 +0300")
Message-ID: <m1od78tq7b.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: Maxim Levitsky <maximlevitsky@gmail.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3176]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> First of all S4 ACPI code turns some leds on some systems,
> cosmetic thing, but still nice.
>
> Secondary, what about wakeup devices?
> Hardware can disable some devices in S5 while leave them running in S4
> on my system for example network card will do WOL in S4,
> but to make it WOL in S5 I have to turn a specific option in BIOS.
>
> While my system doesn't have this, it isn't uncommon for system to leave USB
> ports
> running so one can turn the PC with keyboard/mouse even in S4.
> in S5 those ports  will probably  be disabled.
> My system on have this for S3 only.
>
> On laptops we can expect even more ACPI functionality, so some more differences
> between
> S4 and S5 can happen.
>
> Last thing that I want to say is that, when linux puts PC in S? state, on top of
> executing
> _PTS, _GTS acpi functions, it writes the destination S state to a fixed
> register, thus the hardware
> can (and does) behave differently.

Yes.

S4 looks interesting.  Especially the weird fans don't work on restore
from S5 case.

S4 still appears to be a premature optimization, that ads lots of
complexity and reduces the reliability of the code.

Software hibernation to disk should be a rock solid proposition, that
needs little if any cooperation from drivers, and it should work on
every box, because fundamentally it is hardware agnostic.  The only
cooperation we need from drivers is for devices that we can't tolerate
at upper layers an unplug and replug event like block devices because
we would loose our filesystems.

All of the reports say hibernation is not rock solid reliable.
Things like S4 support keep us from being hardware agnostic.
Therefore it appears to me we have a design bug.

Which is why I'm not at all happy with S4 support.



It actually occurs to me that the first mode we should really support
is the mode where the user hits the power button themselves.  That
totally removes the hibernation path from any weird hardware
interactions.

Then S5 is an optimization upon that (just a little more work on the
shutdown path).

Then ultimately S4 reusing and refactoring the work for S3? suspend to
ram to allow us to leave very specific devices on.  But that is lot
of complexity, for a little bit of gain.

We should have code that works by design. Code that practically
every time.  Something that is easy to diagnose.


Eric
