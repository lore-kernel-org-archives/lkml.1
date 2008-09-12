Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYILRbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYILRbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYILRbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:31:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:29798 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYILRbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uWJuStwym/wlFGIRLJJ+xKRx/7bLAYz7LEth3AOzJss7HnKE0AjOvf7d2a75T+lyMH
         OGB1a/WZB19AfQx2NZqj+8EQvu4DOry5bU2nNVTtNTjJKf4rvxWnijlhlodv2g1wpfMC
         tBFA+N/AAfxagW4ndBI2URmyd+Xe4w0sRwmMw=
Message-ID: <86802c440809121031r3aa498deqec3ecef61bafd21c@mail.gmail.com>
Date: Fri, 12 Sep 2008 10:31:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080912094955.GB14201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1220826072@localhost>
	 <944fe7ea3da7707eb90f.1220826078@localhost>
	 <20080907234418.GB26079@one.firstfloor.org>
	 <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu>
	 <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org>
	 <86802c440809111334u6d6691c3sd83bcfddc83b1bbd@mail.gmail.com>
	 <48C9889B.7090901@goop.org> <20080912094955.GB14201@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 2:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> Yinghai Lu wrote:
>> > void __iomem *__init_refok
>> > acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
>> > {
>> >         if (phys > ULONG_MAX) {
>> >                 printk(KERN_ERR PREFIX "Cannot map memory that high\n");
>> >                 return NULL;
>> >         }
>> >         if (acpi_gbl_permanent_mmap)
>> >                 /*
>> >                 * ioremap checks to ensure this is in reserved space
>> >                 */
>> >                 return ioremap((unsigned long)phys, size);
>> >         else
>> >                 return __acpi_map_table((unsigned long)phys, size);
>> > }
>> > EXPORT_SYMBOL_GPL(acpi_os_map_memory);
>> >
>> > void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
>> > {
>> >         if (acpi_gbl_permanent_mmap) {
>> >                 iounmap(virt);
>> >         }
>> > }
>> > EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
>> >
>> > just let acpi_os_unmap_memory to call __acpi_unmap_table...
>> >
>>
>> That was my first attempt.  Unfortunately a lot of the acpi code seems
>> pretty sloppy about unmapping its tables, and basically relies on
>> __acpi_map_table's current behaviour of removing the previous mapping
>> when creating the new mapping.
>
> could we just emit a WARN_ON_ONCE() warning when we have to remove a
> previous mapping, so that the ACPI code can be fixed eventually?

could be some code is shared between early and permanent, and later
may not need unmap.

anyway those code need to be cleanup, to double check if some fix-map
is overwrited unexpected..

YH
