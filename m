Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbZFPXco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbZFPXco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZFPXcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:32:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbZFPXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:32:35 -0400
Date: Tue, 16 Jun 2009 16:32:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906161623240.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain> <1245192703.8234.226.camel@bluto.andrew> <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Linus Torvalds wrote:
> 
> So your patch may fix a bug, but I'm pretty sure I've seen a patch from 
> Ivan that should _also_ fix it, and that I would expect to do it not by 
> just tweaking a fundamentally ambiguous case.

Hmm. For the life of me, I can't seem to find this patch. Maybe it wasn't 
Ivan who wrote it after all. Or maybe my google-fu is weak. Or maybe I'm 
just delusional, and the patch never existed.

However, regardless of that, I'm now confused about your patch too. So you 
have this layout:

	-+-[0000:c2]---00.0-[0000:c3-fb]--+-00.0  QLogic Corp. 8Gb Fibre Channel HBA
	 |                                \-00.1  QLogic Corp. 8Gb Fibre Channel HBA

where bus c3 is inside bus c2. Fine. And we clearly get that wrong in the 
resource tree:

	f0000000-fdffffff : PCI Bus 0000:c3
	  f0000000-fdffffff : PCI Bus 0000:c2
	    f0000000-f00fffff : 0000:c3:00.1

since that one end up having the c3 bus resource _outside_ of the c2 one. 
That is, I think, the real bug. However, your patch doesn't try to fix 
that bad nesting, but instead seems to try to work around it some odd way.

But looking at things, I don't even see how this happens in the first 
place. Afaik, we use pci_assign_resource() to assign bus resources, and 
that one _should_ nest properly. So now I'm really confused about how you 
got that /proc/iomem in the first place. 

Is this perhaps some hotplug-pci specific bug? How did that bus resource 
for "PCI Bus 0000:c3" get allocated? 

			Linus
