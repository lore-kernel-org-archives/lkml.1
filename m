Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZANKYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZANKYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZANKYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:24:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:37374 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZANKYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iYInn3a7Uc5ietACuF9qLLgdvYWMfRpC5q7mM5FTcFCNVkghdEwLjfmGjrmoeYQekJ
         AvMOX+A62PAdPauox4PUrJ/jlKY1O8nfVWaN2t53nU0sffJ8alVDIgSoND4oPP1F6XOj
         BFufRC9l982nq+53oaRQlbmHo/bpPFK6tHelQ=
MIME-Version: 1.0
In-Reply-To: <20090112131100.GA670@elte.hu>
References: <1231764478.10461.5.camel@jaswinder.satnam>
	 <20090112131100.GA670@elte.hu>
Date: Wed, 14 Jan 2009 15:54:21 +0530
Message-ID: <3f9a31f40901140224o5de6d6ecj136d05ca2ba40e92@mail.gmail.com>
Subject: Re: [PULL -tip] x86: replacing mp_config_X with mpc_X
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, paul.s.diefenbaugh@intel.com,
       jun.nakajima@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 6:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
>
>> -struct mp_config_ioapic {
>> -     unsigned long mp_apicaddr;
>> -     unsigned int mp_apicid;
>> -     unsigned char mp_type;
>> -     unsigned char mp_apicver;
>> -     unsigned char mp_flags;
>> -};
>> -
>> -struct mp_config_intsrc {
>> -     unsigned int mp_dstapic;
>> -     unsigned char mp_type;
>> -     unsigned char mp_irqtype;
>> -     unsigned short mp_irqflag;
>> -     unsigned char mp_srcbus;
>> -     unsigned char mp_srcbusirq;
>> -     unsigned char mp_dstirq;
>> -};
>
> So you replaced that with mpc_ioapic and mpc_intsrc uses:
>
>  struct mpc_ioapic {
>         unsigned char type;
>         unsigned char apicid;
>         unsigned char apicver;
>         unsigned char flags;
>         unsigned int apicaddr;
>  };
>
>  struct mpc_intsrc {
>         unsigned char type;
>         unsigned char irqtype;
>         unsigned short irqflag;
>         unsigned char srcbus;
>         unsigned char srcbusirq;
>         unsigned char dstapic;
>         unsigned char dstirq;
>  };
>
> And removed the mp_config_ioapic and mp_config_intsrc types.
>
> The mp_config_ioapic and mp_config_intsrc types are kernel-internal, while
> mpc_ioapic and mpc_intsrc is an MP Specification type - the lowlevel
> structure of these tables as provided in RAM or ROM by the BIOS.
>
> Here's the potential problems that need to be thought through:
>
> - the biggest potential problem is that apicaddr is 32-bit wide while
>  mp_apicaddr is 64-bit wide, on the 64-bit kernel. Can an apic address be
>  above 4 GB, in an mptable? I dont think it can be.
>

mp_apicaddr is getting its value from apicaddr which is u32
(arch/x86/kernel/acpi/boot.c)
 OR
mp_apicaddr is getting its value from apicaddr which is u32
(arch/x86/kernel/mpparse.c)

> - another problem could be that dstapic are all 1-byte entities - while in
>  the in-kernel version (mp_apicid and mp_dstapic) they are 32 bit. The
>  ACPI code fills in the tables too so maybe there it can be wider than 8
>  bits?
>

mp_apicid is getting its value from uniq_ioapic_id(id) which returns
u8 (arch/x86/kernel/acpi/boot.c)
 OR
mp_apicid is getting its value from reg_00.bits.ID which also 8 bits
(arch/x86/kernel/io_apic.c)
 OR
mp_apicid is getting its value from apicid which also 8 bits
(arch/x86/kernel/mpparse.c)

and

mp_dstapic is getting its value from mp_apicid which is already 8 bits
(arch/x86/kernel/acpi/boot.c)
 OR
mp_dstapic is getting its value from mpc_intsrc->dstapic which is
already 8 bits (arch/x86/kernel/mpparse.c)

By using current structure we are wasting space as well as creating
confusion for checking u8 <-> u32 and u32 <-> u64.

Thanks,
--
JSR
