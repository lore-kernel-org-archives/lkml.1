Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbXGEOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbXGEOYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbXGEOYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:24:11 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:52875 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbXGEOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:24:10 -0400
Date: Thu, 5 Jul 2007 15:23:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
Message-ID: <20070705142318.GA22598@srcf.ucam.org>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051528.34754.oliver@neukum.org> <20070705134632.GA22177@srcf.ucam.org> <200707051609.25887.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707051609.25887.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 04:09:24PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 15:46, Matthew Garrett wrote:
> > I have a model for STD that avoids the need to freeze the entirity of 
> > userspace, but I need to find some more time to flesh it out.
> 
> You can just describe it, as far as I'm concerned. :-)

The basic model is that nobody's really described a use-case where we 
actually care about restoring system state. What people want is to be 
able to restore application state. So, arguably, what we want isn't to 
save the entire kernel state and application state in one go because we 
can reconstruct a huge amount of that afterwards.

This isn't too much of a problem. All we actually need to be able to do 
is to atomically dump process state (which requires the freezer, but 
doesn't require freezing the entire system), shut down, get the system 
back into approximately the correct state (remount filesystems, start X, 
whatever) and then restore the processes.

Now, obviously, there's actually quite a lot of complexity here that I'm 
neatly eliding :) The biggest issue is restoring hardware state. We'd 
require quite a different model to the existing one, but I think there 
are arguments there for it being helpful anywy. Keeping state in the 
midlevels rather than the low-level drivers would give us much more 
ability to deal with hardware issues, and potentially allow the 
replacement of faulty hardware without userspace caring (freeze your 
mission-critical application, hotplug the network card, let the kernel 
restore state and resume it)

There's other advantages to this. As long as the kernel hasn't changed 
too much it would be possible to restore userspace across kernel 
security upgrades. You end up saving less to disk so performance should 
be better. Touching filesystems between suspend and resume doesn't 
result in the entire world ending.

I've mocked up a basic implementation using cryopid, but it's somewhat 
limited by the lack of support for sockets. I'd like to move more of the 
smarts into the kernel (Hurray, checkpointing!) and then see how much 
hardware support ends up horifically broken.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
