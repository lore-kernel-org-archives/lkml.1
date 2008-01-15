Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYAOWO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYAOWO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYAOWOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:14:20 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1809 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752693AbYAOWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:14:19 -0500
Message-ID: <478D2FE2.3060502@myri.com>
Date: Tue, 15 Jan 2008 17:12:50 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
CC: Tony Camuso <tcamuso@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, Adrian Bunk <bunk@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <478D0928.9020802@redhat.com> <alpine.LFD.1.00.0801151137390.2806@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801151137390.2806@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/15/2008 2:38 PM, Linus Torvalds wrote:
> On Tue, 15 Jan 2008, Tony Camuso wrote:
>   
>> Linus is confident that conf1 is not going away for at least the
>> next five years.
>>     
>
> Not on PC's. Small birds tell me that there can be all these non-PC x86 
> subarchitectures that may or may not have conf1.
>
> 		Linus
>
>   




But is there a ACPI-compliant/architecture that only offers mmconfig for 
configuration-space access and no other fallback method (i.e. no conf1, 
no bios,...)?

2.6.24 supports mmconfig for:
 - ACPI-system with  MCFG
 - a couple chipset discovered by conf1


If a system has no conf1, but does not have e820+ACPI+MCFG, or does have 
some other method than mmconfig, it was already irrelevant in the 
discussion of Ivan's initial patch in december (because that system was 
either never supported or not impacted, and we were trying to fix bugs, 
not introduce support for new class of systems).


Maybe Arjan could share his knowledge, and tell us what system he was 
thinking about (and whether it needed to be supported by 2.6.24) when 
saying:
  "When (and I'm saying "when" not "if") systems arrive that only have 
MMCONFIG for some of the devices."


Anyway Ivan's patch + Matthew's extensions are handling that non-PC 
arch. That combination is advocated by at least:
Ivan Kokshaysky
Matthew Wilcox
Tony Camuso
Loic Prylli
even Arjan's said that while he prefers his patch (saying it's more 
conservative), he does not see a existing problem with the Ivan/Matthew 
combination.

[ simpler, less ambitious fixes can be forgotten if nothing can be done 
for 2.6.24, I can understand that choice ]


The list of problems I see with Arjan's patch are:
- no word on whether the existing Linux driver/pci/pcie/aer code should 
be converted to opt-in?
- mmconfig still needs to be revisited to sort-out the mix of 
mmconfig+conf1+third-method access.
- you cannot test if ext-conf-space is available without taking risks: 
when pci_enable_ext_config() is called, even legacy-conf-space is 
switched to the new method.  So some administrator action (lspci -v 
+maybe-other-flag) or some driver action (that can optionally use 
ext-conf-space but does not *rely* on it) could cause some devices to 
totally disappear (if some pci hierarchy is handled by mmconfig as a 
0xffffffff section as seen on many amd machines). Matthew/Ivan will 
simply in the worst case detect that ext-conf-space is not available in 
pci_cfg_space_size()), legacy-conf-space will still work (and that 
0xffffffff section is perfectly *safe* to query, tell me if you need 
more details of why).
- introduce a new user-api, and a new kernel API, while in practice 
there is no evidence that brings any benefits compared to Ivan/Matthew.


IMHO, making  "pci=nommconf" the default behaviour is better than 
Arjan's patch: for the exaggerated 99.99% users he claims don't need 
ext-conf-space, that's obviously as good. And many of the others would 
benefit from the ability to test and optionally use ext-conf-space is 
available without taking the risk of crashing something, so something 
else is better for them.


With Arjan's patch, in 10 years, we might still have to use an extra 
option (or some other action) when using lspci to display extended caps, 
and we would still run the risk of crashing some old machine when doing 
so (unless maybe a blacklist of some sort will be added, making the 
newly introduced API completely useless soon, or unless we keep the 
painful bitmaps in mmconfig potentially ending-up with 3 set of pci-ops).


Loic

