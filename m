Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZHNMbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZHNMbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZHNMbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:31:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36730 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbZHNMbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:31:01 -0400
Date: Fri, 14 Aug 2009 13:30:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Message-ID: <20090814123059.GA27995@srcf.ucam.org>
References: <20090813002925.GA2532@srcf.ucam.org> <Pine.LNX.4.44L0.0908131100440.2940-100000@iolanthe.rowland.org> <20090813214701.GC14532@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813214701.GC14532@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:47:01PM +0100, Matthew Garrett wrote:

> Ugh. I'd really prefer us to assume that drivers are able to cope unless 
> proven otherwise. Userspace policy makes sense where we don't have any 
> idea whether something will work or not, but I'd really expect that most 
> PCI drivers will either cope (in which case they'll have enabling code) 
> or won't (in which case they won't). Why would we want userspace to 
> influence this?

Though, thinking about it, you're right that setting this does override 
user policy. I think we need an additional flag to indicate that the 
device supports runtime wakeup and test that as well when doing 
device_may_wakeup().

> > This misses the point.  The whole idea of runtime_idle is to tell you 
> > that the device is idle and might be ready to be suspended.  If you're 
> > going to call pm_schedule_suspend anyway, there's no reason to invoke 
> > pm->runtime_idle.
> 
> My understanding of the API was that pm_device_put() invokes 
> runtime_idle if the refcount hits 0. The bus layer has no idea of the 
> refcount, and calling suspend directly from the driver would defeat the 
> point of the system-wide recounting.

>From the API docs:

"The action performed by a bus type's ->runtime_idle() callback is 
totally dependent on the bus type in question, but the expected and 
recommended action is to check if the device can be suspended (i.e. if 
all of the conditions necessary for suspending the device are satisfied) 
and to queue up a suspend request for the device in that case."

Though perhaps the device level runtime_idle shouldn't be void - that 
way the bus can ask the driver whether its suspend conditions have been 
satisfied? Right now there doesn't seem to be any way for the bus to ask 
that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
