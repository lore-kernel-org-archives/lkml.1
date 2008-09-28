Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYI1Js2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYI1Js2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 05:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYI1JsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 05:48:20 -0400
Received: from c01.privatesystems.net ([65.99.213.12]:40636 "EHLO
	c01.privatesystems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYI1JsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 05:48:19 -0400
X-Greylist: delayed 2362 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2008 05:48:19 EDT
Message-ID: <48DF492A.6070503@talisiorder.ca>
Date: Sun, 28 Sep 2008 05:06:50 -0400
From: jbi <jbi@talisiorder.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: e1000e NVM corruption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - c01.privatesystems.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - talisiorder.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not a member of this list (I read occasionally via the public 
archives) or an experienced kernel hacker but I do have a few 
semi-informed thoughts on the 8256x NVM corruption issue.  Take with 
salt as necessary:

According to Intel's datasheet, these interfaces expose *writable* PCI 
ID registers at NVM words 0x0A-0x0E[1].  Fill the NVM with FFs and the 
interface will probably respond with vendor ID : device ID FFFF:FFFF 
during bus enumeration.  The potential for these devices to disappear 
off the PCI bus after NVM corruption means that unbricking damaged 
devices could be nontrivial.

One possible recovery option would be see if a bricked interface still 
responds to commands at the appropriate hardware address in the PCI 
configuration space.  Even if the device escapes enumeration because its 
vendor ID and device ID are invalid, the hardware might be alive enough 
to work with an NVM-reflash driver that ignored the PCI ID.  In the best 
case, getting a dead device back could just be a matter of setting up 
MBARB by writing to the configuration space for bus 0 dev 25 fn 0 (for 
ICH9) and reloading the NVM with a reasonable set of defaults.

Another recovery possibility would be to rewrite the NVM using the ICH's 
SPI interface.  The same flash chip serves both the BIOS and NIC.  The 
NVM might be rewritable through the ICH even if the NVM is too deeply 
corrupted for the NIC to respond to reflash commands.  This fix would be 
complex, risky, and possibly motherboard specific, but should be able to 
put most bricked 8256x NICs back together unless NVM corruption has 
caused deeper damage.

Finally, given that one write to the wrong part of the NVM will turn one 
of these NICs into a brick, memory mapping the NVM--even for the 
briefest period--seems deeply imprudent.  As long as the NVM is memory 
mapped, all it takes to turn one of these NICs into a brick is for one 
kernel mode bug to make one dword write to any of those registers.  With 
the current cost of stomping on 8256x NVM data running at upwards of 
$500 per laptop, eliminating MMIO NVM access in favor of extensively 
sanity checked IO-mapped access seems like a very good idea.  Unlike the 
simplicity of MMIO writes, the IO-based flash write process for the 
8256x chips is sufficiently complex that rogue writes are unlikely to 
happen by accident.



[1]
http://download.intel.com/design/network/applnots/ICH9_NVM.pdf
See especially the example NVM tables in the last few pages.
