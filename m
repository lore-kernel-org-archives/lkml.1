Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbXLSAiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbXLSAiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXLSAin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:38:43 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44780 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXLSAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:38:42 -0500
Date: Tue, 18 Dec 2007 18:38:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI resource problems caused by improper address rounding
In-reply-to: <fa.Obg5E3fyax+MaF94//uo40q/Zyk@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Message-id: <4768680B.6060702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.WmGIH8th8MfmciABVSBi6whxeFE@ifi.uio.no>
 <fa.Obg5E3fyax+MaF94//uo40q/Zyk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 17 Dec 2007, Chuck Ebbert wrote:
>> Looks like a commit that I can't find in git due to the arch merge
>> has broken PCI address assignment. This patch by Richard Henderson
>> against 2.6.23 fixes it for x86_64:
>>
>> --- linux-2.6.23.x86_64/arch/x86_64/kernel/e820.c	2007-10-09 13:31:38.000000000 -0700
>> +++ linux-2.6.23.x86_64-rth/arch/x86_64/kernel/e820.c	2007-12-15 12:37:44.000000000 -0800
>> @@ -718,8 +718,8 @@ __init void e820_setup_gap(void)
>>  	while ((gapsize >> 4) > round)
>>  		round += round;
>>  	/* Fun with two's complement */
>> -	pci_mem_start = (gapstart + round) & -round;
>> +	pci_mem_start = (gapstart + round - 1) & -round;
> 
> No, it's very much meant to be that way.
> 
> We do *not* want to have the PCI memory abutthe end of memory exactly. So 
> it leaves a gap in between "gapstart" and the actual start of PCI memory 
> addressing very much on purpose.
> 
> In fact, the very commit (it's f0eca9626c6becb6fc56106b2e4287c6c784af3d in 
> the kernel tree) you mention actually explicitly *explains* that, although 
> maybe it's a bit indirect: if you start allocating PCI resources directly 
> after the end-of-RAM thing, you can easily end up using addresses that are 
> actually inside the magic stolen system RAM that is being used for UMA 
> video etc.
> 
> So you very much want to have a buffer in between the end-of-RAM and the 
> actual start of the region we try to allocate in. 
> 
> So why do you want them to be close, anyway? 
> 
> 		Linus
> 
> PS. On a different topic: if you do
> 
> 	git log --follow arch/x86/kernel/e820_64.c
> 
> you'd see the history past the renames in git. Or just do a "git blame -C" 
> which will also follow renames (and copies).

That patch is from the 2.6.14 era - I don't think we even did PnP ACPI 
resource reservation handling then? It could be that the BIOS was trying 
to tell us that UMA memory region is reserved using PnP ACPI 
reservations, but we just ignored it.

It seems rather arbitrary in how much it leaves unused - and in this 
case, likely prevents us from using the nice big open gap that the BIOS 
presumably expected the graphics card to be mapped into.

I suspect this buffer space insertion is really not needed at this 
point. The patch description is likely technically correct in that the 
BIOS should have reserved it in E820, but (according to MS comments in a 
presentation I read) Windows doesn't use E820 for anything other than 
figuring out where RAM is, it uses PnP ACPI for figuring out areas it 
needs to avoid. Since BIOS writers test against that behavior, there are 
surely lots of systems where ignoring PnP ACPI reservations and relying 
only on E820 would result in things really going blammo (like mappings 
things over MMCONFIG tables for instance). So disabling it on modern 
machines is really not an option. And if it's enabled, you likely 
wouldn't hit the problem it tries to fix.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

