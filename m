Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbXJNXYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbXJNXYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXJNXYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:24:14 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:22724 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755328AbXJNXYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:24:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZdFG2HgYloG6/acEhW+YbfV5911A/JXY4PlQ+eetr4LG+FhGpUn0dP5aBs86eYMbEUzqMtANGMMdF12V8s727fRi197B8ODOvzzLsvHfb1QDVM6Oas+AuGysnAoQUKyXSRIBCKv6E9gUhuAy2xy94qw++GTgdPoRi7R+J2WMjaM=  ;
X-YMail-OSG: b9hsX.wVM1nBu2NHQtHy_cJOPTlxBBvbmgZrdv9r6IDFGKJ4cfOU7pxsabOCcQMShzmZ.eP53w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Date: Mon, 15 Oct 2007 14:15:06 +1000
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org>
In-Reply-To: <4712A254.4090604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151415.07248.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 09:12, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > You mean xfs_buf.c.
>
> Yes, sorry.
>
> > And yes, we delay unmapping pages until we have a batch of them
> > to unmap. vmap and vunmap do not scale, so this is batching helps
> > alleviate some of the worst of the problems.
>
> How much performance does it cost?  What kind of workloads would it show
> up under?
>
> > Realistically, if this delayed release of vmaps is a problem for
> > Xen, then I think that some generic VM solution is needed to this
> > problem as vmap() is likely to become more common in future (think
> > large blocks in filesystems). Nick - any comments?
>
> Well, the only real problem is that the pages are returned to the free
> pool and reallocated while still being part of a mapping.  If the pages
> are still owned by the filesystem/pagecache, then there's no problem.
>
> What's the lifetime of things being vmapped/unmapped in xfs?  Are they
> necessarily being freed when they're unmapped, or could unmapping of
> freed memory be more immediate than other memory?

Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
because it generally has to invalidate TLBs on all CPUs.

I'm looking at some more general solutions to this (already have some
batching / lazy unmapping that replaces the XFS specific one), however
they are still likely going to leave vmap mappings around after freeing
the page.

We _could_ hold on to the pages as well, but that's pretty inefficient.
The memory cost of keeping the mappings around tends to be well under
1% the cost of the page itself. OTOH we could also avoid lazy flushes
on architectures where it is not costly. Either way, it probably would
require an arch hook or even a couple of ifdefs in mm/vmalloc.c for
Xen. Although... it would be nice if Xen could take advantage of some
of these optimisations as well.

What's the actual problem for Xen? Anything that can be changed?
