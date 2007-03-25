Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXCYDmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXCYDmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 23:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964862AbXCYDmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 23:42:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49108 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbXCYDmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 23:42:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tony Luck <tony.luck@intel.com>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>
	<m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de>
	<m1odmi4gx5.fsf@ebiederm.dsl.xmission.com> <46058B47.60204@m3y3r.de>
Date: Sat, 24 Mar 2007 21:39:39 -0600
In-Reply-To: <46058B47.60204@m3y3r.de> (Thomas Meyer's message of "Sat, 24 Mar
	2007 21:34:15 +0100")
Message-ID: <m1fy7u3sas.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> Eric W. Biederman schrieb:
>>
>> Odd.  I would have thought the oops happened in the first resume, not
>> the second. 
>>
>> Hmm.  It may have something to do with the ``managed'' driver
>> aspect of this as well..
>>   
> No. I don't think so. The problem is caused by this sequence: (the info
> is always before entry of a function and before the exit of a function):

Ok.  Thanks.   It is the ordering of events that keeps it
from showing up.  The problem happens the first time but only
after we have restored msi state so we don't see the ill effects
until the second time.


Ok staring at the code and thinking about the problem.  The only
thing that pci_enable_device does (except messing with irqs is
flip enable bits).   Further pci_enable_device only messes with
on 5 architectures.   Only ia64 really cares.  i386 and x86_64
it is simply delaying work until we need it.  frv doesn't
really care it just pokes the irq value back into the hardware
for some reason.  cris just sets a hard coded value.  Does cris
only have one pci irq?

So I think the right solution is to simply make pci_enable_device
just flip enable bits and move the rest of the work someplace else.

However a thorough cleanup is a little extreme for this point in
the release cycle, so I think a quick hack that makes the code
not stomp the irq when msi irq's are enabled should be the first
fix.  Then we can later make the code not change the irqs at all.

Thomas could you verify the patch below makes the problem go away
for you.

Tony, Len the way pci_disable_device is being used in a suspend/resume
path by a few drivers is completely incompatible with the way irqs
are allocated on ia64.  In particular people the following sequence
occurs in several drivers.

probe:
  pci_enable_device(pdev);
  request_irq(pdev->irq);
suspend:
  pci_disable_device(pdev);
resume:
  pci_enable_device(pdev);
remove:
  free_irq(pdev->irq);
  pci_disable_device(pdev);

What I'm proposing we do is move the irq allocation code out of
pci_enable_device and the irq freeing code out of pci_disable_device
in the future.  If we move ia64 to a model where the irq number equal
the gsi like we have for x86_64 and are in the middle of for i386 that
should be pretty straight forward.  It would even be relatively simple
to delay vector allocation in that context until request_irq, if we
needed the delayed allocation benefit.   Do you two have any problems
with moving in that direction?

If fixing the arch code is unacceptable for some reason I'm not aware
of we need to audit the 10-20 drivers that call pci_disable_device
in their suspend/resume processing and ensure that they have freed
all of the irqs before that point.  Given that I have bug reports on
the msi path I know that isn't true.

Tony, Len before we merge any fixes for 2.6.21-rcX I'd like to at
least get an ack on the long term direction.

Thanks,
Eric


diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index a2b9c60..5b79a7a 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -100,7 +100,9 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
 
-	return pcibios_enable_irq(dev);
+	if (!dev->msi_enabled)
+		pcibios_enable_irq(dev);
+	return 0;
 }
 
 int pcibios_assign_resources(void)
diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index f7279d7..0b581e3 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -466,6 +466,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
-	pcibios_enable_irq(dev);
+	if (!dev->msi_enabled)
+		pcibios_enable_irq(dev);
 	return 0;
 }
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 1bb0693..a990a6c 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -426,11 +426,13 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
 
-	return pcibios_enable_irq(dev);
+	if (!dev->msi_enabled)
+		return pcibios_enable_irq(dev);
+	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (pcibios_disable_irq)
+	if (!dev->msi_enabled && pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 474d179..f8bcccd 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -557,14 +557,18 @@ pcibios_enable_device (struct pci_dev *dev, int mask)
 	if (ret < 0)
 		return ret;
 
-	return acpi_pci_irq_enable(dev);
+	if (!dev->msi_enabled)
+		return acpi_pci_irq_enable(dev);
+	return 0;
 }
 
 void
 pcibios_disable_device (struct pci_dev *dev)
 {
 	BUG_ON(atomic_read(&dev->enable_cnt));
-	acpi_pci_irq_disable(dev);
+	if (!dev->msi_enabled)
+		acpi_pci_irq_disable(dev);
+	return 0;
 }
 
 void
