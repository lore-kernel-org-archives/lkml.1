Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYHPFZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYHPFZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYHPFZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:25:33 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:48036 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYHPFZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:25:32 -0400
Date: Sat, 16 Aug 2008 07:25:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-ID: <20080816052552.GA21668@uranus.ravnborg.org>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com> <200808161347.41253.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808161347.41253.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 01:47:40PM +1000, Rusty Russell wrote:
> On Saturday 16 August 2008 12:57:57 Andi Kleen wrote:
> > >> Extract is:
> > >>
> > >> XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
> > >
> > > ...
> > >
> > >> XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
> > >
> > > Two different "modules" use the same prefix, which does not work with
> > > the current logic, they need to live next to each other in the sequence
> > > of options.
> >
> > Sequence of options being defined by link order?
> 
> Simplest fix is to shuffle Makefile.  But better is to create an acpi "module"
> so the namespacing just works, something like below.  Overriding MODULE_PREFIX
> only works for builtin code anyway.  (Which makes sense: moving a parameter
> from one module to another isn't a change we can cover up).
> 
> (Sam: foo-objs-y would make this neater)

foo-y is even neater and works today.

> 
> diff -r 5f7194400572 drivers/acpi/Makefile
> --- a/drivers/acpi/Makefile	Sat Aug 16 13:23:26 2008 +1000
> +++ b/drivers/acpi/Makefile	Sat Aug 16 13:44:17 2008 +1000
> @@ -21,10 +21,18 @@ obj-$(CONFIG_X86)		+= blacklist.o
>  #
>  # ACPI Core Subsystem (Interpreter)
>  #
> -obj-y				+= osl.o utils.o reboot.o\
> +obj-y				+= osl.o utils.o reboot.o acpi.o \
>  				   dispatcher/ events/ executer/ hardware/ \
>  				   namespace/ parser/ resources/ tables/ \
>  				   utilities/
> +
> +# "acpi." module_param namespace.
> +ifdef CONFIG_ACPI_POWER
> +acpi-objs	+= power.o
> +endif

becomes:
acpi-y += power.o

> +ifdef CONFIG_ACPI_SYSTEM
> +acpi-objs	+= system.o event.o
> +endif
acpi-y += system.o event.o

[Assuming both config symbols are bool]

	Sam
