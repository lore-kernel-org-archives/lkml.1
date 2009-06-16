Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbZFPWtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbZFPWtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZFPWtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:49:13 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28281 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZFPWtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:49:12 -0400
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
 resources trees
From: Andrew Patterson <andrew.patterson@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
	 <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 16:51:43 -0600
Message-Id: <1245192703.8234.226.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 15:19 -0700, Linus Torvalds wrote:
> 
> On Tue, 16 Jun 2009, Andrew Patterson wrote:
> >
> > I recently ran into a resource collision problem where PCI hot-plug
> > operations are failing for certain PCI topologies.  One case
> > illustrating the problem is using a QLogic PCIe HBA in a slot with a
> > PCIe root port as its parent bus.  Here is an abbreviated lspci output
> > for this topology:
> 
> I think the problem is real, but the fix is wrong.
> 
> > After boot, the resource tree looks like:
> > 
> > f0000000-fdffffff : PCI Bus 0000:c3
> >   f0000000-fdffffff : PCI Bus 0000:c2
> 
> So the problem is 9if I get this correctly) that c3 should be _inside_ c2. 

That is at least one problem. I initially tried reparenting this stuff.
That is what got backed out in
http://thread.gmane.org/gmane.linux.kernel/768526/

> No?
> 
> But you fix it by making find_resource always go as deep as it can (if I 
> read the code correctly).

Well, just deep enough.

>  Which is not necessarily always what we want 
> either - we've had this kind of confusion before, and the problem is that 
> different users of find_resource simply want different thing

find_resources is only called by allocate_resources, which in turn is
called in about 15 places. I think this change won't affect callers
other than pci_bus_alloc_resource as I am careful to maintain current
behavior as much as possible.

Is there a reason that find_resources should stop at the roots immediate
child/sibling.  It seems like a bug to me. Hence this patch.

> 
> The deeper problem (I think) is that the whole "find c3 resource" thing 
> should not have started from the root IN THE FIRST PLACE. I think it 
> should have started from its parent resources (and then, as a special 
> case, if the parent is transparent, look into the parent of the parent, 
> etc - in which case it can easily end up in the root in the end, but only 
> if it couldn't fit things in a parent window).
> 
> And I'm almost certain that I've seen that patch from Ivan at some point, 
> but it was after the merge window closed so it didn't get merged.
> 
> Ivan? Or anybody else who remembers the patch?
> 
> 		Linus
> 
-- 
Andrew Patterson
Hewlett-Packard

