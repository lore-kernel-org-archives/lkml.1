Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYAIPYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYAIPYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYAIPYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:24:43 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:37611 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYAIPYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:24:43 -0500
Message-ID: <4784E738.3070202@grupopie.com>
Date: Wed, 09 Jan 2008 15:24:40 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, kyle@mcmartin.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
References: <20080108063113.GA21287@fattire.cabal.ca> <200801082250.06828.rusty@rustcorp.com.au> <20080108162159.9f37d856.akpm@linux-foundation.org> <200801091420.19273.rusty@rustcorp.com.au>
In-Reply-To: <200801091420.19273.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 09 January 2008 11:21:59 Andrew Morton wrote:
>> [...]
>> And the fact that incoming arg `namebuf' MUST point at a
>> KSYM_NAME_LEN-sized buffer could be better communicated by using a
>> dedicated struct for this, or by giving the arg a type of `char
>> namebuf[KSYM_NAME_LEN]'.  Or by adding a comment. Or by just ignoring
>> me and doing something more useful.
> 
> Or better, rework all the name lookup interfaces, rather than having: 

Yes, there is some rework we can do here....

> struct module *module_text_address(unsigned long addr);
> struct module *__module_text_address(unsigned long addr);
> int is_module_address(unsigned long addr);
> int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
> 			char *name, char *module_name, int *exported);
> char *module_address_lookup(unsigned long addr,
> 			    unsigned long *symbolsize,
> 			    unsigned long *offset,
> 			    char **modname,
> 			    char *namebuf);
> int lookup_module_symbol_name(unsigned long addr, char *symname);
> int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
> 			       unsigned long *offset, char *modname, char *name);
> unsigned long module_kallsyms_lookup_name(const char *name);

All of these are somewhat less important, because most users call the 
kallsyms generic functions which will in turn call these functions if 
the symbol isn't global.

So, they should suffer basically the same transformations as the 
kallsyms_ counterparts and can be considered almost "internal" to the 
kallsyms infrastructure.

> unsigned long kallsyms_lookup_name(const char *name);

This one look fine, as there is no duplication in any other function.

> extern int kallsyms_lookup_size_offset(unsigned long addr,
> 				  unsigned long *symbolsize,
> 				  unsigned long *offset);
> const char *kallsyms_lookup(unsigned long addr,
> 			    unsigned long *symbolsize,
> 			    unsigned long *offset,
> 			    char **modname, char *namebuf);
> int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
> 		        unsigned long *offset, char *modname, char *name);
> int lookup_symbol_name(unsigned long addr, char *symname);

These 4 functions can probably be condensed into just one, by allowing 
NULL pointer arguments to mean "don't need this result":

kallsyms_lookup_size_offset(a,s,o) <=> kallsyms_lookup(a,s,o,NULL,NULL)
lookup_symbol_attrs(a,s,o,m,n) <=> kallsyms_lookup(a,s,o,m,n)
lookup_symbol_name(a,n) <=> kallsyms_lookup(a,NULL,NULL,NULL,n)

> extern int sprint_symbol(char *buffer, unsigned long address);
> extern void __print_symbol(const char *fmt, unsigned long address);

These 2 are probably fine.

There is a difference in the way the module name is passed, because 
kallsyms_lookup assumes it can return just a pointer to the module name.

However, we should probably change that interface so that the caller 
provides the buffer to hold the module name, to avoid races. The 
stop_machine should help already, but returning a pointer that can be 
stale just a little bit later isn't pretty anyway.

I can do a patch for this, but this will touch a few subsystems that use 
these interfaces (there are not a lot of them, though). The major change 
would probably be the allocation of a small buffer (56~60 bytes) in some 
of the callers to hold the module name.

-- 
Paulo Marques - www.grupopie.com

"There cannot be a crisis today; my schedule is already full."
