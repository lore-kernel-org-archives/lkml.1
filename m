Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZF3XCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZF3XCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZF3XBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:01:53 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:30201 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZF3XBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:01:52 -0400
X-IronPort-AV: E=Sophos;i="4.42,319,1243828800"; 
   d="scan'208";a="3269410"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: RFC - printk handling more than one CON_BOOT
Date: Tue, 30 Jun 2009 19:05:12 -0400
User-Agent: KMail/1.9.5
CC: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <20090630222520.GG1241@elte.hu>
In-Reply-To: <20090630222520.GG1241@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906301905.13095.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 30 Jun 2009 23:01:55.0096 (UTC) FILETIME=[C341D980:01C9F9D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Jun 2009 18:25, Ingo Molnar pondered:
> 
> * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > Today, register_console() assumes the following usage (with 
> > respect to boot consoles/early_printk).
> > 
> > The first console to register with register_console() with a flags 
> > set to CON_BOOT is the one and only bootconsole.
> > 
> > If another register_console() is called with an additional 
> > CON_BOOT, today it is silently rejected.
> > 
> > As soon as a console without the CON_BOOT set calls 
> > register_console(), the one and only bootconsole is automatically 
> > unregistered.
> > 
> > Once there is a "standard" console - register_console() will 
> > silently reject any consoles with it's CON_BOOT, set.
> > 
> > 
> > This changeset allows multiple boot consoles, and changes the 
> > functionality to, be mostly the same as the above.
> > 
> > Any number of bootconsoles can be registered. A "real" console 
> > will unregister all the bootconsoles. Once a "real" console is 
> > registered, no more bootconsoles can be added.
> > 
> > Thoughts?
> >
> > The use case is to have a console buffer which goes to serial, and 
> > a console buffer which goes to a fixed memory buffer at the same 
> > time. (serial is what most people use, but if serial is hosed for 
> > some reason, having things in a buffer (which gets printed out by 
> > the bootloader) is the only way to tell what is going on).
> 
> Looks genuinely useful ...

Yeah, I found it so.

> > If you don't object I will send a properly formatted patch...
> 
> Find some minor comments below:
> 
> > -------------
> > 
> > 
> > Index: kernel/printk.c
> > ===================================================================
> > --- kernel/printk.c	(revision 6860)
> > +++ kernel/printk.c	(working copy)
> > @@ -1126,9 +1126,24 @@
> >  	unsigned long flags;
> >  	struct console *bootconsole = NULL;
> >  
> > +	/* before we register a new CON_BOOT console, make sure we don't
> > +	 * already have a valid console
> > +	 */
> 
> please use the customary comment style:
> 
>   /*
>    * Comment .....
>    * ...... goes here:
>    */
> 
> specified in Documentation/CodingStyle.

OK.

> >  	if (console_drivers) {
> > -		if (console->flags & CON_BOOT)
> > -			return;
> > +		if (console->flags & CON_BOOT) {
> > +			for (bootconsole = console_drivers;
> > +				bootconsole != NULL;
> > +				bootconsole = bootconsole->next) {
> > +				if (!(bootconsole->flags & CON_BOOT))
> > +					break;
> > +			}
> > +			if ((console->flags & CON_BOOT) &&
> > +				!(bootconsole->flags & CON_BOOT))
> > +				return;
> > +			if (!(bootconsole->flags & CON_BOOT))
> > +				bootconsole = NULL;
> > +		}
> 
> This is really ugly to read mainly because the meat of the function, 
> the loop over all console drivers, is two indentation levels to the 
> right which creates line break artifacts. I'd suggest to put this 
> portion into a helper inline.
> 
> Also, the name 'bootconsole' is way too long for an iterator. 
> Something like 'con' would be more than enough. (and the new console 
> that is being registered could be new_con or so, to bring it in line 
> with this naming.)

I was just re-using what was already there. If you don't mind reviewing a 
larger patch - I'll change it to something shorter.

> Also, the new semantics here seem overly complex.

They are - I fixed things a little, but not as much as you suggest.

> Why not have a  
> state variable that tells us whether we are in the early boot phase 
> or not and warn about early consoles that get registered too late 
> and real consoles that get registered too early?

That makes sense to me. Today - there are some bootconsoles (x86 and sh) that 
accept a "keep" - still register early - but don't set the CON_BOOT, so they 
get treated like a normal console (but are hooked up before console_init()).

This would not allow that to happen.... - is that really desired?

> That way the CON_BOOT flag is really reduntant in terms of 
> semantics: all consoles registered before console_init() are early 
> ones, and all consoles registered after that are final consoles. (or 
> something like that)

Again - just using what is already there...

> Is there any reason why we'd want to do something more complex than 
> such simple rules?
>  
> > +
> >  		if (console_drivers->flags & CON_BOOT)
> >  			bootconsole = console_drivers;
> >  	}
> > @@ -1195,15 +1210,32 @@
> >  	if (!(console->flags & CON_ENABLED))
> >  		return;
> >  
> > -	if (bootconsole && (console->flags & CON_CONSDEV)) {
> > -		printk(KERN_INFO "console handover: boot [%s%d] -> real
> [%s%d]\n",
> > -		       bootconsole->name, bootconsole->index,
> > -		       console->name, console->index);
> > -		unregister_console(bootconsole);
> > +	if (bootconsole && (console->flags & CON_CONSDEV) &&
> > +		!(console->flags & CON_BOOT)) {
> > +		/* we need to iterate through twice, to make sure we
> print
> > +		 * everything out, before we unregister the console(s)
> > +		 */
> 
> (please fix the comment.)

will do.

> > +		printk(KERN_INFO "console handover: ");
> > +		for (bootconsole = console_drivers; bootconsole != NULL;
> > +			bootconsole = bootconsole->next) {
> > +			if (bootconsole->flags & CON_BOOT)
> > +				printk("boot [%s%d] ",
> bootconsole->name,
> > +					bootconsole->index);
> > +		}
> > +		printk(" -> real [%s%d]\n", console->name,
> console->index);
> > +		for (bootconsole = console_drivers; bootconsole != NULL;
> > +			bootconsole = bootconsole->next) {
> > +			if (bootconsole->flags & CON_BOOT)
> > +				unregister_console(bootconsole);
> > +		}
> 
> this too should probably move into a helper inline.

OK

> >  		console->flags &= ~CON_PRINTBUFFER;
> >  	} else {
> > -		printk(KERN_INFO "console [%s%d] enabled\n",
> > -		       console->name, console->index);
> > +		if (console->flags & CON_BOOT)
> > +			printk(KERN_INFO "bootconsole [%s%d] enabled\n",
> > +				console->name, console->index);
> > +		else
> > +			printk(KERN_INFO "console [%s%d] enabled\n",
> > +				console->name, console->index);
> 
> multi-line branch statemens should preferably come with curly 
> braces. And this could probably be written simpler as well, as:
> 
> 	printk(KERN_INFO "%sconsole [%s%d] enabled\n",
> 		(con->flags & CON_BOOT) ? "boot" : "",
> 		 con->name, con->index);

OK.
