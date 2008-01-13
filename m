Return-Path: <linux-kernel-owner+w=401wt.eu-S1751506AbYAMHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbYAMHU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 02:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYAMHUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 02:20:18 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:2027 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbYAMHUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 02:20:16 -0500
Message-ID: <4789BB67.5000503@myri.com>
Date: Sun, 13 Jan 2008 02:19:03 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Arjan van de Ven <arjan@infradead.org>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org> <alpine.LNX.1.00.0712272204520.13593@iabervon.org> <alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org> <alpine.LNX.1.00.0712280036330.13593@iabervon.org> <20071228103451.GA28694@jurassic.park.msu.ru> <20071228081418.08b60228@laptopd505.fenrus.org> <20071228163841.GA9409@jurassic.park.msu.ru> <47753525.3010701@myri.com> <20071228211219.GA10475@jurassic.park.msu.ru> <20080113060154.GZ18741@parisc-linux.org>
In-Reply-To: <20080113060154.GZ18741@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/13/2008 1:01 AM, Matthew Wilcox wrote:
> On Sat, Dec 29, 2007 at 12:12:19AM +0300, Ivan Kokshaysky wrote:
>   
>> On Fri, Dec 28, 2007 at 12:40:53PM -0500, Loic Prylli wrote:
>>     
>>> One thing that could be changed in pci_cfg_space_size() is to avoid
>>> making a special case for PCI-X 266MHz/533Mhz (assume cfg_size == 256
>>> for such devices too, reserve extended cfg-space for pci-express
>>> devices). 
>>>       
>> I agree, we should remove it. IIRC, this PCI-X check was written
>> long ago with some draft (not a final spec) in hands. Matthew?
>>     
>
> I have what I believe to be the released version of PCI-X 2.0a (July
> 22, 2003).  It is quite clear that Mode 2 devices (ie those running at
> 266MHz or 533MHz) are required to support all 4096 bytes of extended
> config space.
>
> More to the point, I don't think we have any bug reports suggesting that
> PCI-X Mode 2 devices/bridges have any problems. 



As PCI-X2 bridge/chipset, I only knows about the AMD-8132 (from what I 
understand it does PCI-X Mode 2), and some obscure IBM enterprise 
chipset (I am sure there are a few more).



Too bad for the spec, but we definitely know for sure the AMD-8132 
doesn't do ext-space (and makes it unusable for any device behind it).



> There are relatively
> few of them in existance, and my impression is that PCI-X2 is only being
> implemented on server-class machines. 



True.



>  'Consumer grade' equipment is
> where all the problems lie anyway.
>   



mmconfig has been a pain on the servers too (there are a lot of server 
class amd machines using one pcie/mmconfig/chipset + amd-8131/2).


> While the PCI-X 2.0a spec does not define any Extended Capability IDs,
> it simply states that "This field is a PCI-SIG defined ID number that
> indicates the nature and format of the Extended Capabilities List item".
> The PCIe spec does define Extended Capability IDs, and I would think
> it's entirely appropriate to use the same IDs for PCI-X Mode 2 devices.
>   


Sure it might be needed on PCI-X2. But contrary to pcie (where the 
driver/pci/pcie/aer subsystem already use ext-conf-space, and other 
usages are bound to increase), needing ext-conf-space in the future on 
pci-x2 is quite unlikely (pcie is long-lived, whereas PCI-X2 was 
short-lived, obsoleted by PCI-E, and nobody has mentioned yet an example 
of using ext-registers with a PCI-X2 device).

I was only mentioning that because of the very small trade-off:  if you 
don't exclude PCI-X2, on platforms with the amd-8132+bad-MCFG, you might 
trigger a cfg-read==0xffffffff/master-abort in pci_cfg_space_size() for 
such devices with Ivan patch. This is harmless, because a lot of similar 
master-abort happen during PCI-probing anyway, so one more won't change 
anything.


Anyway, I am equally happy with keeping pci_cfg_space_size() as it is.


Loic

