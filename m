Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZANLCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZANLCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZANLCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:02:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZANLCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:02:08 -0500
Date: Wed, 14 Jan 2009 12:01:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, paul.s.diefenbaugh@intel.com,
       jun.nakajima@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PULL -tip] x86: replacing mp_config_X with mpc_X
Message-ID: <20090114110142.GJ2913@elte.hu>
References: <1231764478.10461.5.camel@jaswinder.satnam> <20090112131100.GA670@elte.hu> <3f9a31f40901140224o5de6d6ecj136d05ca2ba40e92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901140224o5de6d6ecj136d05ca2ba40e92@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Mon, Jan 12, 2009 at 6:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> >
> >> -struct mp_config_ioapic {
> >> -     unsigned long mp_apicaddr;
> >> -     unsigned int mp_apicid;
> >> -     unsigned char mp_type;
> >> -     unsigned char mp_apicver;
> >> -     unsigned char mp_flags;
> >> -};
> >> -
> >> -struct mp_config_intsrc {
> >> -     unsigned int mp_dstapic;
> >> -     unsigned char mp_type;
> >> -     unsigned char mp_irqtype;
> >> -     unsigned short mp_irqflag;
> >> -     unsigned char mp_srcbus;
> >> -     unsigned char mp_srcbusirq;
> >> -     unsigned char mp_dstirq;
> >> -};
> >
> > So you replaced that with mpc_ioapic and mpc_intsrc uses:
> >
> >  struct mpc_ioapic {
> >         unsigned char type;
> >         unsigned char apicid;
> >         unsigned char apicver;
> >         unsigned char flags;
> >         unsigned int apicaddr;
> >  };
> >
> >  struct mpc_intsrc {
> >         unsigned char type;
> >         unsigned char irqtype;
> >         unsigned short irqflag;
> >         unsigned char srcbus;
> >         unsigned char srcbusirq;
> >         unsigned char dstapic;
> >         unsigned char dstirq;
> >  };
> >
> > And removed the mp_config_ioapic and mp_config_intsrc types.
> >
> > The mp_config_ioapic and mp_config_intsrc types are kernel-internal, while
> > mpc_ioapic and mpc_intsrc is an MP Specification type - the lowlevel
> > structure of these tables as provided in RAM or ROM by the BIOS.
> >
> > Here's the potential problems that need to be thought through:
> >
> > - the biggest potential problem is that apicaddr is 32-bit wide while
> >  mp_apicaddr is 64-bit wide, on the 64-bit kernel. Can an apic address be
> >  above 4 GB, in an mptable? I dont think it can be.
> >
> 
> mp_apicaddr is getting its value from apicaddr which is u32
> (arch/x86/kernel/acpi/boot.c)
>  OR
> mp_apicaddr is getting its value from apicaddr which is u32
> (arch/x86/kernel/mpparse.c)
> 
> > - another problem could be that dstapic are all 1-byte entities - while in
> >  the in-kernel version (mp_apicid and mp_dstapic) they are 32 bit. The
> >  ACPI code fills in the tables too so maybe there it can be wider than 8
> >  bits?
> >
> 
> mp_apicid is getting its value from uniq_ioapic_id(id) which returns
> u8 (arch/x86/kernel/acpi/boot.c)
>  OR
> mp_apicid is getting its value from reg_00.bits.ID which also 8 bits
> (arch/x86/kernel/io_apic.c)
>  OR
> mp_apicid is getting its value from apicid which also 8 bits
> (arch/x86/kernel/mpparse.c)
> 
> and
> 
> mp_dstapic is getting its value from mp_apicid which is already 8 bits
> (arch/x86/kernel/acpi/boot.c)
>  OR
> mp_dstapic is getting its value from mpc_intsrc->dstapic which is
> already 8 bits (arch/x86/kernel/mpparse.c)
> 
> By using current structure we are wasting space as well as creating
> confusion for checking u8 <-> u32 and u32 <-> u64.

ok, that sounds fair enough - double-checking that we are not introducing 
some stupid limit somewhere was important.

I've pulled your two cleanup commits, thanks,

	Ingo
