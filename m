Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbYBFAfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbYBFAfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYBFAfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:35:39 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:46997 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761096AbYBFAfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=mddmGjce8uqDndTTjBQy26DWDA4qKcc2LR+nrVxtUaBx0WsvUJZq9/yvGOXhRtNbfBckhenuCDyVp3I5PS8tBZZ626A4nmC0YmTRnsCl4S4b7OmH4EZz6HoDdIuDYkbqSpgqqwQCCZj6CmwfP/WdLdYq+xGvXSglza/nxpNRGXo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] IDE updates part #4
Date: Wed, 6 Feb 2008 01:48:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802022035.02326.bzolnier@gmail.com> <alpine.LFD.1.00.0802051059330.3110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802051059330.3110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802060148.17663.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

On Tuesday 05 February 2008, Linus Torvalds wrote:
> 
> On Sat, 2 Feb 2008, Bartlomiej Zolnierkiewicz wrote:
> > 
> > * next part of IDE probing code re-organization saga
> >   (that would be me)
> 
> This seems to cause very irritating and bogus messages for me:
> 
> 	Probing IDE interface ide0...
> 	Probing IDE interface ide1...
> 	ide2: I/O resource 0x0-0x7 not free.
> 	ide2: ports already in use, skipping probe
> 	ide3: I/O resource 0x0-0x7 not free.
> 	ide3: ports already in use, skipping probe
> 	ide4: I/O resource 0x0-0x7 not free.
> 	ide4: ports already in use, skipping probe
> 	ide5: I/O resource 0x0-0x7 not free.
> 	ide5: ports already in use, skipping probe
> 	ide6: I/O resource 0x0-0x7 not free.
> 	ide6: ports already in use, skipping probe
> 	ide7: I/O resource 0x0-0x7 not free.
> 	ide7: ports already in use, skipping probe
> 	ide8: I/O resource 0x0-0x7 not free.
> 	ide8: ports already in use, skipping probe
> 	ide9: I/O resource 0x0-0x7 not free.
> 	ide9: ports already in use, skipping probe
> 
> and that's just totally bogus. It shouldn't even request that region, 
> since it's not been allocated!
> 
> So that "ide_device_add_all()" is missing some checks. Should it check the 
> probe[] array like ideprobe_init() used to, or what?

This is ide-generic problem exhibited by recent ide_device_add_all() changes.
Fix below (it works for me) - you may merge the patch as it is or wait an hour
or so for the next IDE tree pull request.

Also sorry for the issue in the first place (it turned out that it slipped
my testing because I has been running with IDE_MAX_HWIFS=2 for some time :).


From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-generic: probing bugfix

On Tuesday 05 February 2008, Linus Torvalds wrote:
> 
> On Sat, 2 Feb 2008, Bartlomiej Zolnierkiewicz wrote:
> > 
> > * next part of IDE probing code re-organization saga
> >   (that would be me)
> 
> This seems to cause very irritating and bogus messages for me:
> 
>       Probing IDE interface ide0...
>       Probing IDE interface ide1...
>       ide2: I/O resource 0x0-0x7 not free.
>       ide2: ports already in use, skipping probe
>       ide3: I/O resource 0x0-0x7 not free.
>       ide3: ports already in use, skipping probe
>       ide4: I/O resource 0x0-0x7 not free.
>       ide4: ports already in use, skipping probe
>       ide5: I/O resource 0x0-0x7 not free.
>       ide5: ports already in use, skipping probe
>       ide6: I/O resource 0x0-0x7 not free.
>       ide6: ports already in use, skipping probe
>       ide7: I/O resource 0x0-0x7 not free.
>       ide7: ports already in use, skipping probe
>       ide8: I/O resource 0x0-0x7 not free.
>       ide8: ports already in use, skipping probe
>       ide9: I/O resource 0x0-0x7 not free.
>       ide9: ports already in use, skipping probe
> 
> and that's just totally bogus. It shouldn't even request that region, 
> since it's not been allocated!

The commit 139ddfcab50e5eabcc88341c8743a990ac1be6a2 ("ide: move handling of
I/O resources out of ide_probe_port()") changed the ordering of hwif->noprobe
check vs ide_hwif_request_regions() call (so that we now reserve I/O regions
before checking for hwif->noprobe).  However ide-generic host driver depended
on hwif->noprobe to be set for skipping probing of empty ide_hwifs[] slots.

Fix it by passing only indexes of non-empty slots to ide_device_add_all()
from ide_generic_init().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -20,8 +20,14 @@ static int __init ide_generic_init(void)
 	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
 		ide_get_lock(NULL, NULL); /* for atari only */
 
-	for (i = 0; i < MAX_HWIFS; i++)
-		idx[i] = ide_hwifs[i].present ? 0xff : i;
+	for (i = 0; i < MAX_HWIFS; i++) {
+		ide_hwif_t *hwif = &ide_hwifs[i];
+
+		if (hwif->io_ports[IDE_DATA_OFFSET] && !hwif->present)
+			idx[i] = i;
+		else
+			idx[i] = 0xff;
+	}
 
 	ide_device_add_all(idx, NULL);
 
