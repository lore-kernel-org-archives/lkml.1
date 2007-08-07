Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXHGMej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXHGMej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXHGMeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:34:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12080 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbXHGMea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MRCWbyBnZpLZCZjObuoiveXRPOXqVYLB3HiKL1daLXnVmOtHSQesFLwa0g2dOefHGC0sDhIK6VphthTrQHcTujXkIfDGevIYsr7jdHlUopTfIpQe+LpHRRjSfk0Gb2rcwlSeiGqvQYiYTLPhU7zAXf9yIb5pbngoC+NH4rM5VCk=
Message-ID: <6278d2220708070534t7096e579uef2ddbb2c997daa6@mail.gmail.com>
Date: Tue, 7 Aug 2007 13:34:28 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: PAT support for i386 and x86_64
Cc: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Aug, 09:40, Andi Kleen <a...@firstfloor.org> wrote:
> On Mon, Aug 06, 2007 at 10:03:15PM -0400, Cédric Augonnet wrote:
> > Hi all,
>
> > For quite a while now, there as been numerous attempt to introduce support for
> > Page Attribute Table (PAT) in the Linux kernel, whereas most other OS already
> > have some support for this feature. Such a proposition popping up periodically,
> > perhaps it would be an opportunity to fix that lack for once.
>
> The trouble is you need to avoid conflicting attributes, otherwise
> you risk cache corruption. This means the direct mapping needs to be fixed
> up and the kernel needs to keep track of the ranges to prevent conflicts.

The general case of drivers setting up mappings to PCI memory space is
usually done consistently, thus no virtual pages with different PAT
indexes referring to the same physical page would exist here.

What cases did you have in mind?

> Also when there is already a MTRR it might not work due to the complicated
> rules of MTRR<->PAT interaction.

Not so complicated - stronger ordering always takes precedence (for safety).

>From current Intel 64 and IA-32 Architectures Software Developer's Manual
Volume 3A: System Programming Guide, section 10.5.2:

"[...] If there is an overlap of page-level and MTRR caching controls,
the mechanism that prevents caching has precedence. In cases where
there is a overlap in the assignment of the write-back and
write-through caching policies to a page and a region of memory, the
write-through policy takes precedence. The write-combining policy
(which can only be assigned through an MTRR or the PAT) takes
precedence over either write-through or write-back."

If (eg) a broken BIOS marks PCI memory space as UC, we gain nothing
like today. Most modern systems (in the server domain) I've seen don't
do this, as Windows' use of PAT would be broken too.

> Then there are old CPU errata that need to be handled etc.

I don't see a problem with having CONFIG_PAT depend on P4/Athlon or
newer to avoid such workarounds for now. Better to have something
there which works in (only) 80% of the cases, than nothing at all.

> There are also some other issues.

What like?

> You didn't solve all that at all. If it was as simple as your patch
> we would have long done it already.

Perhaps this feature can be marked as WIP to allow this to move
forward while corner-cases are worked out. Adding such a go/no-go
barrier will hamper progress we do see, as it has done already for
years.

The PCI ordering config option years ago was a similar case, since
various drivers didn't issue wmb()s until they were fixed up.

Daniel
--
Daniel J Blueman
