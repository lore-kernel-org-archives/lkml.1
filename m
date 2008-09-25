Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYIYB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYIYB0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYIYB0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:26:07 -0400
Received: from styx.suse.cz ([82.119.242.94]:45720 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138AbYIYB0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:26:03 -0400
Date: Thu, 25 Sep 2008 03:27:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
cc: jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net>  <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>  <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>  <20080923.211215.193696086.davem@davemloft.net>  <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
 <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Dave Airlie wrote:

> Well I'm out of the race, my attempts to re-write my eeprom using an 
> eeprom from an equivalent laptop have totally failed and my BIOS won't 
> boot anymore - so my laptop is == a brick.

Uh oh. Shouldn't we put something like the patch below in Linus' tree 
unless we get this sorted out? Otherwise more and more people who use -rc 
kernels will run into this, and will get their hardware [hopefully 
temporarily, but not all users are able to re-flash their network card 
EEPROMs, right] bricked.

I know that it is quite aggressive and is going to disable wired 
networking on a lot of systems that have been functioning properly, 
therefore RFC ...



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] [RFC] E1000E: temporarily disable e1000e driver

E1000E: temporarily disable e1000e driver

There is a serious bug somewhere, that renders e1000e network cards 
unusable on certain hardware configurations by rewriting EEPROM with 0xff 
all over. Debugging this is not trivial, because:

- it is not yet even clear whether the bug is caused by userspace (new 
  version of xorg drivers, bad interaction with PAT, ...) or some bug in 
  kernel code; it's even not yet certain at which exact combination of 
  software versions and hardware configuration this started to trigger
- you have only one attempt to test potential fix. If the fix doesn't 
  work, the eeprom of the card is hosed

and therefore fixing this has potential to take some time.

The tool that will safely restore the previous contents of EEPROM is 
currently being written, but even this is not trivial (Dave Airlie has 
turned his notebook into brick while trying to restore the EEPROM 
contents).

Let's therefore mark this driver as broken (though it is very well 
possible that this particular driver is not at fault at all) until this 
gets resolved, so that users of -rc kernels don't get their network cards 
totally unusable.

References (information about sw/hw configurations of affected systems 
might be found in the bugzillas):

	http://lkml.org/lkml/2008/8/8/123
	http://lkml.org/lkml/2008/9/22/23

	http://bugzilla.kernel.org/show_bug.cgi?id=11382

	https://bugzilla.novell.com/show_bug.cgi?id=425480
	https://bugzilla.redhat.com/show_bug.cgi?id=459202
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/263555
	https://qa.mandriva.com/show_bug.cgi?id=44147

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4a11296..2d7a7f2 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1938,7 +1938,7 @@ config E1000_DISABLE_PACKET_SPLIT
 
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
-	depends on PCI && (!SPARC32 || BROKEN)
+	depends on PCI && BROKEN
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,

