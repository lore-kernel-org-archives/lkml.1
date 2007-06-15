Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbXFOR2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbXFOR2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXFOR14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:27:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:56785 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbXFOR1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gOKqVqlvtkRc6usUmkqbe/c48avDCb+esqXoepNe5UqN/Y3hO9VFqGKIVxFzf29pDyKKu0Pt4H1Kx5afRxb5gGFnJxhqGRInSL1bdp16FAyYwXAW3RchKRUmtPiG4pRL9IKyhVPTGJVXZUUNbHqINZUmHkHqblFMAVV2UPAVC3Q=
Message-ID: <32209efe0706151027v45719185w4463556c31df5632@mail.gmail.com>
Date: Fri, 15 Jun 2007 10:27:52 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: vgoyal@in.ibm.com
Subject: Re: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
Cc: linux-kernel@vger.kernel.org, rdreier@cisco.com, akpm@linux-foundation.org
In-Reply-To: <20070615152938.GA9230@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EB9@USRV-EXCH4.na.uis.unisys.com>
	 <32209efe0706131522n42eff7b1hfea6a6252289e280@mail.gmail.com>
	 <20070615152938.GA9230@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> On Wed, Jun 13, 2007 at 03:22:55PM -0700, Natalie Protasevich wrote:
> [..]
> > >Seems it would be cleaner to figure out some way to build es7000.c for
> > >if CONFIG_X86_ES7000 is set?  Or just move them here all the time?
> > >
> > > > ---
> > >linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-e
> > >s7000-build-breakage-fix        2007-06-13 22:52:14.000000000 +0530
> > > > +++
> > >linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h
> > >2007-06-13 22:52:14.000000000 +0530
> > > > @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
> > > >  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
> > > >  extern void setup_unisys(void);
> > > >
> > > > +#ifndef CONFIG_X86_GENERICARCH
> > > > +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
> > > > +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
> > > > +                            char *productid);
> > > > +#endif
> > >
> > >It seems that this #ifndef is not needed -- even if there is another
> > >declaration of these functions that is visible, the signatures should
> > >match so it should be OK.
> >
> > I just finished my test builds with and without GENERIC, so I can
> > suggest just move all functions to arch/i386/mach-es7000/es7000plat.c
> > - es7000_sw_apic() ,es7000_enable_apic_mode(),acpi_madt_oem_check(),
> > mps_oem_check() and make them non-static - from
> > arch/i386/mach-generic/es7000.c
>
> I think this will also break with CONFIG_X86_GENERIC=y. The moment you
> make es7000 specific acpi_madt_oem_check() non static, It will conflict
> with generic definition present in mach-generic/probe.c. That function is
> a generic function designed to probe for underlying subarch.

I am not sure why it needs to be static, since the genapic structure
in include/asm-i386/ just being a switch table for the corresponding
functions of the right type. It compiles for me, and i just need to
extern those in include/asm/mach-es7000/mach_apic.h:

...
extern void es7000_sw_apic(void);
extern void __init enable_apic_mode(void);

extern __init int mps_oem_check(struct mp_config_table *mpc, char
*oem, char *productid);
extern int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id);
...

or do this in mach_mpparse.h - wherever I removed them from. I
apologize again, will make a descent patch shortly just so we can look
closer and evaluate possible approach.

Regards,
--Natalie
