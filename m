Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYCMFpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYCMFpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYCMFpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:45:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46300 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYCMFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:45:32 -0400
Date: Wed, 12 Mar 2008 22:44:00 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
	Reported regressions from 2.6.24)
Message-ID: <20080313054400.GA17102@kroah.com>
References: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> <20080312213826.GA17101@kroah.com> <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org> <20080312225421.GA24449@kroah.com> <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 04:09:17PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 12 Mar 2008, Greg KH wrote:
> > 
> > I can't get a box here to produce both of those PCI: messages myself,
> > and neither can Len, so something is really odd here.

Ok, stupid me, this was my fault.  I was assuming that pci busses would
never be registered multiple times with the pci core.  Obviously this
isn't true.  The previous patch I proposed was only paying attention to
the PCI devices, and that logic is just fine (it's already protected
when it is attempted to be registered multiple times.)

So, the patch below fixes the issue for me, and reboot seems to work as
well.

Guennadi, can you test this out on your machine?

thanks for your patience,

greg k-h

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: PCI: fix issue with busses registering multiple times in sysfs

PCI busses can be registered multiple times, so we need to detect if we
have registered our bus structure in sysfs already.  If so, don't do it
again.

Thanks to Guennadi Liakhovetski <g.liakhovetski@gmx.de> for reporting
the problem, and to Linus for poking me to get me to believe that it was
a real problem.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/bus.c   |    6 +++++-
 include/linux/pci.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -143,14 +143,18 @@ void pci_bus_add_devices(struct pci_bus 
 			/* register the bus with sysfs as the parent is now
 			 * properly registered. */
 			child_bus = dev->subordinate;
+			if (child_bus->is_added)
+				continue;
 			child_bus->dev.parent = child_bus->bridge;
 			retval = device_register(&child_bus->dev);
 			if (retval)
 				dev_err(&dev->dev, "Error registering pci_bus,"
 					" continuing...\n");
-			else
+			else {
+				child_bus->is_added = 1;
 				retval = device_create_file(&child_bus->dev,
 							&dev_attr_cpuaffinity);
+			}
 			if (retval)
 				dev_err(&dev->dev, "Error creating cpuaffinity"
 					" file, continuing...\n");
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -278,6 +278,7 @@ struct pci_bus {
 	struct device		dev;
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
+	unsigned int		is_added:1;
 };
 
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
