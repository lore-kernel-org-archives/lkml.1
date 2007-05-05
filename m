Return-Path: <linux-kernel-owner+w=401wt.eu-S1423264AbXEEPo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423264AbXEEPo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423238AbXEEPo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:44:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423283AbXEEPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:44:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Date: Sat, 5 May 2007 15:50:52 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <200705041132.32227.rjw@sisk.pl> <200705051421.31067.rjw@sisk.pl> <1178368028.7408.93.camel@johannes.berg>
In-Reply-To: <1178368028.7408.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705051550.53436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 May 2007 14:27, Johannes Berg wrote:
> On Sat, 2007-05-05 at 14:21 +0200, Rafael J. Wysocki wrote:
> > 
> > Power off the system instead of halting it if the 'platform' mode of
> > hibernation
> > has been requested, but hibernation_ops is not set. 
> 
> Ehm, unless you made a mistake in the patch then that shouldn't be
> possible.

Hmm, right, but the patch is correct nevertheless. :-)

I see where the problem is.  hibernation_mode is 0 by default
(HIBERNATION_INVALID) and it's not changed to anything else later if
defaults are used.

Something like this is necessary, I think:

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Make sure that hibernation_mode is set to a reasonable value by default.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.21/kernel/power/disk.c
===================================================================
--- linux-2.6.21.orig/kernel/power/disk.c	2007-05-05 13:51:45.000000000 +0200
+++ linux-2.6.21/kernel/power/disk.c	2007-05-05 15:45:23.000000000 +0200
@@ -30,8 +30,6 @@ char resume_file[256] = CONFIG_PM_STD_PA
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
-static int hibernation_mode;
-
 enum {
 	HIBERNATION_INVALID,
 	HIBERNATION_PLATFORM,
@@ -45,6 +43,8 @@ enum {
 #define HIBERNATION_MAX (__HIBERNATION_AFTER_LAST-1)
 #define HIBERNATION_FIRST (HIBERNATION_INVALID + 1)
 
+static int hibernation_mode = HIBERNATION_SHUTDOWN;
+
 struct hibernation_ops *hibernation_ops;
 
 /**
@@ -60,6 +60,9 @@ void hibernation_set_ops(struct hibernat
 	}
 	mutex_lock(&pm_mutex);
 	hibernation_ops = ops;
+	if (ops)
+		hibernation_mode = HIBERNATION_PLATFORM;
+
 	mutex_unlock(&pm_mutex);
 }
 
