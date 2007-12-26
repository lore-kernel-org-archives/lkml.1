Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbXLZOws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbXLZOws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 09:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXLZOwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 09:52:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbXLZOwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 09:52:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] PM: Do not destroy/create devices while suspended
Date: Wed, 26 Dec 2007 16:12:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0712252229050.25960-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0712252229050.25960-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261612.24583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of December 2007, Alan Stern wrote:
> On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:
> 
> > > > Do we need to worry about the possibility that when the system wakes up 
> > > > from hibernation, the set of usable CPUs might be smaller than it was 
> > > > beforehand?
> > > 
> > > This is possible in error conditions.
> > > 
> > > > Is any special handling needed for this, or is it already accounted for?
> > > 
> > > Hm, well.  The cleanest thing would be to allow the drivers to remove the
> > > device objects on CPU_UP_CANCELED_FROZEN, which means that we weren't able to
> > > bring the CPU up during a resume, but still that will deadlock with
> > > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch.
> > 
> > Hmm.  In principle, device objects may be destroyed on CPU_UP_CANCELED_FROZEN
> > without acquiring the device locks, since in fact we know these objects won't
> > be accessed concurrently at that time (the locks are already held by the PM
> > core, but the PM core is not going to actually access the devices before the
> > subsequent resume).
> 
> How about delaying the CPU_UP_CANCELED_FROZEN announcements until it's 
> really safe to send them out?  That is, after all devices have been 
> resumed and the PM core no longer holds any of their locks.  (Should 
> this be before or after tasks leave the freezer? -- I'm not sure.)
> 
> So the idea is send appropriate announcements at the usual time for
> CPUs that do come back up normally, and don't send anything right away
> for CPUs that fail to come up.  Just keep track of which ones failed,
> and then later take care of them.

However, we don't want to execute .resume() for device objects that correspond
to the "dead" CPUs, so to a minimum we should remove them from the dpm_off
list on CPU_UP_CANCELED_FROZEN.  For this purpose, we can define a
callback that will remove the device from dpm_off immediately and schedule its
destruction after all devices have been resumed.

Rafael
