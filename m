Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbZHDXHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbZHDXHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933510AbZHDXHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:07:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933437AbZHDXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:07:00 -0400
Date: Tue, 4 Aug 2009 16:04:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manuel Lauss <mano@roarinelk.homelinux.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <20090803165909.GA12824@roarinelk.homelinux.net>
Message-ID: <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Aug 2009, Manuel Lauss wrote:
> 
> This patch introduces a warning on my system:
> 
> pci 0000:02:03.0: BAR 6: address space collision on of device [0xff680000-0xff69ffff]

Heh, that's funny. I suspect you have always had the error, it's just that 
back before the commit that started using "pci_claim_resource()", we did 
that "find_parent_resource()+request_resource()" by hand.

So before commit a76117dfd687ec4be0a9a05214f3009cc5f73a42, the ROM 
resources were done with:

	pr = pci_find_parent_resource(dev, r);
	if (!pr || request_resource(pr, r) < 0) {
		r->end -= r->start;
		r->start = 0;
	}

inside pcibios_assign_resources(), and it would never warn about it, it 
would just silently mark the resource unregistered (and then we'd 
re-allocate it later).

So I _think_ that you actually are getting the same layout as with 2.6.30, 
but with a warning that didn't exist in 2.6.30. Can you verify?

With the change to use "pci_claim_resource()", it initially changed things 
to use "insert_resource()", and that shouldn't have even succeeded, but 
apparently did! That's a bit scary. The patch to make it use 
pci_request_resource() should have made it have the same behavior as we 
had in 2.6.30 - albeit with the warning (that we didn't use to have).

I do wonder why the insert_resource() seems to have worked, though, so 
maybe I'm misdiagnosing this. Can you post your /proc/iomem from 2.6.30?

		Linus
