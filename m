Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbZCaVA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbZCaVA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZCaVAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:00:48 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14843 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbZCaVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:00:48 -0400
Date: Tue, 31 Mar 2009 15:00:45 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pci logical vs. physical hotplug
Message-ID: <20090331210045.GD16311@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> I confirmed this patch fix the kernel oops problem I reported.
> 
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Thank you for reviewing and testing.

> By the way, /sys/bus/pci/slots/<slot> directory by acpiphp are
> remaining even after the parent bridge/bus of the slots are
> removed. At this point, acpiphp is working with struct pci_bus
> for the already disabled pci bus. I guess some operation against
> the files under /sys/bus/pci/slots/<slot> directory would cause
> something problems. So I think we also need something mechanism
> to unregister acpiphp slots when the parent bus is removed.

Yes, I've been thinking about this (and thank you for your other
mail confirming the issue).

The logical hotplug and physical hotplug don't play very nicely
with each other.

I think one of the core issues is that logical hotplug allows
function level granularity while physical hotplug is naturally
restricted to physical slot granularity, which includes an entire
hierarchy, from host bus down to function.

If a user uses logical hotplug to take out a piece of the tree,
what does that mean if it's part of the physical slot/device?

What should happen?

Take something like this:

[0000:2e-4f]----00.0-[0000:2f-4f]--+-02.0-[0000:30-3f]--+-00.0  Intel GigE
                                   |                    \-00.1  Intel GigE
                                   \-04.0-[0000:40-4f]--+-00.0  Intel GigE
                                                        \-00.1  Intel GigE

Assume that this is a quad-port NIC with a bridge in it, and that
the physical slot is 0000:2e:00.0.

What should we do if the user does a logical hotplug on
0000:2f:04.0 and has acpiphp loaded?

If acpiphp tries to do anything to 0000:40: we'll probably get an
oops.

But just because the user took out one piece of that tree doesn't
mean that we should disable the entire slot. If that was the
case, then he could just use the existing hotplug drivers.

I don't have a good answer for right now, other than, "don't try
to mix logical and physical hotplug". I'm open to any ideas that
you may have.

Thanks.

/ac

