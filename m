Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYAMVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYAMVTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYAMVTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:19:33 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1969 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753887AbYAMVTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:19:32 -0500
Message-ID: <478A8020.4000203@myri.com>
Date: Sun, 13 Jan 2008 16:18:24 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Arjan van de Ven <arjan@infradead.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org> <478A5727.3000102@myri.com> <20080113104124.022cd0a5@laptopd505.fenrus.org> <20080113204309.GF18741@parisc-linux.org>
In-Reply-To: <20080113204309.GF18741@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/13/2008 3:43 PM, Matthew Wilcox wrote:
> On Sun, Jan 13, 2008 at 10:41:24AM -0800, Arjan van de Ven wrote:
>   
>> Note: There is not a 100% overlap between "need" and "will not be used in 
>> the patches that use legacy for < 256". In the other patches posted, 
>> extended config space will be used in cases where it won't be with my 
>> patch. (Most obvious one is an "lspci -vx" from automated scripts). 
>>     
>
> I believe you to be mistaken in this belief.  If you take Ivan's patch,
> conf1 is used for all accesses below 256 bytes.  lspci -x only dumps
> config space up to 64 bytes; lspci -xxxx is needed to show extended pci
> config space.
>   


I agree with Arjan about that "not a 100% overlap". It is about the 
extra ext-conf-space access done while probing in drivers/pci/probe.c:
    dev->cfg_size = pci_cfg_space_size(dev);

(and lspci -v will also query/show the list of extended-caps for 
pci-x/pcie-x devices that have some, provided the kernel can access 
ext-conf-space).

With Ivan's patch, that line would still cause one extended-conf-space 
access at offset 256 for pcie/pci-x2 devices  (to check the ability to 
query ext-space). Arjan "opt-in" patch would prevent that extra access.

IMHO that access is OK and harmless in all cases, we are already 
protected by MCFG/e820 checks, but I agree one can express a different 
opinion based on trying to prevent "never-seen/potential" hardware/BIOS 
bugs. FWIW it is also there that I was suggested to exclude PCI-X2 
devices (when restricted to pcie, that access while probing cannot even 
cause the harmless master-abort/0xffffffff), but there is a small trade-off.


Loic

