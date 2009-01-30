Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZA3SlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZA3SlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZA3Skt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:40:49 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3011 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZA3Sks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:40:48 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Fri, 30 Jan 2009 10:40:30 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Parag Warudkar" <parag.lkml@gmail.com>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
Message-ID: <20090130184030.GA14933@xw6200.broadcom.net>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop>
 <alpine.LFD.2.00.0901281636270.3123@localhost.localdomain>
 <alpine.DEB.2.00.0901282049040.5026@parag-desktop>
 <20090129184215.GA13459@xw6200.broadcom.net>
 <alpine.DEB.2.00.0901291700130.5149@parag-desktop>
 <20090129222247.GA13861@xw6200.broadcom.net>
 <alpine.DEB.2.00.0901291730030.5149@parag-desktop>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0901291730030.5149@parag-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 659D96153FC43663562-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 02:35:44PM -0800, Parag Warudkar wrote:
> 
> 
> On Thu, 29 Jan 2009, Matt Carlson wrote:
> 
> > FWIW, I can suspend and resume using the latest linux-2.6 kernel
> > on a machine with a similar chip here.  The problem doesn't seem to
> > affect all Broadcom devices.
> 
> It is failing for me on HP xw6600 workstation, if that helps in any way.
> 
> Parag

O.K.  Let's test some more assumptions.  Can you apply the following
patch and observe the system logs when the device is first loaded and
again after resume.  The patch looks at the pci command register to
verify that memory space IO is indeed enabled.  (It should be.)  This is
all that should be needed for MMIO to work.

If the PCI_COMMAND message doesn't match, then it means that the
PCI_COMMAND register isn't getting restored for some reason.  If they do
match, then something else in the system is not getting restored
correctly.


diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 8b3f846..67bb29f 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -7225,8 +7225,17 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
  */
 static int tg3_init_hw(struct tg3 *tp, int reset_phy)
 {
+	u16 cmd;
+
 	tg3_switch_clocks(tp);
 
+	pci_read_config_word(tp->pdev, PCI_COMMAND, &cmd);
+
+	printk(KERN_NOTICE "%s: PCI_COMMAND reg = 0x%x (bit 1 is %s)\n",
+	       tp->dev->name, cmd, (cmd & PCI_COMMAND_MEMORY) ? "on" : "off");
+	printk(KERN_NOTICE "%s: Reg value at offset 0x0 is 0x%x\n",
+	       tp->dev->name, tr32(0x0));
+
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
 	return tg3_reset_hw(tp, reset_phy);

