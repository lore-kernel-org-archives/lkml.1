Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXLYQCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXLYQCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 11:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXLYQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 11:02:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35160 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXLYQB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 11:01:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] PM: Do not destroy/create devices while suspended
Date: Tue, 25 Dec 2007 17:21:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0712241045150.25920-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0712241045150.25920-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251721.42233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of December 2007, Alan Stern wrote:
> On Mon, 24 Dec 2007, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > Some device drivers register CPU hotplug notifiers and use them to destroy
> > device objects when removing the corresponding CPUs and to create these objects
> > when adding the CPUs back.
> > 
> > Unfortunately, this is not the right thing to do during suspend/hibernation,
> > since in that cases the CPU hotplug notifiers are called after suspending
> > devices and before resuming them, so the operations in question are carried
> > out on the objects representing suspended devices which shouldn't be
> > unregistered behing the PM core's back.  Although right now it usually doesn't
> > lead to any practical complications, it will predictably deadlock if
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch is applied.
> > 
> > The solution is to prevent drivers from removing/adding devices from within
> > CPU hotplug notifiers during suspend/hibernation using the FROZEN bit
> > in the notifier's action argument.  The following three patches modify the
> > MSR, x86-64 MCE and cpuid drivers along these lines.
> 
> Do we need to worry about the possibility that when the system wakes up 
> from hibernation, the set of usable CPUs might be smaller than it was 
> beforehand?

This is possible in error conditions.

> Is any special handling needed for this, or is it already accounted for?

Hm, well.  The cleanest thing would be to allow the drivers to remove the
device objects on CPU_UP_CANCELED_FROZEN, which means that we weren't able to
bring the CPU up during a resume, but still that will deadlock with
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch.

Greetings,
Rafael

