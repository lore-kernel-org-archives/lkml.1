Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYCDNbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYCDNbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCDNbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:31:25 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56177 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbYCDNbZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:31:25 -0500
Message-Id: <1204637483.28473.1240465303@webmail.messagingengine.com>
X-Sasl-Enc: 701UKV/fo+YLaPfuPmBp4IcRwAFAqfg6L3EuNungSZrt 1204637483
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Mark McLoughlin" <markmc@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Ian Campbell" <ijc@hellion.org.uk>,
       "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <47C22568.1010405@zytor.com>
   <1203958478.20033.1239002461@webmail.messagingengine.com>
   <20080225170134.GA15839@elte.hu>
   <20080225180750.GA31054@mailshack.com>
   <20080228131341.GA25213@mailshack.com>
   <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
   <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>
   <1204310323.24514.1239870063@webmail.messagingengine.com>
   <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com>
   <1204631082.16613.7.camel@muff>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
In-Reply-To: <1204631082.16613.7.camel@muff>
Date: Tue, 04 Mar 2008 14:31:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 11:44:42 +0000, "Mark McLoughlin"
<markmc@redhat.com> said:
> On Sat, 2008-03-01 at 17:09 +0100, Alexander van Heukelum wrote:
> > This patch adds explicit detection of the EBDA and reservation
> > of the rom and adapter address space 0xa0000-0x100000 to the
> > i386 kernels. Before this patch, the EBDA size was hardcoded
> > as 4Kb. Also, the reservation of the adapter range was done by
> > modifying the e820 map which is now not necessary any longer,
> > and that code is removed from copy_e820_map.
> > 
> > The amount of conventional memory and the start of the EBDA are
> > detected by reading the BIOS data area directly. Paravirtual
> > environments do not provide this area, so we bail out early
> > in that case. They will just have to set up a correct memory
> > map to start with.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > 
> > ---
> > 
> > Hi Ingo,
> > 
> > This is the second attempt at a i386-version of the ebda
> > patch. I hope that one of the Xen people will be able to
> > check that this does not break their setups, but I think
> > it will be fine after their patch to exclude the 0x9f000-
> > 0x100000 area explicitly in their setup.
> 
> Confirmed that with Ian's e820 map patch and your patch, Xen DomU boots
> fine.

Thanks for testing that!

> > diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> > index a1d7071..20e537b 100644
> > --- a/arch/x86/kernel/setup_32.c
> > +++ b/arch/x86/kernel/setup_32.c
> > @@ -385,15 +385,60 @@ unsigned long __init find_max_low_pfn(void)
> >  	return max_low_pfn;
> >  }
> >  
> > +#define BIOS_EBDA_SEGMENT 0x40E
> > +#define BIOS_LOWMEM_KILOBYTES 0x413
> > +
> >  /*
> > - * workaround for Dell systems that neglect to reserve EBDA
> > + * The BIOS places the EBDA/XBDA at the top of conventional
> > + * memory, and usually decreases the reported amount of
> > + * conventional memory (int 0x12) too. This also contains a
> > + * workaround for Dell systems that neglect to reserve EBDA.
> > + * The same workaround also avoids a problem with the AMD768MPX
> > + * chipset: reserve a page before VGA to prevent PCI prefetch
> > + * into it (errata #56). Usually the page is reserved anyways,
> > + * unless you have no PS/2 mouse plugged in.
> >   */
> >  static void __init reserve_ebda_region(void)
> >  {
> > -	unsigned int addr;
> > -	addr = get_bios_ebda();
> > -	if (addr)
> > -		reserve_bootmem(addr, PAGE_SIZE, BOOTMEM_DEFAULT);
> > +	unsigned int lowmem, ebda_addr;
> > +
> > +	/* To determine the position of the EBDA and the */
> > +	/* end of conventional memory, we need to look at */
> > +	/* the BIOS data area. In a paravirtual environment */
> > +	/* that area is absent. We'll just have to assume */
> > +	/* that the paravirt case can handle memory setup */
> > +	/* correctly, without our help. */
> > +#ifdef CONFIG_PARAVIRT
> > +	if ((boot_params.hdr.version >= 0x207) &&
> > +			(boot_params.hdr.hardware_subarch != 0)) {
> > +		return;
> > +	}
> > +#endif
> 
> This is a bit magic, is it worth splitting it out as something like
> is_paravirt_environment() ?

Yes, I guess it would make sense, but do we really want to start
creating accessor functions to the boot_params struct? If we do,
then maybe put this as an inline function in <asm-x86/bootparam.h>?
I don't think <asm-x86/paravirt.h> is the right place for this.

Should is_paravirt_environment then always return 0 if
CONFIG_PARAVIRT is not set? Maybe a function like get_subarch
would be preferable? or has_legacy_bios_areas? I don't know.
If someone makes a reasonable suggestion, I'll code it up.

Greetings,
    Alexander

> Cheers,
> Mark.
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

