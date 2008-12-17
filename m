Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754885AbYLQEGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYLQEGE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 23:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbYLQEFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 23:05:52 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:39868 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYLQEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 23:05:51 -0500
Date: Tue, 16 Dec 2008 21:05:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Chiang <achiang@hp.com>, justin.chen@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: PCI BAR mem resource allocation "regression"
Message-ID: <20081217040534.GA19967@parisc-linux.org>
References: <20081213000538.GC9947@ldl.fc.hp.com> <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain> <alpine.LFD.2.00.0812130929100.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812130929100.3340@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 09:41:05AM -0800, Linus Torvalds wrote:
> Matthew: I do suspect that the "insert below" patch is wrong. Look at 
> "pci_claim_resource()", for example: it uses insert_resource() to insert 
> the PCI device resource into the resource tree. But if the PCI device 
> resource has the same size as the bus window, that commit changes it to 
> insert it as the _parent_ of the bus window, no?

You're quite correct.  This was actually the intended behaviour of
insert_resource() ... the problem is that pci_claim_resource() is using
it wrong.

> Of course, on a PC, the only user of pci_claim_resource() would be some 
> PCI quirks that should never trigger this, but it's an example of the kind 
> of behavioural change that that commit introduced, and which looks 
> like it could result in a wrong resource tree.
> 
> I'm not finding the original discussion that resulted in that patch, 
> though, so I have a somewhat hard time to judge the reasoning. It's from 
> almost three years ago, I don't remember details even if I had been 
> involved with it (and judging by the sign-off path, I hadn't).
> 
> Matthew, do you remember the context of that commmit d33b6fba2?

Basically it was that we came across a machine with the opposite problem
-- that we found a parent after we found a child (and claimed the
child's resources), and had no way to insert the parent's region above
the child's region.  Alex's machine finds the child after the parent and
needs to insert the child's resource inside the parent's resource.

pci_claim_resource() should be looking through the resources that belong
to the parent bus, trying to insert inside each of them, not just
taking the root resource and wandering all the way down.  I'll work on a
patch tomorrow to do that unless someone beats me to it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
