Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYIKUeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYIKUeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYIKUeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:34:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:53767 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYIKUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RRdgYQs23l1bNOuonbVE0evVd5bWaXUxPRp/Xb8riNx3+dkRGiMRgzm9ChEGY3ayvB
         HBM60Ay8yIgRTvBFrHKm7iSq82vIlJbDqvRC7Jk0ykZ4aJ2YBoiMn26xVWASXkFBH4ZE
         aJm1CT/N2tzA9w8RKrifExHRDD/Bnbf0qhnp8=
Message-ID: <86802c440809111334u6d6691c3sd83bcfddc83b1bbd@mail.gmail.com>
Date: Thu, 11 Sep 2008 13:34:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48C7FA91.9050302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1220826072@localhost>
	 <944fe7ea3da7707eb90f.1220826078@localhost>
	 <20080907234418.GB26079@one.firstfloor.org>
	 <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu>
	 <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 9:49 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Ingo Molnar wrote:
>>> So i'd suggest a different, more carful approach: keep the new code
>>> you wrote, but print a WARN()ing if prev_map is not unmapped yet when
>>> the next mapping is acquired. That way the ACPI code can be fixed
>>> gradually and without breaking existing functionality.
>>>
>>
>> ok, i stuck in your patches into tip/master today and -tip testing
>> quickly found an early-ioremap leak:
>>
>> [   36.625100] calling  check_early_ioremap_leak+0x0/0x3d
>> [   36.630253] ------------[ cut here ]------------
>> [   36.634884] WARNING: at arch/x86/mm/ioremap.c:577 check_early_ioremap_leak+0x28/0x3d()
>> [   36.642811] Debug warning: early ioremap leak of 1 areas detected.
>>
>> find the full log below with ioremap-leak-tracing turned on. I've
>> excluded these commits for now from tip/master.
>>
>
> Yes, that leak is expected, unfortunately.  __acpi_map_table() has no
> corresponding unmap, and only maintains one mapping.  So it will leak
> its last mapping when it switches over from using __acpi_map_table() to
> ioremap().
>
> So, yes, its ugly, but its guaranteed to be a single leaked mapping.
> But I'm not sure what the best approach to deal with it is.
>
> (All those other backtraces are just informational, right?)
>

acpi_os_map_memory is the only user for __acpi_map_table (except es7000_32.c)

void __iomem *__init_refok
acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
{
        if (phys > ULONG_MAX) {
                printk(KERN_ERR PREFIX "Cannot map memory that high\n");
                return NULL;
        }
        if (acpi_gbl_permanent_mmap)
                /*
                * ioremap checks to ensure this is in reserved space
                */
                return ioremap((unsigned long)phys, size);
        else
                return __acpi_map_table((unsigned long)phys, size);
}
EXPORT_SYMBOL_GPL(acpi_os_map_memory);

void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
{
        if (acpi_gbl_permanent_mmap) {
                iounmap(virt);
        }
}
EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);

just let acpi_os_unmap_memory to call __acpi_unmap_table...

YH
