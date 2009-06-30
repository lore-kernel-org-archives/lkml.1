Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZF3XPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZF3XPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbZF3XPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:15:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758852AbZF3XPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:15:07 -0400
Date: Wed, 1 Jul 2009 01:14:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: RFC - printk handling more than one CON_BOOT
Message-ID: <20090630231457.GB17968@elte.hu>
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <20090630222520.GG1241@elte.hu> <200906301905.13095.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906301905.13095.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Tue 30 Jun 2009 18:25, Ingo Molnar pondered:
> > 
> > * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > 
> > > Today, register_console() assumes the following usage (with 
> > > respect to boot consoles/early_printk).
> > > 
> > > The first console to register with register_console() with a flags 
> > > set to CON_BOOT is the one and only bootconsole.
> > > 
> > > If another register_console() is called with an additional 
> > > CON_BOOT, today it is silently rejected.
> > > 
> > > As soon as a console without the CON_BOOT set calls 
> > > register_console(), the one and only bootconsole is automatically 
> > > unregistered.
> > > 
> > > Once there is a "standard" console - register_console() will 
> > > silently reject any consoles with it's CON_BOOT, set.
> > > 
> > > 
> > > This changeset allows multiple boot consoles, and changes the 
> > > functionality to, be mostly the same as the above.
> > > 
> > > Any number of bootconsoles can be registered. A "real" console 
> > > will unregister all the bootconsoles. Once a "real" console is 
> > > registered, no more bootconsoles can be added.
> > > 
> > > Thoughts?
> > >
> > > The use case is to have a console buffer which goes to serial, and 
> > > a console buffer which goes to a fixed memory buffer at the same 
> > > time. (serial is what most people use, but if serial is hosed for 
> > > some reason, having things in a buffer (which gets printed out by 
> > > the bootloader) is the only way to tell what is going on).
> > 
> > Looks genuinely useful ...
> 
> Yeah, I found it so.
> 
> > > If you don't object I will send a properly formatted patch...
> > 
> > Find some minor comments below:
> > 
> > > -------------
> > > 
> > > 
> > > Index: kernel/printk.c
> > > ===================================================================
> > > --- kernel/printk.c	(revision 6860)
> > > +++ kernel/printk.c	(working copy)
> > > @@ -1126,9 +1126,24 @@
> > >  	unsigned long flags;
> > >  	struct console *bootconsole = NULL;
> > >  
> > > +	/* before we register a new CON_BOOT console, make sure we don't
> > > +	 * already have a valid console
> > > +	 */
> > 
> > please use the customary comment style:
> > 
> >   /*
> >    * Comment .....
> >    * ...... goes here:
> >    */
> > 
> > specified in Documentation/CodingStyle.
> 
> OK.
> 
> > >  	if (console_drivers) {
> > > -		if (console->flags & CON_BOOT)
> > > -			return;
> > > +		if (console->flags & CON_BOOT) {
> > > +			for (bootconsole = console_drivers;
> > > +				bootconsole != NULL;
> > > +				bootconsole = bootconsole->next) {
> > > +				if (!(bootconsole->flags & CON_BOOT))
> > > +					break;
> > > +			}
> > > +			if ((console->flags & CON_BOOT) &&
> > > +				!(bootconsole->flags & CON_BOOT))
> > > +				return;
> > > +			if (!(bootconsole->flags & CON_BOOT))
> > > +				bootconsole = NULL;
> > > +		}
> > 
> > This is really ugly to read mainly because the meat of the 
> > function, the loop over all console drivers, is two indentation 
> > levels to the right which creates line break artifacts. I'd 
> > suggest to put this portion into a helper inline.
> > 
> > Also, the name 'bootconsole' is way too long for an iterator. 
> > Something like 'con' would be more than enough. (and the new 
> > console that is being registered could be new_con or so, to 
> > bring it in line with this naming.)
> 
> I was just re-using what was already there. If you don't mind 
> reviewing a larger patch - I'll change it to something shorter.

I dont mind it at all. We try to goad people into improving the 
immediate context of code they touch. For the sake of network 
effects and the viral spreading of good code and stuff.

(Assuming my suggestions are good that is.)

> > Also, the new semantics here seem overly complex.
> 
> They are - I fixed things a little, but not as much as you 
> suggest.
> 
> > Why not have a state variable that tells us whether we are in 
> > the early boot phase or not and warn about early consoles that 
> > get registered too late and real consoles that get registered 
> > too early?
> 
> That makes sense to me. Today - there are some bootconsoles (x86 
> and sh) that accept a "keep" - still register early - but don't 
> set the CON_BOOT, so they get treated like a normal console (but 
> are hooked up before console_init()).
> 
> This would not allow that to happen.... - is that really desired?

Hm, i actually rely on 'earlyprintk=...,keep' myself sometimes.

I should really have noticed that ;-)

'keep' is really useful for some of the nastiest of crashes: where 
we crash so hard and so fast that regular printk has no chance/time 
to print something useful. On more than one occasion i got the 
un-fancy early-printk stuff give me a vital clue before the kernel 
crapped up - while normal printk wouldnt.

So you are right - we need an iteration over early consoles and 
shuffle the keep-ones into the real console list, right?

	Ingo
