Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYI2S1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYI2S1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYI2S1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:27:17 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55634 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbYI2S1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:27:16 -0400
Message-ID: <48E11EFA.8010402@keyaccess.nl>
Date: Mon, 29 Sep 2008 20:31:22 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
 in quirk_system_pci_resources()
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-09-08 18:34, Linus Torvalds wrote:

> On Mon, 29 Sep 2008, Bjorn Helgaas wrote:
>>  
>> +			if (!pci_resource_enabled(pdev, i))
>> +				continue;
> 
> I really don't think this is the right approach.
> 
> Maybe the PCI device has been turned off, but the *resource* may still be 
> valid.
> 
> Wouldn't it be much better to just check whether the resource is inserted 
> in the resource tree or not? 
> 
> Quite frankly, it looks like your change will basically cause us to look 
> over *every* system PnP resource, and for each of them, it will look at 
> *every* PCI device, and for each PCI device it will look at *every* BAR, 
> and for each BAR it finds it will read the PCI status register, over and 
> over and over again.
> 
> Now, I doubt you'll be able to wear out the PCI bus, but doesn't this just 
> make you go "umm, that's not pretty, and it doesn't make much sense".
> 
> If we've detected the PCI resource as being valid by the PCI layer, why 
> not just use that information? And afaik, the easy way to check that is 
> just whether it's inserted into the resource tree, which in turn is most 
> trivially done by just checking whether the resource has a parent.
> 
> IOW, why isn't it just doing
> 
> 	struct resource *res = dev->resource[bar];
> 
> 	if (!res->parent)
> 		continue;
> 
> or something? Or what was wrong with just checking the res->start for 
> being zero? Wherever PnP is relevant, resources that start at zero are 
> disabled, no? 

I believe the possible issue is that resources that do _not_ (seem to) 
start at zero might also be disabled.

Bjorn commented that pci_resource_start() returns a CPU address for I/O 
which might not be the actual I/O address on some platforms. I haven't a 
clue if that's actually possible "wherever PnP is relevent" as you put 
it but that seems to otherwise make sense.

If it does though, it might for all I know also be possible to check 
against some ARCH_SPECIFIC_INVALID_IO_ADDRESS instead of plain unadorned 
0 (or just recheck the actual BAR again if not stored anywhere).

But that's the issue as I understood it: we might miss them on some 
platforms if checking against 0...

Rene.
