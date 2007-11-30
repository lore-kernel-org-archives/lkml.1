Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbXK3X16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbXK3X16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759928AbXK3X1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:27:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32774 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759998AbXK3X12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:27:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [lm-sensors] [PATCH 1/1] HWMON: coretemp, suspend fix
Date: Sat, 1 Dec 2007 00:45:49 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
References: <661416096128474967.slaby@pripojeni.net> <20071130231512.1111d558@hyperion.delvare> <47508C72.8050703@gmail.com>
In-Reply-To: <47508C72.8050703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712010045.50297.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 30 of November 2007, Jiri Slaby wrote:
> On 11/30/2007 11:15 PM, Jean Delvare wrote:
> > Hi Jiri,
> 
> Hi.
> 
> > On Fri, 30 Nov 2007 15:12:46 +0100, Jiri Slaby wrote:
> >> Ok, I don't see it merged in the latest -mm (mmotm). Could you, Mark, Rafael,
> >> sign off this version of the patch (Mark's + Rafael's fix)?
> >>
> >> --
> >>
> >> From: Mark M. Hoffman <mhoffman@lightlink.com>
> >>
> >> coretemp, suspend fix
> >>
> >> It's not permitted to unregister device/cpu if frozen and going to sleep.
> >> It causes deadlock on systems, where coretemp hwmon is loaded. Do it only
> >> in non-freezed states instead.
> >>
> >> Cc: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
> >> Cc: Mark M. Hoffman <mhoffman@lightlink.com>
> >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> >>
> >> ---
> >> commit 4f0e19b172ed18fb29e8006c4470fd37aa245a7a
> >> tree bec1cc4f7a499efe94c5f9d2d208db325914f28e
> >> parent 877dcc2ef6c7c17a64155cf201886c49622250e9
> >> author Jiri Slaby <jirislaby@gmail.com> Tue, 27 Nov 2007 20:19:47 +0100
> >> committer Jiri Slaby <ku@bellona.localdomain> Thu, 29 Nov 2007 23:41:11 +0100
> >>
> >>  drivers/hwmon/coretemp.c |    6 ++++--
> >>  1 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> >> index 5c82ec7..ce7457d 100644
> >> --- a/drivers/hwmon/coretemp.c
> >> +++ b/drivers/hwmon/coretemp.c
> >> @@ -338,11 +338,13 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
> >>  	switch (action) {
> >>  	case CPU_ONLINE:
> >>  	case CPU_ONLINE_FROZEN:
> >> +	case CPU_DOWN_FAILED:
> >>  		coretemp_device_add(cpu);
> >> +	case CPU_DOWN_FAILED_FROZEN:
> >>  		break;
> >> -	case CPU_DEAD:
> >> -	case CPU_DEAD_FROZEN:
> >> +	case CPU_DOWN_PREPARE:
> >>  		coretemp_device_remove(cpu);
> >> +	case CPU_DOWN_PREPARE_FROZEN:
> >>  		break;
> >>  	}
> >>  	return NOTIFY_OK;
> > 
> > Should this change go to the stable tree(s) as well?
> 
> Sorry, I have no idea. Rafael?

Well, actually, having looked once again at the patch, I think that it's
slightly wrong.  Namely, it looks like we just should drop all of the _FROZEN
actions from there.

Fixed patch follows and I think it's also a candidate for -stable.

---
Subject: HWMON: coretemp, suspend fix

It's not permitted to unregister a device after devices have been suspended.
It causes deadlocks to appear on systems with coretemp hwmon loaded.  To avoid
this, we can make coretemp_cpu_callback() do nothing if the _FROZEN bit is set
in action.

Also, in other cases it's generally to late to unregister the coretemp device
if the CPU is already dead, so it should be unregistered on CPU_DOWN_PREPARE.

Cc: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/hwmon/coretemp.c
===================================================================
--- linux-2.6.orig/drivers/hwmon/coretemp.c
+++ linux-2.6/drivers/hwmon/coretemp.c
@@ -337,11 +337,10 @@ static int coretemp_cpu_callback(struct 
 
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED:
 		coretemp_device_add(cpu);
 		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DOWN_PREPARE:
 		coretemp_device_remove(cpu);
 		break;
 	}
