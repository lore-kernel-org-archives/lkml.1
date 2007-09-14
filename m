Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXINXyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXINXyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXINXyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:54:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6917 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbXINXyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:54:12 -0400
Date: Fri, 14 Sep 2007 17:53:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
In-reply-to: <20070914192913.A6668@jurassic.park.msu.ru>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Message-id: <46EB1F16.8060209@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
 <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no>
 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
 <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca>
 <20070914192913.A6668@jurassic.park.msu.ru>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Fri, Sep 14, 2007 at 08:30:59AM -0600, Robert Hancock wrote:
>> Do you have an example of specific hardware that exhibits this problem?
> 
> Well, first two results of google search for "disable bar when sizing":
>  http://lkml.org/lkml/2002/12/21/95
>  http://lkml.org/lkml/2002/12/20/110

In the first one, Linus talks about a USB controller whose SMM code 
chokes on the BAR being disabled. That explanation seems odd to me. If 
it chokes on the BAR disabled, how doesn't it choke on the BAR being 
moved to a different location, which is unavoidable during probing?

Also, I think we do USB handoff from the BIOS much earlier than we used 
to, which likely prevents these issues.

In the second one, he mentions that "So the secondary rule to "don't 
turnoff MEM or IO accesses" is "never allocate real PCI BAR resources at 
the top of memory". Well, unfortunately, the second one isn't possible 
to meet given that we have boards with the MMCONFIG up there, so 
disabling the decode is the only thing we can do. That whole discussion 
was also based on the fact that it wasn't necessary to solve problems. 
This is no longer a theoretical problem. We now have real problems that 
we need this in order to solve.

> 
>> So far after a similar patch has been in -mm for months there have been 
>> no reports of any such problems.
> 
> You cannot compare user base of -mm and release kernels. Also, note
> that we're talking about maybe 0.01% of systems running Linux.
> And similar patch appeared in various trees several times over the last
> decade and every time it had to be reverted.
> 
>> This isn't guaranteed to help. I don't think it is only integrated 
>> graphics that could cause this problem, I think that an add-on PCI 
>> Express card can do this as well. Depending on the chipset memory decode 
>> rules, any PCI or PCI Express device with a BAR large enough could cause 
>> issues.
> 
> No, it's impossible for several reasons. Most obvious one is that a PCI-E
> bridge does isolate stuff quite nicely.

It's not impossible at all. In fact I'm quite sure (Jesse can confirm) 
that in the case of the board he was using, it was an add-in graphics 
card where he saw this problem.

The fact is that in the case of MMCONFIG overlap with PCI BARs, which 
one takes priority is completely undefined. In the case of this Intel 
chipset, clearly the PCI Express device connected to the northbridge had 
higher decode priority than the MMCONFIG aperture.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

