Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbYLBEr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbYLBEr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYLBErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:47:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYLBErT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:47:19 -0500
Date: Mon, 1 Dec 2008 20:46:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812020531.53175.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812012037320.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812011933050.3256@nehalem.linux-foundation.org>
 <200812020531.53175.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Frans Pop wrote:
> 
> You're in luck. I still had /proc/io* contents from .28-rc3 lying around 
> from working on some other issue.
> 
> Here's the relevant diff for iomem; there's no diff for ioports.
> 
> --- iomem_2.6.28-rc3    2008-11-03 10:59:37.000000000 +0100
> +++ iomem_2.6.28-rc6_linus      2008-12-02 05:20:31.000000000 +0100
> @@ -10,10 +10,9 @@
>  7e7b0000-7e7c53ff : reserved
>  7e7c5400-7e7e7fb7 : ACPI Non-volatile Storage
>  7e7e7fb8-7effffff : reserved
> -80000000-83ffffff : PCI Bus 0000:02
> -  80000000-83ffffff : PCI CardBus 0000:03
> -84000000-87ffffff : PCI CardBus 0000:03
> -88000000-88000fff : Intel Flush Page
> +80000000-83ffffff : PCI CardBus 0000:03
> +84000000-84000fff : Intel Flush Page
> +84400000-847fffff : PCI CardBus 0000:03
>  d0000000-dfffffff : 0000:00:02.0
>    d0000000-d076ffff : vesafb
>  e0000000-e00fffff : PCI Bus 0000:10

I'm not seeing how this could matter. In the latter one, we apparently 
don't set up any PCI bus memory window, but I bet it's a transparent 
bridge, and it shouldn't matter. IOW, your dmesg probably has a line like 
this somewhere:

	pci 0000:00:1e.0: transparent bridge

and whether there is an explicit bus window or not is simply immaterial.

That said, if you can show the differences in dmesg from the two cases, it 
would probably be interesting to see why it happens that way.  Why did we 
bother setting up that PCI bus window in -rc3 at all? Was it there from 
the beginning?

> I've tried a few quick suspend/resume cycles and no failures so far, but 
> that's not really conclusive yet.
> 
> Besides snd_hda_intel I've also been unloading e1000e before suspend 
> because I thought it contributed to resume failures. I'm now keeping that 
> loaded as well. Will report results.

There were some HDA fixes recently, although I don't think they should 
matter for suspend/resume (well, at least a couple of them should fix the 
case of sound being _silent_ on resume, but shouldn't have caused any 
other issues).

		Linus
