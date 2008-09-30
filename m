Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYI3OtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYI3OtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYI3Osy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:48:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbYI3Osx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:48:53 -0400
Date: Tue, 30 Sep 2008 07:48:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <48E1EF0E.8030006@keyaccess.nl>
Message-ID: <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org>
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
 <48E1EF0E.8030006@keyaccess.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Rene Herman wrote:
> 
> Just did the attached which might match that intention. Please do not consider
> this a submission as I've no idea if this is sensible nor if it actually helps
> Frans. Just for discussion. Anything here should arrive through Bjorn.

I think you got the logic the wrong way around:

+                       /* have we been registered already? */
+                       if (pci_res->parent)
+                               continue;

This ignores resources that are _registered_, but it should be the other 
way around - we should ignore resources that aren't (because they may be 
invalid or they may move around)

+                       pci_start = pci_res->start;
+                       pci_end = pci_res->end;
+
+                       if (pci_end < pci_start || !pci_end)
+                               continue;

Hmm. This should be unnecessary with any registered resource, since the 
resource code wouldn't allow registering such a resource in the first 
place.

Of course, it may be that the PnP code runs too early, and we have only 
parsed the PCI resources, not inserted them into the resource tree yet. If 
so, none of this will work, of course.

		Linus
