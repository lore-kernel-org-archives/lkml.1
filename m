Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZEALob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZEALob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZEALoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:44:09 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59538 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbZEALoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:44:07 -0400
Date: Fri, 1 May 2009 13:46:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix false positive section mismatch warnings in the apic code
Message-ID: <20090501114617.GB22023@uranus.ravnborg.org>
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com> <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org> <49EAF31C.8020108@gmail.com> <20090419095759.GA4808@elte.hu> <20090419111650.GA19873@uranus.ravnborg.org> <b9df5fa10904192100h6d5b728bldcc9337bb50d88b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10904192100h6d5b728bldcc9337bb50d88b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 10:00:24AM +0600, Rakib Mullick wrote:
> On 4/19/09, Sam Ravnborg <sam@ravnborg.org> wrote:
> > If I understand it correct we have the following:
> 
> >  (data) struct apic apic_es7000.acpi_madt_oem_check =>
> >  (function) es7000_acpi_madt_oem_check =>
> >  (function) find_unisys_acpi_oem_table
> >  (__init) early_acpi_os_unmap_memory
> >
> >  So the real fix is to:
> >  1) annotate find_unisys_acpi_oem_table __init
> >  2) annotate es7000_acpi_madt_oem_check __init
> >  3) teach modpost that struct apic apic_es7000 may reference __init
> >
> >  Step 3 is done using __refdata
> >
> >  Based on the above analysis I would assume the best fix
> >  would look like this the following.
> >  [I only looked at the first warning]
> >
> >  Rabik/Marcin - if you agree in the analysis could you produce
> >  a proper patch and send to Ingo - thanks.
> >
> >  You can add my:
> >  Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> >  if the patch is ok.
> >
> >         Sam
> Hi Sam, after applying your suggested three steps, we still have the
> following warning:
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0x36174): Section mismatch
> in reference from the function unmap_unisys_acpi_oem_table() to the
> function .init.text:__acpi_unmap_table()
> The function unmap_unisys_acpi_oem_table() references
> the function __init __acpi_unmap_table().
> This is often because unmap_unisys_acpi_oem_table lacks a __init
> annotation or the annotation of __acpi_unmap_table is wrong.
> 
> So, I think we've to annote unmap_unisys_acpi_oem_table with __init (
> If we apply Sam's suggested steps). If anything else please notice.

Hi guys - I lost track of this so here come a late reply.

What we have is apic_es7000.acpi_madt_oem_check that references es7000_acpi_madt_oem_check

And es7000_acpi_madt_oem_check =>
	unmap_unisys_acpi_oem_table =>
		__acpi_unmap_table

So we may only annotate unmap_unisys_acpi_oem_table if
we know that apic_es7000.acpi_madt_oem_check is only used from __init.

Looking at probe_32.c this seems to be true - but I did not look too closely
on this.

If you can make sure apic_es7000.acpi_madt_oem_check is only used from __init
then the right fix is to annotate the relevant functions with __init.
That is es7000_acpi_madt_oem_check() and unmap_unisys_acpi_oem_table().

	Sam
