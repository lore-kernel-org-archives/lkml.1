Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZFPWUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZFPWUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZFPWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:19:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755900AbZFPWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:19:53 -0400
Date: Tue, 16 Jun 2009 15:19:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <20090616220419.14021.84524.stgit@bob.kio>
Message-ID: <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Andrew Patterson wrote:
>
> I recently ran into a resource collision problem where PCI hot-plug
> operations are failing for certain PCI topologies.  One case
> illustrating the problem is using a QLogic PCIe HBA in a slot with a
> PCIe root port as its parent bus.  Here is an abbreviated lspci output
> for this topology:

I think the problem is real, but the fix is wrong.

> After boot, the resource tree looks like:
> 
> f0000000-fdffffff : PCI Bus 0000:c3
>   f0000000-fdffffff : PCI Bus 0000:c2

So the problem is 9if I get this correctly) that c3 should be _inside_ c2. 
No?

But you fix it by making find_resource always go as deep as it can (if I 
read the code correctly). Which is not necessarily always what we want 
either - we've had this kind of confusion before, and the problem is that 
different users of find_resource simply want different things.

The deeper problem (I think) is that the whole "find c3 resource" thing 
should not have started from the root IN THE FIRST PLACE. I think it 
should have started from its parent resources (and then, as a special 
case, if the parent is transparent, look into the parent of the parent, 
etc - in which case it can easily end up in the root in the end, but only 
if it couldn't fit things in a parent window).

And I'm almost certain that I've seen that patch from Ivan at some point, 
but it was after the merge window closed so it didn't get merged.

Ivan? Or anybody else who remembers the patch?

		Linus
