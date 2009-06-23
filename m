Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbZFWW5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbZFWW5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZFWW4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:56:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39529 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbZFWW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:56:54 -0400
Date: Tue, 23 Jun 2009 23:56:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090623225651.GA18736@srcf.ucam.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain> <20090623185120.GA13824@srcf.ucam.org> <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain> <20090623202302.GA15265@srcf.ucam.org> <20090623204524.GA15891@srcf.ucam.org> <alpine.LFD.2.00.0906231734170.32098@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231734170.32098@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 06:20:11PM -0400, Len Brown wrote:
> On Tue, 23 Jun 2009, Matthew Garrett wrote:
> 
> > I think I've got a clearer understanding of my objections to this now. 
> > The first is that SFI is designed to support the subset of information 
> > that's in ACPI and which can't be intuited by the OS. However, that 
> > subset is predicated on the system looking like Moorestown. A system 
> > that wants to provide any information beyond that subset can't use SFI 
> > unless it defines additional tables.
> 
> Correct.
> 
> Per my previous message...
> 
> Should a platform require them, any and all of the ACPI
> defined/reserved tables can be accessed on an SFI system
> if needed.  Today, the PCI MCFG is the only ACPI table implemented
> in the known universe of SFI systems.

Right. But you've already got a potential conflict when it comes to 
wrapping the MADT - if someone wants a greater set of APIC information 
than you can provide via the SFI APIC table they're going to hit 
interesting problems.

> WRT to native SFI table names...
> 
> int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
>                         uint flag, sfi_table_handler handler);
> 
> While the invocations in the tree today have NULL oem_id
> and NULL oem_table_id, it is possible for a vendor to
> stick their own name in there with their own table_id
> and get the OS or a driver to find their home-brewed table
> without reserving a table signature to the SFI spec.

Ok, that looks plausible. Can this be added to the spec as a best 
practice?

> However, should overwhemling demand for table signatures materialize,
> I'm sure that a process can be put in place to manage collisions...

Given the potential for vendors to ship customised Linux kernels, I 
think it'd be beneficial to have that in place before any hardware's 
shipped. The moment we have a collision we have a support nightmare.

> > And that brings me onto my second issue. ACPI is sufficiently 
> > generalised that there's little need for vendors to add additional 
> > tables. SFI isn't, and so vendor adoption is going to require 
> > vendor-specific tables. This potentially results in SFI bloating out to 
> > cover much of the functionality of ACPI, while at the same time turning 
> > into a namespacing nightmare. Without a formal process for adding new 
> > tables and without any kind of certification requirements before 
> > claiming SFI compatibility, we're looking at a real risk of collisions.
> 
> The SFI table signatures are totally independent of the ACPI table
> signatures -- they can not collide.  The only overlap is the XSDT
> itself, which exists in SFI explicitly to separate the ACPI namespace
> from the SFI namespace.

My concern is collisions within the SFI namespace, not collisions 
between ACPI and SFI.

> > SFI appears to be presented as a generic firmware interface, but in 
> > reality it's currently tightly wed to Moorestown and I don't see any way 
> > that that can be fixed without reinventing chunks of ACPI. I'm certainly 
> > not enthusiastic about seeing this presented as a fait accompli in 
> > generic driver code, rather than under arch/x86/moorestown.
> 
> SFI was invented with the goal to help a somewhat generic 
> distro-supported kernel to boot and run optimally
> on the Moorestown platform.  If SFI helps enable Moorestown
> to participate in even just a small part of the vibrant
> x86 open source development community, than it has been successful.
> 
> Yes, SFI is written to be "generic enough" so that it can be
> used by more than Moorestown.  It is not trying to displace ACPI
> on systems that are willing and able to support ACPI, but it
> is freely available for those platforms that can't.

If SFI's intended to support non-Moorestown platforms then I think we 
need to spend some more time determining what a non-Moorestown SFI 
implementation would look like, what changes would be required in the 
kernel to support that and how to ensure that vendors do this in a 
manner that doesn't make it likely that we'll have incompatible 
impleentations. If it's not then I think the Kconfig and documentation 
need to make that clearer.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
