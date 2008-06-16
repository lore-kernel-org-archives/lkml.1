Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYFPTQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYFPTQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYFPTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:16:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbYFPTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:16:34 -0400
Date: Mon, 16 Jun 2008 15:15:11 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] dynamic debug - core infrastructure
Message-ID: <20080616191511.GB30284@redhat.com>
References: <20080613190039.GC8813@redhat.com> <1213396218.5463.48.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213396218.5463.48.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 03:30:18PM -0700, Joe Perches wrote:
> On Fri, 2008-06-13 at 15:00 -0400, Jason Baron wrote:
> > This is the core patch that implements a new dynamic debug
> > infrastructure.
> 
> Some general and specific comments.
> 
> > +int dynamic_printk_enabled[NR_CPUS];
> 
> I don't understand why you use NR_CPUS.
> 
> Also, I think the major use cases are 1 or 2 modules enabled,
> no modules enabled, or all modules enabled, so the hashing of
> module names is particularly not useful.
> 
> Any pr_debug or dev_dbg is in a slow path.
> 
> I think a list and a direct comparison to KBUILD_MODNAME
> would be simpler and as fast as necessary.
> 

NR_CPUS is used to set up a per-cpu int variable where bit 'n' is set if any 
enabled module's name hashes into bucket 'n'. Having a single linked list of
the enabled modules would work, but i like just checking a bit in the common
case. Like you pointed out, most modules are likely disabled which means in the
common case, i'm just checking a bit, whereas in a linked list I'd be walking
a small number of entries.

However, we can better optimize the case of no modules enabled or all modules
enabled, by simply checking globals that indicate this state. I think that
would be improvment. So dynamic_dbg_enabled() looks something like:

if (alloff)
	return 0;
elseif (allon)
	return 1;
elseif (if hash bucket of KBUILD_MODNAME is disabled)
	return 0;
else
	lookup KBUILD_MODNAME in hash table
	if (level or flag comparisons pass and enabled)
		return 1;
	else
		return 0;
	
> > +         To set the level or flag value for type 'level' or 'flag': 
> > +
> > +               $echo "set level=<#> <module_name>" > dynamic_printk/modules
> > +
> 
> I think that set level=<#> should also work for "all"
> 

good idea.

> Perhaps a simpler interface would be to use
> 	enable <module> <level>
> where <level> not specified is 0.
> 

hmmm, there are also 'flags' that can be set for certain modules. Right now
flags and level are set the same way, via 'set level=". However, i want flags
to be able to be set via their name - "set FLAG_FOOBAR=1" or 
"set FLAG_FOOBAR=0". I also like having this independent of whether the module
is enabled or disabled. 

> > +int unregister_debug_module(char *mod_name)
> > +{
> > +	struct debug_name *element;
> > +	struct debug_name *parent = NULL;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	down(&debug_list_mutex);
> > +	element = find_debug_module(mod_name);
> > +	if (!element) {
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> 
> []
> 
> > +out:
> > +	up(&debug_list_mutex);
> > +	return 0;
> > +}
> 
> Because the return values aren't used,
> the functions might as well be declared void
> 

ok

> You should probably add a sprinkling of "const"
> to the argument lists.
> 

ok

> +extern void dynamic_printk(char *, char *, ...);
> 
> +	dynamic_printk(KBUILD_MODNAME,                     \
> +			KERN_DEBUG KBUILD_MODNAME ": " fmt,\
> 
> Instead of prefixing every fmt with KBUILD_MODNAME ": ",
> why not change this to something like:
> 
> extern void dynamic_printk(const char *level, const char *module,
> 			   const char *fmt, ...);
> 
> and just do the printk in 2 parts?
> 
> 	if (module_enabled) {
> 		printk("%s%s: ", level, module);
> 		vprintk(fmt, args);
> 	}
> 
> If not that, why should dynamic_printk prefix a KBUILD_MODNAME
> at all?  Why not just check if the module is enabled, then
> output what the code specifies?
> 
> trivial:  The dynamic versions of the dev_dbg and pr_debug macros
> don't return the number of chars output, but always return 0.
> 
>

good idea - i think pr_debug and dev_dbg should simply be implemented on top
of dynamic_dbg_enabled(). I'll add that in the next spin.

thanks,

-Jason

 
