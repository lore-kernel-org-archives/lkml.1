Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYIXFvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYIXFvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIXFv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:51:29 -0400
Received: from colo.lackof.org ([198.49.126.79]:39364 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYIXFv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:51:28 -0400
Date: Tue, 23 Sep 2008 23:51:16 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Notes from LPC PCI/MSI BoF session
Message-ID: <20080924055116.GA3101@colo.lackof.org>
References: <200809221229.18501.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809221229.18501.jbarnes@virtuousgeek.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 12:29:18PM -0700, Jesse Barnes wrote:
> Matthew was kind enough to set up a BoF for those of us interested in PCI and 
> MSI issues at this year's LPC.  We went over several issues there:  MSI, PCI 
> hotplug, PCIe virtualization, VGA arbitration and PCI address space 
> management.

Jesse,
thanks for summarizing and posting this....let me use this as an opportunity
to write up an MSI API proposal like I promised.

> Issue:
> MSI API improvements.  Need ways to allocate MSIs at runtime, and perhaps
> on a per-CPU level and get affinity information.  And of course we need
> a way to get more than one legacy MSI allocated.
> Owner:
> Matthew is handling the first pass of this (the more than one legacy MSI 
> addition).  I think we'll need some detailed requirements from the driver 
> guys to make further improvements (e.g. per-CPU or affinity stuff).

Being one of the "driver guys", let me add my thoughts.
For the following discussion, I think we can treat MSI and MSI-X the
same and will just say "MSI". The issue is smp_affinity and how
drivers want to bind MSIs to specific CPUs based on topology/architecture
for optimal performance.

"queue pairs" means command/completion queues.
"multiple queues" means more than one such pairs.

The problem is multi-queue capable devices want to bind MSIs
to specific queues. How those queues are bound to each MSI depends
on how the device uses the queues. I can think of three cases:
1) 1:1 mapping between queue pairs and MSI.
2) 1:N mapping of MSI to multiple queues - e.g. different classes of service.
3) N:1 mapping of MSI to a queue pair - e.g. different event types
   (error vs good status). 

"classes of service" could be 1:N or N:1.
"event types" case would typically be 1 command queue with
multiple completion queues and one MSI per completion queue.

Dave Miller (and others) have clearly stated they don't want to see
CPU affinity handled in the device drivers and want irqbalanced
to handle interrupt distribution. The problem with this is irqbalanced
needs to know how each device driver is binding multiple MSI to it's queues.
Some devices could prefer several MSI go to the same processor and
others want each MSI bound to a different "node" (NUMA).

Without any additional API, this means the device driver has to
update irqbalanced for each device it supports. We thought pci_ids.h
was a PITA...that would be trivial compared to maintaining this.

Initially, at the BOF, I proposed "pci_enable_msix_for_nodes()"
to spread out MSI across multiple NUMA nodes by default. CPU Cores which
share cache was my definition of a "NUMA Node" for the purpose of
this discussion. But each arch would have to define that. The device
driver would also need an API to map each "node" to a queue pair as well.

In retrospect, I think this API only work well for smaller systems
and simple 1:1 MSI/queue mappings. and we'd still have to teach
irqbalanced to not touch some MSIs which are "optimally" allocated.

A second solution I thought of later might be for the device driver to
export (sysfs?) to irqbalanced which MSIs the driver instance owns and
how many "domains" those MSIs can serve.  irqbalanced can then write
back into the same (sysfs?) the mapping of MSI to domains and update
the smp_affinity mask for each of those MSI.

The driver could quickly look up the reverse map CPUs to "domains".
When a process attempts to start an IO, driver wants to know which
queue pair the IO should be placed on so the completion event will
be handled in the same "domain". The result is IOs could start/complete
on the same (now warm) "CPU cache" with minimal spinlock bouncing.

I'm not clear on details right now. I belive this would allow
irqbalanced to manage IRQs in an optimal way without having to
have device specific code in it. Unfortunately, I'm not in a position
propose patches due to current work/family commitments. It would
be fun to work on. *sigh*


I suspect the same thing could be implemented without irqbalanced since
I believe process management knows about the same NUMA attributes we care
about here...maybe it's time for PM to start dealing with interrupt
"scheduling" (kthreads like the RT folks want?) as well?

Ok..maybe I should stop before my asbestos underwear aren't sufficient. :)

hth,
grant
