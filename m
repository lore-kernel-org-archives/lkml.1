Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYAOQCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYAOQCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYAOQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:02:47 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1991 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbYAOQCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:02:47 -0500
Message-ID: <478CD8A5.5090608@myri.com>
Date: Tue, 15 Jan 2008 11:00:37 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist>
In-Reply-To: <20080114230448.GL9847@does.not.exist>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/14/2008 6:04 PM, Adrian Bunk wrote:
>> I thought so, but due to the way that things are initialised, mmconfig
>> happens before conf1.  conf1 is known to be usable, but hasn't set
>> raw_pci_ops at this point.  Confusing, and not ideal, but fixing this
>> isn't in scope for 2.6.24.
>> ...
>>     
>
> *ahem*
>
> I don't think anything of what was discussed in this thread would be in 
> scope for 2.6.24 (unless Linus wants to let the bunny that brings eggs 
> release 2.6.24).
>
> cu
> Adrian
>   


Why not put in 2.6.24 a simple fix for the last known remaining mmconfig 
problems in 2.6.24?  There has mostly been three bugs related to mmconfig:
- BIOS/hardware: exaggerated MCFG claims: solved long ago
- hardware: buggy CRS+mmconfig chipset: fix included last month
- Linux code: mmconfig incompatible with live BAR-probing: *not fixed*

It would be ironic to not fix the only one that is really confined to 
the Linux code.

Everybody more or less agrees *any* patches submitted so far does solve 
the known problems, and will not cause regressions. The only long 
discussion is about how to best prevent the effect of an "imaginary" 
fourth bug, and by nature that's a controversial topic.

For 2.6.24, if nothing more than a few lines can be done, either make 
pci=nommconf the default and add a pci=mmconf option, or/and apply one 
of the easiest patch to review i.e.Tony's one, so small I copy it again 
below (using 0x40 or 0x100 for the comparison does not really matter, 
personally I would change it to 0x100 to be like Ivan's patch, but 
either is much better than nothing). Replacing some mmconfig access by 
conf1 cannot cause any regression.


Loic


P.S.: with that patch, conf1-less x86 systems requiring mmconfig would 
not be supported. But they are like UFOs. They are plenty of them in the 
galaxy, but earth sightings are not convincing enough for 2.6.24 
support, they can wait 2.6.25.


diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 1bf5816..4474979 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -73,7 +73,7 @@ static int pci_mmcfg_read(unsigned int seg, unsigned 
int bus,
     }
 
     base = get_base_addr(seg, bus, devfn);
-    if (!base)
+    if ((!base) || (reg < 0x40))
         return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
     spin_lock_irqsave(&pci_config_lock, flags);
@@ -106,7 +106,7 @@ static int pci_mmcfg_write(unsigned int seg, 
unsigned int bus,
         return -EINVAL;
 
     base = get_base_addr(seg, bus, devfn);
-    if (!base)
+    if ((!base) || (reg < 0x40))
         return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
     spin_lock_irqsave(&pci_config_lock, flags);
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 4095e4d..4ad1fcb 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -61,7 +61,7 @@ static int pci_mmcfg_read(unsigned int seg, unsigned 
int bus,
     }
 
     addr = pci_dev_base(seg, bus, devfn);
-    if (!addr)
+    if ((!addr) || (reg < 0x40))
         return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
     switch (len) {
@@ -89,7 +89,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned 
int bus,
         return -EINVAL;
 
     addr = pci_dev_base(seg, bus, devfn);
-    if (!addr)
+    if ((!addr) || (reg < 0x40))
         return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
     switch (len) {





