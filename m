Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZHCVSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZHCVSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZHCVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:18:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43696 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbZHCVSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:18:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Mon, 3 Aug 2009 23:18:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, dtor@mail.ru
References: <1248404514.2670.107.camel@rzhang-dt>
In-Reply-To: <1248404514.2670.107.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032318.35070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009, Zhang Rui wrote:
> Hi,

Hi,

> this is the patch set I made to speed up the device
> suspend/resume/shutdown process.
> 
> A new mechanism called Device Async Actions is introduced
> in this patch set.

Well, I'm not sure we'll need that.

> The basic idea is that,
> if the suspend/resume/shutdown process of a device group, including
> a root device and its child devices, are independent of other devices,
> we create an async domain for this device group,
> and make them suspend/resume/shutdown asynchronously.    

I don't really think this is the right approach.  IMO, we should rather try to
identify groups of devices for which the PM callbacks (forget about .shutdown()
for now) can be executed in parallel.  One such group is leaf devices, ie.
devices that have no children.  Of course, some of them will depend of the
other indirectly, so we should make it possible to declare (in the driver)
whether the device can be suspended/resumed asynchronously and use the
following logic (at the core level), in pseudo code:

if (has_no_children(dev) && asynchronous_suspend_resume_allowed(dev))
    async_resume(dev);
else
    resume(dev);

and analogously for suspend.  Then, we can easily use one async domain for all
of these devices.

Later, we can add async domains for devices that have children, but can be
suspended and woken up in parallel with each other.  IOW, I think the async
domains should span the levels rather than branches of the device tree.

Thanks,
Rafael
