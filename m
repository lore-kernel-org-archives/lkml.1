Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715AbXISA5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbXISA5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 20:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXISA5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 20:57:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47910 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXISA5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 20:57:12 -0400
Date: Wed, 19 Sep 2007 06:30:05 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Gilboa Davara <gilboad@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
In-Reply-To: <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
Message-ID: <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain> 
 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com> 
 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gilboa,


On Sat, 15 Sep 2007, Gilboa Davara wrote:
> 
> This is my second stab at solving the "stack over flow due to
> dump_strace when close to stack-overflow is detected by do_IRQ" problem.
> (Hopefully) this patch is creates less noise then the previous one.
> 
> [snip]
> > I'll try and create an option 2 (static allocation, minimal locking)
> > patch and post ASAP.
> > Hopefully it'll fare better. (While keeping the current interface intact
> > and reducing the damage/noise)
> 
> - Gilboa
> 
> --- linux-2.6/kernel/kallsyms.orig	2007-09-15 11:46:54.000000000 +0300
> +++ linux-2.6/kernel/kallsyms.c	2007-09-15 21:06:55.000000000 +0300
> @@ -306,13 +306,14 @@ int lookup_symbol_attrs(unsigned long ad
>  	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
>  }
>  
> -/* Look up a kernel symbol and return it in a text buffer. */
> -int sprint_symbol(char *buffer, unsigned long address)
> +/* Internal version:
> +   Look up a kernel symbol and module name and return them to the
> +     caller's buffer/namebuf buffers. */

/*
 * ...
 * ...
 */

is the general coding style here ...

> +int __sprint_symbol(char *buffer, char *namebuf, unsigned long address)
>  {
> -	char *modname;
> -	const char *name;
>  	unsigned long offset, size;
> -	char namebuf[KSYM_NAME_LEN];
> +	const char *name;
> +	char *modname;
>  
>  	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
>  	if (!name)
> @@ -325,14 +326,35 @@ int sprint_symbol(char *buffer, unsigned
>  		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
>  }
>  
> +/* Exported version:
> +   Look up a kernel symbol and return it in a text buffer. */

ditto.

> +int sprint_symbol(char *buffer, unsigned long address)
> +{
> +	char namebuf[KSYM_NAME_LEN];

Hmm, don't we intend to push this array out of the stack too?

+	static char namebuf[KSYM_NAME_LEN];
+	static DEFINE_SPINLOCK(namebuf_lock);

here ?

> +
> +	return __sprint_symbol(buffer, namebuf, address);

And you'd need to wrap spin_lock_irqsave()/spin_unlock_irqrestore()
around this call.

> +}


> +static DEFINE_SPINLOCK(symbol_lock);

Try to keep the declarations of a lock, and the data that it protects,
close together. Since this lock is being used to protect "buffer", it
makes sense to ...


>  /* Look up a kernel symbol and print it to the kernel messages. */
>  void __print_symbol(const char *fmt, unsigned long address)
>  {
> -	char buffer[KSYM_SYMBOL_LEN];
> +	/* Use static buffers instead of char array to reduce
> +	     stack footprint in i386/4KSTACKS.
> +	     Buffers must be protected against re-entry. */
> +	static char namebuf[KSYM_NAME_LEN];
> +	static char buffer[KSYM_SYMBOL_LEN];

... have it:

+	static DEFINE_SPINLOCK(buffer_lock);

here (note the name that exactly describes what the lock protects).

And the namebuf array isn't required here, it's already there in
sprint_symbol(), which you can call from ...

> +	unsigned long flags;
> +
>  
> -	sprint_symbol(buffer, address);
> +	spin_lock_irqsave(&symbol_lock, flags);
> +
> +	__sprint_symbol(buffer, namebuf, address);

here ... sprint_symbol() ?

>  	printk(fmt, buffer);
> +
> +	spin_unlock_irqrestore(&symbol_lock, flags);

But I still don't much like this :-(

More importantly, if a panic occurs *below* this callchain (and let's
say we ended up in this callchain because somebody put in a dump_stack()
somewhere for debugging purposes), then we'd have a deadlock on our hands,
and nothing gets printed for that panic.

I don't know who maintains this part of kernel code, but you can try
resubmitting (with the changes suggested above) to someone appropriate ...


Satyam
