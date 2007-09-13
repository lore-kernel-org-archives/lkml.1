Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXIMNav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXIMNav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXIMNao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:30:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47648 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXIMNan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:30:43 -0400
Date: Thu, 13 Sep 2007 06:33:21 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>
Subject: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070913133321.GA6362@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that USB devices suck when it comes to powermanagement
issues :(

A number of patches have been submitted near the end of this kernel
release cycle that add new device ids to the quirk table in the kernel
to disable autosuspend for specific devices.  However, a number of
developers are very worried that even with the testing that has been
done, once 2.6.23 is released, we are going to get a whole raft of angry
users when their devices break in nasty ways.

As an example, it seems that almost 2/3 of all USB printers just can not
handle autosuspend.  And there's a _lot_ of USB printers out there...

When researching how other operating systems handle this, it was found
out that they use a whitelist of devices that are able to properly
suspend.  So, in the future, that is how we are going to handle this.

These two patches address the need today to have users machines still
work, even if they might draw more power than they possibly could (which
is not any more than they did in 2.6.22.)

These patches do two things:
  - disable USB autosuspend on all devices except for USB hubs.  This
    can be easily overridden by userspace to turn on autosuspend for
    devices that a user wants to.  HAL will use a whitelist in the
    future for these types of devices.
  - revert the usb-storage autosuspend patch.  This breaks a number of
    devices out there that can not handle suspend properly, _AND_ the
    current patch is broken even for devices that do work properly under
    some situations.  Data loss is not a good thing to have happen, so
    this patch is reverted for now.  Oliver has more specifics about the
    issues involved here if anyone is curious.

The "disable autosuspend" patch has been in the -mm tree for a while,
and is being shipped by Ubuntu and Red Hat in their bleeding-edge
kernels in order to handle the huge number of broken devices.  openSUSE
will also get this patch for its next kernel release once the suse
developers return from wondering around the woods of the Czech Republic
next week.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/usb/core/quirks.c      |    6 ++++++
 drivers/usb/storage/scsiglue.c |   13 ++++---------
 drivers/usb/storage/usb.c      |   27 +++++++--------------------
 3 files changed, 17 insertions(+), 29 deletions(-)

---------------

Alan Stern (1):
      USB: disable autosuspend by default for non-hubs

Greg Kroah-Hartman (1):
      Revert "usb-storage: implement autosuspend"


