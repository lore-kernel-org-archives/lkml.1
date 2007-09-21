Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXIUMbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXIUMbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbXIUMbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:31:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:4448 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXIUMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jz9vlwANNH+SHvXf3s2I7r3+82Awk8JmdI3RH5pjsAuXldoCKib/hQ+dsZgFig78a1c/48AZe6esYlec5Kyh23mTeTBt3Uvyn6p958YJXgOmf7x3uTnF50f0J0ed9ML5qp+q0jjFAE7PjGSHB1VfEA68DaGM3NTaFm4OyNQOPWY=
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>
	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
	 <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 14:31:34 +0200
Message-Id: <1190377894.30016.4.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Satyam,

On Wed, 2007-09-19 at 06:30 +0530, Satyam Sharma wrote: 
> Hi Gilboa,
> 
> 
> On Sat, 15 Sep 2007, Gilboa Davara wrote:
> > 
> > This is my second stab at solving the "stack over flow due to
> > dump_strace when close to stack-overflow is detected by do_IRQ" problem.
> > (Hopefully) this patch is creates less noise then the previous one.
> > 
> > [snip]
> > > I'll try and create an option 2 (static allocation, minimal locking)
> > > patch and post ASAP.
> > > Hopefully it'll fare better. (While keeping the current interface intact
> > > and reducing the damage/noise)
> > 
> > - Gilboa
> > 
> > --- linux-2.6/kernel/kallsyms.orig	2007-09-15 11:46:54.000000000 +0300
> > +++ linux-2.6/kernel/kallsyms.c	2007-09-15 21:06:55.000000000 +0300
> > @@ -306,13 +306,14 @@ int lookup_symbol_attrs(unsigned long ad
> >  	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
> >  }
> >  
> > -/* Look up a kernel symbol and return it in a text buffer. */
> > -int sprint_symbol(char *buffer, unsigned long address)
> > +/* Internal version:
> > +   Look up a kernel symbol and module name and return them to the
> > +     caller's buffer/namebuf buffers. */
> 
> /*
>  * ...
>  * ...
>  */
> 
> is the general coding style here ...

ACK.
Will be fixed ASAP.

> 
> > +int __sprint_symbol(char *buffer, char *namebuf, unsigned long address)
> >  {
> > -	char *modname;
> > -	const char *name;
> >  	unsigned long offset, size;
> > -	char namebuf[KSYM_NAME_LEN];
> > +	const char *name;
> > +	char *modname;
> >  
> >  	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
> >  	if (!name)
> > @@ -325,14 +326,35 @@ int sprint_symbol(char *buffer, unsigned
> >  		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
> >  }
> >  
> > +/* Exported version:
> > +   Look up a kernel symbol and return it in a text buffer. */
> 
> ditto.
> 
> > +int sprint_symbol(char *buffer, unsigned long address)
> > +{
> > +	char namebuf[KSYM_NAME_LEN];
> 
> Hmm, don't we intend to push this array out of the stack too?
> 
> +	static char namebuf[KSYM_NAME_LEN];
> +	static DEFINE_SPINLOCK(namebuf_lock);
> 
> here ?

I did my best to keep the old interface (sprint_symbol), char arrays and
all, fixing only the critical dump_stack path. (Hence, print_symbol no
longer calls sprint_symbol - it calls the __sprint_symbol helper
function instead.

> 
> > +
> > +	return __sprint_symbol(buffer, namebuf, address);
> 
> And you'd need to wrap spin_lock_irqsave()/spin_unlock_irqrestore()
> around this call.

As I'm keeping the old interface (with it's static char arrays) for
non-dump_stack paths, there's no need to use locks around sprint_symbol.

> 
> > +}
> 
> 
> > +static DEFINE_SPINLOCK(symbol_lock);
> 
> Try to keep the declarations of a lock, and the data that it protects,
> close together. Since this lock is being used to protect "buffer", it
> makes sense to ...

ACK. 

> 
> 
> >  /* Look up a kernel symbol and print it to the kernel messages. */
> >  void __print_symbol(const char *fmt, unsigned long address)
> >  {
> > -	char buffer[KSYM_SYMBOL_LEN];
> > +	/* Use static buffers instead of char array to reduce
> > +	     stack footprint in i386/4KSTACKS.
> > +	     Buffers must be protected against re-entry. */
> > +	static char namebuf[KSYM_NAME_LEN];
> > +	static char buffer[KSYM_SYMBOL_LEN];
> 
> ... have it:
> 
> +	static DEFINE_SPINLOCK(buffer_lock);

ACK.

> 
> here (note the name that exactly describes what the lock protects).
> 
> And the namebuf array isn't required here, it's already there in
> sprint_symbol(), which you can call from ...
> 
> > +	unsigned long flags;
> > +
> >  
> > -	sprint_symbol(buffer, address);
> > +	spin_lock_irqsave(&symbol_lock, flags);
> > +
> > +	__sprint_symbol(buffer, namebuf, address);
> 
> here ... sprint_symbol() ?
> 
> >  	printk(fmt, buffer);
> > +
> > +	spin_unlock_irqrestore(&symbol_lock, flags);
> 
> But I still don't much like this :-(

Yep. Still needs work.
... I'll get there. Dead or alive. ;)

> 
> More importantly, if a panic occurs *below* this callchain (and let's
> say we ended up in this callchain because somebody put in a dump_stack()
> somewhere for debugging purposes), then we'd have a deadlock on our hands,
> and nothing gets printed for that panic.

The -best- solution is to use locking in normal circumstances (E.g.
debug code, sleep while atomic ,etc) -but- drop all locks when BUG/Oops
is being hit.

I believe the next patch will take care of this problem.

> 
> I don't know who maintains this part of kernel code, but you can try
> resubmitting (with the changes suggested above) to someone appropriate ...

Any suggestions?

- Gilboa

