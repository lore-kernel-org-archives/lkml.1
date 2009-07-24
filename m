Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZGXFzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZGXFzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZGXFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:55:24 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:58701 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbZGXFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:55:23 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH?] Re: Linux 2.6.31-rc4: strange change in iomem allocation
Date: Fri, 24 Jul 2009 09:53:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain> <200907231653.48933.elendil@planet.nl> <alpine.LFD.2.01.0907230905360.21520@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907230905360.21520@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907240953.48297.elendil@planet.nl>
X-OriginalArrivalTime: 24 Jul 2009 05:55:23.0081 (UTC) FILETIME=[55783390:01CA0C23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009, Linus Torvalds wrote:
> On Thu, 23 Jul 2009, Frans Pop wrote:
> > On Thursday 23 July 2009, Frans Pop wrote:
> > > I'm seeing the following change in dmesg between -rc3 and -rc4:
> > > -system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
> > > +system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
> > >
> > > There is nothing in the earlier part of dmesg that would explain
> > > this change.
> >
> > Reverting that commit did indeed restore the old situation.
>
> So think of it this way: the difference between "has been reserved" and
> "could not be reserved" is _not_ a "good" vs "bad" situation. They are
> both purely informational. They're not good-or-bad, they are
> information we leave around in case bad things happen later.

Yeah, I suspected that might be the case (which is why I used "restores old
situation" rather than "fixes regression" :-). My message was triggered by
the fact that it's still a somewhat unusual change, so I was mainly looking
for confirmation that it was intended.

Still, failure messages can be confusing for users. The source code documents
that reservation failures are expected, but most users don't read source...

So, also looking at David John's message, would something like the patch
below be an option? The result is as follows on my system:

pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
(The fact that a range could not be reserved is generally harmless.)
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved
system 00:0a: ioport range 0x500-0x55f has been reserved

---
From: Frans Pop <elendil@planet.nl>
Subject: PNP: make explicit that range allocation failures are generally harmless

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 59b9092..72de2a7 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -52,6 +52,10 @@ static void reserve_range(struct pnp_dev *dev, resource_size_t 
start,
 		port ? "ioport" : "iomem",
 		(unsigned long long) start, (unsigned long long) end,
 		res ? "has been" : "could not be");
+	if (!res)
+		printk_once(KERN_INFO
+			"(The fact that a range could not be reserved "
+			"is generally harmless.)\n");
 }
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)
