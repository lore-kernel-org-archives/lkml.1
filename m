Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYI3UoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYI3UoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYI3UoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:44:11 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:34241 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYI3UoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:44:10 -0400
Message-ID: <48E2909A.8090703@keyaccess.nl>
Date: Tue, 30 Sep 2008 22:48:26 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
 in quirk_system_pci_resources()
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <48E27E23.20400@keyaccess.nl> <alpine.LFD.2.00.0809301241300.3262@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809301241300.3262@nehalem.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------040206040806010003050400"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040206040806010003050400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 30-09-08 21:44, Linus Torvalds wrote:

> On Tue, 30 Sep 2008, Rene Herman wrote:

>> Yes, I also get that oops but other than that, both link order versions you
>> sent out work -- ie, booting with acpi=noirq gets me to a functional system
>> with the quirk having run for PNP0c02 (acpi=off disables all of PNP0c02) and
>> doing its job.
> 
> Ok. But that means that the last patch I sent out - the one that _only_ 
> changes the order for PnP itself, and moves pnpacpi_init and pnpbios_init 
> to be fs_initcalls - should also work, and have none of he other 
> interactions. Yes?

Yes.

I am fine on current mainline and with this seem to still be fine, with 
or without the quirk changes (*) applied.

(*) http://marc.info/?l=linux-kernel&m=122280330516865&w=2

Frans Pop will need something like those quirk changes on top to have 
his machine stop yelling at him -- assuming it actually works for him 
that is (which it should I guess, but it's not been tested by him yet).

The pci_start == 0 version, attached for convenience and also still 
available from the bugzilla:

http://bugzilla.kernel.org/show_bug.cgi?id=11550

is still the minimal version for Frans' issue.

(I see there are multiple copies of messages that I sent in that marc 
archive. Seem to again be experiencing severe email trouble since I'm 
also not getting back most messages that I see there. Anyways, if you 
get multiple copies, sorry, can't help it it seems, and I need to be 
away after this).

Rene.







--------------040206040806010003050400
Content-Type: text/plain;
 name="0001-PNP-avoid-checking-unitialized-BARs-for-conflicts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-avoid-checking-unitialized-BARs-for-conflicts.patch"

>From 6ba1072ef110f8977832592c092501b81439da4b Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Tue, 30 Sep 2008 22:33:42 +0200
Subject: [PATCH] PNP: avoid checking unitialized BARs for conflicts

Avoid checking a PCI BAR for conflicts if the BIOS left it
unitialized.

Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/pnp/quirks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..d0120a5 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -253,6 +253,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				continue;
 
 			pci_start = pci_resource_start(pdev, i);
+			if (!pci_start)
+				continue;
+
 			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
 			     (res = pnp_get_resource(dev, type, j)); j++) {
-- 
1.6.0.2


--------------040206040806010003050400--
