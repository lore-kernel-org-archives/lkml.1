Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbXLZDeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbXLZDeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 22:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXLZDd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 22:33:56 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1703 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751476AbXLZDdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 22:33:55 -0500
Date: Tue, 25 Dec 2007 22:33:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3] PM: Do not destroy/create devices while suspended
In-Reply-To: <200712252021.14540.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0712252229050.25960-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:

> > > Do we need to worry about the possibility that when the system wakes up 
> > > from hibernation, the set of usable CPUs might be smaller than it was 
> > > beforehand?
> > 
> > This is possible in error conditions.
> > 
> > > Is any special handling needed for this, or is it already accounted for?
> > 
> > Hm, well.  The cleanest thing would be to allow the drivers to remove the
> > device objects on CPU_UP_CANCELED_FROZEN, which means that we weren't able to
> > bring the CPU up during a resume, but still that will deadlock with
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch.
> 
> Hmm.  In principle, device objects may be destroyed on CPU_UP_CANCELED_FROZEN
> without acquiring the device locks, since in fact we know these objects won't
> be accessed concurrently at that time (the locks are already held by the PM
> core, but the PM core is not going to actually access the devices before the
> subsequent resume).

How about delaying the CPU_UP_CANCELED_FROZEN announcements until it's 
really safe to send them out?  That is, after all devices have been 
resumed and the PM core no longer holds any of their locks.  (Should 
this be before or after tasks leave the freezer? -- I'm not sure.)

So the idea is send appropriate announcements at the usual time for
CPUs that do come back up normally, and don't send anything right away
for CPUs that fail to come up.  Just keep track of which ones failed,
and then later take care of them.

Alan Stern

