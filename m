Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYHFHWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYHFHWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYHFHWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:22:44 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3429 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYHFHWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:22:43 -0400
Date: Wed, 6 Aug 2008 09:22:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Milton Miller <miltonm@bga.com>
Cc: Greg KH <gregkh@suse.de>, Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Message-ID: <20080806092219.10ee080e@hyperion.delvare>
In-Reply-To: <ad61f8387a737bc410e9d6dc3a8a5b63@bga.com>
References: <for-27-patch1-0@bga.com>
	<for-27-patch9@bga.com>
	<20080712041137.GA5933@kroah.com>
	<e6b3109a0ab047bea58ceecb8734761d@bga.com>
	<0a67ecbf69649dce778db1b463e59c3a@bga.com>
	<ad61f8387a737bc410e9d6dc3a8a5b63@bga.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milton, hi Greg,

On Wed, 16 Jul 2008 05:18:18 -0500, Milton Miller wrote:
> Greg,
> 
> Please respond to this email and explain why the patch
> 
> pci: dynids.use_driver_data considered harmful
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.1/index.html#2188
> 
> should not be applied.   I am not arguing the correctness of
> the removed code, rather its utility and benefit to the linux
> community.

I _am_ arguing the correctness of the removed code. That code silently
defaults driver_data to 0 when the driver doesn't set
dynids.use_driver_data. This assumes that 0 is always a safe value,
which is not true for all drivers as Milton explains below.

> As far as I can tell, the code only succeeds in limiting the
> usefulness of the pci dynamic id addition mechanism.  We chose
> not to limit which drivers can have a table entry added, now
> let us not limit telling the driver which previous entry is
> most similar to our new entry.
> 
> If a driver doesn't set this bit, and only 3 out of 419 do,
> then the facility can only be used if the driver can function
> correctly with the data zero.  In some drivers (radeonfb) a
> nonzero flag is always set, in some a list of boards or
> chipsets is listed in an arbitrary order (e1000e), and in yet
> others the field is used as a pointer without checking for NULL
> (DAC960, iwl3945).

I have to agree with Milton. Allowing all drivers to use dynamic IDs
first, and then limiting the use of the driver_data field to drivers
setting a specific flag, doesn't make sense. For one thing, just
because the driver sets the flag, doesn't mean that it does the proper
checks on the passed value. For another, as written above, assuming
that 0 is a safe value (that doesn't need to be checked by the driver)
is incorrect.

The correct approach here if you really want to play it safe, would be
to not allow dynamic IDs by default. Drivers would set a flag when they
want to use them (instead of when they want to use driver_data as we
currently do.) Setting the flag would suggest that you have checked
that nothing can go wrong when a dynamic ID is added. As I said above,
it's impossible to actually enforce other than with careful code
review, but if you insist on trying, maybe we can have these drivers
set a validation callback function rather than a flag. In the absence of
validation callback function, dynamic IDs would be forbidden. This has
a cost in terms of driver size though.

That would be a pretty big change, as someone would have to go through
all the PCI drivers and update them. I certainly do not have the time
to do that, but maybe Milton does if we agree on that?

The alternative is to just apply Milton's patch and get away with all
checks. That's perfectly fine with me, as I can't see how it is worse
than what we currently have, but apparently not with Greg (although I
still don't know why.) If Milton's patch isn't going to be applied,
then I would like to suggest applying the following patch of mine as a
measure to prevent what happened to Milton and started this discussion:

* * * * *

Subject: PCI: Don't silently ignore dynids driver data

If driver data is provided when adding a dynamic ID to a PCI driver,
but the driver doesn't actually support that, fail, instead of
silently defaulting to a value of 0.

Likewise, if the driver expects driver_data and the user didn't
provide it, fail, instead of silently defaulting to a value of 0.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Milton Miller <miltonm@bga.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci-driver.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.26-rc9.orig/drivers/pci/pci-driver.c	2008-06-23 08:38:32.000000000 +0200
+++ linux-2.6.26-rc9/drivers/pci/pci-driver.c	2008-07-13 09:59:39.000000000 +0200
@@ -54,6 +54,10 @@ store_new_id(struct device_driver *drive
 			&class, &class_mask, &driver_data);
 	if (fields < 2)
 		return -EINVAL;
+	/* Presence of driver_data must match the use_driver_data flag */
+	if ((fields >= 7 && !pdrv->dynids.use_driver_data)
+	 || (fields < 7 && pdrv->dynids.use_driver_data))
+		return -EINVAL;
 
 	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
 	if (!dynid)
@@ -65,8 +69,7 @@ store_new_id(struct device_driver *drive
 	dynid->id.subdevice = subdevice;
 	dynid->id.class = class;
 	dynid->id.class_mask = class_mask;
-	dynid->id.driver_data = pdrv->dynids.use_driver_data ?
-		driver_data : 0UL;
+	dynid->id.driver_data = driver_data;
 
 	spin_lock(&pdrv->dynids.lock);
 	list_add_tail(&dynid->node, &pdrv->dynids.list);

* * * * *

> You sent your request for others to withdraw the patch
> from consideration when I resent the patch without seeing your
> comments that were less than 12 hours old, but have been silent
> for the last 60 hours since I responded to them over the next
> several hours.   If I do not hear from you with technical
> arguments for keeping the code, I will resend the patch for
> consideration.

Milton, please keep in mind that many people are on vacation or
meetings at this time of the year. Delayed replies aren't unusual, and
neither is plain lack of reply. When you come back from vacation and
have over 1300 mails to process, you _have_ to ignore some of the
discussions. Important things will resurface later anyway.

Thanks,
-- 
Jean Delvare
