Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbXK3Xdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbXK3Xdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762362AbXK3XdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:33:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762924AbXK3XdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:33:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [lm-sensors] [PATCH 1/1] HWMON: coretemp, suspend fix
Date: Sat, 1 Dec 2007 00:51:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
References: <661416096128474967.slaby@pripojeni.net> <47508C72.8050703@gmail.com> <200712010045.50297.rjw@sisk.pl>
In-Reply-To: <200712010045.50297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712010051.41227.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 1 of December 2007, Rafael J. Wysocki wrote:
> On Friday, 30 of November 2007, Jiri Slaby wrote:
> > On 11/30/2007 11:15 PM, Jean Delvare wrote:
> > > Hi Jiri,
> > 
[--snip--]
> > > 
> > > Should this change go to the stable tree(s) as well?
> > 
> > Sorry, I have no idea. Rafael?
> 
> Well, actually, having looked once again at the patch, I think that it's
> slightly wrong.  Namely, it looks like we just should drop all of the _FROZEN
> actions from there.
> 
> Fixed patch follows and I think it's also a candidate for -stable.

Crap, I forgot to add the sign-off, so here it goes again:

---
Subject: HWMON: coretemp, suspend fix
 
It's not permitted to unregister a device after devices have been suspended.
It causes deadlocks to appear on systems with coretemp hwmon loaded.  To avoid
this, we can make coretemp_cpu_callback() do nothing if the _FROZEN bit is set
in action.
 
Also, in other cases it's generally to late to unregister the coretemp device
if the CPU is already dead, so it should be unregistered on CPU_DOWN_PREPARE.
 
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
