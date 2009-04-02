Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbZDBAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbZDBAY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZDBAYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:24:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:32698 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZDBAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:24:15 -0400
Date: Wed, 1 Apr 2009 18:24:12 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090402002412.GB28975@ldl.fc.hp.com>
References: <20090331121331.3673cf59@hobbes> <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain> <20090401101309.67d0bea5@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401101309.67d0bea5@hobbes>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Wed, 1 Apr 2009 10:01:12 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, 31 Mar 2009, Jesse Barnes wrote:
> > >
> > > Please consider pulling my PCI tree from
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> > > linux-next
> > 
> > This produces
> > 
> >   WARNING: drivers/built-in.o(.text+0x69a1): Section mismatch in
> > reference from the function dev_rescan_store() to the
> > function .devinit.text:pci_rescan_bus() The function
> > dev_rescan_store() references the function __devinit
> > pci_rescan_bus(). This is often because dev_rescan_store lacks a
> > __devinit annotation or the annotation of pci_rescan_bus is wrong.
> > 
> > Hmm?
> 
> Arg how did I miss that?  Maybe the last build I did was missing
> hotplug support or something... Anyway looking now (at first glance I
> think pci_rescan_bus needs to drop __devinit).

This patch eliminates the warning in what I think is the correct
manner.

Thanks.

/ac

From: Alex Chiang <achiang@hp.com>

PCI: annotate pci_rescan_bus as __ref, not __devinit

pci_rescan_bus was annotated as __devinit, which is wrong,
because it will never be part of device initialization.
Howevever, we can't simply drop the annotation, because then we
get section warnings about calling pci_scan_child_bus (which is
correctly marked as __devinit).

pci_rescan_bus will only get built when CONFIG_HOTPLUG is set,
meaning that __devinit is a nop, so we know that pci_scan_child_bus
has not been freed.

Annotate as __ref to silence modpost.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e2f3dd0..8eb50df 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1220,7 +1220,7 @@ EXPORT_SYMBOL(pci_scan_bus_parented);
  *
  * Returns the max number of subordinate bus discovered.
  */
-unsigned int __devinit pci_rescan_bus(struct pci_bus *bus)
+unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 	struct pci_dev *dev;
