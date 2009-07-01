Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZGAUsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZGAUsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZGAUrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:47:53 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:32105 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZGAUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:47:53 -0400
X-IronPort-AV: E=Sophos;i="4.42,327,1243828800"; 
   d="scan'208";a="966364"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC v2] kernel/printk.c - handling more than one CON_BOOT
Date: Wed, 1 Jul 2009 16:50:19 -0400
User-Agent: KMail/1.9.5
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       vapier.adi@gmail.com, lethal@linux-sh.org
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <200906302251.52966.rgetz@blackfin.uclinux.org> <20090701124414.fe188893.akpm@linux-foundation.org>
In-Reply-To: <20090701124414.fe188893.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907011650.19173.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jul 2009 20:47:00.0244 (UTC) FILETIME=[14C33540:01C9FA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 1 Jul 2009 15:44, Andrew Morton pondered:
> On Tue, 30 Jun 2009 22:51:52 -0400
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Today, register_console() assumes the following usage:
> >   - The first console to register with a flag set to CON_BOOT is the
> >     one and only bootconsole.
> >   - If another register_console() is called with an additional
> >     CON_BOOT, it is silently rejected.
> >   - As soon as a console without the CON_BOOT set calls registers
> >     the bootconsole is automatically unregistered.
> >   - Once there is a "real" console - register_console() will silently
> >     reject any consoles with it's CON_BOOT flag set.
> 
> hm.  I never knew all that.  Thanks for taking the time to explain all
> this - it helps.

Is it also worthwhile to mention that this function (when used with 
early_printk) can get called _very_ early in the boot process, (before 
setup_arch() completes)

> I think it would be useful if we had a description of the new design,
> similar to your description of the "Today" behaviour above.  Perhaps
> as a comment over register_console()?

Can do - do you want it as v3 or on-top of this one?

> > In many systems (alpha, blackfin, microblaze, mips, powerpc, sh, &
> > x86), there are early_printk implementations, which use the CON_BOOT 
> > which come out serial ports, vga, usb, & memory buffers. In many 
> > embedded systems, it would be nice to have two - in case the primary
> > fails, you always have access to a backup memory buffer - but this
> > requires at least two CON_BOOT consoles.
> > 
> > This changeset allows multiple boot consoles, and changes the
> functionality
> > to, be mostly the same as the above.
> >  - Any number CON_BOOT consoles of can be registered
> >  - A "real" console will unregister all the CON_BOOT consoles
> >  - Once a "real" console is registered, no more CON_BOOT consoles 
> >    can be added (still silently rejected)
> 
> Is the "silent" rejection desirable?  Perhaps that's a
> programming/configuration error which the developer should be informed
> of?

That is what it is today. I would actually prefer not silent - as it 
would have meant 10 min that I would have saved myself trying to figure out 
what was going on... :)

But when I was figuring out how things worked, and had a few too many printks 
in register_console - I was getting BUG: "recent printk recursion!" - so I 
just left it silent (rather than figuring this out).

> 
> > diff -puN
> kernel/printk.c~kernel-printkc-handling-more-than-one-con_boot
> kernel/printk.c
> > --- a/kernel/printk.c~kernel-printkc-handling-more-than-one-con_boot
> > +++ a/kernel/printk.c
> > @@ -37,6 +37,12 @@
> >  #include <asm/uaccess.h>
> >  
> >  /*
> > + * for_each_console() allows you to iterate on each console
> > + */
> > +#define for_each_console(con) \
> > +	for (con = console_drivers; con != NULL; con = con->next)
> 
> hum.  Fair enough.

Was there an issue with this? (Or you just want me to split that up into a 
separate patch?)

> The patch looks good to me.
> 

