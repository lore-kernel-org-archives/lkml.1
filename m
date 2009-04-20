Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZDTEHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZDTEHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZDTEHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:07:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:41996 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZDTEHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CssY0xRyYehizL55Rvh0YRhrhyS0IvHwVjK0ysCkHjHYMumtkZkJvfEP3e0TziPXNO
         /R7b92baidq6r5rmQra2VEiYyz/YNeKMKmwkcw3eGkXOF0PzRHKuVKxMlrusDnvD0/5A
         JyxalETpv4EPGUKl/Fs9TnaINeuSiLolVjf14=
MIME-Version: 1.0
In-Reply-To: <20090419111650.GA19873@uranus.ravnborg.org>
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com>
	 <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org>
	 <49EAF31C.8020108@gmail.com> <20090419095759.GA4808@elte.hu>
	 <20090419111650.GA19873@uranus.ravnborg.org>
Date: Mon, 20 Apr 2009 10:00:24 +0600
Message-ID: <b9df5fa10904192100h6d5b728bldcc9337bb50d88b@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: Fix false positive section mismatch 
	warnings in the apic code
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/09, Sam Ravnborg <sam@ravnborg.org> wrote:
> If I understand it correct we have the following:

>  (data) struct apic apic_es7000.acpi_madt_oem_check =>
>  (function) es7000_acpi_madt_oem_check =>
>  (function) find_unisys_acpi_oem_table
>  (__init) early_acpi_os_unmap_memory
>
>  So the real fix is to:
>  1) annotate find_unisys_acpi_oem_table __init
>  2) annotate es7000_acpi_madt_oem_check __init
>  3) teach modpost that struct apic apic_es7000 may reference __init
>
>  Step 3 is done using __refdata
>
>  Based on the above analysis I would assume the best fix
>  would look like this the following.
>  [I only looked at the first warning]
>
>  Rabik/Marcin - if you agree in the analysis could you produce
>  a proper patch and send to Ingo - thanks.
>
>  You can add my:
>  Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>  if the patch is ok.
>
>         Sam
Hi Sam, after applying your suggested three steps, we still have the
following warning:

WARNING: arch/x86/kernel/built-in.o(.text+0x36174): Section mismatch
in reference from the function unmap_unisys_acpi_oem_table() to the
function .init.text:__acpi_unmap_table()
The function unmap_unisys_acpi_oem_table() references
the function __init __acpi_unmap_table().
This is often because unmap_unisys_acpi_oem_table lacks a __init
annotation or the annotation of __acpi_unmap_table is wrong.

So, I think we've to annote unmap_unisys_acpi_oem_table with __init (
If we apply Sam's suggested steps). If anything else please notice.

Rakib.
