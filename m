Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbXLRRef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbXLRRef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbXLRReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:34:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759758AbXLRReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:34:19 -0500
Message-ID: <47680489.6040809@redhat.com>
Date: Tue, 18 Dec 2007 12:34:01 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2007 07:57 PM, Linus Torvalds wrote:
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

Because otherwise some video adapters with 256MB of memory end up with their
resources allocated above 4GB, and that doesn't work very well.

https://bugzilla.redhat.com/show_bug.cgi?id=425794#c0

> 
> PS. On a different topic: if you do
> 
> 	git log --follow arch/x86/kernel/e820_64.c
> 
> you'd see the history past the renames in git. Or just do a "git blame -C" 
> which will also follow renames (and copies).

The history in the web interface just ends at the rename.


