Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXL1Rmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXL1Rmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 12:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXL1Rml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 12:42:41 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1882 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752969AbXL1Rmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 12:42:40 -0500
Message-ID: <47753525.3010701@myri.com>
Date: Fri, 28 Dec 2007 12:40:53 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Arjan van de Ven <arjan@infradead.org>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com> <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org> <alpine.LNX.1.00.0712272204520.13593@iabervon.org> <alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org> <alpine.LNX.1.00.0712280036330.13593@iabervon.org> <20071228103451.GA28694@jurassic.park.msu.ru> <20071228081418.08b60228@laptopd505.fenrus.org> <20071228163841.GA9409@jurassic.park.msu.ru>
In-Reply-To: <20071228163841.GA9409@jurassic.park.msu.ru>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/28/2007 11:38 AM, Ivan Kokshaysky wrote:
> On Fri, Dec 28, 2007 at 08:14:18AM -0800, Arjan van de Ven wrote:
>   
>> it removes code by removing quirks / known not working stuff..
>>     
>
>   




The only quirk I see removed is a bitmap with an arbitrary size (that we
don't really know is sufficient for every system), and that is only
built using comparison between mmconf and type1 accesses.  IMHO, there
is zero knowledge in that removed code (no knowledge about specific
chipsets that work or don't work, or misleading BIOSes).




> This not working stuff gets detected at probe time - see
> drivers/pci/probe.c:pci_cfg_space_size().
>   


This indeed avoids most mmconf invalid attempts (for extended-conf-space
probing that goes through pci_find_ext_capability() or from user-space).


One could think of adding a cfg_size check in
pci_read_config_{read/write), but IMHO that would be useless, since
direct read/write into a known extended-conf-space register in the
extended-config-space can only happen for a pci-express device, and
there is ample evidence that such accesses always work (more exactly
MCFG can always be trusted for pcie devices).

One thing that could be changed in pci_cfg_space_size() is to avoid
making a special case for PCI-X 266MHz/533Mhz (assume cfg_size == 256
for such devices too, reserve extended cfg-space for pci-express
devices). There is good reasons to think no such PCI-X 266Mhz/533 device
will ever have an extended-space (no capability IDs was ever defined in
the PCI-X 2.0 spec, no new revision is planned). Such a check would
avoid the possibility of trying extended-conf-space access for PCI-X 2.0
devices behind a amd-8132 or similar (such accesses would just returnd
-1, but there was some objections raised about doing anything like that
other than at initialization time, even if there is ample reasons to
argue it would be harmless).


Loic


