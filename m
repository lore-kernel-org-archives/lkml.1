Return-Path: <linux-kernel-owner+w=401wt.eu-S935685AbYBMWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935685AbYBMWIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbYBMWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:07:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:37594 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933744AbYBMWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:07:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MTu7ubFH8oJWUUdiMuGaz6TnRWsmYKsBSqoWho7otWu0kVd6pVSZar7fRtJUpoHfHZTPLbDrZeqw+eA2/B9utJHnaDzcjUv9aE+5LIsp+yke03D2I+LaaCbMgBdO9gYhDcO2+jCC5hGpF9eoqzmGrfb04b2iB91iehuWVfZmazc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Date: Wed, 13 Feb 2008 23:20:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
References: <20080213001506.GA13933@kroah.com> <20080213172824.GB10733@kroah.com> <20080213181655.GB8960@kroah.com>
In-Reply-To: <20080213181655.GB8960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132320.37172.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Greg KH wrote:
> On Wed, Feb 13, 2008 at 09:28:24AM -0800, Greg KH wrote:
> > On Wed, Feb 13, 2008 at 01:34:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > On Wednesday 13 February 2008, Greg KH wrote:
> > > > On Wed, Feb 13, 2008 at 02:17:37AM +0000, Alan Cox wrote:
> > > > > > Why does the calgary driver need this?  Can we just use pci_get_device()
> > > > > > instead?  Why do you need to walk the device list backwards?  Do you get
> > > > > > false positives going forward?
> > > > > 
> > > > > It doesn't look to be performance critical so the driver can
> > > > > pci_get_device until the end and use the final hit anyway.
> > > > 
> > > > That would make more sense.
> > > > 
> > > > > IDE reverse is more problematic but nobody seems to use it.
> > > > 
> > > > I've seen two posters say they use it.  I'm wondering what it is really
> > > > solving if they use it, and why if it's really needed, scsi never had to
> > > > implement such a hack...
> > > 
> > > It is no longer solving anything, just adds more pain. ;)
> > > 
> > > [ The option comes from 2.2.x (so long before LABEL=/ and /dev/disk/by-id/
> > >   became popular).  Some "off-board" controllers integrated on motherboards
> > >   used to appear before "on-board" IDE on PCI bus so this option was meant
> > >   to preserve the legacy ordering. ]
> > > 
> > > Since it is valid only when "Probe IDE PCI devices in the PCI bus order
> > > (DEPRECATED)" config option is used it is already on its way out (though
> > > marking it as obsoleted would make it more explicit).
> > > 
> > > I think that removing "ide=reverse" in 2.6.26 would be OK...
> > 
> > Great, thanks for your blessing.  I'll make up a patch and send it to
> > you for approval.
> 
> How does the patch below look?  I didn't want to remove the whole config
> option, as there is more to the logic than just the "reverse order"
> stuff there.

looks fine,

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> If you don't mind, can I take this through the PCI tree so as to allow
> the removal of this pci function afterwards?

[...]

great, could you also:
- rebase it on top of the patch below
- forward the patch below to Linus for 2.6.25

?

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: mark "ide=reverse" option as obsolete

- it is valid only if "Probe IDE PCI devices in the PCI bus order
  (DEPRECATED)" config option is used

- Greg needs to remove pci_get_device_reverse() for PCI core changes

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1038,7 +1038,7 @@ static int __init ide_setup(char *s)
 	if (!strcmp(s, "ide=reverse")) {
 		ide_scan_direction = 1;
 		printk(" : Enabled support for IDE inverse scan order.\n");
-		return 1;
+		goto obsolete_option;
 	}
 #endif
 
