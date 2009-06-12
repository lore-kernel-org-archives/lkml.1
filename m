Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZFLUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZFLUL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZFLULR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:11:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZFLULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:11:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d/eW8l9R+HDGtQCJ6dK9P/AeJZvYsJpwZmpYR9kovHhv9+3TMzsViga7g556/f9hpj
         njqg1zYBfICo0xquCTJmgBq5Az25kheNr9CBlzGfmD4RsJiz3rYWJgKfiJqK75waWE14
         qYq5JiX+OzJ1ocLFo52ck/UvRC3VTu/FPBePw=
Date: Sat, 13 Jun 2009 00:11:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because
	there's no local APIC
Message-ID: <20090612201117.GA29923@lenovo>
References: <4A329CF8.4050502@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A329CF8.4050502@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeremy Fitzhardinge - Fri, Jun 12, 2009 at 11:22:48AM -0700]
> Parse the ACPI MADT for I/O APIC information, even if the cpu has no
> (apparent) local APIC (ie, the CPU's APIC feature flag is clear).
>
> In principle, the local APIC and the I/O APIC are distinct (but related)
> components, which can be independently present.
>
> In practice this can happen in a Xen system, where the hypervisor has
> full control over the local APICs, and delivers interrupts initiated by
> the I/O APICs via Xen's event channel mechanism.
>
> (This eliminates the need for any explicit if (xen...) tests in
> acpi/boot.c)
>
> Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 2410469..19d13e5 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -193,9 +193,6 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
>  {
>  	struct acpi_table_madt *madt = NULL;
>
> -	if (!cpu_has_apic)
> -		return -EINVAL;
> -

Hi Jeremy,

just for the record -- this removement has a side effect.
Imagine I've passed "disableapic" so I expect as many as
possible apic-related code would not pass thru execution.
Now we would have (say for IBM Summit)

acpi_parse_madt
  default_acpi_madt_oem_check
    summit_acpi_madt_oem_check
      mark_tsc_unstable
      setup_summit

Dunno if it harmless or no but it changes kernel behaviour.
cpu_has_apic cleared if disableapic option (which is early
param) passed to kernel.

Just a note. Didn't walk thru all ways.

	-- Cyrill
