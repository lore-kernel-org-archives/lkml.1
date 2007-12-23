Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbXLWEwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbXLWEwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 23:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXLWEwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 23:52:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50755 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbXLWEwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 23:52:39 -0500
Message-ID: <476DE98F.2010009@garzik.org>
Date: Sat, 22 Dec 2007 23:52:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 22 Dec 2007, Jeff Garzik wrote:
> 
>> My core assertion:  the present situation -- turning off MMCONFIG aggressively
>> -- is greatly preferable to adding pci_enable_mmconfig_accesses(pdev).
> 
> Well, you do realize that right now we have to have _users_ just doing 
> "pci=nommconf" on the kernel command line, because we apparently don't do 
> it aggressively enough?
> 
> The fact is, we simply don't know what the breakage is. The only safe 
> situation is to just assume things are broken, and enable it only when 
> necessary.

Absolutely.

But regardless of problems, enabling should be done globally, not per 
device...  You have three possibilities for an mmconfig-maybe-capable 
machine:

1) mmconfig disabled globally (for a single computer)

	Widely tested by users and hw vendors

	Consistent (all devices use same type of config access)

2) mmconfig enabled globally (for a single computer)

	Poorly tested by hw vendors, apparently

	Consistent (all devices use same type of config access)

3) mmconfig might or might not be enabled, depending on which driver is 
loaded, whether it called an API or not.

	Even LESS testing by hw vendors than #2.  Maybe even "never"

	Inconsistent (config access depends on device)

Choosing solution #3 is to choose the /least/ tested, /least/ likely to 
get hw vendor testing, /most/ inconsistent solution available.  Doing so 
is not maximizing good engineering attributes :)

AFAICS, solution #3 has a much higher chance of breaking userspace 
(pciutils, X.org, distro installers that read PCI config space, ...) as 
a result of the inconsistencies introduced.

I agree 100% with your summary of the problem.

But the per-device enabling solution introduced a "mixed model" for 
config space accesses is worse than any whitelist or other global [for a 
single computer] solution.

The per-device enabling solution is IMO worse than simply deleting all 
mmconfig code from the kernel.  At least the "kill mmconfig" solution 
would maintains the "tested" and "consistent" properties :)

	Jeff




