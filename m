Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbXEIMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbXEIMrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbXEIMrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:47:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXEIMrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:47:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tglx@linutronix.de
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Date: Wed, 9 May 2007 14:52:07 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
References: <20070430102837.748238000@linutronix.de> <1178701183.3042.469.camel@localhost.localdomain> <200705091345.55207.rjw@sisk.pl>
In-Reply-To: <200705091345.55207.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091452.08092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 May 2007 13:45, Rafael J. Wysocki wrote:
> On Wednesday, 9 May 2007 10:59, Thomas Gleixner wrote:
> > On Wed, 2007-05-09 at 01:31 -0700, Andrew Morton wrote:
> > > > I suspect I just tested the wrong thing yesterday.  Let me recheck just
> > > > these patches against 2.6.21.
> > > 
> > > yup, same hang with just these three:
> > > 
> > > origin
> > > clocksource-fix-resume-logic
> > > clockevents-fix-resume-logic-updated-version
> > 
> > I have no idea, how this affects acpi_evaluate_object()
> 
> I think the problem is that the ACPI code ordering here is broken in a
> difficult to fix way.
> 
> Definitely, we shouldn't execute the _BFS method after creating the image
> and most probably _WAK shouldn't be executed here either.  Moreover,
> acpi_leave_sleep_state() enables the runtime GPEs, which AFAICS
> is equivalent to allowing ACPI to generate SCIs.  I'm not sure if this is a
> good idea to do such a thing in this particular place.
> 
> Andrew, could you please apply the appended patch and see if that
> helps (should apply to -mm2)?

Argh, sorry.  This needs yet another patch (sent for review to linux-pm) to
be applied.  The following one is against -mm2:

---
NOTE: This is not a complete solution, because it removes the enabling of GPEs
from the resume-during-hibernation code path entirely, which probbably is not a
good idea in general.
---
 kernel/power/disk.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.21-mm2/kernel/power/disk.c
===================================================================
--- linux-2.6.21-mm2.orig/kernel/power/disk.c
+++ linux-2.6.21-mm2/kernel/power/disk.c
@@ -205,7 +205,6 @@ int hibernate(void)
 
 	if (in_suspend) {
 		enable_nonboot_cpus();
-		platform_finish();
 		device_resume();
 		resume_console();
 		pr_debug("PM: writing image.\n");
