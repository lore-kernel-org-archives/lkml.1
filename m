Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYJGJMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYJGJMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYJGJL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:11:58 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:16269 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYJGJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:11:57 -0400
X-BigFish: VPS-58(z21eW6f5iz1432R98dR936eQ1805M936fO103dK1b0bM19c2kzzzz5a6ciz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K8D2VL-02-IYM-01
Date: Tue, 7 Oct 2008 11:10:32 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081007091032.GD22097@alberich.amd.com>
References: <20081005183603.GA3263@amd.corenet.prv> <20081005121046.579089b9@infradead.org> <20081006062838.GC2808@amd.corenet.prv> <20081006195350.GB22097@alberich.amd.com> <20081007034230.GA6095@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081007034230.GA6095@amd.corenet.prv>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Oct 2008 09:10:44.0906 (UTC) FILETIME=[946D40A0:01C9285C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Mon, Oct 06, 2008 at 11:42:35PM -0400, Dmitry Torokhov wrote:
> On Mon, Oct 06, 2008 at 09:53:50PM +0200, Andreas Herrmann wrote:
> > On Mon, Oct 06, 2008 at 02:28:39AM -0400, Dmitry Torokhov wrote:
> > > On Sun, Oct 05, 2008 at 12:10:46PM -0700, Arjan van de Ven wrote:
> > > > On Sun, 5 Oct 2008 14:36:25 -0400
> > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > > speed, fans are constantly on, everything seems sluggish.
> > > > > 
> > > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > > somewhere in tty_init.
> > > > 
> > > > hpet=force is a "the kernel thinks it's not wise to use, but you think
> > > > better"... don't do that ;(
> > > > 
> > > 
> > > That is not how I parse dmesg:
> > > 
> > > [    0.077927] HPET not enabled in BIOS. You might try hpet=force boot
> > > option
> > > 
> > > Here kernel recommends to try and enable it. If we generally don't recommed
> > > using 'force' I'd suggest removing the 2nd sentence from the message.
> > 
> > FYI.
> > Commit e7250b8ae3870f37f660c2f65cafcaba85e3bfd3 of tip/master is
> > needed to really enable hpet on SB400. I guess that patch should go
> > upstream asap -- and probably it's a good idea to add a check for timer
> > interrupt routing as well which could solve the issues on HP nx6xxx
> > laptops.
> > 
> 
> Having trouble locating this one. Could you please send me a patch so I
> can try it here? Thanks!

Here it is.

commit e7250b8ae3870f37f660c2f65cafcaba85e3bfd3
Author: Andreas Herrmann <andreas.herrmann3@amd.com>
Date:   Fri Sep 5 18:33:26 2008 +0200

    x86: hpet: modify IXP400 quirk to enable interrupts
    
    The current quirk is incomplete. Some more chipset fiddling has to be
    done to enable HPET interrupts. This patch aims to do this. From my
    tests it seems to work faultlessly.
    
    But the official statement is that HPET is not supported on SB4X0.
    
    Users will still have to use hpet=force to enable it.
    
    Use it at your own risk.
    
    Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d138588..f6a11b9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,9 +354,27 @@ static void ati_force_hpet_resume(void)
 	printk(KERN_DEBUG "Force enabled HPET at resume\n");
 }
 
+static u32 ati_ixp4x0_rev(struct pci_dev *dev)
+{
+	u32 d;
+	u8  b;
+
+	pci_read_config_byte(dev, 0xac, &b);
+	b &= ~(1<<5);
+	pci_write_config_byte(dev, 0xac, b);
+	pci_read_config_dword(dev, 0x70, &d);
+	d |= 1<<8;
+	pci_write_config_dword(dev, 0x70, d);
+	pci_read_config_dword(dev, 0x8, &d);
+	d &= 0xff;
+	dev_printk(KERN_DEBUG, &dev->dev, "SB4X0 revision 0x%x\n", d);
+	return d;
+}
+
 static void ati_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 d, val;
+	u8  b;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -366,14 +384,33 @@ static void ati_force_enable_hpet(struct pci_dev *dev)
 		return;
 	}
 
+	d = ati_ixp4x0_rev(dev);
+	if (d  < 0x82)
+		return;
+
+	/* base address */
 	pci_write_config_dword(dev, 0x14, 0xfed00000);
 	pci_read_config_dword(dev, 0x14, &val);
+
+	/* enable interrupt */
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	b |= 0x1;
+	outb(0x72, 0xcd6); outb(b, 0xcd7);
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	if (!(b & 0x1))
+		return;
+	pci_read_config_dword(dev, 0x64, &d);
+	d |= (1<<10);
+	pci_write_config_dword(dev, 0x64, d);
+	pci_read_config_dword(dev, 0x64, &d);
+	if (!(d & (1<<10)))
+		return;
+
 	force_hpet_address = val;
 	force_hpet_resume_type = ATI_FORCE_HPET_RESUME;
 	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		   force_hpet_address);
 	cached_dev = dev;
-	return;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 			 ati_force_enable_hpet);


