Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYHGQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYHGQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYHGQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:45:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53702 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYHGQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:45:48 -0400
Date: Thu, 7 Aug 2008 17:45:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: [WHINGE+PATCH] Stupid structure naming and stupid linker error messages
Message-ID: <20080807164539.GA26947@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building one ARM configuration, I'm getting this very very useful
error message:

  LD      .tmp_vmlinux1
`.devexit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o
`.devexit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o
make[1]: *** [.tmp_vmlinux1] Error 1

Wow.  How much more useful information can it give me?  Anyway, let's
try and work out what's going on.

$ arm-linux-objdump --section=.data -r ../build/ixp4xx/drivers/built-in.o |grep '\.devexit\.text'
00002d10 R_ARM_ABS32       .devexit.text
00003038 R_ARM_ABS32       .devexit.text

Okay, now we know where in the .data section these references are.  Let's
try to find what's responsible.

$ arm-linux-nm -n ../build/ixp4xx/drivers/built-in.o | grep ' d '|less
00002c8c d driver
00002cfc d driver
00002d6c d hpt37x_timings
...
00003014 d xfer_speeds
00003024 d driver
00003094 d pdc_quirk_drives

How.  Very.  Informative.  They're both in a structure called 'driver'.

$ grep 'struct.* driver *=' drivers -r | wc -l
62

Yes.  Well, 62 structures called 'driver'.  How about someone deciding
to prefix such a generic name with something specific to the actual
driver in question?

However, you can take a guess that it might be in IDE.  Thankfully,
there aren't that many IDE drivers selected, so it's a choice of
three.  If there were more, finding this would be a BIG problem.

Can we please change this silly policy of using stupidly generic names
like 'driver'?

In any case, this fixes the breakage.  Referencing discarded exit
sections from .data sections is Bad News.  And no, the kernels static
checker doesn't find this because 'driver' structures are exempted.

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 748793a..259ddf2 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1594,7 +1594,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	return ret;
 }
 
-static void __devexit hpt366_remove(struct pci_dev *dev)
+static void hpt366_remove(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct ide_info *info = host->host_priv;
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 0f609b7..05ddfde 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -541,7 +541,7 @@ static int __devinit pdc202new_init_one(struct pci_dev *dev, const struct pci_de
 	return ide_pci_init_one(dev, d, NULL);
 }
 
-static void __devexit pdc202new_remove(struct pci_dev *dev)
+static void pdc202new_remove(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct pci_dev *dev2 = host->dev[1] ? to_pci_dev(host->dev[1]) : NULL;


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
