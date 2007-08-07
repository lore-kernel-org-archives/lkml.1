Return-Path: <linux-kernel-owner+w=401wt.eu-S934759AbXHGP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759AbXHGP0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXHGP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:26:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:57968 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbXHGP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oQrDfU2OGCVNs1i6PQicY7VYJyEcNSHt9PU0n3lweP5vA//RtaPJky83o/0ySNBeYGVTmY9jLN05mSKLRwYkzbVeEunOl7xFey0u8f43/m6dIHMj4nyKJecTjuYpnFabAo4qlVwT9lwx9VC3Dzeq2+vZO92HXD38JQQIKzUZ7mI=
Message-ID: <6278d2220708070826h2613dd7dr6e3b8001fba3441a@mail.gmail.com>
Date: Tue, 7 Aug 2007 16:26:06 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: PAT support for i386 and x86_64
Cc: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070807141042.GB952@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220708070534t7096e579uef2ddbb2c997daa6@mail.gmail.com>
	 <20070807141042.GB952@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/07, Andi Kleen <andi@firstfloor.org> wrote:
> > What cases did you have in mind?
>
> Mainly mapping memory which is rather tricky.

Yes, I'm talking about memory-mapping PCI memory regions; however I
can't see other immediate uses. Then maybe it's acceptable to document
that - for now - we need to hand out mappings which have consistent
PAT indexes, which would be natural in all cases I've seen with
processes writing/bursting to registers in PCI memory space.

> > From current Intel 64 and IA-32 Architectures Software Developer's Manual
> > Volume 3A: System Programming Guide, section 10.5.2:
>
> If you look at the detailed table it's not that simple.

Ignoring the N/A PPro and PII table, the various combinations of MTRR
and PAT entries (table 10-7) again show expected safe behaviour. We
don't worry about WP MTRRs, since BIOSes and Linux don't set that, and
we are practically only interested in WC and UC access, which we get
irrespective of the MTRR type covering that region.

A number of vendors (graphics, HPC etc) implement and use their own
PAT mechanisms, so defining only WC and UC covers all the cases.

> > > Then there are old CPU errata that need to be handled etc.
> >
> > I don't see a problem with having CONFIG_PAT depend on P4/Athlon or
> > newer to avoid such workarounds for now. Better to have something
> > there which works in (only) 80% of the cases, than nothing at all.
>
> Agreed, but the patch doesn't do that.

Noted for later.

> > > You didn't solve all that at all. If it was as simple as your patch
> > > we would have long done it already.
> >
> > Perhaps this feature can be marked as WIP to allow this to move
> > forward while corner-cases are worked out. Adding such a go/no-go
>
> We're not going to have potentially cache corrupting features
> as WIP. The last time one such bug took months to track down.

A driver that hands out mappings to the same PCI memory address with
different access ordering seems broken by design (due to PCI BARs
being strictly prefetchable or not). Again vendors implement their own
PAT mechanics which are consistent about access types.

(Intel IA32 ASDM 3A 10-47) "a WC page must never be aliased to a
cacheable page because WC writes may not check the processor caches."

This is not talking about corrupting the cache generally, but data
hitting a PCI target twice by (ie) a broken driver.

> > barrier will hamper progress we do see, as it has done already for
> > years.
>
> Because it's not simple and nobody has done it properly yet.

Providing only UC and WC types and documenting aliasing problems is
what is required here.

> > The PCI ordering config option years ago was a similar case, since
> > various drivers didn't issue wmb()s until they were fixed up.
>
> wmb alone is not enough for PCI ordering.

(not the point in question)

> -Andi
-- 
Daniel J Blueman
