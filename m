Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXGGR6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXGGR6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXGGR6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:58:24 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26667 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXGGR6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:58:23 -0400
Date: Sat, 07 Jul 2007 11:57:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Disabling ADMA?  (was Re: [PATCH] drivers/ata: Add the SW NCQ
 support to sata_nv for MCP51/MCP55/MCP61)
In-reply-to: <468FB3A5.9000008@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Kuan Luo <kluo@nvidia.com>, Peer Chen <pchen@nvidia.com>,
       Allen Martin <AMartin@nvidia.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org
Message-id: <468FD427.8010904@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <15F501D1A78BD343BE8F4D8DB854566B059FE131@hkemmail01.nvidia.com>
 <468FB3A5.9000008@garzik.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Kuan Luo wrote:
>>     @@ -1714,3 +2761,6 @@ module_init(nv_init);
>>      module_exit(nv_exit);
>>      module_param_named(adma, adma_enabled, bool, 0444);
>>      MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
>>     +module_param_named(ncq, ncq_enabled, bool, 0444);
>>     +MODULE_PARM_DESC(ncq, "Enable use of NCQ (Default: false)");
> 
> After looking through sata_nv bug reports, I am leaning towards 
> disabling ADMA by default, and wanted to solicit comments.
> 
> While admittedly not knowing the root cause, it seems like every current 
> outstanding sata_nv bug report that remains after switching out hardware 
> can be solved by setting module option 'adma' to zero.  That's my first 
> suggestion upon any bugzilla sata_nv bug, and it usually works.  You can 
> look through bugs assigned to or CC'd to jgarzik@pobox.com (kernel.org 
> bugs) jgarzik@redhat.com (redhat.com bugs) for examples.

Do you have some specific bug numbers? Other than this one:

http://bugzilla.kernel.org/show_bug.cgi?id=8421

That one is hotplug-related, and it would seem only affects specific 
boards as it works fine for me. Likely NVIDIA input would be needed on 
that one to get much farther.

I didn't find any other sata_nv ADMA-related bugs in the kernel.org or 
RH Bugzillas.

Most of the reports I've gotten recently have been in one of these 
categories:

-broken NCQ implementation on the drive (usually shows up as commands 
timing out with CPB resp_flags of 2)
-cabling or power problems (often showing errors in the SError register)

There have been a few reports yet of problems with commands getting 
issued and seeing to go nowhere. These can be difficult to diagnose. 
However, in some cases there's evidence leaning toward this being a 
drive issue as well, ex: this thread:

http://groups.google.ca/group/linux.kernel/browse_frm/thread/2ebf329e3f6470eb/0d26dff9a30d29e9?lnk=gst

Here there's a report of this drive model doing this on multiple 
controllers.

Keep in mind, in the case where a broken NCQ implementation on the drive 
is the cause, disabling ADMA (and hence NCQ) will appear to "fix" the 
problem when the proper course of action would be to blacklist NCQ on 
that drive globally.

Given the relative scarcity of problem reports (at least those I've 
seen), and the fact that this is not obscure hardware (they must have 
made millions of these nForce4 boards, and I think some may even still 
be in production), I'm reluctant to say we should be switching ADMA off 
by default.

> 
> I still need to review the SWNCQ patch in detail, but I presume it is 
> possible to still use SWNCQ without ADMA?

Yes, they're independent.

> 
> On a side note, I would rather default SWNCQ to 'on'.


