Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYLBDQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYLBDQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYLBDQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:16:46 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22391 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYLBDQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:16:44 -0500
Date: Mon, 1 Dec 2008 20:16:03 -0700
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Problems with fakephp
Message-ID: <20081202031602.GG19000@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Matthew Wilcox <matthew@wil.cx>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net> <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net> <20081128231820.GA23578@ldl.fc.hp.com> <Pine.LNX.4.58.0812010356410.2943@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net> <Pine.LNX.4.58.0812010356410.2943@shell2.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

I think there are now enough ideas in this thread that they're
starting to get confusing.

	1) Function vs. device removal
	2) User interface
	3) Existing fakephp bugs

For (1), do you need function level hotplug? Or will you be able
to get away with device level?

The answer to (2) will naturally flow from your answer to (1).

A few responses for you, along with some of my thoughts...

* Trent Piepho <xyzzy@speakeasy.org>:
> It looks like you weren't opposed to reverting the original
> patch.  I think that should be done for 2.6.27 and 2.6.28, to
> restore the existing interface.  

Unfortunately, it won't be that simple. The reason is, the PCI
slot logic expects a bus/slot tuple. It doesn't know anything
about functions. In the context of the original goal (physical
slots), this design decision made sense.

So we can't do a simple revert of fe99740c because:

	- fakephp registers with PCI hotplug core for device xxxx:yy.0
	- fakephp tries to register device xxxx:yy.1
	- PCI hotplug core returns -EBUSY because the _device_ is
	  already claimed

I played around with this today and encountered the above problem.

Now, if _device_ level hotplug is sufficient for you, then fixing
(2) and (3) within the context of fakephp is pretty easy. The
interface would have the limitation of only displaying function 0
per given device.

[root@canola slots]# pwd
/sys/bus/pci/slots

# my test patch applied to fakephp to get domain:bus:slot.fn in sysfs
[root@canola slots]# ls
0000:00:01.0  0000:0f:00.0  0000:4e:00.0  0000:50:01.0  0000:c2:00.0
0000:00:02.0  0000:10:00.0  0000:4f:00.0  0000:51:00.0
0000:00:04.0  0000:48:02.0  0000:50:00.0  0000:89:00.0

We can then work on fixing the fakephp bugs that you've found.

Something tells me that you're interested in _function_ level
hotplug though. Can you confirm this?

> What should be done is to create a better interface for
> disabling PCI devices/functions/bridges and re-scanning.  Then
> create a compatibility system that will allow software the used
> fakephp to continue to work.  Now fakephp can change to be more
> like a real hotplug driver.  At some time in future, the
> compatibility layer, which will have been listed in the feature
> removal schedule, can be removed.

I took a _very_ brief look at the compatibility driver you wrote.
It _is_ a lot simpler than fakephp. ;)

You've convinced me that the 'fake%d' names are pretty useless. I
was thinking of submitting my test patch that shows the
domain:bus:slot.fn output above.

If I do that, then fakephp will have issues with the
legacy_fakephp driver you wrote because we will have name
collisions in sysfs.

So the question is, do we keep the existing sucky fakephp mess
that I created and go with your new legacy driver as the way
forward?

Or do we try and fix up fakephp?

Again, I think the answer to this question is whether you need
function or device level hotplug. If the former, then we go with
your new legacy driver and the fakephp interface has to remain
sucky.

If the latter, then we can keep fakephp and just get it usable
again.

> I also noticed this in drivers/pci/probe.c:pci_scan_device()
> 
> list_for_each_entry(slot, &bus->slots, list)
> 	if(PCI_SLOT(devfn) == slot->number)
> 		dev->slot = slot;
> 
> This appears to assume that there will only one slot with a given number
> on the same bus.  But if fakephp and real hotplug driver are both loaded,
> this won't be the case anymore, will it?

Only one hotplug driver can claim a device at a time, so the
above won't be an issue.

> I think a much more useful interface would be a "scan" file
> that will just trigger a rescan of everything.  Even the users
> who know what ID to scan would probably rather not be bothered
> to be forced to specify.

Yes, I think a generic /sys/bus/pci/scan is a good idea.

> Maybe each PCI device could get a 'rescan' attribute that
> triggers a rescan of that device for new functions and
> recursively rescans any subordinate busses if it's a bridge?
> That might be useful too.

Also a good idea.

Thanks.

/ac

