Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZH0VRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZH0VRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZH0VRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:17:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZH0VRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:17:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/6] PM: Asynchronous suspend and resume of devices
Date: Thu, 27 Aug 2009 23:18:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908271637480.25639-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908271637480.25639-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908272318.19868.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 August 2009, Alan Stern wrote:
> On Wed, 26 Aug 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > The following patches introduce a mechanism allowing us to execute device
> > drivers' suspend and resume callbacks asynchronously during system sleep
> > transitions, such as suspend to RAM.
> > 
> > The idea is explained in the changelogs of the first two patches.
> > 
> > Comments welcome.
> 
> I've been terribly busy and haven't had a chance to look at this.  The
> earlier version seemed to have a bunch of mutual-exclusion issues; are
> they resolved now?

Please be more specific.

> There were also some problems involving unsafe iteration over the dpm_list
> -- remember that devices can be unregistered at any time, not just while
> they are suspending or resuming.

Not at the time we're holding dpm_list_mtx, though.

I don't think there are any unsafe iterations over dpm_list in the patches.

> When a device finishes, instead of having the async thread look for 
> another device to work on, I think it would be better to have the 
> thread check the dependents of the current device.  Those which are 
> now ready can be added to a "device-ready" list, which is used to 
> direct the actions of new async threads.

Actually, I wanted to avoid adding such a list, because that would be
duplicating of the async framework's actions, to some extent.  Yes, we can
duplicate the async framework just for the suspend/resume needs.  No, I don't
think it's worth it.

BTW, the patches have been tested on a dual-core box and I haven't seen any
problems with them so far.  Also, the testing shows that the waiting for
devices with unsatisfied dependencies is almost eliminated (on my test box
it happens 4-8 times during the entire suspend-resume cycle).

Thanks,
Rafael
