Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXC2JKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXC2JKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXC2JKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:10:45 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:53612 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbXC2JKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:10:22 -0400
Date: Thu, 29 Mar 2007 11:12:18 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [Patch -mm 3/3] s390: cio: Delay uevents for subchannels.
Message-ID: <20070329111218.40c358dd@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

We often have the situation that we register a subchannel and start
device recognition, only to find out that the device is not usable
after all, which triggers an unregister of the subchannel. This often
happens on hundreds of subchannels on a LPAR, leading to a storm of
events which aren't of any use. Therefore, use uevent_suppress to
delay the KOBJ_ADD uevent for a subchannel until we know that its
ccw_device is to be registered.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/cio/css.c    |    9 +++++++++
 drivers/s390/cio/device.c |    6 ++++++
 2 files changed, 15 insertions(+)

--- linux-2.6.21-rc5-mm1.orig/drivers/s390/cio/device.c
+++ linux-2.6.21-rc5-mm1/drivers/s390/cio/device.c
@@ -903,6 +903,12 @@ io_subchannel_register(struct work_struc
 		}
 		goto out;
 	}
+	/*
+	 * Now we know this subchannel will stay, we can throw
+	 * our delayed uevent.
+	 */
+	sch->dev.uevent_suppress = 0;
+	kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 	/* make it known to the system */
 	ret = ccw_device_register(cdev);
 	if (ret) {
--- linux-2.6.21-rc5-mm1.orig/drivers/s390/cio/css.c
+++ linux-2.6.21-rc5-mm1/drivers/s390/cio/css.c
@@ -135,6 +135,15 @@ css_register_subchannel(struct subchanne
 	sch->dev.bus = &css_bus_type;
 	sch->dev.release = &css_subchannel_release;
 	sch->dev.groups = subch_attr_groups;
+	/*
+	 * We don't want to generate uevents for I/O subchannels that don't
+	 * have a working ccw device behind them since they will be
+	 * unregistered before they can be used anyway, so we delay the add
+	 * uevent until after device recognition was successful.
+	 */
+	if (!cio_is_console(sch->schid))
+		/* Console is special, no need to suppress. */
+		sch->dev.uevent_suppress = 1;
 
 	css_get_ssd_info(sch);
 
