Return-Path: <linux-kernel-owner+w=401wt.eu-S1763978AbXGYH6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763978AbXGYH6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXGYH6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:58:00 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:15334 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXGYH56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:57:58 -0400
Date: Wed, 25 Jul 2007 09:58:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Simon Arlott" <simon@fire.lp0.eu>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs/udev broken in 2.6.23-rc1 [input, i2c, ...] (Was:
 sysfs/udev broken in latest git?)
Message-ID: <20070725095808.09b2cc2a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650707241719w6c7f2dc7s1bc29d7f1dfd4288@mail.gmail.com>
References: <46A59EAA.9030105@simon.arlott.org.uk>
	<20070724072540.GA835@suse.de>
	<20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
	<20070724084654.GB13152@suse.de>
	<3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
	<20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>
	<46A628AC.3060900@simon.arlott.org.uk>
	<3ae72650707240934o68047677n97e6081ff3f42ce7@mail.gmail.com>
	<46A62F6A.8010403@simon.arlott.org.uk>
	<3ae72650707241719w6c7f2dc7s1bc29d7f1dfd4288@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 02:19:18 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> > >> Removing the dev->parent->bus check fixes it:
> 
> Yes, let's remove the check, I will check now if we possibly need to
> fix more than this or only the block-device patch.

It seems this is the only place we check for dev->parent->bus in the
current git tree.

Patch below.


driver core: revert "device" link creation check

Commit 2ee97caf0a6602f749ddbfdb1449e383e1212707 introduced an extra
check on when to create the "device" symlink. Unfortunately, this
breaks input, so let's revert to the old behaviour.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -680,8 +680,7 @@ static int device_add_class_symlinks(str
 		if (error)
 			goto out_subsys;
 	}
-	/* only bus-device parents get a "device"-link */
-	if (dev->parent && dev->parent->bus) {
+	if (dev->parent) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
 		if (error)
