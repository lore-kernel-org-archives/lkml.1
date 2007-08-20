Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbXHTPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbXHTPNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXHTPMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:12:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbXHTPMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:12:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46C58B4E.4080803@t-online.de>
References: <46C58B4E.4080803@t-online.de> <23249.1186492623@redhat.com> <46B86FC1.7050601@t-online.de> <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com> <23350.1186492903@redhat.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 20 Aug 2007 16:12:48 +0100
Message-ID: <16451.1187622768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> In do_mmap_private, I've commented out the logic to free excess pages, as it
> fragments terribly

I wonder if there's a good heuristic for this.  The problem is that whilst
not releasing excess pages _may_ seem like a good idea, if your system is
something like a single persistent app, then it really is not.

For instance, if such an app allocates a byte over 16MB (perhaps implicitly in
the binfmt driver), then you'd completely waste a large chunk of RAM.  In the
16MB+1 case, the wastage would be a byte less than 16MB.

> and causes a simple
>  while true; do cat /proc/buddyinfo; done
> loop to go oom.

Are you sure it's not just another leak?

> Also, I think you're freeing high-order pages unaligned to
> their order?

Yeah, but some of the pages might still be in use when we want to release
them.

> In shrink_vma, we must save the mm across calls to remove_vma_from_mm (oops
> when telnetting into the box).

I'll have a look, but I don't see that.

> In do_munmap, we can deal with freeing more than one vma.  I've not touched
> the rb-tree logic in the shared file case, as I have no idea what it's trying
> to do given that only exact matches are allowed.

I'd generally rather not do this.  You can't use MAP_FIXED to request adjacent
regions, so why should you anticipate there would be any?

> It still does not survive my mmap stress-tester, so I'll keep looking.

Thanks.

> Why do we need vm_regions for anonymous memory?  Wouldn't it be enough to just
> have a VMA?

It makes it simpler to have a common way of allocating memory for both anon
regions and file regions.

David
